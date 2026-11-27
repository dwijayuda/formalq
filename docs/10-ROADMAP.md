# 10 — Implementation roadmap
Status: phase 0 draft; no dates or completion claims.

| Gate | Work | Exit evidence |
|---|---|---|
| G0 design | Review charter, assumptions, schema, logic, methodology, license policy | Maintainer acceptance and open-problem register |
| G1 acquisition | Download P0 datasets locally, exact versions, notices, SHA-256, independent comparison | Manifest, validation report, resolved/recorded mismatches |
| G2 tooling | Reproducible parsing, identifiers, schemas, source/derived separation | Deterministic tests, provenance round trip, license gate |
| G3 calculus | Lean toolchain spike, typed FOL syntax, semantics, derivation, soundness | Clean build, checked lemmas, negative controls, axiom report |
| G4 pilot | Linguistic annotation, interpretation alternatives and reviewed formulas | Reviewed pilot records and explicit unsupported cases |
| G5 comparison | Proof/countermodel interface, consistency and profile reporting | Synthetic benchmark, verified certificates and reports |
| G6 extension | Add selected modal/deontic/temporal features and canonical reading support | Formal semantics and soundness per extension; no forced interpretation |
| G7 scaling | Increase corpus coverage in batches, reviewer workflow and regression checks | Coverage dashboard and independent review |
| G8 release | Real hadith case studies, external audit, reproducible research report | Qualified review, provenance, open limitations, no authenticity overclaim |

## First implementation backlog (after G0)
- Source manifests and ignore policy; verify exact URLs and dataset terms.
- Edition-aware parser and basmala tests; compare Tanzil/KFGQPC.
- Annotation schema and sample records using synthetic text.
- Lean compatibility spike and minimal logic library evaluation.
- Proof and finite model examples with no religious interpretation.
- Pilot review forms, source dependency validation and evaluation specification.

## Dependencies and risks
Restricted data access or license → document manual retrieval and do not redistribute. No qualified reviewers → remain draft. Semantic ambiguity → retain alternatives. Solver incompleteness → abstain. Toolchain incompatibility → pin compatible version. Expanding scope → gate extensions by pilot need. Do not claim completion of entire Quran simply from verse indexing.

## Current status
G0 documents drafted, pending review. G1–G8 not started. No source hashes, tests or proof artifacts yet. Use issues/PRs for decisions and record milestone completion with evidence.
