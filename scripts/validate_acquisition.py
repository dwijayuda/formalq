"""Replay G1 structural checks on local, byte-pinned source artifacts."""

import argparse
from collections import Counter
from contextlib import closing
import csv
import hashlib
import io
import json
from pathlib import Path
import re
import sqlite3
import unicodedata
import xml.etree.ElementTree as ET
import zipfile


MANIFEST = Path(__file__).resolve().parents[1] / "data/manifests/g1-20261127.json"
VERSE_ROW = re.compile(r"([1-9][0-9]*)\|([1-9][0-9]*)\|(.+)")
QAC_POSITION = re.compile(r"\(([1-9][0-9]*):([1-9][0-9]*):([1-9][0-9]*):([1-9][0-9]*)\)")
KFGQPC_DATA = "UthmanicHafs_v2-0 data/"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha256(file):
    with file.open("rb") as source:
        return hashlib.file_digest(source, "sha256").hexdigest()


def verify_files(root, manifest):
    files = {}
    for record in manifest["artifacts"]:
        name = record["id"]
        path = (root / record["file"]).resolve()
        require(path.is_relative_to(root) and name not in files, f"{name}: invalid path or duplicate ID")
        require(path.stat().st_size == record["bytes"], f"{name}: unexpected byte length")
        measured = sha256(path)
        require(measured == record["sha256"], f"{name}: local SHA-256 mismatch")
        expected = record.get("expected_sha256")
        if expected:
            require(measured == expected["value"], f"{name}: external SHA-256 mismatch")
        files[name] = path
    return files


def verify_external_inventory(files, manifest):
    records = {record["id"]: record for record in manifest["artifacts"]}
    inventory = json.loads(files["mas-inventory"].read_bytes())
    expected_names = {"MASAQ.csv", "MASAQ.tsv", "MASAQ.json", "MASAQ.db"}
    require(len(inventory) == len(expected_names), "MASAQ: incomplete repository inventory")
    require({item["filename"] for item in inventory} == expected_names, "MASAQ: unexpected inventory filenames")
    for item in inventory:
        record = records["MAS-" + item["filename"]]
        details = item["content_details"]
        require(record["bytes"] == details["size"], "MASAQ: manifest length differs from repository")
        require(record["sha256"] == details["sha256_hash"], "MASAQ: manifest digest differs from repository")
        require(record["requested_url"] == details["download_url"], "MASAQ: manifest route differs from repository")

    mirror = json.loads(files["K-H-manifest"].read_bytes())["sources"]["hafs"]["layout"]
    record = records["K-H"]
    require(mirror["package"] == Path(record["file"]).name, "K-H: mirror package name differs")
    require(mirror["sha256"] == record["sha256"], "K-H: digest differs from mirror manifest")
    require(mirror["origin"]["url"] == record["reported_publisher_url"], "K-H: mirror's publisher route differs")


def read_metadata(file):
    document = file.read_bytes().decode("utf-8")
    require(not re.search(r"<!\s*(?:DOCTYPE|ENTITY)\b", document, re.I), "T-M: XML declarations forbidden")
    root = ET.fromstring(document)
    require(root.tag == "quran" and root.get("type") == "metadata", "T-M: wrong root")
    require(root.get("version") == "1.0" and root.get("license") == "cc-by", "T-M: wrong edition or notice")
    suras = root.findall("./suras/sura")
    require(len(suras) == 114, "T-M: expected 114 surahs")
    keys = []
    for index, row in enumerate(suras, 1):
        require(int(row.attrib["index"]) == index, "T-M: surah index discontinuity")
        require(int(row.attrib["start"]) == len(keys), "T-M: verse offset discontinuity")
        count = int(row.attrib["ayas"])
        require(count > 0, "T-M: empty surah")
        keys.extend((index, verse) for verse in range(1, count + 1))
    require(len(keys) == 6236, "T-M: expected 6236 verses")
    return keys


