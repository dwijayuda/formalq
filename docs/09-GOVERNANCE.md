# 09 — Quality, reproducibility and governance
Status: proposed.

## Roles
Maintainer handles releases, Arabic reviewer assesses language, Islamic-studies reviewer assesses interpretive scope, formal-methods reviewer checks semantics and proof dependencies, data steward checks license and integrity. Roles may overlap only with explicit disclosure. Public contributions remain drafts until reviewed. Do not claim peer review before it occurs.

## Review checklist
Source exactness, stable IDs, correct speaker/act, context, alternatives, declared dependencies, formal typing, soundness, theory consistency evidence, limitations, license, and reproducibility. Document dissent and preserve earlier revisions. Review decisions must be attributable and versioned; no personal data beyond necessary public contributor details.

## Tests and CI
Schema validation and reference integrity; raw checksum verification if licensed data available; expected edition counts; Unicode and normalization tests; deterministic generation; Lean build and unit/regression tests; certificate/model verification; no sorry/admit in verified modules; axiom dependency report; profile firewall; coverage reports. Test known inconsistent and underdetermined theories. CI must fail on unsupported data or logic in a verified release. Pin tools, sandbox parsers, disallow untrusted code and archive traversal; avoid secrets in manifests or logs.

## Release policy
v0.x research draft, versioned source/schema/toolchain/theory hashes. Semantic changes invalidate dependent proofs and comparison reports. Publish changelog, known limitations, reproducibility instructions and review record. No definitive religious labels in software output. Provide correction and issue-report process; disputed claims remain clearly marked. No auto-merge of interpreted premises or third-party data.

## Licensing
Choose software license after maintainer review; it cannot relicense external corpora. Do not commit raw data until terms explicitly permit it, and keep attribution and notices. Record per-artifact permission and use constraints. Do not imply endorsement by data publishers or scholars.
