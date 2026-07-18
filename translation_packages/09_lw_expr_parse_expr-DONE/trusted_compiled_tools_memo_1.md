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
architectural.

In that same session, the actual fact of the matter was: a Claude instance
had downloaded the original GPL source and compiled it itself. That detail
turns out to matter a lot for what kind of solution makes sense here.

## Three separate problems, often conflated

1. **Provenance** — did this artifact come from the source it claims to
   come from, unmodified?
2. **Integrity in transit/storage** — has it been tampered with since it
   was built?
3. **Behavioral bound** — regardless of (1) and (2), what's the worst
   thing this code can do when it runs?

Code signing addresses (1) and (2). It does not address (3). A
faithfully signed, unmodified binary compiled from source that does
something bad is still bad — signing tells you who to blame, not
whether to run it. Any design here needs a behavioral bound
independent of how trusted the provenance looks.

## The key simplification: this can stay entirely internal

The scenario that actually occurred wasn't "artifact from an untrusted
third party, needs public verification." It was "one Claude instance
built something, and it would be useful for another Claude instance to
reuse it later." If the compiled artifact never leaves Anthropic's own
infrastructure — never gets served to a user, never crosses out to
another organization — the hard version of the provenance problem
disappears. You don't need to convince an external, adversarial verifier
that the binary matches its claimed source. You just need an internal
system that already knows what built what, because it built it.

That's a much smaller, well-precedented problem: an internal,
content-addressed artifact cache — the same shape as a private Bazel
remote-execution cache or an internal package registry — where each
build gets an inventory reference (a hash or an ID) tied to the source
it came from and the process that built it. Large engineering orgs run
this pattern for their own build outputs constantly; there's nothing
novel required to stand it up, just internal write-access control on the
registry and a record of provenance kept at build time rather than
reconstructed after the fact. This is the piece I'd actually expect to
be worth prioritizing, and the one most likely to already exist in some
form as ordinary infrastructure rather than needing an "AI trust"
justification at all.

Public-facing machinery — reproducible builds verifiable by outsiders,
signed attestations in an external transparency log — only earns its
cost if these artifacts are meant to cross *out* of Anthropic's own
boundary (e.g. shared with users directly, or across separately-trusted
systems). Inside the boundary, it's optional hardening, not the load-
bearing mechanism.

## Behavioral bound, regardless of provenance

Whatever the caching model, I'd still want execution to happen inside a
small, fully-specified, capability-based sandbox — deny-by-default, no
ambient authority, every effect (filesystem paths, network destinations,
CPU/memory/time budget) an explicit, individually granted capability.
This is the part that shouldn't depend on how trusted an artifact's
history looks, since provenance answers "who built this," not "what
should it be allowed to do right now."

WASM is a reasonable existing target for this: near-native speed once
compiled, no ambient syscalls, host-mediated imports only, and mature
toolchains already compile C, Rust, and (via Pyodide) Python to it. It
gets most of the way to the performance-and-safety combination without
requiring anything new to be invented.

## The part no architecture removes

Even with a clean internal registry and a tight sandbox, one problem
survives: an artifact can be exactly what it claims to be, unmodified,
running inside a well-scoped sandbox — and still be a bad tool to run,
because it does, correctly and as designed, something nobody actually
wanted. Provenance and sandboxing bound *unintended* behavior and
tampering; they don't substitute for something having actually looked at
what the tool is for. That step doesn't go away — it just gets cheaper,
paid once per artifact at build/registration time instead of once per
use.

## Shape, given the internal-only framing

Build once (a Claude instance compiles from source, as already
happened) → register the artifact in an internal content-addressed cache
with an inventory reference and provenance metadata attached at write
time → other Claude instances draw on it by that reference rather than
rebuilding → execution still happens inside a capability-scoped sandbox
regardless of the artifact's internal pedigree. External
attestation/transparency-log machinery stays available as an optional
layer only if these artifacts ever need to cross outside Anthropic's own
systems.

I have no visibility into what Anthropic already has along these lines,
what it would cost to build further, or where it would rank against
other priorities — this is just my read on the shape of the problem.
