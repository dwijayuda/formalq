# 11 — Decisions and open research problems
All decisions are provisional, pending maintainer and expert review.

| ID | Proposed decision | Alternative / reason |
|---|---|---|
| D01 | Documentation before code | Prevent hard-coding ambiguous interpretation |
| D02 | Hafs/Kufan initial edition; multi-reading schema | All readings initially increases scope; no claim Hafs alone exhaustive |
| D03 | Immutable Arabic, derived views separate | Normalization can erase meaningful marks |
| D04 | Typed IR + Lean verification | Direct translation to axioms loses provenance and scope |
| D05 | FOL first; extensions modular | Rich logic upfront raises correctness burden |
| D06 | Explicit profile alternatives and provenance | A single merged theory risks contradiction and circularity |
| D07 | Proof and model evidence separate | Binary pass/fail hides unknowns |
| D08 | Historical authenticity separate | Consistency is not transmission evidence |
| D09 | English docs + Arabic originals + Indonesian support | Avoid unnecessary translation authority |
| D10 | No raw corpus in public Git until license clearance | Public download is not permission to redistribute |
| D11 | No global axioms asserting interpretations | Conditional theories make assumptions auditable |
| D12 | Separate recitational attribution, witness and printed numbering | A reading key that implies a counting system can misalign multiple editions. [Edition contract](14-READINGS.md) |
| D13 | Separate raw range, decoded coordinates and reviewed alignment | Whole-verse strings are simpler and discard the trace needed for split spans and source-specific markup. [Data contracts](03-DATA.md) |
| D14 | Use partial lowering from discourse and speech-act records | Universal lowering can promote quotes, commands and unresolved anaphora into assertions. [Semantics](04-SEMANTICS.md) |
| D15 | Qualify entailment and refutation with base satisfiability evidence | A proof-only label can hide an inconsistent theory. Treat mutually impossible evidence as an integrity error. [Verification specification](15-VERIFICATION-SPEC.md) |
| D16 | Compare library reuse, proved translation and minimal deep embedding | A standalone calculus incurs metatheory maintenance. A library embedding still needs review of semantics and certificate binding. [Lean qualification](06-LEAN.md) |

## Open problems
O1: What counts as admissible interpretation, and who can approve it? Define criteria without falsely claiming consensus.
O2: How to model cross-reading differences and numbering with reliable alignment and canonical classification?
O3: How to represent metaphor, ellipsis, Arabic scope, pronouns, speech acts, and intertextual interpretation?
O4: What formal semantics for obligations, exceptions, chronology and competing abrogation theories? Review usul al-fiqh and alternatives.
O5: How to establish consistency of growing theories? Finite model witness may not exist even when satisfiable.
O6: How to detect dependence on hadith across lexicons/tafsir and inherited ontologies?
O7: How to scale qualified review while preserving disagreement and uncertainty?
O8: What sound, feasible bridge exists between typed IR, automated prover and Lean kernel? Test certificate transport.
O9: How to establish interpretation robustness without pretending enumerated profiles are exhaustive?
O10: What is the licensing policy for derived linguistic and semantic annotations? Confirm source-specific rules.
O11: What is novelty relative to Quran ontologies, Islamic legal reasoning and formal deontic logic? Systematic literature review required before claiming originality.
O12: What constitutes useful partial formalization if some Quranic content resists propositional encoding?
O13: How to handle revised claims and theory versioning across dependent outputs?
O14: Which software license and contribution model does the maintainer prefer?
O15: What source is an adequate fallback for the unavailable KFGQPC developer route, and which independence claims would that fallback permit?
O16: What canonical serialization and compatibility theorem are needed for hashing and replay, including renamed binders, duplicated premises and migrations?
O17: What review evidence is sufficient to establish that a proposed context bridge preserves the meaning of the specific claim?
O18: How can local-only required data be revalidated independently under publisher terms? Which public artifacts can report meaningful diagnostics without redistributing protected contents?

Maintain an issue per research problem once design is reviewed; record evidence and rationale for decisions. No novelty, completeness, consistency or correctness claim before appropriate evidence.
