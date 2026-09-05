# Set up and run in a minimal virtual environment with the following:
# python3 -m venv .venv
# ./.venv/bin/python -m pip install --quiet --upgrade pip sympy
# ./.venv/bin/python solve.py
import sympy as sp
sp.init_printing()
x1, x2, x3 = sp.symbols("x1 x2 x3")
A = sp.Matrix([[1, 3, 4], [3, 9, 7]])
a = sp.Matrix([7, 6])
solution = sp.linsolve((A, a), x1, x2, x3)
print("General solution:")
sp.pprint(solution, use_unicode=True)
# {(-3*x2 - 5, x2, 3)}
print()
print("Reduced Row Echelon Form:")
sp.pprint(A.row_join(a).rref()[0], use_unicode=True) # don't print the pivot positions
# Matrix([
# [1, 3, 0, -5],
# [0, 0, 1,  3]])
