# Current Python translation of insn_resolve_indexed_aux
# cocotools/insn_funcs.py, lines 860-1025 (module-private: _insn_resolve_indexed_aux)
#
# STATUS AS OF 2026-07-17 AUDIT (this package): AUDITED, FAITHFUL.
#
# This file previously read "insn_resolve_indexed_aux not yet located in
# cocotools/insn_funcs.py" -- that was stale. The function was already
# present, added the same day as glue required by package 02's faithful
# insn_parse_indexed_aux (see the function's own header comment below for
# why). This package's job was to run the full independent audit that
# header comment called for. Result: the function's internal branch logic
# is a correct, line-for-line match of source.c (insn_indexed.c lines
# 480-750) -- no bugs found inside this function.
#
# However, the audit did find and fix one bug in a directly adjacent area:
# cocotools/lwasm_core.py's AsmState.__init__ was missing the
# PRAGMA_FORWARDREFMAX default that real lwasm sets in main.c. Without it,
# forward-referenced indexed operands resolved to their minimal encoding
# once the referenced value became known, instead of staying locked at the
# worst-case (16-bit) encoding decided when the value was still unknown --
# which is what real lwasm actually does. See SUMMARY.md for full detail,
# reproduction, and verification against the lwasm 4.24 reference binary.

# ---------------------------------------------------------------------------
# FUNCTION: insn_resolve_indexed_aux  (module-private: _insn_resolve_indexed_aux)
# SOURCE:   lwtools-4.24/lwasm/insn_indexed.c lines 479-707 (approx.)
# TRANSLATED / RE-TRANSLATED: 2026-07-17
#
# Not the primary subject of this translation package (that is package
# 03), but re-translated here as required glue: this is the *only*
# consumer of the "undetermined offset" marker byte that the newly
# faithful insn_parse_indexed_aux (above) writes into cl.pb, and the
# marker's bit layout changed as a direct result of that translation
# (register field now unshifted in bits 0-2, indirect at bit 7, explicit
# "f0" zero-offset flag at bit 6 -- see insn_parse_indexed_aux's header
# comment). The previous hand-rolled resolve helper decoded a different,
# incompatible layout (register pre-shifted into bits 5-6, indirect at
# bit 4) that matched the previous hand-rolled parse helper. Plugging in
# a faithful parser without also fixing this decoder would silently
# corrupt every forward-referenced indexed operand. A full line-by-line
# audit of this function (matching package 02's process: checklist,
# independent translation, comparison, tests) is still recommended as
# follow-up under package 03 -- this translation is a faithful, complete
# transliteration of the C but has not been through that separate audit
# process.
# ---------------------------------------------------------------------------

