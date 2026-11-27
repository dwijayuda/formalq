import hashlib
from pathlib import Path
import tempfile
import unittest

from scripts.validate_acquisition import read_metadata, read_qac, verify_files


class AcquisitionChecks(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.root = Path(directory.name).resolve()

    def test_detects_same_length_mutation(self):
        path = self.root / "artifact"
        path.write_bytes(b"changed")
        manifest = {"artifacts": [{
            "id": "test",
            "file": path.name,
            "bytes": 7,
            "sha256": hashlib.sha256(b"initial").hexdigest(),
        }]}
        with self.assertRaisesRegex(ValueError, "local SHA-256 mismatch"):
            verify_files(self.root, manifest)

    def test_rejects_path_outside_source_root(self):
        manifest = {"artifacts": [{"id": "test", "file": "../unrelated"}]}
        with self.assertRaisesRegex(ValueError, "invalid path"):
            verify_files(self.root, manifest)

    def test_rejects_xml_entity_declarations(self):
        path = self.root / "metadata.xml"
        path.write_text('<!DOCTYPE quran [<!ENTITY ref "unexpected">]><quran>&ref;</quran>', encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "XML declarations forbidden"):
            read_metadata(path)

    def test_preserves_qac_position_for_blank_suffix(self):
        path = self.root / "qac.txt"
        path.write_text("LOCATION\tFORM\tTAG\tFEATURES\n(1:1:1:1)\t\tPRON\tSUFFIX|PRON:1S\n", encoding="utf-8")
        self.assertEqual(read_qac(path, [(1, 1)]), ([(1, 1, 1, 1)], 1))

    def test_rejects_unexpected_blank_qac_form(self):
        path = self.root / "qac.txt"
        path.write_text("LOCATION\tFORM\tTAG\tFEATURES\n(1:1:1:1)\t\tN\tSTEM\n", encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "unexpected empty form"):
            read_qac(path, [(1, 1)])


if __name__ == "__main__":
    unittest.main()
