# 04 — Formal language and semantic representation
Status: proposed, not yet a validated grammar or implementation.

## Language design
Use a typed intermediate representation (IR) with separate syntax and semantics, not direct translation into opaque Lean axioms. Start with many-sorted first-order formulas; extend by explicitly specified semantic modules. Sorts may include Agent, Act, Event, Time, Place, Utterance, Context and Proposition. Domain-specific theological terms remain declared symbols with reviewed definitions, not reductions imposed by implementation.

Core terms: variable, constant, function application. Core formulas: predicate application, equality, negation, conjunction, disjunction, implication, forall, exists. Use explicit binders with capture-avoiding substitution and type checking. Context includes reading, speaker, addressee, time, condition, domain restrictions and source spans.

## Speech act IR
Represent assertion(phi), obligation(agent, act, context), prohibition(...), permission(...), question(...), quotation(speaker, content), promise(...), narrative(event,...), ambiguous(alternatives), and unformalized(reason). Not all constructors coerce to Prop. A quoted false claim is a claim that someone uttered it, not an assertion of its content. A question is not an axiom. Modal/deontic wrappers have separate semantics and cannot be reduced to factual predicates without reviewed bridge rules.

## Semantics
Define structures with nonempty domains per sort (or explicitly choose empty-domain policy), interpretations for symbols, variable environments and satisfaction relation. Evaluate quantifiers over specified domains. Use open-world semantics; unknown is not false. Temporal index and context restrict quantification. Explicitly document identity and reference resolution assumptions.

## Alternatives
Interpretation sets retain alternatives with eligibility rules, evidence, reviewer status, and compatible combinations. A profile is a coherent selection plus assumptions, not a conjunction of mutually exclusive readings. Separate ambiguity within a reading from different transmitted readings. Where combination explosion occurs, report bounded coverage.

## Arabic analysis and lowering

The proposed analysis record carries ordered span groups, the annotation source's own segmentation and tagset, inflection and clitic features, candidate dependencies and ellipses, discourse referents and accessible antecedents, type of negation, and scope of qualifiers. Record what supplies each lexical sense and the locus of any disagreement. A shared root, an English gloss or an imported ontology identifier supplies a retrieval cue. Sense equivalence requires its own argument.

Use an utterance frame for speaker, reporting level, addressee and context, with optional truth-conditional content. Preserve an ascribed speech act within a quoted frame separately from the narrator's enclosing frame. Conditions include the scope and anchor of a negation, quantifier, exception or time restriction. Keep uncertainty about an antecedent as distinct candidate frames. Where the candidate requires discourse state beyond a single clause, compare a scoped discourse representation against a shallow annotation of the dependencies before choosing an implementation. [Kamp](https://doi.org/10.1002/9780470758335.ch8)

Proposed lowering for the initial fragment is partial. It returns a closed formula plus reviewed bridge, declared signature, resolved context and source path, or a structured reason for abstaining. Distinguish unresolved speaker, unresolved referent, competing scopes, unsupported speech act and unsupported semantic operator. No quotation elimination rule is proposed. Commands and questions remain represented as frames, even when their contents cannot enter the base theory. A choice among alternatives belongs in a named profile with its own evidence.

Use a restricted universal `∀ x : S, R(x) → P(x)` only when the reviewer endorses that reading and restriction. It is vacuously true if no entity satisfies `R`. If existence is intended, state and warrant it separately. Distinguish `¬∀ x, P(x)` from `∀ x, ¬P(x)`. For contradictory-looking formulations, first test speaker, sense, temporal and quantifier scope, exceptions and conditionality. Any reconciliation or chronology/abrogation assumption enters a revisioned, method-specific profile. Preserve divergent proposals and their evidence.

## Example (illustrative, not approved)
For Quran 6:164, one candidate representation of a scoped clause about bearing burdens:
    forall a b, a != b -> not BearsAnotherMoralBurden(a,b,ctx)
This is schematic and not an accepted axiom. Define what burden, agency, and accountability mean; compare related passages such as 16:25 and 29:13 before claiming scope. Distinguish responsibility for one's own acts of misleading from carrying another person's guilt. Keep alternatives and unresolved scope.

## Extensions
Deontic semantics must address conflicting duties, conditions and contrary-to-duty scenarios. Temporal logic requires explicit order and event semantics. Epistemic and modal operators require accessible-world semantics and distinction between divine and human knowledge. Defeasible reasoning, if used, is separate from monotonic derivability with a published consequence relation. Do not add modules solely to increase coverage; require a pilot example and tests.
