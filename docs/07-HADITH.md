# 07 — Hadith comparison specification
Status: proposed; no religious or authenticity judgments.

## Separate assessments
A hadith record has collection/edition/book/number, Arabic matn, isnad, variant family, narrator and grading references (source-specific), exact citations and provenance. Historical authenticity assessment is independent from formal compatibility. A sahih grading does not automatically resolve interpretation; compatibility does not authenticate a narration.

Extract candidate propositions with speaker, audience, normative/descriptive status, time, conditions and alternative readings. A report may contain multiple claims. Never infer that the Quran endorses a claim merely because it is not contradicted. Compare matched contexts; report missing context as unresolved. Record any shared evidence dependencies to avoid circularity.

## Per-profile outcome policy
First validate h and context; if invalid or not formalized, report not assessable. If theory known inconsistent, report invalid theory and suppress ordinary classification. Otherwise record separate checked evidence:
| Evidence | Output |
|---|---|
| Proof of h | Entailed relative to profile |
| Proof of not h | Refuted relative to profile |
| Model of theory + h | Satisfiable with claim (may overlap entailment) |
| Models of theory + h and theory + not h | Independent in represented theory |
| No adequate evidence | Undetermined |
| Both proof directions | Inconsistent theory / invalid |
If theory consistency not established, mark proofs conditional and do not label a definitive contradiction. Proof absence alone is never a compatibility witness. Report coverage and consistency status on every result.

## Across profiles
Return per-profile results first. Aggregate only with precise quantification over the reviewed evaluated set; list unassessed alternatives. Different legitimate interpretations can yield differing outcomes. A contradiction between formal premises and claim is not a blanket rejection of a hadith, its transmitter or a religious tradition.

## Report template
Hadith edition and claim ID; Arabic span; interpretation assumptions; Quran passage(s) and reading; theory and signature hashes; inference rules; certificate/countermodel; theory consistency; profile coverage; external dependencies; unresolved context; review record; disclaimer. Avoid a binary authenticity score and avoid presenting LLM confidence as evidence.

## Evaluation
Synthetic controls before real texts: exact agreement, explicit negation, compatible unentailed claim, contradictory theory, ambiguity, different context, unknown, missing evidence and circular dependency. Real examples require qualified review; avoid cherry-picking cases to support a preselected doctrinal conclusion.
