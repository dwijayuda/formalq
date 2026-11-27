import FormalQSorted
import Lean.Elab.Command
import Lean.Util.CollectAxioms

namespace FormalQ.Sorted.Tests

inductive Kind where
  | agent
  | place

inductive Named : Kind → Type where
  | ada : Named .agent
  | room : Named .place

inductive MapSymbol : Kind → Kind → Type where
  | home : MapSymbol .agent .place

inductive Property : Kind → Type where
  | marked : Property .agent

inductive Relation : Kind → Kind → Type where
  | visits : Relation .agent .place

def demo : Signature where
  SortName := Kind
  Constant := Named
  Function := MapSymbol
  Unary := Property
  Binary := Relation

def carrier : Kind → Type
  | .agent => Bool
  | .place => Unit

def sample (everyone : Bool) : Structure demo where
  Carrier := carrier
  nonempty
    | .agent => ⟨false⟩
    | .place => ⟨()⟩
  constant
    | _, .ada => true
    | _, .room => ()
  function
    | _, _, .home, _ => ()
  unary
    | _, .marked, agent => agent = true
  binary
    | _, _, .visits, agent, _ => (everyone || agent) = true

def samplePresentation (everyone : Bool) : FinitePresentation (sample everyone) where
  values
    | .agent => [false, true]
    | .place => [()]
  covers := by
    intro kind value
    cases kind
    · cases value
      · exact List.mem_cons_self
      · exact List.mem_cons_of_mem _ List.mem_cons_self
    · cases value
      exact List.mem_cons_self
  decideEqual := by
    intro kind
    cases kind
    · change DecidableEq Bool
      infer_instance
    · change DecidableEq Unit
      infer_instance
  decideUnary := by
    intro _ symbol value
    cases symbol
    exact @decEq Bool (inferInstance : DecidableEq Bool) value true
  decideBinary := by
    intro _ _ symbol agent place
    cases symbol
    change Decidable ((everyone || agent) = true)
    infer_instance

def goesHome (agent : Term demo Γ .agent) : Formula demo Γ :=
  .binary Relation.visits agent (.apply MapSymbol.home agent)

def homeBody : Formula demo [.agent] := goesHome (.var .here)

def allHome : Sentence demo := .all .agent homeBody

def someHome : Sentence demo := .ex .agent homeBody

def adaHome : Sentence demo := goesHome (.constant Named.ada)

theorem specializes_universal : Derives demo [allHome] adaHome := by
  have universal : Derives demo [allHome] (.all .agent homeBody) := .premise List.mem_cons_self
  exact Derives.allElim (body := homeBody) (.constant Named.ada) universal

theorem specializes_entailment : Entails [allHome] adaHome :=
  specializes_universal.entails

theorem supports_universal_premise : Models (sample true) [allHome] :=
  (checkModel_iff (samplePresentation true) [allHome]).mp rfl

theorem introduces_universal :
    Derives demo (Γ := []) [] (.all .agent (.equal (.var .here) (.var .here))) :=
  .allIntro (.equalRefl (.var .here))

theorem introduces_existential : Derives demo [allHome] someHome :=
  .exIntro (.constant Named.ada) specializes_universal

theorem eliminates_existential : Derives demo (Γ := []) [.ex .agent .falsum] .falsum :=
  .exElim (.premise List.mem_cons_self) (.premise (show Formula.falsum ∈ _ from List.mem_cons_self))

theorem supports_positive_extension : Models (sample true) [allHome, someHome] :=
  (checkModel_iff (samplePresentation true) [allHome, someHome]).mp rfl

theorem supports_negative_extension : Models (sample false) [allHome.neg, someHome] :=
  (checkModel_iff (samplePresentation false) [allHome.neg, someHome]).mp rfl

theorem positive_polarity_countermodel : ¬ Entails [someHome] allHome :=
  countermodel (samplePresentation false) rfl rfl

theorem negative_polarity_countermodel : ¬ Entails [someHome] allHome.neg :=
  countermodel (samplePresentation true) rfl rfl

theorem rejects_nonmodel : checkModel (samplePresentation false) [someHome, allHome] = false :=
  rfl

private def nested : Formula demo [.agent, .agent] :=
  .all .agent (.equal (.var (.there .here)) (.var .here))

theorem preserves_binding_under_substitution :
    nested.instantiate (.var .here : Term demo [.agent] .agent) =
      .all .agent (.equal (.var (.there .here)) (.var .here)) :=
  rfl

theorem captured_formula_would_change_result :
    let query : Sentence demo := .all .agent (nested.instantiate (.var .here))
    evaluate (samplePresentation true) (Valuation.empty (sample true)) query = false :=
  rfl

example : True := by
  fail_if_success
    have _bad : Sentence demo := .binary Relation.visits (.constant Named.room) (.constant Named.room)
  fail_if_success
    have _bad : Term demo [] .agent := .var .here
  trivial

run_cmd do
  let declarations := #[
    ``Term.eval_rename, ``Term.eval_subst, ``satisfies_subst, ``satisfies_weaken,
    ``satisfies_instantiate, ``Derives.sound, ``Derives.entails, ``evaluate_iff,
    ``checkModel_iff, ``countermodel, ``specializes_universal, ``specializes_entailment,
    ``supports_universal_premise, ``introduces_universal, ``introduces_existential,
    ``eliminates_existential, ``supports_positive_extension, ``supports_negative_extension,
    ``positive_polarity_countermodel, ``negative_polarity_countermodel, ``rejects_nonmodel,
    ``preserves_binding_under_substitution, ``captured_formula_would_change_result]
  for declaration in declarations do
    let axioms ← Lean.collectAxioms declaration
    for axiomName in axioms do
      unless axiomName == ``propext || axiomName == ``Quot.sound do
        throwError "{declaration} uses the unexpected axiom {axiomName}"
    Lean.logInfo m!"{declaration} uses {axioms.toList}"

end FormalQ.Sorted.Tests
