# 18 — Synthetic sorted first-order experiment

Status: acceptance plan, 2026-11-27. This experiment extends the mathematical work in [the propositional result](17-SYNTHETIC-RESULT.md). It uses invented signatures and models. Source qualification and review of real interpretations remain governed by the [roadmap](10-ROADMAP.md).

## Design decision

A signature declares sorts, constants, unary functions, and unary and binary relations. The type of each term names its sort and variable context. A formula scopes its own binders and admits equality only within a sort. A structure interprets each sort as a separate nonempty domain, interprets functions as total maps, and gives relations propositional semantics. For a supplied finite structure, its presentation supplies complete domain enumerations and decisions for equality and relation membership.

The experiment directly encodes typed contexts because its immediate questions concern binder safety and checking a supplied finite structure. Mathlib's first-order semantics uses a single carrier with functions and relations of arbitrary finite arity. Foundation provides a broader metatheory of first-order deduction. A production bridge could reuse that work by translating to a single carrier with checked sort guards, existence conditions and function closure. Such a bridge must establish satisfaction preservation and must validate decoding before transporting a countermodel. The Isabelle sort-encoding development offers a reference for this obligation. The direct encoding here leaves that comparison and the production calculus choice open. [Mathlib realization](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/ModelTheory/Semantics.lean), [Foundation](https://github.com/FormalizedFormalLogic/Foundation), [verified sort encodings](https://isa-afp.org/entries/Sort_Encodings.html)

## Acceptance criteria

- A variable position is valid for its context and sort. Replacing an outer variable under a new binder must preserve the binding of both. Prove the general satisfaction law for typed substitutions and give a nested-binder regression.
- Prove semantic soundness of the included derivation constructors over all matching nonempty structures. Test quantifier introduction and elimination and reject an ill-sorted atom and an unbound variable.
- Prove that evaluating a formula in a supplied finite presentation agrees with its semantics, and prove the corresponding claim for every premise in a closed theory. Return evidence relative to that exact theory and structure. A rejected model supplies no global unsatisfiability result.
- Exhibit a checked model for each polarity of a query in one synthetic theory and a checked derivation with a separate satisfiability witness in another. Record the Lean version, exact axioms, replay commands and limits.
