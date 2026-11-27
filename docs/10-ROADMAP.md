# 10 — Implementation roadmap
Status: the maintainer authorized autonomous work after the G0 draft. G1 local acquisition and structural replay are recorded. Proposed interpretation and implementation decisions remain subject to the relevant reviews.

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

The [G0 research review](13-RESEARCH-REVIEW.md) and [decision register](11-DECISIONS.md) identify proposals for acceptance. A G0 decision should name the reviewed commit, accepted proposals and unresolved issues, and identify who owns source and scholarly review. Decisions about P0 substitutions must carry their own rationale and validation consequences. Gate exit requires the evidence listed in the table.

The [G1 report](16-ACQUISITION-REPORT.md) records acquisition, checksums and structural checks, plus the source and reviewer qualifications still needed for G1 exit. G2–G8 remain pending. The [verification specification](15-VERIFICATION-SPEC.md) contains hand-worked cases for future Lean replay.
