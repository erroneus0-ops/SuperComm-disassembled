# Current Python translation of insn_parse_tfm
# cocotools/insn_funcs.py
#
# Updated 2026-07-18: added the two `_skip_to_next_token(cl, p)` calls that
# were missing from this file (see SUMMARY.md / checklist.md for the full
# writeup). Everything else is unchanged from the version audited.

_TFM_REGLIST = "DXYUS   AB  00EF"

def _tfm_reg(p):
    c = p.peek()
    if not c:
        return None
    idx = _TFM_REGLIST.find(c.upper())
    if idx < 0:
        return None
    p.advance()
    return idx

def insn_parse_tfm(as_, cl, operand):
    p = Ptr(operand)
    ops = _ops(cl)
    tfm = 0

    r0 = _tfm_reg(p)
    if r0 is None:
        as_.register_error(cl, E_REGISTER_BAD); return p.remaining()

    if p.peek() == '+':
        p.advance(); tfm = 1
    elif p.peek() == '-':
        p.advance(); tfm = 2

    _skip_to_next_token(cl, p)
    if p.peek() != ',':
        as_.register_error(cl, E_UNKNOWN_OPERATION); return p.remaining()
    p.advance()

    _skip_to_next_token(cl, p)
    r1 = _tfm_reg(p)
    if r1 is None:
        as_.register_error(cl, E_REGISTER_BAD); return p.remaining()

    if p.peek() == '+':
        p.advance(); tfm |= 4
    elif p.peek() == '-':
        p.advance(); tfm |= 8

    if p.peek() and not p.peek().isspace():
        as_.register_error(cl, E_OPERAND_BAD); return p.remaining()

    if r0 > 4 or r1 > 4:
        bad = r1 if r0 < r1 else r0
        as_.register_error2(cl, E_REGISTER_BAD, "'%c'", _TFM_REGLIST[bad])

    if tfm == 5:
        cl.lint = ops[0]
    elif tfm == 10:
        cl.lint = ops[1]
    elif tfm == 1:
        cl.lint = ops[2]
    elif tfm == 4:
        cl.lint = ops[3]
    else:
        as_.register_error(cl, E_UNKNOWN_OPERATION); return p.remaining()

    cl.pb  = (r0 << 4) | r1
    cl.len = _oplen(cl.lint) + 1
    return p.remaining()
