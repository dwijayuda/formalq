# 17 — Synthetic propositional experiment

Status: first experimental result, 2026-11-27. Lean checked the inference rules and the mathematical meaning of all four classifier outcomes. The experiment uses invented atoms and formulas. G1 source qualification and the production roadmap continue independently.

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

## Checked result

The [Lean module](../experiments/propositional/FormalQExperiment.lean) proves the following for arbitrary finite vocabulary size and any finite propositional premise list.

| Theorem | Kernel-checked statement |
|---|---|
| `mem_assignments`, `assignments_length` | Each typed assignment occurs in the enumeration, which has length `2^n`. |
| `Derives.sound` | Any derivation from the included rules preserves truth in every model of its premise list. |
| `findModel_sound`, `hasModel_iff` | Every returned assignment satisfies the exact input theory, and the search succeeds exactly when a satisfying assignment exists. |
| `classify_sound` | The classifier's verdict has the meaning in the table above. In particular, entailment and refutation include existence of a base model. |

The [synthetic controls](../experiments/propositional/FormalQExperimentTests.lean) include modus ponens with a model, explicit refutation, two opposite models for an independent claim, and a contradictory base with derivations in both directions. Lean also rejects a forbidden atom index, proves that projecting an atom from a disjunction is not derivable by these rules, and classifies falsity in an empty vocabulary.

## Replay

```sh
cd experiments/propositional
lean --version
lake build
lake env leanchecker --verbose FormalQExperiment FormalQExperimentTests
```

The checked release was Lean 4.35.0, build commit `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`, on x86-64 Windows. Lake compiled both targets with warnings as errors from a clean source archive, and Lean's bundled `leanchecker` replayed both modules. The audit fails the build on any axiom outside `propext` and `Quot.sound`. The auxiliary `lean4lean` binary on the host rejected the compiled module's header during an exploratory run. The reported evidence is Lean kernel checking and replay. [Lean 4.35.0 release](https://github.com/leanprover/lean4/releases/tag/v4.35.0)

The enumeration stores `2^n` assignments, so the checker is a reference for small synthetic theories. The inference system has a soundness theorem. The semantic search, separately, exhausts the represented valuations. A later external certificate interface still needs input binding and a checkable bridge to the sorted semantics. A next experiment can evaluate that bridge on a small synthetic first-order signature while reviewed source qualification continues.
