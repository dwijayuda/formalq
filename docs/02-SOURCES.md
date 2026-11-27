# 02 — Source inventory and acquisition plan
Status: discovery only; no bytes, hashes, exact editions, or license clearance are claimed. URLs below are acquisition starting points from prior research and must be verified at ingestion. Do not publish restricted data.

| ID | Source / entry point | Required artifact | Priority / status |
|---|---|---|---|
| T-U | [Tanzil](https://tanzil.net/download/) | Uthmani numbered UTF-8 text, v1.1 candidate | P0 pending |
| T-S | [Tanzil](https://tanzil.net/download/) | Simple numbered text, same release | P0 pending |
| T-C | [Tanzil](https://tanzil.net/download/) | Simple Clean numbered text, search only | P1 pending |
| T-M | [Metadata](https://tanzil.net/docs/quran_metadata) | Quran metadata XML | P0 pending |
| K-H | [King Fahd Complex](https://qurancomplex.gov.sa/techquran/dev) | Hafs edition + official documentation | P0 pending |
| QAC | [Quranic Arabic Corpus](https://corpus.quran.com/download/) | morphology 0.4 + annotation documentation | P0 pending; signup may be required |
| MAS | [MASAQ v6](https://data.mendeley.com/datasets/9yvrzxktmr/6) | all annotation files and paper | P0 pending |
| R | [Quran.ws](https://text.quran.ws/) | published riwayat texts and alignments | P1 pending |
| CC | [Corpus Coranicum](https://corpuscoranicum.de/) | historical variant records | P2 pending |
| QUL | [Quranic Universal Library](https://qul.tarteel.ai/resources) | translations, tafsir, morphology by exact edition | P1 pending |
| TR | [Tanzil translations](https://tanzil.net/trans/), [QuranEnc](https://quranenc.com/en) | Kemenag, Pickthall, Saheeh International, other comparative editions | P1 pending |
| LEX | [Lane](https://laneslexicon.github.io/), [OpenITI](https://openiti.org/) | Lane, Mufradat, Lisan al-Arab, Maqayis al-Lugha | P1 pending |
| ONT | [QAC ontology](https://corpus.quran.com/ontology.jsp) | reference concepts only, not base premises | P2 pending |
| H | [Sunnah.com](https://sunnah.com/), [Hadith KG](https://huggingface.co/datasets/emadjumaah/hadith-kg) | exact editions, matn, isnad, attribution/grades | Later, pending |

P0 begins after design approval. Compare sources at code-point, documented orthographic equivalence, and semantic levels; neither source automatically corrects the other. Independent editions may share upstream provenance; agreement is not independent transmission verification. Qiraat support is not exhaustive merely because several digital editions exist. Separate historical variants from canonical transmissions.

## Acquisition procedure
1. Verify official landing page, artifact version, release notes, exact download options and terms. Capture access date and resolved URL; no automated scraping of restricted sources.
2. Download locally in binary mode; preserve bytes. Record SHA-256 and size; verify publisher checksum/signature if available. Record whether hash is publisher supplied or locally computed.
3. Store immutable originals, original notice and license snapshot. Parse in a reproducible isolated step; compare counts/IDs against edition metadata and document exceptions (including basmala handling).
4. Cross-check editions and investigate discrepancies with specialists. Create a report, not automatic source corrections.
5. Publish only artifacts with explicit permission, preserving notice and attribution. Otherwise publish manifest and lawful acquisition instructions; ignore raw files in Git.
6. Pin manifest versions; quarantine invalid encoding, missing rows, unexpected HTML downloads, duplicate IDs, unapproved license, or inconsistent mappings.

## Licensing gate
Tanzil publishes verbatim distribution conditions with attribution and no alteration; inspect exact notice, especially derived datasets. QAC's stated licensing/restrictions need clarification; MASAQ v6 was reported as CC BY-NC 3.0, verify actual version. Quran.ws project licensing does not automatically relicense underlying editions. Translation/tafsir permissions vary by work and publisher. No global data license; software license choice pending. Public availability is not redistribution permission.

## Completion criteria
Each required artifact has a manifest, exact source and license decision, checksum, validation report and reviewer. Unavailable artifacts remain explicitly pending. No fabricated hashes, automated acceptance of mismatched versions, or claims of authenticity from byte matching.
