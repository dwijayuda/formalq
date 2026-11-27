import FormalQSorted.Semantics

namespace FormalQ.Sorted

variable {σ : Signature} {M : Structure σ}

/-- A computational presentation of one structure, with evidence that its lists cover each domain. -/
structure FinitePresentation (M : Structure σ) where
  values : ∀ s, List (M.Carrier s)
  covers : ∀ s (value : M.Carrier s), value ∈ values s
  decideEqual : ∀ s, DecidableEq (M.Carrier s)
  decideUnary : ∀ ⦃s⦄ (symbol : σ.Unary s) (value : M.Carrier s), Decidable (M.unary symbol value)
  decideBinary : ∀ ⦃s t⦄ (symbol : σ.Binary s t) (left : M.Carrier s) (right : M.Carrier t),
    Decidable (M.binary symbol left right)

def evaluate (F : FinitePresentation M) (ρ : Valuation M Γ) : Formula σ Γ → Bool
  | .falsum => false
  | .equal left right => @decide _ (F.decideEqual _ (left.eval ρ) (right.eval ρ))
  | .unary symbol input => @decide _ (F.decideUnary symbol (input.eval ρ))
  | .binary symbol left right => @decide _ (F.decideBinary symbol (left.eval ρ) (right.eval ρ))
  | .conj p q => evaluate F ρ p && evaluate F ρ q
  | .disj p q => evaluate F ρ p || evaluate F ρ q
  | .impl p q => !evaluate F ρ p || evaluate F ρ q
  | .all s body => (F.values s).all fun value => evaluate F (ρ.extend value) body
  | .ex s body => (F.values s).any fun value => evaluate F (ρ.extend value) body

private theorem evaluate_imp_iff (a b : Bool) : (!a || b) = true ↔ (a = true → b = true) := by
  cases a <;> cases b <;> decide

theorem evaluate_iff (F : FinitePresentation M) (p : Formula σ Γ) :
    ∀ ρ : Valuation M Γ, evaluate F ρ p = true ↔ Satisfies ρ p := by
  induction p with
  | falsum => intro ρ; simp [evaluate, Satisfies]
  | equal left right => intro ρ; simp only [evaluate, Satisfies, decide_eq_true_eq]
  | unary symbol input => intro ρ; simp only [evaluate, Satisfies, decide_eq_true_eq]
  | binary symbol left right => intro ρ; simp only [evaluate, Satisfies, decide_eq_true_eq]
  | conj p q left right =>
    intro ρ
    simp only [evaluate, Satisfies, Bool.and_eq_true, left ρ, right ρ]
  | disj p q left right =>
    intro ρ
    simp only [evaluate, Satisfies, Bool.or_eq_true, left ρ, right ρ]
  | impl p q left right =>
    intro ρ
    exact (evaluate_imp_iff _ _).trans (imp_congr (left ρ) (right ρ))
  | all s body ih =>
    intro ρ
    simp only [evaluate, Satisfies, List.all_eq_true]
    constructor
    · intro checked value
      exact (ih _).mp (checked value (F.covers s value))
    · intro holds value _
      exact (ih _).mpr (holds value)
  | ex s body ih =>
    intro ρ
    simp only [evaluate, Satisfies, List.any_eq_true]
    constructor
    · rintro ⟨value, _, checked⟩
      exact ⟨value, (ih _).mp checked⟩
    · rintro ⟨value, holds⟩
      exact ⟨value, F.covers s value, (ih _).mpr holds⟩

def checkModel (F : FinitePresentation M) (theory : Theory σ) : Bool :=
  theory.all (evaluate F (Valuation.empty M))

theorem checkModel_iff (F : FinitePresentation M) (theory : Theory σ) :
    checkModel F theory = true ↔ Models M theory := by
  change theory.all (evaluate F (Valuation.empty M)) = true ↔ _
  simp only [List.all_eq_true, evaluate_iff, Models, SatisfiesAll]

theorem countermodel (F : FinitePresentation M) {theory : Theory σ} {query : Sentence σ}
    (checked : checkModel F theory = true)
    (failed : evaluate F (Valuation.empty M) query = false) : ¬ Entails theory query := by
  intro entailment
  have holds := entailment M ((checkModel_iff F theory).mp checked)
  have yes := (evaluate_iff F query (Valuation.empty M)).mpr holds
  exact Bool.noConfusion (failed.symm.trans yes)

end FormalQ.Sorted
