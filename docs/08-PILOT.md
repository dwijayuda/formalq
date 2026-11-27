# 08 — Pilot corpus and benchmark
Status: selection proposal; none of these examples are adjudicated.

| Passage | Test feature | Risk |
|---|---|---|
| 112:1–4 | theological assertions, negation | identity and theological vocabulary |
| 1:1–7 | speech act, supplication, alternate reading at 1:4 | prayer is not a simple assertion |
| 103:1–3 | quantification and exceptions | domain of humanity, exception scope |
| 2:256 | negation, normative/descriptive ambiguity | scope and interpretive disagreement |
| 4:135, 5:8 | obligations and contextual qualifiers | deontic inference |
| 6:164, 16:25, 29:13 | personal responsibility and related verses | burden/guilt ambiguity |
| 17:36, 49:6 | epistemic norms and conditionality | predicate scope and evidence |
| 12:25–29 | narrated and quoted claims | speaker attribution |

Use source spans rather than retyped Arabic. Review cross-verse dependencies and multiple translations without treating them as axioms. Start with source and speech-act annotation for the full pilot, but only formalize cases covered by the verified logic; mark others unsupported rather than inventing semantics.

## Benchmark design
Three suites: data integrity (IDs, Unicode, alignment, license); logic (synthetic formulas with known models and derivations); interpretation (reviewed candidate alternatives and expected conditional outcomes). Maintain a blinded holdout subset of synthetic and reviewed cases. Report per category precision where a reference exists, abstention, unresolved disagreements, proof checking success, coverage by verse and proposition, and review counts. Avoid treating reviewer agreement as absolute truth.

## Acceptance
All pilot spans resolve, every formal premise has a review record, every verified claim has checked evidence, no unsupported constructor is accepted, and negative controls do not pass accidentally. Include cases where the tool must abstain. Document alternative interpretations and failed attempts. No target numerical accuracy until benchmark denominator and ground-truth method are specified.
