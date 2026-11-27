# FormalQ

A research framework for **traceable formal representation of Quranic propositions and evaluation of hadith claims relative to those representations**.

Status: **v0.1 G0 design review** (2026-11-27). Maintainer acceptance is pending. This draft documents source discovery, proposed semantics and hand-worked mathematical controls. Corpus ingestion, Lean qualification and interpretation review await their roadmap gates.

## Start here

| Document | Purpose |
|---|---|
| [Charter](docs/00-CHARTER.md) | Scope, aims, boundaries |
| [Research methodology](docs/01-METHODOLOGY.md) | Evidence, epistemology, interpretive discipline |
| [Sources and acquisition](docs/02-SOURCES.md) | Dataset inventory and licensing gates |
| [Data architecture](docs/03-DATA.md) | Identifiers, provenance, normalization, schemas |
| [Language and semantics](docs/04-SEMANTICS.md) | Formal representation and interpretation |
| [Logic and verification](docs/05-LOGIC.md) | Proof obligations and model theory |
| [Lean architecture](docs/06-LEAN.md) | Module boundaries and trusted base |
| [Hadith evaluation](docs/07-HADITH.md) | Conditional results, historical authenticity separation |
| [Pilot and benchmarks](docs/08-PILOT.md) | Representative passages and evaluation |
| [Quality and governance](docs/09-GOVERNANCE.md) | Review, releases, testing, security |
| [Roadmap](docs/10-ROADMAP.md) | Milestones and acceptance gates |
| [Decisions and open problems](docs/11-DECISIONS.md) | Provisional decisions, alternatives and unresolved questions |
| [Research bibliography](docs/12-BIBLIOGRAPHY.md) | Primary and secondary research leads |
| [G0 research review](docs/13-RESEARCH-REVIEW.md) | Prior work, findings and design implications |
| [Edition and qirāʾāt contract](docs/14-READINGS.md) | Transmission attribution, counting and alignment |
| [Verification specification](docs/15-VERIFICATION-SPEC.md) | Formal fragment, evidence and hand-worked controls |
| [Changelog](CHANGELOG.md) | Research and design changes |

Proof certificates establish consequences of explicitly named, human-selected premises. Assessing the fidelity of an interpretation requires separate scholarly evidence. Hadith comparisons report compatibility with a specified profile. Historical authenticity requires separate transmission and textual evidence.

## Workflow

Follow the [roadmap gates](docs/10-ROADMAP.md) from design approval through acquisition, tooling, calculus qualification, pilot review and comparison. Keep third-party data outside Git until redistribution permission is confirmed. FormalQ is a research framework for use alongside qualified scholarship.

Primary implementation target: Lean 4; auxiliary data tooling: Python (provisional). English technical documentation; original Arabic preserved; Indonesian annotations supported.