def read_tanzil(file, expected_keys, text_type):
    text = file.read_bytes().decode("utf-8")
    require("\r" not in text and text.endswith("\n"), f"{text_type}: expected LF framing")
    lines = text.split("\n")
    verses = {}
    for line in lines[:len(expected_keys)]:
        match = VERSE_ROW.fullmatch(line)
        require(match is not None, f"{text_type}: malformed verse row")
        key = int(match[1]), int(match[2])
        require(key not in verses, f"{text_type}: duplicate verse {key}")
        verses[key] = match[3]
    require(list(verses) == expected_keys, f"{text_type}: verse inventory differs from T-M")
    footer = lines[len(expected_keys):]
    require(all(not line or line.startswith("#") for line in footer), f"{text_type}: unexpected footer row")
    require(f"Tanzil Quran Text ({text_type}, Version 1.1)" in "\n".join(footer), f"{text_type}: missing release notice")

    opening = verses[1, 1]
    require(opening and opening[0] == "\u0628", f"{text_type}: unexpected 1:1")
    joined_opening = opening[0] + "\u0651" + opening[1:]
    for surah in range(2, 115):
        row = verses[surah, 1]
        prefix = joined_opening if surah in (95, 97) else opening
        if surah == 9:
            require(not row.startswith((opening, joined_opening)), f"{text_type}: unexpected prefix in 9:1")
        else:
            require(row.startswith(prefix + " "), f"{text_type}: missing expected prefix at {surah}:1")
    require(0 < verses[27, 30].find(opening), f"{text_type}: missing in-verse opening formula at 27:30")
    return verses


def read_kfgqpc(file, expected_keys):
    with zipfile.ZipFile(file) as package:
        require(package.testzip() is None, "K-H: ZIP integrity check failed")
        notice = package.read(KFGQPC_DATA + "read.me")
        require(b"Version: 2.0" in notice and b"2022-09-07" in notice, "K-H: wrong release notice")
        with package.open(KFGQPC_DATA + "hafsData_v2-0.csv") as source:
            rows = list(csv.DictReader(io.TextIOWrapper(source, encoding="utf-8-sig", newline=""), strict=True))
        records = json.loads(package.read(KFGQPC_DATA + "hafsData_v2-0.json"))
        member_hashes = {
            member.filename: hashlib.sha256(package.read(member)).hexdigest()
            for member in package.infolist()
            if not member.is_dir()
        }

    keys = [(int(row["sura_no"]), int(row["aya_no"])) for row in rows]
    require(keys == expected_keys, "K-H: verse inventory differs from T-M")
    require([int(row["id"]) for row in rows] == list(range(1, 6237)), "K-H: global IDs differ")
    require(len(rows) == len(records), "K-H: CSV/JSON row counts differ")
    for row, record in zip(rows, records):
        require(row == {key: str(value) for key, value in record.items()}, f"K-H: CSV/JSON difference at ID {row['id']}")
        require(row["aya_text"] and row["aya_text_emlaey"], f"K-H: empty verse at ID {row['id']}")
    return dict(zip(keys, rows)), member_hashes


def compare_kfgqpc(reference, comparison, field):
    opening = reference[1, 1]
    joined_opening = opening[0] + "\u0651" + opening[1:]
    display_matches = 0
    display_nfc_matches = 0
    for (surah, verse), text in reference.items():
        other = comparison[surah, verse][field]
        if verse == 1 and surah not in (1, 9):
            prefix = joined_opening if surah in (95, 97) else opening
            text = text.removeprefix(prefix + " ")
        if field == "aya_text":
            # The package read.me describes a font-dependent terminal verse mark.
            separator = " " if (surah, verse) == (2, 286) else "\u00a0"
            suffix = separator + chr(0xFC00 + verse - 1)
            require(other.endswith(suffix), f"K-H: unexpected terminal mark at {surah}:{verse}")
            other = other.removesuffix(suffix)
        display_matches += text == other
        display_nfc_matches += unicodedata.normalize("NFC", text) == unicodedata.normalize("NFC", other)
    return {
        "matching_verse_keys": len(reference),
        "exact_matches": sum(text == comparison[key][field] for key, text in reference.items()),
        "nfc_matches": sum(
            unicodedata.normalize("NFC", text) == unicodedata.normalize("NFC", comparison[key][field])
            for key, text in reference.items()
        ),
        "kfgqpc_rows_with_private_use": sum(
            any(unicodedata.category(char) == "Co" for char in row[field])
            for row in comparison.values()
        ),
        "kfgqpc_rows_with_nbsp": sum("\u00a0" in row[field] for row in comparison.values()),
        "exact_after_display_boundary_exclusion": display_matches,
        "nfc_after_display_boundary_exclusion": display_nfc_matches,
    }


