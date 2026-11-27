import FormalQSorted.Syntax

namespace FormalQ.Sorted

structure Structure (σ : Signature) where
  Carrier : σ.SortName → Type
  nonempty : ∀ s, Nonempty (Carrier s)
  constant : ∀ ⦃s⦄, σ.Constant s → Carrier s
  function : ∀ ⦃s t⦄, σ.Function s t → Carrier s → Carrier t
  unary : ∀ ⦃s⦄, σ.Unary s → Carrier s → Prop
  binary : ∀ ⦃s t⦄, σ.Binary s t → Carrier s → Carrier t → Prop

variable {σ : Signature} {M : Structure σ}

abbrev Valuation (M : Structure σ) (Γ : List σ.SortName) :=
  ∀ ⦃s⦄, Var Γ s → M.Carrier s

def Valuation.empty (M : Structure σ) : Valuation M []
  | _, position => nomatch position

def Valuation.extend (ρ : Valuation M Γ) (value : M.Carrier s) : Valuation M (s :: Γ)
  | _, .here => value
  | _, .there v => ρ v

def Term.eval (ρ : Valuation M Γ) : Term σ Γ s → M.Carrier s
  | .var v => ρ v
  | .constant c => M.constant c
  | .apply symbol input => M.function symbol (input.eval ρ)

theorem Term.eval_rename (term : Term σ Γ s) (f : Renaming Γ Δ)
    (source : Valuation M Γ) (target : Valuation M Δ)
    (related : ∀ ⦃t⦄ (v : Var Γ t), target (f v) = source v) :
    (term.rename f).eval target = term.eval source := by
  induction term with
  | var v => exact related v
  | constant c => rfl
  | apply symbol input ih => exact congrArg (M.function symbol) ih

theorem Term.eval_subst (term : Term σ Γ s) (f : Substitution σ Γ Δ)
    (source : Valuation M Γ) (target : Valuation M Δ)
    (related : ∀ ⦃t⦄ (v : Var Γ t), (f v).eval target = source v) :
    (term.subst f).eval target = term.eval source := by
  induction term with
  | var v => exact related v
  | constant c => rfl
  | apply symbol input ih => exact congrArg (M.function symbol) ih

private theorem lift_compatible (f : Substitution σ Γ Δ) (source : Valuation M Γ)
    (target : Valuation M Δ) (related : ∀ ⦃t⦄ (v : Var Γ t), (f v).eval target = source v)
    (value : M.Carrier s) (v : Var (s :: Γ) t) :
    (f.lift s v).eval (target.extend value) = (source.extend value) v := by
  cases v with
  | here => rfl
  | there v =>
    exact ((f v).eval_rename (fun {_} position => .there position) target
      (target.extend value) (fun {_} _ => rfl)).trans (related v)

/-- Tarski semantics for any structure with the given signature. -/
def Satisfies (ρ : Valuation M Γ) : Formula σ Γ → Prop
  | .falsum => False
  | .equal left right => left.eval ρ = right.eval ρ
  | .unary symbol input => M.unary symbol (input.eval ρ)
  | .binary symbol left right => M.binary symbol (left.eval ρ) (right.eval ρ)
  | .conj p q => Satisfies ρ p ∧ Satisfies ρ q
  | .disj p q => Satisfies ρ p ∨ Satisfies ρ q
  | .impl p q => Satisfies ρ p → Satisfies ρ q
  | .all s body => ∀ value : M.Carrier s, Satisfies (ρ.extend value) body
  | .ex s body => ∃ value : M.Carrier s, Satisfies (ρ.extend value) body

theorem satisfies_subst (p : Formula σ Γ) :
    ∀ {Δ} (f : Substitution σ Γ Δ) (source : Valuation M Γ) (target : Valuation M Δ),
      (∀ ⦃t⦄ (v : Var Γ t), (f v).eval target = source v) →
      (Satisfies target (p.subst f) ↔ Satisfies source p) := by
  induction p with
  | falsum => intros; rfl
  | equal left right =>
    intro Δ f source target related
    simp only [Formula.subst, Satisfies, Term.eval_subst _ f source target related]
  | unary symbol input =>
    intro Δ f source target related
    simp only [Formula.subst, Satisfies, Term.eval_subst _ f source target related]
  | binary symbol left right =>
    intro Δ f source target related
    simp only [Formula.subst, Satisfies, Term.eval_subst _ f source target related]
  | conj p q left right =>
    intro Δ f source target related
    exact and_congr (left f source target related) (right f source target related)
  | disj p q left right =>
    intro Δ f source target related
    exact or_congr (left f source target related) (right f source target related)
  | impl p q left right =>
    intro Δ f source target related
    exact imp_congr (left f source target related) (right f source target related)
  | all s body ih =>
    intro Δ f source target related
    apply forall_congr'
    intro value
    exact ih (f.lift s) (source.extend value) (target.extend value)
      (fun {_} v => lift_compatible f source target related value v)
  | ex s body ih =>
    intro Δ f source target related
    apply exists_congr
    intro value
    exact ih (f.lift s) (source.extend value) (target.extend value)
      (fun {_} v => lift_compatible f source target related value v)

theorem satisfies_weaken (ρ : Valuation M Γ) (value : M.Carrier s) (p : Formula σ Γ) :
    Satisfies (ρ.extend value) (p.weaken s) ↔ Satisfies ρ p :=
  satisfies_subst p (fun {_} v => .var (.there v)) ρ (ρ.extend value) (fun {_} _ => rfl)

theorem satisfies_instantiate (ρ : Valuation M Γ) (term : Term σ Γ s) (body : Formula σ (s :: Γ)) :
    Satisfies ρ (body.instantiate term) ↔ Satisfies (ρ.extend (term.eval ρ)) body := by
  apply satisfies_subst
  intro t position
  cases position <;> rfl

def Holds (M : Structure σ) (sentence : Sentence σ) : Prop :=
  Satisfies (Valuation.empty M) sentence

def SatisfiesAll (ρ : Valuation M Γ) (premises : List (Formula σ Γ)) : Prop :=
  ∀ p, p ∈ premises → Satisfies ρ p

def Models (M : Structure σ) (theory : Theory σ) : Prop :=
  SatisfiesAll (Valuation.empty M) theory

def Entails (theory : Theory σ) (query : Sentence σ) : Prop :=
  ∀ M : Structure σ, Models M theory → Holds M query

end FormalQ.Sorted
