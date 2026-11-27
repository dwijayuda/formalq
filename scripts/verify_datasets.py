"""Verify exact original dataset bytes against data/manifest.json."""
from pathlib import Path
import hashlib
import json
import sys

root = Path(__file__).resolve().parents[1]
manifest = json.loads((root / "data/manifest.json").read_text(encoding="utf-8"))
errors = 0
for item in manifest["artifacts"]:
    path = root / item["path"]
    if not path.is_file():
        print("MISSING", item["path"])
        errors += 1
        continue
    h = hashlib.sha256()
    size = 0
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(block)
            size += len(block)
    ok = size == item["bytes"] and h.hexdigest() == item["sha256"]
    print("OK" if ok else "MISMATCH", item["path"])
    errors += not ok
sys.exit(int(bool(errors)))
