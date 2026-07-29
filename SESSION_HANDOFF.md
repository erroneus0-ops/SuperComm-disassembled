# Session handoff -- keyboard drag debugging (2026-07-29)

Written at the end of a session that hit a context/length limit much
faster than any prior session. Purpose of this file: let the next
session (or a fresh Claude instance) pick up exactly where this one
left off, without needing to reconstruct the whole debugging trail
from scratch.

## Current state of wasm/index_new.html -- READ THIS FIRST

**The live/local page is currently NOT showing the real keyboard.**
The `<object>` tag is pointed at `coco3_keyboard_dummy2.svg` -- a
minimal test file with one rectangle (`key-a`) and no embedded image
at all. This was deliberate, for isolating the drag bug from the real
file's complexity. **Before doing anything else keyboard-related,
decide whether to keep testing on the dummy or switch back to the
real `coco3_keyboard.svg`.**

There are also several **TEMPORARY** changes still active, each
clearly marked with a `TEMPORARY` comment in the source, all in
`wasm/index_new.html`:

1. **Toolbox drag handle enabled on desktop** (search `TEMPORARY:
   removed the !_isMobile gate`) -- normally the toolbox's drag handle
   only gets created on mobile. This was temporarily enabled on
   desktop too, specifically to let Daniel drag the toolbox on his PC
   and compare against the keyboard's drag behavior directly. That
   comparison already happened and was decisive (see below) -- this
   can likely be reverted now unless further comparison is wanted.

2. **Toolbox wrapper visible by default on desktop** (search `TEMPORARY:
   visible by default on desktop`) -- side effect of #1: once the
   toolbox got wrapped on desktop, nothing could toggle it, since the
   hamburger's desktop click handler (see #3) never calls
   `toggleControls()`. Made it default-visible on desktop as a quick
   fix. Revert alongside #1.

3. **Hamburger button repurposed for keyboard testing on desktop**
   (search `TEMPORARY (desktop testing only)`) -- added because
   Daniel's phone couldn't reach his work machine at one point. On
   desktop, clicking the hamburger toggles the test keyboard instead
   of the normal controls-panel behavior. This is probably still
   wanted for ongoing desktop testing, but should be reconsidered once
   real mobile testing is reliable again.

4. **Intermediate div wrapping the `<object>`** (search `TEMPORARY TEST
   #3`) -- added to test whether decoupling the dragged wrapper from
   the `<object>` element itself (a "replaced element" in CSS terms,
   like `<iframe>`) helped. It didn't change anything -- the drag code
   was already moving a plain div, not the object directly, even
   before this was added. Probably fine to leave (harmless extra
   nesting) or revert for cleanliness -- doesn't affect behavior either
   way as far as we found.

## The debugging journey, condensed

Long chain of real, evidence-based findings, roughly in order:

1. **Keys weren't clickable at all** -- root cause: the shader image
   and all character-glyph paths sat *after* the key cells in the
   SVG's document order, so they painted on top and intercepted every
   click. Fixed with `pointer-events:none` on the decorative layer
   (`fix_keyboard_pointer_events.py`, a standalone re-runnable script
   now in `wasm/`).

2. **`querySelectorAll('[id^="key-"]')` found zero keys** even though
   all 57 genuinely existed in the file -- a real, narrow quirk:
   attribute selectors don't reliably match in a standalone XML
   document (which is what an `<object type="image/svg+xml">`-loaded
   SVG genuinely is) the way they do in HTML. Fixed by manually
   iterating `querySelectorAll('*')` and checking each element's `.id`
   property directly, which works reliably.

3. **Key taps silently did nothing on mobile, and dragging made the
   keyboard vanish on swipe** -- root cause: Pointer Events (which
   unify mouse/touch) were missing `touch-action:none` and
   `{passive:false}` on the move listener, so the browser's native
   swipe/scroll gesture could still fire regardless of what our code
   asked for. Fixed by switching to the same proven separate
   touch/mouse event pattern already used by the working toolbox drag
   handle (mousedown/mousemove/mouseup + touchstart/touchmove/touchend
   with explicit touch-action:none and passive:false). **This fix
   worked -- key presses are confirmed working on both PC and phone.**

