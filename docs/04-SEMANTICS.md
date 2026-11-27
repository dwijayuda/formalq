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

## Example (illustrative, not approved)
For Quran 6:164, one candidate representation of a scoped clause about bearing burdens:
    forall a b, a != b -> not BearsAnotherMoralBurden(a,b,ctx)
This is schematic and not an accepted axiom. Define what burden, agency, and accountability mean; compare related passages such as 16:25 and 29:13 before claiming scope. Distinguish responsibility for one's own acts of misleading from carrying another person's guilt. Keep alternatives and unresolved scope.

## Extensions
Deontic semantics must address conflicting duties, conditions and contrary-to-duty scenarios. Temporal logic requires explicit order and event semantics. Epistemic and modal operators require accessible-world semantics and distinction between divine and human knowledge. Defeasible reasoning, if used, is separate from monotonic derivability with a published consequence relation. Do not add modules solely to increase coverage; require a pilot example and tests.
