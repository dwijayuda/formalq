# 05 — Logic and verification contract
Status: design proposal.

## Formal objects
Let P be a named admissible interpretation profile, T_P its closed theory (set of well-formed sentences), and h a closed, typed candidate claim under matching context. Write T_P |- h for syntactic derivability, T_P |= h for semantic entailment, and Sat(T_P) for existence of a model. Soundness is a proof obligation linking the specific calculus to semantics; completeness is not assumed for extensions.

## Evidence obligations
- Entailment: kernel-checked derivation of h from declared theory.
- Contradiction: kernel-checked derivation of not h (or unsatisfiability of T_P union {h} with an appropriate checked certificate).
- Joint satisfiability: explicit checked model of T_P union {h}; a bounded solver's failure to find a contradiction is not evidence of existence.
- Independence: checked models of both T_P union {h} and T_P union {not h}, with matched signature and context.
- Theory inconsistency: proof of False or checked unsatisfiability certificate for T_P; block ordinary classification. A model establishes satisfiability for the represented theory only.

Record positive and negative proof searches and satisfiability evidence separately. Timeout, unsupported operator, missing interpretation and solver unknown are explicit, distinct reasons. In classical logic, an inconsistent theory entails every formula. Do not use explosion to report a hadith contradiction. A paraconsistent extension, if researched, must be isolated and labelled.

## Relative soundness
Prove evaluation and substitution lemmas; prove each inference rule sound relative to the semantics; use kernel checking for certificate verification. For finite models, prove evaluator correctness and ensure every theory premise was checked. For infinite models, require explicit mathematical satisfaction proof. An SMT solver may propose certificates or models but is not trusted to establish unverified results.

## Cross-profile reasoning
Only aggregate over registered profiles with known evidence. If each admissible evaluated profile proves not h and has a consistency witness, report contradiction across that evaluated set. If some entail h and others contradict it, label interpretation-dependent. Unchecked profiles block any universal claim about all admissible interpretations. Empty profile set never yields vacuous universal conclusions.

## Trust boundary
Lean kernel, pinned version, explicit logical axioms (including classical principles if used), definitions, and theorem premises. The logical proof cannot validate interpretation quality. Enumerate axiom dependencies for every theorem. No sorry, admit, unchecked external oracle or hidden generated axiom in a verified artifact. Theory assumptions live as explicit parameters/membership evidence, not global declarations of divine truth.
