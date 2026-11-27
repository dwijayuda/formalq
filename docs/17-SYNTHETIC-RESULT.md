# 17 — Synthetic propositional experiment

Status: acceptance plan, 2026-11-27. This experiment isolates the first mathematical result from the unresolved acquisition and interpretation reviews. It uses only invented atoms and formulas. G1 source qualification and the production roadmap continue independently.

## Question and scope

Can one small Lean model make the distinction between consequence, joint satisfiability, independence and an inconsistent base theory precise enough to check? Fix a finite vocabulary of `n` uninterpreted Boolean atoms. A formula uses atoms, falsity, conjunction, disjunction and material implication. Negation abbreviates implication to falsity. A valuation is a length-`n` Boolean assignment. A theory is a finite list of formulas. A model satisfies every formula in the list. Entailment means that every model of the theory satisfies the query.

The propositional fragment supports an exhaustive truth-table oracle and explicit derivations. We use a standalone bounded experiment to establish those contracts before choosing a production first-order calculus. The alternatives for G3 remain library reuse, a proved translation or a custom sorted embedding. Foundation's formalized logic and Mathlib's first-order semantics are candidates for the broader calculus. [Lean architecture](06-LEAN.md)

## Mathematical specification

If `t` means that `T ∪ {p}` is satisfiable and `f` means that `T ∪ {¬p}` is satisfiable, the classifier for this finite fragment is:

| `t` | `f` | Result | Required meaning |
|---|---|---|---|
| false | false | Inconsistent theory | No model of the base theory exists |
| true | false | Entailment | The base has a model and every base model satisfies the query |
| false | true | Refutation | The base has a model and every base model satisfies the negated query |
| true | true | Independence | There is a checked model for each polarity |

Exhaustiveness is a theorem obligation for the enumeration of assignments. Each check must interpret exactly the propositions used by the theory. A second obligation is soundness of the included inference rules, expressed as preservation of satisfaction in every base model. The test suite must distinguish a derivation from a consistency witness and show that opposing derivations carry no ordinary classification in an inconsistent theory.

## Acceptance evidence

- Pin a Lean release and replay the build with warnings as errors. Audit every exported theorem used to substantiate the result.
- Establish completeness of assignment enumeration and the equivalence between Boolean model search and mathematical satisfiability. Prove that the classifier's four outcomes satisfy the table.
- Check synthetic controls for a derived consequence, a refutation, two models preserving different polarities, and a contradictory base. Exercise all four outcomes and reject an out-of-range atom and the invalid projection from a disjunction.
- Document exact replay results and the finite exponential cost. The result covers this propositional experiment. Sorted quantification, interpretation lowering, real-data alignment and hadith comparison retain their existing acceptance requirements.
