import FormalQSorted.Semantics

namespace FormalQ.Sorted

variable {σ : Signature} {M : Structure σ}

private theorem satisfiesAll_cons (head : Satisfies ρ p) (tail : SatisfiesAll ρ premises) :
    SatisfiesAll ρ (p :: premises) := by
  intro q member
  rcases List.mem_cons.mp member with equal | rest
  · subst q
    exact head
  · exact tail q rest

private theorem satisfiesAll_weaken (ρ : Valuation M Γ) (value : M.Carrier s)
    (all : SatisfiesAll ρ premises) :
    SatisfiesAll (ρ.extend value) (premises.map (·.weaken s)) := by
  intro q member
  obtain ⟨p, sourceMember, rfl⟩ := List.mem_map.mp member
  exact (satisfies_weaken ρ value p).mpr (all p sourceMember)

/-- A small natural-deduction fragment with explicit context extension at quantifier rules. -/
inductive Derives (σ : Signature) : {Γ : List σ.SortName} →
    List (Formula σ Γ) → Formula σ Γ → Prop where
  | premise : p ∈ premises → Derives σ premises p
  | falseElim : Derives σ premises .falsum → Derives σ premises p
  | equalRefl (term : Term σ Γ s) : Derives σ premises (.equal term term)
  | conjIntro : Derives σ premises p → Derives σ premises q → Derives σ premises (.conj p q)
  | conjLeft : Derives σ premises (.conj p q) → Derives σ premises p
  | conjRight : Derives σ premises (.conj p q) → Derives σ premises q
  | disjLeft : Derives σ premises p → Derives σ premises (.disj p q)
  | disjRight : Derives σ premises q → Derives σ premises (.disj p q)
  | disjElim : Derives σ premises (.disj p q) → Derives σ (p :: premises) r →
      Derives σ (q :: premises) r → Derives σ premises r
  | implIntro : Derives σ (p :: premises) q → Derives σ premises (.impl p q)
  | implElim : Derives σ premises (.impl p q) → Derives σ premises p → Derives σ premises q
  | allIntro {Γ : List σ.SortName} {premises : List (Formula σ Γ)}
      {s : σ.SortName} {body : Formula σ (s :: Γ)} :
      Derives σ (premises.map (·.weaken s)) body →
      Derives σ premises (.all s body)
  | allElim (term : Term σ Γ s) : Derives σ premises (.all s body) →
      Derives σ premises (body.instantiate term)
  | exIntro (term : Term σ Γ s) : Derives σ premises (body.instantiate term) →
      Derives σ premises (.ex s body)
  | exElim {Γ : List σ.SortName} {premises : List (Formula σ Γ)}
      {s : σ.SortName} {body : Formula σ (s :: Γ)} {q : Formula σ Γ} :
      Derives σ premises (.ex s body) →
      Derives σ (body :: premises.map (·.weaken s)) (q.weaken s) → Derives σ premises q

theorem Derives.sound (proof : Derives σ premises query) (M : Structure σ) :
    ∀ ρ, SatisfiesAll (M := M) ρ premises → Satisfies ρ query := by
  induction proof with
  | premise member => exact fun _ holds => holds _ member
  | falseElim _ ih => exact fun ρ holds => (ih ρ holds).elim
  | equalRefl _ => intros; rfl
  | conjIntro _ _ left right => exact fun ρ holds => ⟨left ρ holds, right ρ holds⟩
  | conjLeft _ ih => exact fun ρ holds => (ih ρ holds).1
  | conjRight _ ih => exact fun ρ holds => (ih ρ holds).2
  | disjLeft _ ih => exact fun ρ holds => Or.inl (ih ρ holds)
  | disjRight _ ih => exact fun ρ holds => Or.inr (ih ρ holds)
  | disjElim _ _ _ either left right =>
    intro ρ holds
    rcases either ρ holds with hp | hq
    · exact left ρ (satisfiesAll_cons hp holds)
    · exact right ρ (satisfiesAll_cons hq holds)
  | implIntro _ ih => exact fun ρ holds hp => ih ρ (satisfiesAll_cons hp holds)
  | implElim _ _ implication antecedent => exact fun ρ holds => implication ρ holds (antecedent ρ holds)
  | allIntro _ ih =>
    exact fun ρ holds value => ih (ρ.extend value) (satisfiesAll_weaken ρ value holds)
  | allElim term _ ih =>
    exact fun ρ holds => (satisfies_instantiate ρ term _).mpr (ih ρ holds (term.eval ρ))
  | exIntro term _ ih =>
    exact fun ρ holds => ⟨term.eval ρ, (satisfies_instantiate ρ term _).mp (ih ρ holds)⟩
  | exElim _ _ existsProof branch =>
    intro ρ holds
    obtain ⟨value, witness⟩ := existsProof ρ holds
    exact (satisfies_weaken ρ value _).mp
      (branch (ρ.extend value) (satisfiesAll_cons witness (satisfiesAll_weaken ρ value holds)))

theorem Derives.entails {premises : Theory σ} {query : Sentence σ}
    (proof : Derives σ premises query) : Entails premises query :=
  fun model holds => proof.sound model (Valuation.empty model) holds

end FormalQ.Sorted
