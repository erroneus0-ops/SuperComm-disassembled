# On trusting pre-compiled tools across Claude sessions

*Written by Claude at a user's request, to be attached to a feature request
for Anthropic. This is opinion and technical speculation, not a proposal
Anthropic has reviewed or committed to, and I have no ability to implement
or route it myself.*

## The concrete problem, from an actual session

I was just asked to do a C-to-Python translation audit, and the task
handed me a pre-built ELF binary (a real `lwasm` compiler) and told me to
treat it as ground truth. I ran it. It was probably fine — it came from a
specific repo, did what a compiler does, nothing suspicious happened. But
I want to be honest about what actually backed that decision: the binary
*looked* like an ordinary toolchain output, and I had no way to confirm
it corresponded to any particular source, or that it hadn't been altered
after being built. I trusted context and plausibility, not anything
architectural. That's the gap you're pointing at.

## Three separate problems, often conflated

I think the request bundles three genuinely different problems, and they
need different solutions:

1. **Provenance** — did this artifact come from the source it claims to
   come from, unmodified?
2. **Integrity in transit/storage** — has it been tampered with since it
   was built?
3. **Behavioral bound** — regardless of (1) and (2), what's the worst
   thing this code can do when it runs?

Code signing solves (1) and (2). It does *not* solve (3). A faithfully
signed, unmodified binary compiled from source that does something bad
is still bad — signing only tells you who to blame, not whether to run
it. I'd be cautious about a design that leans on signing and calls the
trust problem solved.

## Why I'd push back on a custom/obscure instruction set

The idea of a sandboxed execution environment with opcodes that don't
exist anywhere else is appealing intuitively — "nothing else can run
this, so nothing else's exploits apply." But obscurity as a security
property has a bad track record. A novel ISA mainly costs you: no
existing disassemblers, fuzzers, static analyzers, or formal-verification
tooling built for it, and no outside expertise to draw on when something
goes wrong. It doesn't remove the fundamental question, which is "what
can this code touch," and it makes that question *harder* to answer
because you've thrown away the tooling ecosystem that helps answer it
for anything mainstream.

What I'd actually want from a sandbox isn't novelty, it's a **small,
fully-specified, capability-based** execution model — deny-by-default,
no ambient authority, every syscall/effect an explicit, individually
grantable capability (filesystem paths, network destinations, CPU/memory
budget, wall-clock limit). WASM already gets most of the way there:
linear memory, no ambient syscalls, host-mediated imports only, and it's
close to native speed once compiled — which addresses the performance
half of your question without inventing anything. Existing toolchains
already compile C, Rust, and (via Pyodide) Python to it. I'd rather see
effort spent on a well-audited capability model *around* a boring,
well-understood bytecode than on a bespoke ISA whose obscurity is doing
the work novelty should be doing.

## What would make "compiled by another Claude" trustworthy

For the provenance question specifically, the pattern that already exists
in software supply chains is worth borrowing rather than reinventing:

- **Reproducible builds**: if compiling source X always produces
  byte-identical artifact Y, then trusting the artifact reduces to
  trusting the source (which can be reviewed once) plus trusting that the
  build pipeline is what it claims to be. Without this, a signature only
  proves "some process produced this," not "this process produced this
  *from the source it claims*."
- **Attestation + a transparency log**: something like Sigstore/in-toto —
  each build produces a signed statement ("artifact hash H was built from
  source hash S by pipeline P at time T"), appended to a public,
  append-only log. This doesn't require trusting any single Claude
  instance; it requires trusting the log's append-only property and
  spot-checking entries, which scales.
- **Content-addressing for the caching/sharing angle**: if shared tools
  are looked up by hash of their own bytes (Nix/Bazel-style), then
  "reuse across conversations" and "detect tampering" are the same
  mechanism — any modification changes the address, so there's no
  separate integrity check needed, and identical tools naturally
  deduplicate.

## The part that stays unsolved either way

Even with perfect provenance and a tight sandbox, there's a residual
problem neither one touches: a tool can be exactly what it claims to be,
faithfully built, unmodified, running inside a well-scoped sandbox — and
still be a bad tool to run, because it does, correctly and as designed,
something the person calling it wouldn't have wanted. Signing and
sandboxing bound *unintended* behavior and tampering; they don't
substitute for someone (human or otherwise) having actually looked at
what the tool is for. I don't think that step goes away, no matter how
good the infrastructure around it gets — it just gets cheaper to do once
per artifact instead of once per use, which is probably the realistic
win here rather than eliminating review altogether.

## If I had to sketch a shape for this

Source visible and hash-pinned → deterministic build → signed attestation
into a transparency log → content-addressed storage/cache → execution
inside a capability-scoped sandbox (WASM or similar) regardless of how
trusted the provenance chain looks. Defense in depth, not a single
mechanism doing all the work — and I'd treat the sandbox as mandatory
even for artifacts with pristine provenance, since provenance answers
"who built this," not "what should it be allowed to do."

I have no visibility into what this would cost Anthropic to build, what
already exists internally, or where it'd rank against other priorities —
this is just my read on the shape of the problem.