def _insn_resolve_indexed_aux(as_, cl, force, elen=0):
    """Faithful translation of insn_resolve_indexed_aux (insn_indexed.c)."""
    if cl.len != -1:
        return

    e = cl.fetch_expr(0)

    if not (e and e.istype(TYPE_INT)):
        # temporarily set the instruction length to see if we get a
        # constant for our expression; if so, we can select an
        # instruction size
        e2 = e.copy() if e else None
        ops = _ops(cl)
        cl.len = _oplen(ops[0]) + elen + 2
        if e2 is not None:
            as_.reduce_expr(e2)
        cl.len = -1

        regfield = cl.pb & 0x07
        indir    = cl.pb & 0x80
        f0       = cl.pb & 0x40

        if e2 is not None and e2.istype(TYPE_INT):
            v = e2.intval()
            if v == 0 and not curpragma(cl, PRAGMA_NOINDEX0TONONE) and regfield <= 4:
                if regfield < 4:
                    pb = 0x84 | ((cl.pb & 0x03) << 5) | (0x10 if indir else 0)
                else:
                    pb = 0x90 if indir else 0x8F
                cl.pb   = pb
                cl.lint = 0
                return
            elif v < -128 or v > 127:
                cl.lint = 2
                if regfield in (0, 1, 2, 3):
                    pb = 0x89 | ((cl.pb & 0x03) << 5) | (0x10 if indir else 0)
                elif regfield == 4:
                    pb = 0xB0 if indir else 0xAF
                else:
                    pb = 0x9D if indir else 0x8D
                cl.pb = pb
                return
            elif indir or regfield > 3 or v < -16 or v > 15:
                cl.lint = 1
                if regfield in (0, 1, 2, 3):
                    pb = 0x88 | ((cl.pb & 0x03) << 5) | (0x10 if indir else 0)
                elif regfield == 4:
                    if v == 0 and not (curpragma(cl, PRAGMA_NOINDEX0TONONE) or f0):
                        pb = 0x90 if indir else 0x8F
                        cl.lint = 0
                    else:
                        pb = 0xB0 if indir else 0xAF
                        cl.lint = 2
                else:
                    pb = 0x9C if indir else 0x8C
                cl.pb = pb
                return
            else:
                cl.lint = 0
                if v == 0 and not (curpragma(cl, PRAGMA_NOINDEX0TONONE) or f0):
                    pb = ((cl.pb & 0x03) << 5) | 0x84
                else:
                    pb = ((cl.pb & 0x03) << 5) | (v & 0x1F)
                cl.pb = pb
                return
        else:
            if regfield in (5, 6):
                # heuristic fudge-factor pass; see C comment
                saved = as_.pretendmax
                as_.pretendmax = 1
                if e2 is not None:
                    as_.reduce_expr(e2)
                as_.pretendmax = saved
                if e2 is not None and e2.istype(TYPE_INT):
                    v = e2.intval()
                    if -100 <= v <= 100:
                        cl.lint = 1
                        cl.pb   = 0x9C if indir else 0x8C
                        return
        # falls through to the main branch below, exactly as C does

    if e and e.istype(TYPE_INT):
        v = e.intval()
        regfield = cl.pb & 0x07
        indir    = cl.pb & 0x80
        f0       = cl.pb & 0x40

        if v == 0 and not curpragma(cl, PRAGMA_NOINDEX0TONONE) and regfield <= 4 and f0 == 0:
            if regfield < 4:
                pb = 0x84 | ((cl.pb & 0x03) << 5) | (0x10 if indir else 0)
            else:
                pb = 0x90 if indir else 0x8F
            cl.pb   = pb
            cl.lint = 0
            return
        elif v < -128 or v > 127:
            cl.lint = 2
            if regfield in (0, 1, 2, 3):
                pb = 0x89 | ((cl.pb & 0x03) << 5) | (0x10 if indir else 0)
            elif regfield == 4:
                pb = 0xB0 if indir else 0xAF
            else:
                pb = 0x9D if indir else 0x8D
            cl.pb = pb
            return
        elif indir or regfield > 3 or v < -16 or v > 15:
            cl.lint = 1
            if regfield in (0, 1, 2, 3):
                pb = 0x88 | ((cl.pb & 0x03) << 5) | (0x10 if indir else 0)
            elif regfield == 4:
                if v == 0 and not (curpragma(cl, PRAGMA_NOINDEX0TONONE) or f0):
                    pb = 0x90 if indir else 0x8F
                    cl.lint = 0
                else:
                    pb = 0xB0 if indir else 0xAF
                    cl.lint = 2
            else:
                pb = 0x9C if indir else 0x8C
            cl.pb = pb
            return
        else:
            cl.lint = 0
            if v == 0 and not (curpragma(cl, PRAGMA_NOINDEX0TONONE) or f0):
                pb = ((cl.pb & 0x03) << 5) | 0x84
            else:
                pb = ((cl.pb & 0x03) << 5) | (v & 0x1F)
            cl.pb = pb
            return
    else:
        if not force:
            return
        cl.lint  = 2
        regfield = cl.pb & 0x07
        indir    = cl.pb & 0x80
        if regfield in (0, 1, 2, 3):
            pb = 0x89 | ((cl.pb & 0x03) << 5) | (0x10 if indir else 0)
        elif regfield == 4:
            pb = 0xB0 if indir else 0xAF
        else:
            pb = 0x9D if indir else 0x8D
        cl.pb = pb
        return

