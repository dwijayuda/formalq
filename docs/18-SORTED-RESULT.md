# 18 — Synthetic sorted first-order experiment

Status: checked synthetic result, 2026-11-27. This experiment extends the mathematical work in [the propositional result](17-SYNTHETIC-RESULT.md). It uses invented signatures and models. Source qualification and review of real interpretations remain governed by the [roadmap](10-ROADMAP.md).

## Design decision

A signature declares sorts, constants, unary functions, and unary and binary relations. The type of each term names its sort and variable context. A formula scopes its own binders and admits equality only within a sort. A structure interprets each sort as a separate nonempty domain, interprets functions as total maps, and gives relations propositional semantics. For a supplied finite structure, its presentation supplies complete domain enumerations and decisions for equality and relation membership.

The experiment directly encodes typed contexts because its immediate questions concern binder safety and checking a supplied finite structure. Mathlib's first-order semantics uses a single carrier with functions and relations of arbitrary finite arity. Foundation provides a broader metatheory of first-order deduction. A production bridge could reuse that work by translating to a single carrier with checked sort guards, existence conditions and function closure. Such a bridge must establish satisfaction preservation and must validate decoding before transporting a countermodel. The Isabelle sort-encoding development offers a reference for this obligation. The direct encoding here leaves that comparison and the production calculus choice open. [Mathlib realization](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/ModelTheory/Semantics.lean), [Foundation](https://github.com/FormalizedFormalLogic/Foundation), [verified sort encodings](https://isa-afp.org/entries/Sort_Encodings.html)

## Acceptance criteria

- A variable position is valid for its context and sort. Replacing an outer variable under a new binder must preserve the binding of both. Prove the general satisfaction law for typed substitutions and give a nested-binder regression.
- Prove semantic soundness of the included derivation constructors over all matching nonempty structures. Test quantifier introduction and elimination and reject an ill-sorted atom and an unbound variable.
- Prove that evaluating a formula in a supplied finite presentation agrees with its semantics, and prove the corresponding claim for every premise in a closed theory. Return evidence relative to that exact theory and structure. A rejected model supplies no global unsatisfiability result.
- Exhibit a checked model for each polarity of a query in one synthetic theory and a checked derivation with a separate satisfiability witness in another. Record the Lean version, exact axioms, replay commands and limits.

## Checked result

| Obligation | Evidence |
|---|---|
| Typed binding and substitution | `Var Γ s` carries both context and sort. `satisfies_subst` shows that evaluation after substitution agrees with evaluation under a valuation that gives the substituted terms the corresponding values. When a formula introduces a binder, the substitution leaves its new variable in place and shifts the variables in the substituted terms. `satisfies_weaken` and `satisfies_instantiate` specialize the general law. [Syntax](../experiments/sorted-first-order/FormalQSorted/Syntax.lean), [semantics](../experiments/sorted-first-order/FormalQSorted/Semantics.lean) |
| Deductive consequence | `Derives.sound` proves truth preservation for every included constructor in any matching structure and valuation where the premises hold. `Derives.entails` specializes it to closed theories and queries. Universal introduction weakens the old premises into the extended context. Existential elimination also weakens the conclusion, so its truth does not depend on a bound witness escaping its scope. [Deduction](../experiments/sorted-first-order/FormalQSorted/Deduction.lean) |
| Finite-model certification | `evaluate_iff` relates Boolean evaluation to satisfaction for every formula in a supplied finite presentation. The proof uses complete, per-sort domain enumerations. `checkModel_iff` covers the entire premise list. `countermodel` turns an accepted base model with a false query into a proof of non-entailment for that exact base and query. [Finite models](../experiments/sorted-first-order/FormalQSorted/FiniteModel.lean) |

In the invented model, agents range over two values and places over one. A unary function maps an agent to its home and a binary relation records visits. From “every agent visits its home,” Lean verifies the derivation for the named agent Ada and checks a separate model of the premise. With “some agent visits its home” as the only premise, one model has everyone visit and the other has exactly one agent visit. Both extensions are satisfiable, and each model refutes one direction of entailment. The controls also cover quantified introduction and elimination, nested substitution, a rejected presentation for a particular theory, and ill-sorted and unbound input. [Executable controls](../experiments/sorted-first-order/FormalQSortedTests.lean)

## Replay

```sh
cd experiments/sorted-first-order
lean --version
lake build
lake env leanchecker --verbose FormalQSorted FormalQSortedTests
```

A clean source archive was built with Lean 4.35.0, commit `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`, on x86-64 Windows. The official `leanchecker` replayed the sorted modules and controls. The propositional package and five acquisition tests also passed from the archive. The audit allows only `propext` and `Quot.sound`; term renaming and term substitution use neither. The formula substitution theorem uses `propext`. The soundness and finite-evaluation results use both. [Lean 4.35.0 release](https://github.com/leanprover/lean4/releases/tag/v4.35.0)

## Limits

The supported arities are fixed. Soundness covers the included natural-deduction rules. General equality elimination, classical completeness, and arbitrary-arity syntax remain open. The checker evaluates a supplied finite presentation and can certify it as a model or countermodel. Search over structures and certification of global unsatisfiability require separate work. The boundary from externally supplied bytes to the typed problem still needs validation and exact input binding. The two experiments leave Quranic interpretation, qirāʾāt alignment and historical hadith evaluation to their own evidence and reviews.
