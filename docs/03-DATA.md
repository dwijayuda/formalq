# 03 — Data architecture and contracts
Status: proposed v0.1.

## Layering
L0 immutable source bytes → L1 structural/token and linguistic records → L2 interpretations → L3 typed propositions → L4 logic and proof artifacts → L5 result reports. Hadith is a separately namespaced input at comparison time. Each derived object references immutable parents and tool version. Data flows one way; no proof rewrites source.

## Identity
Edition ID = publisher/release/reading/numbering/orthography. Verse key = (edition_id, surah_id, ayah_id), token key adds token index and segment. Cross-edition verse alignment is an explicit many-to-many relation, not assumed equal numbering. Spans specify coordinate system (UTF-8 byte offsets, Unicode scalar offsets, or token IDs), original artifact hash, and half-open range. Store basmala and ornamental markers according to source-specific convention. Stable local identifiers and revision hashes are separate.

## Draft schema (JSONL for derived records)
| Record | Required fields |
|---|---|
| Manifest | source_id, release, resolved_url, retrieved_at, sha256, bytes, media_type, reading, numbering, encoding, license, redistribution_status, tool_version |
| Verse | edition_id, surah, ayah, text_exact, source_span |
| Alignment | from_id, to_ids, mapping_kind, method, confidence_or_unassessed, evidence, review |
| TokenAnalysis | verse_id, span, segmentation, root, lemma, POS, features, parse_id, source, review |
| Interpretation | id, revision, spans, speech_act, speaker, addressee, referents, lexical_senses, scope, alternatives, external_dependencies, reviewer_status |
| Proposition | id, revision, interpretation_ids, typed_AST, signature_id, profile_id, context, assumptions, status |
| Proof | theory_hash, proposition_id, logic_id, toolchain, certificate, axiom_dependencies, result |
| Comparison | hadith_claim_id, profile_id, context, theory_hash, query, result, evidence, coverage, limitations |

All IDs resolve to existing records; validate referential integrity, schema version, valid ranges and vocabulary. Use explicit null for unavailable facts, never infer missing values. Status vocabulary: draft, machine-checked (syntax only), under-review, accepted-in-profile, disputed, superseded, rejected. Store review events separately.

## Normalization
Original source bytes never change. Derived search views may apply declared transformations (NFC, removal of diacritics, orthographic mapping) only as permitted by source license. Preserve reversible alignment or report information loss. Do not apply NFKC or strip marks to primary text silently. Detect BOM, newline variation, bidi control characters and special Quranic marks; report rather than silently removing. Validate canonical encoding and parser behavior using round-trip and golden tests.

## Physical layout
data/raw/ (local ignored); data/manifests/; data/derived/ (license gated); annotations/; schemas/; scripts/; reports/; FormalQ/; tests/. Keep generated outputs deterministic, sorted by edition and identifiers. Each release publishes manifest and SHA-256 for derived artifacts, exact parser version and data policy. No network access during proof checking.
