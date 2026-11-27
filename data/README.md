# FormalQ source datasets

Four original Tanzil files are committed byte-for-byte, with their embedded notices intact. All nine uploaded artifacts are registered in [manifest.json](manifest.json); five are not hosted here. The public GitHub repository must not be assumed to grant rights in third-party data.

## Attribution

Arabic text: Tanzil Project, Uthmani and Simple v1.1, https://tanzil.net/ ; [text terms](https://tanzil.net/docs/Text_License). Do not change original files. Metadata: Tanzil.info 2008–2009, version 1.0, CC BY; see embedded notices and https://tanzil.net/docs/quran_metadata.

Other source links and terms are recorded individually in the manifest. QAC's archive contains its own verbatim redistribution notice and a Tanzil notice. MASAQ v6 source page lists CC BY-NC 3.0. Tanzil translations are listed for non-commercial use. Quran.ws preserves KFGQPC terms for its Hafs text. The exact release and terms of the nested Quranic treebank archive need confirmation.

## Storage
- data/raw/tanzil/ : published immutable source bytes.
- data/local/ : manually supplied, non-published originals, ignored by Git.
- data/manifest.json : original SHA-256, bytes, provenance and status for each artifact.

## Validation
All four verse text files contain the exact same 6,236 unique verse IDs specified by the XML metadata (114 surahs). All three outer ZIP archives passed CRC checks. MASAQ contains TSV, CSV, JSON and SQLite formats; Quranic.zip contains Quranic/Quranic.rar; QAC contains its morphology text. Nested RAR not independently tested. Textual and linguistic agreement still requires independent review.

Run `python scripts/verify_datasets.py` after placing the locally held originals at the paths specified in the manifest. Missing files are reported and the command exits nonzero. The script verifies byte identity, not religious or semantic correctness.

The data/local files are intentionally ignored. Do not force-add them without source-specific rights review. Binary attachment upload was unavailable in the current GitHub integration. No raw file was reconstructed by hand or altered.
