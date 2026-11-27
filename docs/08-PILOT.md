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

Start with reviewer prompts. For 12:25–29, assign narrator, speaker and nested utterance before evaluating a proposition. For 103:1–3, compare candidate quantifier and exception scopes and state any domain commitments. For 6:164 alongside 16:25 and 29:13, ask whether the same predicates and agent roles apply and record the warrant for each proposed bridge. For 1:4, trace attributions and edition spans through the [qirāʾāt fixture](14-READINGS.md). Keep the prescriptions at 4:135 and 5:8 available for annotation while their inferential treatment awaits a deontic design. These are tasks for review, with no preferred exegesis assigned.

Freeze the suite before measuring outcomes, record selection rationale, and split related spans or report families as a group when using a holdout. Publish denominators for spans proposed and resolved, interpretations submitted and reviewed, accepted and disputed formula revisions, evidence replay attempts, and assessed and unassessable comparisons. The [hand-worked logic controls](15-VERIFICATION-SPEC.md) specify expected mathematical results. A disagreement among linguistic reviewers is recorded as a disagreement, with the basis for each view.

## Acceptance
All pilot spans resolve, every formal premise has a review record, every verified claim has checked evidence, no unsupported constructor is accepted, and negative controls do not pass accidentally. Include cases where the tool must abstain. Document alternative interpretations and failed attempts. No target numerical accuracy until benchmark denominator and ground-truth method are specified.
