/-!
A corpus-free experiment in finite propositional verification.
-/

namespace FormalQ.Experiment

inductive Formula (n : Nat) where
  | atom (index : Fin n)
  | falsum
  | conj (left right : Formula n)
  | disj (left right : Formula n)
  | impl (antecedent consequent : Formula n)

def Formula.neg (p : Formula n) : Formula n :=
  .impl p .falsum

inductive Assignment : Nat → Type where
  | empty : Assignment 0
  | cons (bit : Bool) (rest : Assignment n) : Assignment (n + 1)

def Assignment.lookup : Assignment n → Fin n → Bool
  | .empty, index => Fin.elim0 index
  | .cons bit rest, index => Fin.cases bit rest.lookup index

def assignments : (n : Nat) → List (Assignment n)
  | 0 => [.empty]
  | n + 1 =>
    let rest := assignments n
    rest.map (.cons false) ++ rest.map (.cons true)

theorem mem_assignments (v : Assignment n) : v ∈ assignments n := by
  induction v with
  | empty => simp [assignments]
  | cons bit rest ih =>
    cases bit
    · exact List.mem_append_left _ (List.mem_map_of_mem ih)
    · exact List.mem_append_right _ (List.mem_map_of_mem ih)

theorem assignments_length (n : Nat) : (assignments n).length = 2 ^ n := by
  induction n with
  | zero => rfl
  | succ n ih => simp [assignments, ih, Nat.pow_succ, Nat.mul_two]

def evaluate (v : Assignment n) : Formula n → Bool
  | .atom index => v.lookup index
  | .falsum => false
  | .conj p q => evaluate v p && evaluate v q
  | .disj p q => evaluate v p || evaluate v q
  | .impl p q => !evaluate v p || evaluate v q

abbrev Theory (n : Nat) := List (Formula n)

def Holds (v : Assignment n) (p : Formula n) : Prop := evaluate v p = true

def Models (v : Assignment n) (theory : Theory n) : Prop :=
  ∀ p, p ∈ theory → Holds v p

def Satisfiable (theory : Theory n) : Prop := ∃ v : Assignment n, Models v theory

def Entails (theory : Theory n) (query : Formula n) : Prop :=
  ∀ v : Assignment n, Models v theory → Holds v query

private theorem holds_false (v : Assignment n) : Holds v .falsum ↔ False := by
  simp [Holds, evaluate]

private theorem holds_conj (v : Assignment n) (p q : Formula n) :
    Holds v (.conj p q) ↔ Holds v p ∧ Holds v q := by
  simp [Holds, evaluate]

private theorem holds_disj (v : Assignment n) (p q : Formula n) :
    Holds v (.disj p q) ↔ Holds v p ∨ Holds v q := by
  simp [Holds, evaluate]

private theorem holds_impl (v : Assignment n) (p q : Formula n) :
    Holds v (.impl p q) ↔ (Holds v p → Holds v q) := by
  cases hp : evaluate v p <;> cases hq : evaluate v q <;> simp [Holds, evaluate, hp, hq]

theorem holds_neg (v : Assignment n) (p : Formula n) :
    Holds v p.neg ↔ ¬ Holds v p := by
  change Holds v (.impl p .falsum) ↔ ¬ Holds v p
  rw [holds_impl, holds_false]

private theorem holds_or_neg (v : Assignment n) (p : Formula n) :
    Holds v p ∨ Holds v p.neg := by
  cases h : evaluate v p with
  | false =>
    exact Or.inr ((holds_neg v p).mpr (fun hp => Bool.noConfusion (h.symm.trans hp)))
  | true => exact Or.inl h

theorem models_cons (v : Assignment n) (theory : Theory n) (p : Formula n) :
    Models v (p :: theory) ↔ Holds v p ∧ Models v theory := by
  constructor
  · intro h
    exact ⟨h p (List.mem_cons_self), fun q member => h q (List.mem_cons_of_mem _ member)⟩
  · rintro ⟨hp, ht⟩ q member
    rcases List.mem_cons.mp member with equal | tail
    · subst q
      exact hp
    · exact ht q tail

inductive Derives : Theory n → Formula n → Prop where
  | premise : p ∈ theory → Derives theory p
  | falseElim : Derives theory .falsum → Derives theory p
  | conjIntro : Derives theory p → Derives theory q → Derives theory (.conj p q)
  | conjLeft : Derives theory (.conj p q) → Derives theory p
  | conjRight : Derives theory (.conj p q) → Derives theory q
  | disjLeft : Derives theory p → Derives theory (.disj p q)
  | disjRight : Derives theory q → Derives theory (.disj p q)
  | disjElim : Derives theory (.disj p q) → Derives (p :: theory) r →
      Derives (q :: theory) r → Derives theory r
  | implIntro : Derives (p :: theory) q → Derives theory (.impl p q)
  | implElim : Derives theory (.impl p q) → Derives theory p → Derives theory q
  | doubleNegElim : Derives theory p.neg.neg → Derives theory p

