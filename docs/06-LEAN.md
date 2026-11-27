# 06 — Lean 4 architecture
Status: planned. G3 starts after the required upstream gates. No toolchain or library has been selected and no project proof has been compiled.

## Proposed modules
    FormalQ/
      Data/Ids.lean
      Data/Source.lean
      Syntax/Sort.lean
      Syntax/Term.lean
      Syntax/Formula.lean
      Semantics/Structure.lean
      Semantics/Satisfaction.lean
      Logic/Derivation.lean
      Logic/Soundness.lean
      Interpretation/Profile.lean
      Interpretation/Provenance.lean
      Theory/Context.lean
      Verification/Certificate.lean
      Verification/FiniteModel.lean
      Hadith/Comparison.lean
      Pilot/
      Tests/

Imports must flow from data/syntax to semantics, calculus and verification. Interpretation supplies validated theories; hadith imports comparison interfaces, never the reverse. Raw text ingestion and linguistic NLP run outside Lean in deterministic data tooling. Lean verifies the IR, certificates and model claims; it is not an Arabic parser or semantic oracle.

## Interface sketch (pseudocode, not Lean source)
Signature defines sorts/functions/predicates and arities.
Formula(S) is typed syntax; Structure(S) interprets it.
Satisfies(M, valuation, formula) gives semantics.
Derivation(T, phi) records a proof from theory membership and rules.
sound : Derivation(T, phi) -> every model satisfying T satisfies phi.
Profile packages theory, provenance IDs, context and review state.
Comparison evidence includes entailment, refutation, model witness, unknown or invalid.

Prove substitution/weakening, interpretation of closed formulas, and soundness. A verified finite-model checker must produce a theorem about its exact input theory, not just a Boolean. Avoid decidability claims for arbitrary FOL. Keep the syntax fragment small until tests and soundness are complete.

## Build tooling
Pin Lean toolchain and dependency commits after a compatibility spike; prefer minimal dependencies initially, add mathlib only if needed. Lake build, CI on clean checkout, tests for valid/invalid formulas, proof dependency inspection and source/manifest checks. No sorry warnings tolerated in verified modules. Generated input is parsed/validated, never executed as arbitrary Lean code; treat all source data as untrusted.

## Alternatives
Direct shallow embedding is convenient but obscures portable syntax and proof search. Deep embedding supports explicit provenance and certificates; hybrid bridges to Lean Prop may be proven later. Lean is provisional primary target; Coq/Isabelle and SMT remain comparative options. Do not build a new prover before checking existing libraries.

## Planned qualification spike

Evaluate three routes against the same synthetic inputs from the [verification specification](15-VERIFICATION-SPEC.md).

| Route | Evidence required |
|---|---|
| Reuse Mathlib semantics and a supported calculus from the Foundation project | Reproduce a pinned checkout. Identify exact syntax, realization, derivability and soundness objects. Check the treatment of domains, variables, equality, assumptions and axiom dependencies. [Mathlib semantics](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/ModelTheory/Semantics.lean), [Foundation](https://github.com/FormalizedFormalLogic/Foundation) |
| Translate the portable typed IR to existing single-domain FOL | Prove preservation of satisfaction for translated formulas under the intended model relationship. For countermodel transport, also show each accepted target model decodes to a source model with the required sort domains. Test omitted existence, function guards and equalities across sorts. [Isabelle sort encodings](https://isa-afp.org/entries/Sort_Encodings.html) |
| Implement a narrow, dependency-light deep embedding | Explain any unmet reuse requirement. Check sorted syntax, binding, satisfaction, derivation and soundness together. Publish the supported constructors and inference rules. |

Record the Lean version, exact dependency revisions, replay commands, logical axiom allowlist and actual axioms used by each exported theorem. Check only declarations linked to the expected typed statement, with their transitive axiom dependencies. Reject `sorryAx`, undeclared axioms and trusted compiler evaluation for the initial qualification. Inspect the theorem statement as well as its axioms. A compiled synthetic example qualifies only its represented inputs. [Lean proof validation](https://lean-lang.org/doc/reference/latest/ValidatingProofs/), [Lean axiom tracking](https://lean-lang.org/doc/reference/latest/Axioms/)
