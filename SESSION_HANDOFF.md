# Session handoff -- keyboard drag, rebuilt (2026-07-29, updated)

This supersedes the first version of this file. The keyboard drag has
been rebuilt architecturally, not just patched further -- read this
version, not the debugging trail below it (kept for context only).

## Current state

`wasm/index_new.html`'s keyboard now has a **dedicated grab handle**
(`#mobile-kbd-handle`, a plain div sitting above the `<object>`, styled
to match the toolbox's "Controls" handle). Dragging happens entirely
via `wireKeyboardHandleDrag()`, a new, separate function that:

- Only listens on the handle itself (`mousedown`/`touchstart`) and the
  **outer document** (`mousemove`/`mouseup`/`touchmove`/`touchend`/
  `touchcancel`) -- never inside the `<object>`'s nested SVG document
  at all.
- Doesn't depend on the SVG being loaded, only on the handle/wrapper
  elements existing (which they always do). Wired unconditionally at
  page load, regardless of device type.
- Is the exact same pattern the toolbox's drag handle already used
  successfully the whole session.

All the old cross-document listener code (dual inner+outer attachment,
touch-identifier tracking for drag specifically, the manuallyPositioned
movement-threshold logic, the on-screen `[drag]` diagnostic logging)
has been **removed entirely**, not left in place alongside the new
code. The `<object>` is pointed back at the real `coco3_keyboard.svg`
(no longer needs to stay on the stripped-down dummy test file, since
the fix doesn't depend on what's inside the object at all).

The toolbox-on-desktop comparison scaffolding has been reverted --
toolbox is back to mobile-only, as it always was before that
comparison test.

**One TEMPORARY item still active**: the hamburger button on desktop
still toggles the test keyboard instead of the normal controls-panel
behavior (search `TEMPORARY (desktop testing only)` in
`index_new.html`). Kept because desktop testing is still ongoing.
Revisit once real mobile testing is reliable again.

## Why this should actually be structurally sound now, not just another attempt

Every bug this session traced back to the same root cause: the
keyboard's original drag code needed to listen for events *inside* the
`<object>`'s nested document, specifically to distinguish "did this
touch start on a key (which should type) or the bezel (which should
drag)". Both live inside the object, so that check had to happen
there. Everything downstream of that requirement -- the undershoot,
the `mouseup` apparently getting swallowed while the cursor was still
over the object, the rapid-restart bug -- were all different symptoms
of the same underlying cross-document event-propagation quirk.

A dedicated handle removes the requirement itself. It's a plain div in
the outer page, exactly like the toolbox's handle -- there's no key-vs-
bezel ambiguity to resolve, so there's no reason left to listen inside
the nested document for drag purposes at all.

## Immediate next step

**Test it.** This has not been tried against the live/local page yet.
Click the hamburger to show the keyboard, then drag it by the new
"Keyboard" handle bar (should look and behave like the toolbox's
handle). Confirm: tracks the cursor accurately, no undershoot, no
lag/lingering movement after release, works the same on desktop and
(whenever reachable) mobile.

If this works cleanly: the keyboard-drag saga from this session is
closed. Key presses were already confirmed working earlier in the
session (both PC and phone) and weren't touched by this change.

If something's still wrong: it would be a genuinely new, different
symptom, since the entire mechanism that caused every previous bug no
longer exists. Start fresh rather than assuming it's the same root
cause resurfacing.

## Bigger architectural point raised alongside this fix

Daniel raised a related, larger concern: the CM8 monitor bezel's
power-button/LED-light overlay is built as inline SVG hardcoded
directly into `index_new.html`'s own markup, tightly coupled to that
specific bezel image's exact pixel coordinates. Swapping to a
different monitor style would mean real rework, not just changing an
image file. This is a legitimate, separate architectural question --
worth its own dedicated session (per the book/environment/tools
discussion below), not something to fold into whatever comes next
immediately.

## On session structure (carried over from the previous version of this file, resolved/agreed)

Discussed and agreed: treat deep, hard debugging work as its own
bounded session (run until resolved or clearly blocked), and keep
structural/planning discussions (like this one) in separate, dedicated
sessions with nothing else competing for space -- never mid-debug, the
way part of this session went. Worth holding to deliberately, not just
noting once and forgetting.

## Standalone tools built this session, for reference

- `wasm/fix_keyboard_pointer_events.py` -- re-runnable, `--dry-run`
  capable, fixes the pointer-events-blocking issue after any Inkscape
  edit that might reset it.
- `wasm/fix_keyboard_label_naming.py` -- same pattern, for the agreed
  label naming scheme.

## Previous debugging trail (context only, superseded by the fix above)

Kept briefly for anyone curious about *why* things were built the way
they were before this rebuild -- not needed to continue the work, since
the whole mechanism these findings were about no longer exists:

1. Keys weren't clickable -- shader image and glyph labels sat on top
   of key cells in paint order, fixed with `pointer-events:none`.
2. `querySelectorAll('[id^="key-"]')` found zero keys in the nested
   document even though all 57 existed -- attribute selectors don't
   reliably match in a standalone XML document the way they do in
   HTML. Fixed by iterating and checking `.id` directly.
3. Pointer Events lacked `touch-action:none` and `{passive:false}`,
   letting native swipe/scroll gestures fire regardless of
   `preventDefault()`. Fixed by switching to the toolbox's separate
   touch/mouse event pattern -- this fix is why key presses work.
4. The drag-specific undershoot/jerkiness/vanishing bugs (the ones
   this handle rebuild makes moot): ruled out viewBox scaling, the
   real file's complexity, the embedded shader image, and dual-monitor
   DPI, in that order, each with direct evidence. Eventually traced to
   cross-document event propagation quirks between the inner SVG
   document and the outer page -- which the handle-based rebuild
   sidesteps entirely rather than continuing to patch around.

## Future item, explicitly not for now (added 2026-07-30)

**Multi-machine keyboard selection.** CoCo2 and Dragon keyboards share
most of their scheme with CoCo3 (Motorola reference implementation
common ancestry -- confirmed directly: real hardware only has one real
SHIFT switch, with both keycaps wired in parallel to the same matrix
line, which is why our shift-key-sharing fix earlier tonight was
correct, not just a simplification). Building a CoCo2/Dragon keyboard
SVG is expected to be mostly layout work -- moving/removing keys from
the existing CoCo3 artwork, no code changes needed for that part.

The separate, genuinely code-level piece: letting someone actually
*choose* which board is active at runtime. That means swapping the
`<object data="...">` source, probably wired to the existing "Machine:"
dropdown in the toolbox (since the active board should logically follow
whichever machine is being emulated), and very possibly needing its own
`KEY_SCANCODES` table per board, since different real machines could
have genuine differences in what their physical keys map to. Explicitly
deferred -- not started, not scoped in detail yet, just flagged so it
doesn't get lost.

Also still flagged from earlier, unresolved: whether CTRL has a similar
"two keycaps, one real matrix switch" story on real hardware (like
SHIFT does), which might explain why it didn't appear under its own
name in the direct raw-mode scancode table the same way SHIFT's
sharing did.

## Future item, not started -- custom machine-configuration system (added 2026-07-31)

Goal: let Daniel define named machine startup configurations (the
`-machine`/`-cart`/etc. options string XRoar takes) through the web UI
itself, without touching XRoar's source -- directly motivated by the
environment project's actual completion criterion being *maintainability*
of ongoing changes, not a fixed feature list (see the lwtools 4.24->4.25
upgrade-as-process-validation parallel Daniel drew).

Worked out design, in layers, each solving a genuinely different problem
-- discussed but not built:

- **A JSON config file, git-tracked** -- name + comment + options string
  per entry, plus a marker for which entry the file itself considers
  default. Portable between Daniel's own machines via normal `git pull`
  (home/office), which is the thing cookies/localStorage can never do,
  since those are tied to one browser on one device.
- **A textarea (view + copy/paste + edit + apply)** -- replaces a
  file-export/import dialog entirely. Shows the current config JSON,
  editable in place, "Apply" reloads the in-memory list from whatever's
  in the box. Also serves as the direct-editing interface -- no separate
  add/edit form needed. Fits how Daniel actually shares things in
  conversation (pasted text, not attached files) -- if someone needs to
  reproduce his exact setup for debugging, paste-and-apply covers it
  without any file at all.
- **`localStorage`** -- remembers only which single config was last
  selected, purely local to one browser, never the actual config data
  itself. Startup logic: check localStorage first; if it names a config
  still present in the list, use it; otherwise fall back to whatever the
  file/textarea-loaded list marks as its own default.

Explicitly considered and set aside for now: cookies (wrong tool --
their whole design purpose is automatic server visibility, irrelevant
for a static page with no server logic at all) and a URL-parameter
sharing mechanism (genuinely useful, but the textarea alone may already
cover the sharing case well enough -- open question whether it's worth
adding on top, not decided).

**New idea raised alongside this, also not started:** XRoar's own
built-in "Hardware" tab (in its native menu bar -- Software | File |
View | Hardware | Help) offers a limited, fixed selection of machine
configs. Once this custom system exists with its own more flexible,
user-definable list, consider hiding or replacing that native tab
entirely, since it would be redundant with (and more limited than) the
custom system.
