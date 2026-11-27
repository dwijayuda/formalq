# 06 — Lean 4 architecture
Status: planned; no code compiled.

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