theorem Derives.sound (derivation : Derives theory p) : Entails theory p := by
  induction derivation with
  | premise member => exact fun _ model => model _ member
  | falseElim _ ih => exact fun v model => ((holds_false v).mp (ih v model)).elim
  | conjIntro _ _ left right =>
    exact fun v model => (holds_conj v _ _).mpr ⟨left v model, right v model⟩
  | conjLeft _ ih => exact fun v model => ((holds_conj v _ _).mp (ih v model)).1
  | conjRight _ ih => exact fun v model => ((holds_conj v _ _).mp (ih v model)).2
  | disjLeft _ ih => exact fun v model => (holds_disj v _ _).mpr (Or.inl (ih v model))
  | disjRight _ ih => exact fun v model => (holds_disj v _ _).mpr (Or.inr (ih v model))
  | disjElim _ _ _ either left right =>
    intro v model
    rcases (holds_disj v _ _).mp (either v model) with hp | hq
    · exact left v ((models_cons v _ _).mpr ⟨hp, model⟩)
    · exact right v ((models_cons v _ _).mpr ⟨hq, model⟩)
  | implIntro _ ih =>
    exact fun v model => (holds_impl v _ _).mpr fun hp =>
      ih v ((models_cons v _ _).mpr ⟨hp, model⟩)
  | implElim _ _ implication antecedent =>
    exact fun v model => (holds_impl v _ _).mp (implication v model) (antecedent v model)
  | doubleNegElim _ ih =>
    intro v model
    rcases holds_or_neg v _ with hp | hnot
    · exact hp
    · exact ((holds_neg v _).mp (ih v model) hnot).elim

def findModel? (theory : Theory n) : Option (Assignment n) :=
  (assignments n).find? fun v => theory.all (evaluate v)

theorem findModel_sound {theory : Theory n} {v : Assignment n}
    (h : findModel? theory = some v) : Models v theory := by
  have checked : theory.all (evaluate v) = true :=
    List.find?_some (p := fun candidate : Assignment n => theory.all (evaluate candidate)) h
  exact List.all_eq_true.mp checked

def hasModel (theory : Theory n) : Bool := (findModel? theory).isSome

theorem hasModel_iff (theory : Theory n) : hasModel theory = true ↔ Satisfiable theory := by
  unfold hasModel findModel?
  constructor
  · intro h
    obtain ⟨v, _, checked⟩ := List.find?_isSome.mp h
    exact ⟨v, List.all_eq_true.mp checked⟩
  · rintro ⟨v, model⟩
    exact List.find?_isSome.mpr ⟨v, mem_assignments v, List.all_eq_true.mpr model⟩

private theorem hasModel_false (h : hasModel theory = false) : ¬ Satisfiable theory :=
  fun model => Bool.noConfusion (h.symm.trans ((hasModel_iff theory).mpr model))

inductive Verdict where
  | inconsistent
  | entailed
  | refuted
  | independent
  deriving DecidableEq, Repr

def classify (theory : Theory n) (p : Formula n) : Verdict :=
  match hasModel (p :: theory), hasModel (p.neg :: theory) with
  | false, false => .inconsistent
  | true, false => .entailed
  | false, true => .refuted
  | true, true => .independent

def Correct (theory : Theory n) (p : Formula n) : Verdict → Prop
  | .inconsistent => ¬ Satisfiable theory
  | .entailed => Satisfiable theory ∧ Entails theory p
  | .refuted => Satisfiable theory ∧ Entails theory p.neg
  | .independent => Satisfiable (p :: theory) ∧ Satisfiable (p.neg :: theory)

private theorem base_model (h : Satisfiable (p :: theory)) : Satisfiable theory := by
  obtain ⟨v, model⟩ := h
  exact ⟨v, ((models_cons v theory p).mp model).2⟩

theorem classify_sound (theory : Theory n) (p : Formula n) :
    Correct theory p (classify theory p) := by
  unfold classify
  cases hpos : hasModel (p :: theory) <;> cases hneg : hasModel (p.neg :: theory)
  · change ¬ Satisfiable theory
    rintro ⟨v, model⟩
    rcases holds_or_neg v p with hp | hn
    · exact hasModel_false hpos ⟨v, (models_cons v theory p).mpr ⟨hp, model⟩⟩
    · exact hasModel_false hneg ⟨v, (models_cons v theory p.neg).mpr ⟨hn, model⟩⟩
  · change Satisfiable theory ∧ Entails theory p.neg
    refine ⟨base_model ((hasModel_iff _).mp hneg), ?_⟩
    intro v model
    rcases holds_or_neg v p with hp | hn
    · exact (hasModel_false hpos ⟨v, (models_cons v theory p).mpr ⟨hp, model⟩⟩).elim
    · exact hn
  · change Satisfiable theory ∧ Entails theory p
    refine ⟨base_model ((hasModel_iff _).mp hpos), ?_⟩
    intro v model
    rcases holds_or_neg v p with hp | hn
    · exact hp
    · exact (hasModel_false hneg ⟨v, (models_cons v theory p.neg).mpr ⟨hn, model⟩⟩).elim
  · exact ⟨(hasModel_iff _).mp hpos, (hasModel_iff _).mp hneg⟩

end FormalQ.Experiment
