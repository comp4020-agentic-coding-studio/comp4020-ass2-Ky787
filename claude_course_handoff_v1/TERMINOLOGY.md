# Terminology

Definitions are course shorthand; exact behavior depends on the ISA, IR and analysis model. See [primary LLVM and SMT references](BIBLIOGRAPHY.md).

| Term | Definition |
| --- | --- |
| Basic block | A sequence of instructions with one entry and no internal control-flow branching; execution proceeds to its terminal transfer. Tools may split at calls differently, so report the convention. |
| CFG | Control-flow graph: nodes represent blocks and directed edges represent possible transfers. A recovered CFG may be incomplete, especially at indirect jumps. |
| LLVM IR | LLVM's typed intermediate representation, between source-level compilation and target code generation. Register values use SSA; memory effects still require separate reasoning. Compiler-emitted and binary-lifted LLVM IR have different provenance. |
| Compiler optimization | A transformation intended to preserve the language/IR-defined behavior while improving cost or simplifying representation, subject to its semantic assumptions. Undefined behavior and incorrect input IR undermine naive equivalence claims. |
| Lowering | Translating a representation into a more concrete one, such as a source switch into IR branches or IR operations into target instructions. Lowering is not necessarily optimization. |
| Canonicalization | Replacing equivalent forms with a preferred or simpler representation. It can make obfuscated arithmetic recognizable without recovering original source text. |
| Instruction substitution | Replacing an operation with an equivalent instruction/expression sequence, often selected from a set of templates. One static site can differ from another; later optimization may reverse the expansion. |
| MBA | Mixed Boolean-arithmetic: expressions combining bitwise operators and arithmetic over fixed-width values. Bit width, overflow and extensions are part of the semantics. “Linear MBA” names a restricted algebraic class, not a promise of easy native extraction. |
| Bogus control flow (BCF) | Added control-flow structure intended to mislead analysis, commonly involving cloned or irrelevant blocks guarded by opaque conditions. |
| Opaque predicate | A predicate whose outcome is known or constrained to the transformer under relevant program invariants but is intended to be difficult for an analyst to establish. A path-relative one-sided branch is not automatically globally opaque. |
| Flattening | Reorganizing structured control flow so execution of semantic blocks is mediated by a dispatcher and encoded state rather than primarily by the original direct edges. |
| Dispatcher | Code that selects the next semantic block from a state value. It can be a switch, comparison network, jump table or another mechanism; an indirect jump is not required. |
| State variable | A value encoding which block/state should execute next in a flattened program. It may live in memory, a register or several related SSA values. |
| Symbolic execution | Executing instruction semantics over symbolic expressions and constraints rather than only concrete values, to describe sets of possible executions. State and memory models bound its claims. |
| Dynamic symbolic execution | Symbolic reasoning associated with an observed, emulated or otherwise concretely guided execution; path constraints can guide exploration of alternatives. “Dynamic” does not require running the entire original process natively. |
| Concolic execution | Combined concrete and symbolic execution, using concrete values to drive one path while maintaining symbolic expressions and constraints. Often used interchangeably with DSE in practice; state which mechanism the workflow actually uses. |
| SMT | Satisfiability modulo theories: deciding whether a logical formula has a model under theories such as fixed-width bit-vectors or arrays. The theory must match the computation being claimed. |
| SAT | The submitted formula has a satisfying model. For an equivalence-disequality query, that model is a counterexample within the model, not automatically a reachable whole-program input. |
| UNSAT | No assignment satisfies the submitted formula under its assumptions. For a faithful disequality model this establishes equivalence within scope; inconsistent assumptions can make a proof vacuous. |
| UNKNOWN / timeout | The solver did not establish SAT or UNSAT. It is neither an equivalence proof nor a demonstrated counterexample. |
| SSA | Static single assignment: each register-like value has one definition; merge points use mechanisms such as PHI nodes to select an incoming value. This exposes def/use relations without making memory inherently immutable. |
| Lifting | Translating native instructions into an intermediate semantic representation for analysis or recompilation. Well-formed output is not proof that the translation is faithful. |
| Binary rewriting | Modifying an executable's machine code and, where needed, its metadata/layout. Proof generation, patch application and runtime validation are separate concerns. |
| Semantic equivalence | Equality of the relevant observable behavior for specified inputs, states and environment. Equality of a return expression is narrower than whole-program equivalence including memory, faults and external effects. |
| Deobfuscation | Recovering a more useful representation or behavior from obfuscated code. Outputs may be expressions, a CFG, IR or a rewritten executable; always identify which. |
| Virtualization | In this course, translating protected behavior into custom bytecode interpreted by an embedded virtual machine. It is distinct from running Windows in a host VM. No virtualization/devirtualization experiment was performed in this corpus. |

For this corpus, many arithmetic claims concern uint32 values modulo 2^32. Do not replace them with unbounded integer identities without checking the translation.
