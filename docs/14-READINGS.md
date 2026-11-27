# 14 — Edition and qirāʾāt representation

Status: G0 proposal. The initial work still targets a documented Ḥafṣ ʿan ʿĀṣim edition with Kūfan numbering. A particular digital artifact, its printed model and a scholarly attribution require their own evidence.

## Identities and claims

| Object | Record |
|---|---|
| Recitational attribution | Qāriʾ, rāwī and ṭarīq when documented, relation to named transmission sources, uncertainty, and source locations. Keep unknown path distinct from a path deemed inapplicable. |
| Attestation | Form observed or reported, location, source kind (print, manuscript, oral documentation, classical report), source edition, attributed authority, and reporting scholar. A status such as canonical within a framework has a framework citation and review scope. |
| Digital edition revision | Publisher, release and artifact hash; printed model where verified; encoded layers for rasm, vocalization, pause and editorial signs; recitational attribution; printed counting system with evidence. |
| Segment reference | Edition revision, sūrah and local āyah if applicable, segmentation version, and anchored span. Treat liturgical prefixes, ornamental marks and in-verse text as separately classified spans. |
| Alignment | Versioned relationship between two ordered groups of segment references, with method, evidence, relation kind, coverage and review. Source artifacts remain independently addressable. |

Keep counting associated with a reciter distinct from counting actually observed in a printed edition. The Quran.ws counting project documents examples of this distinction. Its external word IDs can be used as candidate crosswalks for its declared coverage and release. A manuscript's consonantal form or a report preserved by a grammarian gets an attestation record with its own evidence and can link to a transmission record where warranted. [Counting model](https://github.com/quran-ws/qiraat-ayah-map), [Quran.ws text pipeline](https://github.com/quran-ws/quran-text), [Corpus Coranicum variant sources](https://corpuscoranicum.de/en/variants)

## Alignment and downstream use

Represent a split or merge as an alignment of grouped spans. A 2-to-1 overlap does not justify copying a proposition about one member to the entire target. Distinguish exact correspondence, partial overlap, split, merge, unresolved and evidence-backed absence. Record potential orthographic, reading and interpretive differences separately from alignment. Composition across two mappings may yield candidates. It requires review before serving as an assertion of equivalence. Published data may include disputed candidates with their evidence.

Compare reading-specific interpretations only through a reviewed pairing of spans and claims. A copied parse or semantic frame has its own transfer decision. A single profile must declare which edition and reading it uses at each anchor. Any explicitly cross-reading theory must identify the linking premises and their scholarly warrants.

## Review fixtures

- Use 1:4 to verify that an attested form, its reported authority, a digital span and a resulting semantic hypothesis stay distinct. Corpus Coranicum reports multiple forms at this anchor, including in entries based on al-Dānī. The catalogue entry supplies a lead for expert review of our chosen editions. [Variant records for 1:4](https://corpuscoranicum.de/en/verse-navigator/sura/1/verse/4/variants)
- Use the Quran.ws claim of a Ḥafṣ 2:255 to Warsh 2:253–254 correspondence as a pending split fixture. Resolve exact editions and boundaries before expecting a mapping to pass. Synthetic controls test incorrect equal-number joins, partial spans, reversed order and ambiguous composition. [Quran.ws comparison](https://text.quran.ws/)
- In the initial Tanzil edition, test preservation of a numbered opening, a prefixed display span in the first numbered row and an in-verse occurrence. Include a missing prefix permitted by the documented edition. A preserved prefix does not create an extra numbered āyah. [Tanzil basmala conventions](https://tanzil.net/docs/a_note_on_bismillah)

An accepted mapping needs retrievable anchors on both sides, direction and coverage, a source citation for the proposed relation, and review of any layer projected through it. Coverage is reported for each pair of releases and segmentation schemes. The schema leaves completeness across transmissions and paths open.
