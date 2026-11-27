# 03 — Data architecture and contracts
Status: proposed v0.1.

## Layering
L0 immutable source bytes → L1 structural/token and linguistic records → L2 interpretations → L3 typed propositions → L4 logic and proof artifacts → L5 result reports. Hadith is a separately namespaced input at comparison time. Each derived object references immutable parents and tool version. Data flows one way; no proof rewrites source.

## Identity
Each edition has a logical ID plus a revision with publisher, release, transmission, printed numbering, orthography and artifact references. Verse keys are edition-revision local. Segmentation schemes have their own versioned identity. The [edition and alignment contract](14-READINGS.md) specifies how references cross those boundaries.

Use zero-based, half-open byte ranges anchored to the exact artifact SHA-256 for primary text. Require bounds and UTF-8 scalar boundary checks for UTF-8 ranges. A container and any extracted member each have raw-byte identities. For a format with escaped text, record the raw field selector and member anchor, then attach decoded coordinates to a pinned decoded representation. Preserve the mapping as far as the format allows. Unicode-scalar, UTF-16, grapheme and token positions need explicit coordinate type and versioned representation. Source rows, in-verse content and layout markers have distinct roles.

## Draft schema (JSONL for derived records)
| Record | Required fields |
|---|---|
| Manifest | schema version, artifact and upstream IDs, release, retrieval method and options, original filename, publisher and resolved URLs, UTC retrieval time, artifact byte length and locally measured SHA-256, separate expected checksum or signature with issuer and verification result, media type, encoding, edition metadata, terms and notice reference, permitted operations and decision record |
| Verse | edition_id, surah, ayah, text_exact, source_span |
| Alignment | from_id, to_ids, mapping_kind, method, confidence_or_unassessed, evidence, review |
| TokenAnalysis | verse_id, span, segmentation, root, lemma, POS, features, parse_id, source, review |
| Interpretation | id, revision, spans, speech_act, speaker, addressee, referents, lexical_senses, scope, alternatives, external_dependencies, reviewer_status |
| Proposition | id, revision, interpretation_ids, typed_AST, signature_id, profile_id, context, assumptions, status |
| Proof | theory_hash, proposition_id, logic_id, toolchain, certificate, axiom_dependencies, result |
| Comparison | hadith_claim_id, profile_id, context, theory_hash, query, result, evidence, coverage, limitations |

All IDs resolve to existing records. Validate referential integrity, schema version, ranges and vocabulary. Represent unavailable fields explicitly. Record structural validation, review disposition and lifecycle independently so a well-typed formula can also be disputed or superseded. Store review events separately and bind them to the reviewed revision and profile.

Record each derivation as an activity with exact input revisions, tool revision, configuration, output hashes and any reviewed assertion or transform used. Use separate relations for byte derivation, bibliographic citation and substantive warrant. Derivation edges must have an acyclic ancestry; cross-references may remain cyclic. Pin a release inventory of input and output identities. Report differences by provenance layer and invalidate reachable dependent results when a referenced revision changes. [W3C PROV-DM](https://www.w3.org/TR/prov-dm/)

## Normalization
Original source bytes never change. Derived search views may apply declared transformations (NFC, removal of diacritics, orthographic mapping) only as permitted by source license. Preserve reversible alignment or report information loss. Do not apply NFKC or strip marks to primary text silently. Detect BOM, newline variation, bidi control characters and special Quranic marks; report rather than silently removing. Validate canonical encoding and parser behavior using round-trip and golden tests.

Record each transform's Unicode version, ordering, options and mapping to raw ranges. NFC equality describes canonical equivalence in the specified Unicode version. It is insufficient evidence of orthographic or reading equivalence. Test combining-mark reordering, Arabic presentation forms, join controls, multi-byte offsets and single-source many-to-one mappings. When alignment is ambiguous, retain alternatives or abstain. [Unicode normalization](https://www.unicode.org/reports/tr15/)

## Physical layout
data/raw/ (local ignored); data/manifests/; data/derived/ (license gated); annotations/; schemas/; scripts/; reports/; FormalQ/; tests/. Keep generated outputs deterministic, sorted by edition and identifiers. Each release publishes manifest and SHA-256 for derived artifacts, exact parser version and data policy. No network access during proof checking.
