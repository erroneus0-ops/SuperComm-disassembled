# Current Python translation of lw_expr_simplify_l
# cocotools/lw_expr.py

    def _simplify_l(self, ctx):
        """
        lw_expr_simplify_l(E, priv):
        Iterates _simplify_go until the expression stops changing.
        Bails out at recursion depth >= 500.
        """
        ctx._level += 1
        if ctx._level >= 500 or ctx._bailing:
            ctx._bailing = True
            ctx._level  -= 1
            if ctx._level == 0:
                ctx._bailing = False
            return
        # Iterate until stable (copy -> simplify -> compare)
        while True:
            before = self.copy()
            self._simplify_go(ctx)
            if self == before:
                break
        ctx._level -= 1

