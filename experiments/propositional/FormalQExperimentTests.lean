import FormalQExperiment
import Lean.Elab.Command
import Lean.Util.CollectAxioms

namespace FormalQ.Experiment

private abbrev p : Formula 2 := .atom 0
private abbrev q : Formula 2 := .atom 1

private def neither : Assignment 2 := .cons false (.cons false .empty)
private def qOnly : Assignment 2 := .cons false (.cons true .empty)
private def both : Assignment 2 := .cons true (.cons true .empty)

theorem consequence_derivation : Derives [.impl p q, p] q :=
  .implElim (.premise List.mem_cons_self) (.premise (List.mem_cons_of_mem _ List.mem_cons_self))

theorem consequence_witness : Models both [.impl p q, p] := by
  exact (List.all_eq_true).mp (show [Formula.impl p q, p].all (evaluate both) = true from rfl)

theorem consequence_verdict : classify [.impl p q, p] q = .entailed := by decide

theorem finds_consequence_witness : findModel? [.impl p q, p] = some both := rfl

theorem refutation_derivation : Derives [p.neg] p.neg := .premise List.mem_cons_self

theorem refutation_witness : Models neither [p.neg] := by
  exact (List.all_eq_true).mp (show [p.neg].all (evaluate neither) = true from rfl)

theorem refutation_verdict : classify [p.neg] p = .refuted := by decide

theorem independence_positive : Models both [p, .impl p q] := by
  exact List.all_eq_true.mp (show [p, Formula.impl p q].all (evaluate both) = true from rfl)

theorem independence_negative : Models neither [p.neg, .impl p q] := by
  exact List.all_eq_true.mp (show [p.neg, Formula.impl p q].all (evaluate neither) = true from rfl)

theorem independence_verdict : classify [.impl p q] p = .independent := by decide

theorem finds_negative_witness : findModel? [p.neg, .impl p q] = some neither := rfl

theorem inconsistent_positive : Derives [p, p.neg] p := .premise List.mem_cons_self

theorem inconsistent_negative : Derives [p, p.neg] p.neg :=
  .premise (List.mem_cons_of_mem _ List.mem_cons_self)

theorem inconsistent_derivation : Derives [p, p.neg] .falsum :=
  .implElim inconsistent_negative inconsistent_positive

theorem inconsistent_verdict : classify [p, p.neg] q = .inconsistent := by decide

theorem rejects_disjunction_projection : ¬ Derives [.disj p q] p := by
  intro proof
  have model : Models qOnly [.disj p q] :=
    List.all_eq_true.mp (show [Formula.disj p q].all (evaluate qOnly) = true from rfl)
  have impossible : false = true := proof.sound qOnly model
  exact Bool.noConfusion impossible

example : True := by
  fail_if_success
    have _outOfRange : Formula 2 := .atom ⟨2, by decide⟩
  trivial

theorem empty_vocabulary_verdict : classify ([] : Theory 0) .falsum = .refuted := by decide

run_cmd do
  let declarations := #[
    ``mem_assignments, ``assignments_length, ``holds_neg, ``models_cons, ``Derives.sound,
    ``findModel_sound, ``hasModel_iff, ``classify_sound, ``consequence_derivation, ``consequence_witness,
    ``consequence_verdict, ``refutation_derivation, ``refutation_witness, ``refutation_verdict,
    ``independence_positive, ``independence_negative, ``independence_verdict,
    ``inconsistent_positive, ``inconsistent_negative, ``inconsistent_derivation,
    ``inconsistent_verdict, ``rejects_disjunction_projection, ``empty_vocabulary_verdict,
    ``finds_consequence_witness, ``finds_negative_witness]
  for declaration in declarations do
    let axioms ← Lean.collectAxioms declaration
    for axiomName in axioms do
      unless axiomName == ``propext || axiomName == ``Quot.sound do
        throwError "{declaration} uses the unexpected axiom {axiomName}"
    Lean.logInfo m!"{declaration} uses {axioms.toList}"

end FormalQ.Experiment