4. **Keyboard drag undershoots to roughly half the real mouse
   movement, feels jerky** -- this took the longest to pin down.
   Ruled out, with direct evidence for each:
   - NOT the SVG's viewBox scale (tested with a faithful local
     reproduction, matching viewBox and explicit width/height attrs --
     coordinates reported correctly, no distortion)
   - NOT the real file's complexity (built `coco3_keyboard_dummy.svg`,
     one rect + the real embedded shader image -- same bug)
   - NOT the embedded shader image itself (`coco3_keyboard_dummy2.svg`,
     one rect, zero embedded image -- same bug)
   - NOT dual-monitor DPI/scaling weirdness -- **decisive test**:
     enabled the toolbox's drag handle on desktop (see TEMPORARY #1/2
     above) and dragged it around the exact same dual-monitor setup.
     Toolbox worked perfectly, zero problems. This ruled out anything
     hardware/OS-level and confirmed the bug is specific to the
     `<object>`-nested document.
   - Found via a screen recording + OCR analysis (extracted frames
     with ffmpeg, read the on-screen log panel text with
     pytesseract rather than trust a visual read of a compressed
     phone recording) that the drag wasn't tracking one continuous
     gesture at all -- rapid START-then-immediately-END pairs, every
     one restarting from the same fixed origLeft/origTop. Fixed by
     tracking a specific touch's `.identifier` throughout the gesture
     and ignoring new touchstarts while already dragging.
   - Found, by comparing structurally against the toolbox's proven
     code, that the toolbox's ongoing mousemove/mouseup tracking
     happens entirely on the *outer* document, never touching the
     nested document's own event system during the actual drag -- the
     keyboard's drag was tracking the whole gesture, including ongoing
     movement, through the *inner* SVG document. Moved the ongoing
     tracking to the outer document to match.
   - **Most recent finding, from a detailed narration of the actual
     symptom**: `mousedown` reaches the inner document's listener
     correctly, but `mouseup` fired while the cursor is still over the
     `<object>`'s visual area appears to never propagate out to the
     outer document at all. Result: `dragging` never reset to false,
     so the keyboard kept chasing the cursor indefinitely. **Just
     fixed, NOT YET TESTED**: attach the ongoing move/end listeners to
     *both* the inner and outer documents simultaneously, so whichever
     one the browser actually delivers to, the code catches it.

## Immediate next step

**Test the dual inner+outer listener fix** (just pushed, commit
`f07e247`) against the dummy2 test page, the same way as before:
mousedown/touchstart, hold, move, release, and confirm (a) the
keyboard actually tracks the cursor accurately now, without undershoot
or the "keeps following after release" bug, and (b) the log panel's
`[drag] END` line appears promptly on release rather than logging
continuing indefinitely.

If this works: revert TEMPORARY #1/#2 (toolbox desktop-drag test),
decide on TEMPORARY #3 (keep or revert the hamburger repurposing) and
#4 (probably harmless to leave), and switch the `<object>` back to the
real `coco3_keyboard.svg` (currently pointed at dummy2.svg for
testing).

If it doesn't work: the next thing worth trying is probably using
`element.setPointerCapture()`-style capture semantics, or investigating
whether a completely different approach (e.g. inlining the keyboard's
SVG directly into the page's own DOM, like the CM8 bezel's power
button already does, rather than loading it via `<object>`) would
sidestep this whole class of cross-document event-propagation quirk
entirely. That's a bigger, more invasive change, so worth trying the
smaller fix first.

## Standalone tools built this session, for reference

- `wasm/fix_keyboard_pointer_events.py` -- re-runnable, `--dry-run`
  capable, fixes the pointer-events-blocking issue after any Inkscape
  edit that might reset it.
- `wasm/fix_keyboard_label_naming.py` -- same pattern, for the agreed
  label naming scheme (letters as "X char", bare symbols get " char"
  appended, etc.)

## A bigger, open question raised at the end of this session

Daniel's observation: this session moved through context far faster
than any prior one, and involved several very different *kinds* of
work tangled together in one continuous thread -- deep technical
debugging (video frame extraction, OCR, cross-document event
propagation), live interactive fixing, and narrative documentation
(commit messages, this very file) all mixed moment to moment.

His proposed direction: **separate these more deliberately going
forward** -- something like distinct spheres for "the book" (the
manifesto/narrative/documentation side of the project), "the
environment" (the actual build/deploy/runtime infrastructure -- CI
workflows, the WASM build pipeline, the served pages), and "the tools"
(standalone, reusable scripts and utilities that do one concrete thing,
independent of any particular narrative or environment). The idea
being that a session scoped to just one of these at a time would likely
stay more focused and cheaper than one that freely mixes all three,
the way this one did.

This wasn't resolved before the session ended -- worth raising again
early in the next session as a real, worthwhile discussion about how
to structure future work on this project, not just a one-off comment
to file away.
