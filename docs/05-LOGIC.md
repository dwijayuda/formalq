# 05 — Logic and verification contract
Status: design proposal.

## Formal objects
Let P be a named admissible interpretation profile, T_P its closed theory (set of well-formed sentences), and h a closed, typed candidate claim under matching context. Write T_P |- h for syntactic derivability, T_P |= h for semantic entailment, and Sat(T_P) for existence of a model. Soundness is a proof obligation linking the specific calculus to semantics; completeness is not assumed for extensions.

The proposed [fragment and classification specification](15-VERIFICATION-SPEC.md) fixes the semantic parameters for review and provides test cases. A proof binds to the formal problem's exact signature and theory. An interpretation report additionally binds to the source and review revisions that justify those inputs.

## Evidence obligations
- Positive direction: kernel-checked derivation of h from the declared theory.
- Negative direction: kernel-checked derivation of not h, or a checked unsatisfiability certificate for T_P union {h}.
- Joint satisfiability: explicit checked model of T_P union {h}; a bounded solver's failure to find a contradiction is not evidence of existence.
- Independence: checked models of both T_P union {h} and T_P union {not h}, with matched signature and context.
- Theory inconsistency: proof of False or checked unsatisfiability certificate for T_P; block ordinary classification. A model establishes satisfiability for the represented theory only.

Record positive and negative proof searches and satisfiability evidence separately. Classification of entailment and refutation also requires accepted base satisfiability evidence. Timeout, unsupported operator, missing interpretation and solver unknown are distinct reasons. In classical logic, an inconsistent theory entails every formula, so report inconsistency and suppress claim classification. A paraconsistent extension would require its own semantics and reporting policy.

## Relative soundness
Prove evaluation and substitution lemmas; prove each inference rule sound relative to the semantics; use kernel checking for certificate verification. For finite models, prove evaluator correctness and ensure every theory premise was checked. For infinite models, require explicit mathematical satisfaction proof. An SMT solver may propose certificates or models but is not trusted to establish unverified results.

## Cross-profile reasoning
Only aggregate over registered profiles and comparable claim readings. If a nonempty declared set of pairs is fully evaluated and every pair yields a consistency-supported refutation, report refutation across that set. For mixed outcomes, identify the varying profile or claim reading and establish comparability before attributing the difference. List unresolved and unevaluated pairs. An unrestricted universal claim about interpretation requires independent coverage evidence.

## Trust boundary
Lean kernel, pinned version, explicit logical axioms (including classical principles if used), definitions, and theorem premises. The logical proof cannot validate interpretation quality. Enumerate axiom dependencies for every theorem. No sorry, admit, unchecked external oracle or hidden generated axiom in a verified artifact. Theory assumptions live as explicit parameters/membership evidence, not global declarations of divine truth.
