# 15 — Initial verification specification

Status: candidate for G0 review. This document specifies a mathematical contract and hand-worked controls for an assertion fragment. G3 is responsible for producing Lean artifacts and replay evidence.

## Sorted first-order semantics

Let a signature `Σ` give a finite vocabulary of named sorts and sorted function and relation symbols. A function signature has a list of argument sorts and one result sort. A relation signature has a list of argument sorts. A constant is a nullary function. A typing context `Γ` lists the sorts of bound variables. Use locally nameless or de Bruijn binding internally subject to the G3 spike. A free variable or an ill-sorted application cannot enter a closed theory. Equality applies within a sort.

A `Σ`-structure `M` supplies a nonempty domain `Dₛ` for each declared sort, a total function on the indicated product for each function symbol, and a relation on the indicated product for each predicate. Equality denotes identity in the corresponding domain. Distinct constant symbols may denote the same element. The language applies no default domain closure, unique-names condition, or closed-world rule. A model witness gives an interpretation for every symbol in the signature, including unused ones.

For a valuation `ρ` assigning values of the declared sorts, evaluate a variable by lookup and an application by applying the interpreted function to the evaluated arguments. Atomic predicates use the interpreted relations. Propositional operators use the ordinary classical satisfaction clauses. In particular, `M,ρ ⊨ φ → ψ` means every proof of satisfaction of `φ` yields satisfaction of `ψ`, and `M,ρ ⊨ ¬φ` means satisfaction of `φ` implies falsity. Universals test every extension `ρ[x:=d]` for `d ∈ Dₛ`. Existentials require one such extension. Fix the object-logic classical rules explicitly and report any Lean axioms used by their soundness proof.

`M ⊨ T` means every sentence in the finite theory inventory is true in the same structure. `T ⊨ h` means every model of `T` satisfies `h`. A usable comparison binds the normalized core AST, exact premise inventory, signature and logic revisions, and designated closed claim to one formal problem. Track a separate report identity for source lineage, profile revision, reviewed context and comparison bridge. Do not combine evidence for different formal problems. Replaying equivalent syntax under another encoding needs an explicit correspondence. The hash serialization and treatment of ordered premises, duplicates and alpha-equivalence remain G2/G3 decisions. Never rely on a digest alone to verify that a decoded certificate proves the expected statement.

## Proof obligations and evidence

- Check variable renaming and weakening, sorted substitution, and the semantic substitution lemma. For `t : S`, satisfaction of `φ[x := t]` under `ρ` equals satisfaction of `φ` under the valuation updated with the denotation of `t`. Check fresh variable conditions for quantified inference rules and the independence of a closed sentence from a valuation. Prove soundness for the exact selected calculus and theory-membership rules.
- For the bounded model checker, validate positive domain sizes, sorted indices, total tables and resource bounds. Establish that each accepted Boolean evaluation corresponds to satisfaction of the same decoded formula. Check all premises and the selected claim polarity. An explicit proof of satisfaction can support an infinite model. Search exhaustion through any fixed bound is a search statistic.
- Record proof of `h`, proof of `¬h`, proof of `False`, and model witnesses of `T`, `T ∪ {h}` or `T ∪ {¬h}` as separate evidence. A sound checked unsatisfiability certificate may supply the corresponding proof obligation. Check at ingestion which formal statement the witness actually establishes.

## Classification and precedence

Report the evidence checks and search dispositions separately. A usable model for an extension is also a model for its base theory. Interpret combined evidence in this order.

1. Reject an invalid target, missing context alignment, unsupported lowering or failed mandatory review as unassessable. Preserve the reason.
2. If simultaneously accepted artifacts assert impossibility and exhibit a model of the same problem, report an evidence-integrity failure and suppress classification. Examples include a model of `T` and a proof of `False`, or a model of `T ∪ {h}` and a proof of `¬h`. Investigate binding, encoding and the trusted base.
3. A proof of `False` or proofs of both polarities with no conflicting witness report an inconsistent theory. Ordinary claim labels are suppressed.
4. A proof of a single polarity and a model of `T` qualify entailment or refutation. Without a model or other accepted satisfiability proof, show only the conditional derivation and unresolved base status.
5. A model of either extension establishes joint satisfiability of that polarity. Models for both establish independence from the represented theory. A single model of `T ∪ {¬h}` refutes semantic entailment of `h` and does not prove entailment of `¬h`. A model of `T ∪ {h}` similarly refutes entailment of `¬h`. Keep these facts alongside any supported proof.
6. In the absence of adequate evidence, report undetermined, with reasons such as budget limit, missing certificate, or unsupported evidence format.

Across profiles hold the claim reading fixed where possible. Keep other readings as separate comparisons. A set-wide conclusion requires named, comparable pairs and complete evidence for each member of that nonempty set. An unassessable or undetermined pair remains visible in any coverage denominator. Claim scope is the evaluated set.

## Hand-worked acceptance cases

Use one uninterpreted sort with constants `a`, `b` and unary predicates `P`, `R`. Let the default query be `P(a)`. A one-element model may interpret both constants by the sole value. The cases specify expected results for a future Lean qualification.

| Theory or comparison input | Evidence and expected result |
|---|---|
| `{∀x, R(x) → P(x), R(a)}` | Specialize the universal and apply implication. A one-element model with both predicates true witnesses base satisfiability. Entailed. |
| `{¬P(a)}` | Use the premise and the one-element model with `P` empty. Refuted. |
| `{∀x, R(x) → P(x)}` | In one-element models, set `R` empty and vary `P` between full and empty. Both extensions are satisfiable. Independence also checks vacuity. |
| `{P(a), ¬P(a)}` | Apply the negative premise to the positive premise. Invalid theory takes precedence over any single claim proof. |
| `∅`, query `a = b` | A singleton model with equal denotations and a two-element model with distinct denotations prove independence. |
| Valid proof of `¬P(a)` with a purported passing model of `T ∪ {P(a)}` | Treat the accepted inputs as inconsistent evidence. Report integrity failure; the pair cannot occur under the soundness obligations. |
| Query refers to another time or speaker, without a reviewed bridge | Unassessable before proof search, even when the normalized unscoped text appears identical. |
| Two-element model with `P` true of exactly one element | Witnesses `¬∀x, P(x)` and `¬(∀x, ¬P(x))` together. Detects an invalid negation-scope rewrite. |

As a bounded-search control, take a sort with a unary function `f` and a constant `a`. Assert that `f` is injective and that `∀x, f(x) ≠ a`. A finite injective endofunction on a nonempty finite set is surjective, so no finite model exists. The natural numbers with successor and zero give a model. A model search restricted to finite domains must never classify this theory as inconsistent based solely on search exhaustion.
