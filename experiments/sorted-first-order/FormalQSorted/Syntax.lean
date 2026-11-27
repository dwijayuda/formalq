namespace FormalQ.Sorted

/-- The experiment fixes arities while allowing any number of symbols of each sort profile. -/
structure Signature where
  SortName : Type
  Constant : SortName → Type
  Function : SortName → SortName → Type
  Unary : SortName → Type
  Binary : SortName → SortName → Type

/-- The index identifies a variable position and its declared sort. -/
inductive Var {SortName : Type} : List SortName → SortName → Type where
  | here : Var (s :: Γ) s
  | there : Var Γ s → Var (t :: Γ) s

variable {σ : Signature}

inductive Term (σ : Signature) (Γ : List σ.SortName) : σ.SortName → Type where
  | var : Var Γ s → Term σ Γ s
  | constant : σ.Constant s → Term σ Γ s
  | apply : σ.Function s t → Term σ Γ s → Term σ Γ t

abbrev Renaming {SortName : Type} (Γ Δ : List SortName) :=
  ∀ ⦃s⦄, Var Γ s → Var Δ s

def Term.rename (f : Renaming Γ Δ) : Term σ Γ s → Term σ Δ s
  | .var v => .var (f v)
  | .constant c => .constant c
  | .apply symbol input => .apply symbol (input.rename f)

abbrev Substitution (σ : Signature) (Γ Δ : List σ.SortName) :=
  ∀ ⦃s⦄, Var Γ s → Term σ Δ s

def Term.subst (f : Substitution σ Γ Δ) : Term σ Γ s → Term σ Δ s
  | .var v => f v
  | .constant c => .constant c
  | .apply symbol input => .apply symbol (input.subst f)

def Substitution.lift (f : Substitution σ Γ Δ) (s : σ.SortName) : Substitution σ (s :: Γ) (s :: Δ)
  | _, .here => .var .here
  | _, .there v => (f v).rename (fun {_} position => .there position)

def Substitution.single (term : Term σ Γ s) : Substitution σ (s :: Γ) Γ
  | _, .here => term
  | _, .there v => .var v

inductive Formula (σ : Signature) : List σ.SortName → Type where
  | falsum : Formula σ Γ
  | equal : Term σ Γ s → Term σ Γ s → Formula σ Γ
  | unary : σ.Unary s → Term σ Γ s → Formula σ Γ
  | binary : σ.Binary s t → Term σ Γ s → Term σ Γ t → Formula σ Γ
  | conj : Formula σ Γ → Formula σ Γ → Formula σ Γ
  | disj : Formula σ Γ → Formula σ Γ → Formula σ Γ
  | impl : Formula σ Γ → Formula σ Γ → Formula σ Γ
  | all (s : σ.SortName) : Formula σ (s :: Γ) → Formula σ Γ
  | ex (s : σ.SortName) : Formula σ (s :: Γ) → Formula σ Γ

def Formula.neg (p : Formula σ Γ) : Formula σ Γ := .impl p .falsum

def Formula.subst (f : Substitution σ Γ Δ) : Formula σ Γ → Formula σ Δ
  | .falsum => .falsum
  | .equal left right => .equal (left.subst f) (right.subst f)
  | .unary symbol input => .unary symbol (input.subst f)
  | .binary symbol left right => .binary symbol (left.subst f) (right.subst f)
  | .conj p q => .conj (p.subst f) (q.subst f)
  | .disj p q => .disj (p.subst f) (q.subst f)
  | .impl p q => .impl (p.subst f) (q.subst f)
  | .all s body => .all s (body.subst (f.lift s))
  | .ex s body => .ex s (body.subst (f.lift s))

def Formula.weaken (p : Formula σ Γ) (s : σ.SortName) : Formula σ (s :: Γ) :=
  p.subst (fun {_} v => .var (.there v))

def Formula.instantiate (body : Formula σ (s :: Γ)) (term : Term σ Γ s) : Formula σ Γ :=
  body.subst (Substitution.single term)

abbrev Sentence (σ : Signature) := Formula σ []
abbrev Theory (σ : Signature) := List (Sentence σ)

end FormalQ.Sorted
