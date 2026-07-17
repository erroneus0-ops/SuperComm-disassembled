# Current Python translation of lw_expr_simplify_l
# cocotools/lw_expr.py
#
# Implemented as two cooperating methods on the Expr class rather than as
# two free functions, matching this codebase's OO style for the expression
# tree (see cocotools/lw_expr.py module docstring's C->Python mapping table):
#
#   lw_expr_simplify_l(E, priv)   -> Expr._simplify_l(self, ctx)
#   lw_expr_simplify_go(E, priv)  -> Expr._simplify_go(self, ctx)
#
# (The public entry point a caller actually uses is Expr.simplify(ctx),
# corresponding to lw_expr_simplify(), which resets the anti-recursion
# counters and then calls _simplify_l.)
#
# Status as of this audit: fully translated and verified against a
# from-source build of lwtools-4.24 (both the real `lwasm` binary, via the
# existing fidelity harness, and a standalone C probe linked directly
# against liblw.a for expression-tree-level ground truth). See
# checklist.md in this directory for the full pre-translation checklist,
# the three real bugs found and fixed, and the verification method.
#
# Bugs found and fixed during this audit (see checklist.md for detail):
#   1. OPER_COM (~) was incorrectly masked to 16 bits; source.c applies
#      no mask to plain COM (only COM8 masks to 8 bits).
#   2. lw_expr_simplify_sortconstfirst was called by source.c but was
#      never implemented in this codebase at all.
#   3. Like-term collection (_is_like_term/_coef_of/_base_of) used a
#      "single base expression" model that silently dropped factors from
#      multi-factor terms, e.g. `2*X*Y + 3*X*Y` collapsed to `X*5`
#      instead of `5*X*Y`.
#   4. The PLUS-node collapse-to-single/collapse-to-zero logic ran too
#      early (right after integer-term collection) instead of after
#      sort-const-first and like-term collection, per source.c's actual
#      block order; and the TIMES int*(a+b) distribution block was
#      likewise out of order (it must run last).
#
# New regression tests: cocotools/test_fidelity.py, EXPRESSION_SIMPLIFY_TESTS
# (8 cases), run via run_expression_simplify_tests(). Full harness:
# 166 + 27 + 18 + 8 = 219 tests, all passing.