def read_qac(file, expected_keys):
    positions = []
    empty_pronoun_forms = 0
    has_header = False
    with file.open(encoding="utf-8", newline="") as source:
        for line_number, line in enumerate(source, 1):
            line = line.rstrip("\r\n")
            if not has_header:
                if line == "LOCATION\tFORM\tTAG\tFEATURES":
                    has_header = True
                else:
                    require(not line or line.startswith("#"), f"QAC: bad notice at line {line_number}")
                continue
            fields = line.split("\t")
            match = QAC_POSITION.fullmatch(fields[0])
            require(len(fields) == 4 and match and fields[2], f"QAC: malformed row {line_number}")
            if not fields[1]:
                require(fields[2:] == ["PRON", "SUFFIX|PRON:1S"], f"QAC: unexpected empty form at row {line_number}")
                empty_pronoun_forms += 1
            positions.append(tuple(map(int, match.groups())))
    require(has_header and positions == sorted(set(positions)), "QAC: missing header or duplicate/out-of-order positions")
    require({key[:2] for key in positions} == set(expected_keys), "QAC: verse inventory differs from T-M")
    return positions, empty_pronoun_forms


def read_masaq(csv_file, tsv_file, json_file, sqlite_file, expected_keys):
    columns = ["ID", "Sura_No", "Verse_No", "Word_No", "Segment_No"]
    positions = Counter()
    ids = set()
    role_cells = 0
    records = json.loads(json_file.read_bytes())
    require(isinstance(records, list), "MASAQ: expected a JSON record list")
    database_uri = sqlite_file.as_uri() + "?mode=ro&immutable=1"
    with csv_file.open(encoding="utf-8-sig", newline="") as csv_data, tsv_file.open(
        encoding="utf-8-sig", newline=""
    ) as tsv_data, closing(sqlite3.connect(database_uri, uri=True)) as database:
        database.execute("PRAGMA trusted_schema=OFF")
        require(database.execute("PRAGMA integrity_check").fetchall() == [("ok",)], "MASAQ: invalid SQLite database")
        csv_rows = csv.reader(csv_data, strict=True)
        tsv_rows = csv.reader(tsv_data, delimiter="\t", strict=True)
        header = next(csv_rows)
        require(header == next(tsv_rows) and len(header) == 19, "MASAQ: unexpected CSV/TSV header")
        require(header[:5] == columns and len(set(header)) == len(header), "MASAQ: position columns differ")
        fields = database.execute("PRAGMA table_info('MASAQ')")
        require(header == [field[1] for field in fields], "MASAQ: SQLite columns differ")
        role_index = header.index("Syntactic_Role")
        role_lookup = database.execute("SELECT count(*), count(DISTINCT Tag) FROM Syntactic_Role").fetchone()
        stored_rows = database.execute("SELECT * FROM MASAQ ORDER BY rowid")
        compared = zip(csv_rows, tsv_rows, records, stored_rows, strict=True)
        for number, (row, other, json_row, stored_row) in enumerate(compared, 2):
            require(row == other and len(row) == len(header), f"MASAQ: mismatched CSV/TSV row {number}")
            require(json_row.keys() == set(header), f"MASAQ: JSON fields differ at row {number}")
            for column, cell, database_cell in zip(header, row, stored_row, strict=True):
                for value in (json_row[column], database_cell):
                    rendered = "" if value is None else str(value)
                    require(cell == rendered, f"MASAQ: JSON or SQLite {column} differs at row {number}")
            require(all(re.fullmatch(r"[1-9][0-9]*", value) for value in row[:5]), f"MASAQ: bad position at row {number}")
            ids.add(int(row[0]))
            positions[tuple(map(int, row[1:5]))] += 1
            role_cells += bool(row[role_index])
    require({key[:2] for key in positions} == set(expected_keys), "MASAQ: verse inventory differs from T-M")
    return positions, len(ids), role_cells, role_lookup


