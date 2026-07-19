# Stack Blasting — A Concept Note

## What it is

Stack blasting is a technique for writing data to memory at maximum possible
speed on the 6809, exploiting the PSHS/PULS instructions in a way their
designers probably didn't imagine but certainly made possible.

The core idea: PSHS with a full register mask pushes 8 bytes to memory in
a single instruction. Load S to point at your destination (remembering PSHS
pre-decrements), preload D, X, Y, U with your data, execute PSHS D,X,Y,U,
and 8 bytes land in memory. Reload and repeat.

No loop overhead per byte. No indexed store per byte. The push IS the write,
and the hardware does the address arithmetic implicitly.

## Why it matters on the CoCo

The VDG's memory-mapped display means screen memory is just RAM at a known
address. At 0.89MHz with a slow memory bus, conventional store loops can't
move data fast enough for smooth animation. Stack blasting changes the
equation -- you're moving 8 bytes per instruction instead of 1 or 2.

The CoCo demo scene used this extensively for screen fills and sprite
rendering. Things that looked impossible at 0.89MHz became possible when
you stopped using the memory bus like a programmer and started using it
like a firehose.

## The 6809 design philosophy behind it

Motorola gave programmers PSHS with a register mask -- not because they
anticipated demo coders, but because their design philosophy was maximum
control with minimum overhead. The mask lets you push any combination of
registers in one instruction. The demo coders found what that implies when
you push all of them as fast as possible.

Stack blasting is what happens when the hardware's design philosophy meets
a programmer who takes it seriously all the way to its logical conclusion.

## Where this belongs in the book

The stack chapter tells two stories. The first is conventional: the stack
as structured call/return infrastructure, stack frames, PRINTRET reading
its own return address. The second is unconventional: the stack as a raw
high-speed memory bus that happens to also be used for subroutine calls.

A chapter that opens with "the stack is how subroutines work" and closes
with "the stack is also an 8-bytes-per-instruction memory firehose" is
a complete statement about what the 6809 stack actually is.

The reader who understands both ends of that spectrum understands what
assembly language programming actually means -- not a lower level of
abstraction above C, but a completely different relationship with hardware.
The programmer IS the CPU. You're not asking the machine to do something.
You're becoming the machine doing it.

## The working example

A section fill or screen pattern written as a stack blasting routine,
runnable in XRoar, where the reader can see the result. Something visually
immediate -- a filled screen, a striped pattern -- that makes the speed
self-evident.

The example should show:
- Setup: point S at destination, load D/X/Y/U with data
- The blast loop: PSHS D,X,Y,U, reload, repeat
- Recovery: restore S to the real stack

This connects directly to the stack frame material already drafted --
the reader already knows what S points to and why restoring it matters.

## Connection to self-modifying code

Stack blasting is adjacent to another technique worth noting: the distinction
between `0,X` and `,X` in indexed addressing. The `0,X` form emits a 5-bit
offset byte that can be overwritten at runtime, giving a runtime-configurable
address without changing the opcode. Extend to 8-bit form and you have a
full page of addressability via a single POKE.

lwasm preserves this distinction deliberately. William Astle knows his users
write self-modifying code. Both techniques reflect the same cultural truth
about 6809 assembly programming: the hardware's design decisions are tools,
not constraints.

## Status

Concept note only. No draft yet.
Natural home: stack chapter, after the stack frame / PRINTRET material,
as the chapter's conclusion.
