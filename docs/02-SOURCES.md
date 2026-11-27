# 02 — Source inventory and acquisition plan
Status: source discovery and acquisition planning, 2026-11-27. The public records below provide release and terms evidence. Corpus files, local hashes, structural validation and per-artifact permission decisions are pending G1.

| ID | Source / entry point | Required artifact | Priority / status |
|---|---|---|---|
| T-U | [Tanzil](https://tanzil.net/download/) | Uthmani numbered UTF-8 text, v1.1 (2021-02-12) | P0, manual form |
| T-S | [Tanzil](https://tanzil.net/download/) | Simple numbered text, v1.1 (2021-02-12) | P0, manual form |
| T-C | [Tanzil](https://tanzil.net/download/) | Simple Clean numbered text, search only | P1 pending |
| T-M | [Metadata](https://tanzil.net/docs/quran_metadata) | `quran-data.xml`, v1.0 (2008-02-28) | P0, separate terms review |
| K-H | [King Fahd Complex developer entry point](https://qurancomplex.gov.sa/techquran/dev) | Exact Ḥafṣ package and publisher documentation | P0, publisher endpoint returned 404 during review |
| QAC | [Quranic Arabic Corpus](https://corpus.quran.com/download/) | Morphology v0.4 and annotation documentation | P0, publisher form requires a contact email |
| MAS | [MASAQ v6](https://data.mendeley.com/datasets/9yvrzxktmr/6) | Versioned member inventory, annotation data and paper | P0, archive DOI `10.17632/9yvrzxktmr.6` |
| R | [Quran.ws text](https://github.com/quran-ws/quran-text), [verse-count map](https://github.com/quran-ws/qiraat-ayah-map) | Separate versioned text package and alignment source | P1, upstream terms and alignment review |
| CC | [Corpus Coranicum](https://corpuscoranicum.de/) | historical variant records | P2 pending |
| QUL | [Quranic Universal Library](https://qul.tarteel.ai/resources) | translations, tafsir, morphology by exact edition | P1 pending |
| TR | [Tanzil translations](https://tanzil.net/trans/), [QuranEnc](https://quranenc.com/en) | Kemenag, Pickthall, Saheeh International, other comparative editions | P1 pending |
| LEX | [Lane](https://laneslexicon.github.io/), [OpenITI](https://openiti.org/) | Lane, Mufradat, Lisan al-Arab, Maqayis al-Lugha | P1 pending |
| ONT | [QAC ontology](https://corpus.quran.com/ontology.jsp) | reference concepts only, not base premises | P2 pending |
| H | [Sunnah.com](https://sunnah.com/), [Hadith KG](https://huggingface.co/datasets/emadjumaah/hadith-kg) | exact editions, matn, isnad, attribution/grades | Later, pending |

P0 begins after G0 acceptance. Compare exact code points first, documented orthographic comparisons second, and semantic hypotheses in the reviewed pilot. Report shared upstream provenance alongside agreement. See the proposed [edition and alignment contract](14-READINGS.md).

## Acquisition procedure
1. Verify official landing page, artifact version, release notes, exact download options and terms. Capture access date and resolved URL; no automated scraping of restricted sources.
2. Download locally in binary mode; preserve bytes. Record SHA-256 and size; verify publisher checksum/signature if available. Record whether hash is publisher supplied or locally computed.
3. Store immutable originals, original notice and license snapshot. Parse in a reproducible isolated step; compare counts/IDs against edition metadata and document exceptions (including basmala handling).
4. Cross-check editions and investigate discrepancies with specialists. Create a report, not automatic source corrections.
5. Publish only artifacts with explicit permission, preserving notice and attribution. Otherwise publish manifest and lawful acquisition instructions; ignore raw files in Git.
6. Pin manifest versions; quarantine invalid encoding, missing rows, unexpected HTML downloads, duplicate IDs, unapproved license, or inconsistent mappings.

## Licensing gate

| Artifact | Published evidence | Project handling proposed for review |
|---|---|---|
| T-U, T-S, T-C | The notice names CC BY 3.0 and states conditions on verbatim copying, alteration, notice and attribution. [Tanzil text license](https://tanzil.net/docs/text_license) | Keep exact downloads and their notices locally. Require explicit clearance before releasing transformed text or a substantial extract. |
| T-M | The metadata has its own release page and download. [Metadata release history](https://tanzil.net/docs/metadata_updates) | Inspect the XML notice and apply an artifact-specific decision. |
| K-H, R | Quran.ws identifies KFGQPC packages as upstream and distinguishes its own work from upstream text. The counting map identifies separate data and tooling licenses. [Text project](https://github.com/quran-ws/quran-text), [counting project](https://github.com/quran-ws/qiraat-ayah-map) | Locate the exact publisher package, edition and applicable terms. Retain any authorized mirror as a separately identified retrieval route. A downstream hash needs an explicit issuer. |
| QAC | The page names a GNU GPL and also displays verbatim/no-change terms. The advertised download is morphology. [QAC download](https://corpus.quran.com/download/) | Use the publisher's form after approval. Preserve the acquired notice. Resolve the scope of the stated terms before redistribution or transformation. Track any treebank or ontology artifact separately. |
| MAS | The exact v6 record states CC BY-NC 3.0 and names Tanzil as the text base. [Mendeley Data](https://data.mendeley.com/datasets/9yvrzxktmr/6) | Keep originals in the authorized research workspace. Track embedded source notices and resolve permissions before any public derived output. |
| QUL, TR, LEX, CC, H | These are catalogs, editions, or compound artifacts whose terms and dependencies can vary. [QUL resources](https://qul.tarteel.ai/resources), [Sunnah.com access](https://sunnah.com/developers), [Hadith KG dataset card](https://huggingface.co/datasets/emadjumaah/hadith-kg) | Pin each item and rights holder. Verify edition-level coverage and permissions. Sunnah.com's partial API requires a key. The Hadith KG's package license and automated groupings need distinct upstream-rights and scholarly checks. |

## G1 acquisition and validation procedure by artifact

1. **T-U and T-S.** Use the publisher form and select the named text type plus numbered text. Save the exact checkbox values for pause, sajdah, rubʿ al-ḥizb, tatwīl and sequential tanwīn where offered. Use the documented standard Unicode encoding as the proposed baseline and keep any alternative export as a separate artifact. Record options, response metadata, original filename and release. Check the 114 sūrah identifiers and 6,236 numbered āyāt against the complete per-sūrah count vector, strict UTF-8, order, delimiter structure, and unique IDs. Preserve footer, line endings and whitespace. Verify numbered 1:1, Tanzil's documented unnumbered prefixes in first-āyah rows, the absence of a prefix in sūrah 9, the join marks noted for sūrahs 95 and 97, and the in-verse occurrence at 27:30. Verify form-specific behavior on actual bytes before pinning a rule. [Text updates](https://tanzil.net/docs/text_updates), [orthographic encoding](https://tanzil.net/docs/uthmani), [basmala documentation](https://tanzil.net/docs/a_note_on_bismillah)
2. **T-M.** Retrieve the linked [publisher XML](https://tanzil.net/res/text/metadata/quran-data.xml). Check declared version, character decoding, the XML structure and the ordered count vector, with external entity and network resolution disabled. Keep revelation-order fields as publisher assertions outside the base theory. Text and metadata share a publisher and cannot supply independent corroboration.
3. **K-H.** Identify the official package and record its text/rendering model, release and printed count. If a publisher-authorized route remains unavailable, record the failed route and date, then seek a maintainer decision on an explicitly labelled proxy or an edition-specific print comparison. Compare only confirmed corresponding spans. Classify differences as exact, reviewed orthography/encoding, reviewed boundary/layout, unresolved, or candidate reading difference. Report treatment of font-dependent values. Preserve the difference evidence separately from the raw files.
4. **QAC and MAS.** Pin each exact release and preserve any archive and member hashes. Reconcile headers, rows, defined columns, encoding, reference ranges and segmentation tiers against release-specific documentation. Separate source-format checks from annotation agreement. In MASAQ, reconcile overlapping representations and distinguish word, segment and syntactic-function counts. For both, select documented ambiguous instances and check alignment through to an edition-local span. Report unaligned segments, upstream text release uncertainty and sample-review limits.

An acquisition report includes expected versus observed checks, tool and version, outcomes and unresolved discrepancies. Internally keep manifest, notices and logs with the raw byte hashes. For public reproducibility, include the allowed URLs, options, manifest facts and diagnostic summaries after rights review. Hosts can serve different bytes under an unchanged URL. Treat a same-release hash mismatch as a new candidate artifact pending investigation.

## Completion criteria
Each required artifact has a manifest, exact source and license decision, checksum, validation report and reviewer. Unavailable artifacts remain explicitly pending. No fabricated hashes, automated acceptance of mismatched versions, or claims of authenticity from byte matching.