def annotation_summary(qac, empty_pronoun_forms, masaq, masaq_ids, masaq_role_cells, role_lookup):
    qac_words = {key[:3] for key in qac}
    mas_words = {key[:3] for key in masaq}
    qac_per_verse = Counter(key[:2] for key in qac_words)
    mas_per_verse = Counter(key[:2] for key in mas_words)
    differences = [
        {"surah": key[0], "ayah": key[1], "qac": qac_per_verse[key], "masaq": mas_per_verse[key]}
        for key in sorted(qac_per_verse.keys() | mas_per_verse.keys())
        if qac_per_verse[key] != mas_per_verse[key]
    ]
    return {
        "qac_rows": len(qac),
        "qac_word_keys": len(qac_words),
        "qac_empty_first_person_suffix_forms": empty_pronoun_forms,
        "masaq_cross_format_rows": sum(masaq.values()),
        "masaq_corpus_columns": 19,
        "masaq_distinct_ids": masaq_ids,
        "masaq_nonempty_role_cells": masaq_role_cells,
        "masaq_sqlite_role_lookup_rows": role_lookup[0],
        "masaq_sqlite_role_lookup_distinct_tags": role_lookup[1],
        "masaq_word_keys": len(mas_words),
        "masaq_segment_keys": len(masaq),
        "masaq_repeated_segment_keys": sum(count > 1 for count in masaq.values()),
        "shared_position_keys": len(set(qac).intersection(masaq)),
        "shared_word_keys": len(qac_words & mas_words),
        "verses_with_different_word_key_counts": len(differences),
        "word_key_count_differences": differences,
    }


def main():
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("source_dir", type=Path)
    cli.add_argument("--manifest", type=Path, default=MANIFEST)
    arguments = cli.parse_args()
    manifest = json.loads(arguments.manifest.read_text(encoding="utf-8"))
    files = verify_files(arguments.source_dir.resolve(), manifest)
    verify_external_inventory(files, manifest)
    keys = read_metadata(files["T-M"])
    uthmani = read_tanzil(files["T-U"], keys, "Uthmani")
    simple = read_tanzil(files["T-S"], keys, "Simple")
    kfgqpc, members = read_kfgqpc(files["K-H"], keys)
    qac, empty_pronoun_forms = read_qac(files["QAC-v0.4-mirror"], keys)
    masaq, masaq_ids, role_cells, role_lookup = read_masaq(
        files["MAS-MASAQ.csv"], files["MAS-MASAQ.tsv"], files["MAS-MASAQ.json"], files["MAS-MASAQ.db"], keys
    )
    report = {
        "artifact_count": len(files),
        "surahs": len({key[0] for key in keys}),
        "verses": len(keys),
        "unicode_version": unicodedata.unidata_version,
        "kfgqpc_zip_member_sha256": members,
        "uthmani_comparison": compare_kfgqpc(uthmani, kfgqpc, "aya_text"),
        "simple_comparison": compare_kfgqpc(simple, kfgqpc, "aya_text_emlaey"),
        "annotation_positions": annotation_summary(qac, empty_pronoun_forms, masaq, masaq_ids, role_cells, role_lookup),
    }
    print(json.dumps(report, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
