#Modified by: Fernando Nunez Sanchez, Santiago Suarez Carrera.

import sys

lineas = list(sys.stdin)
total_de_filas = len(lineas)

for i, line in enumerate(lineas):
    j = total_de_filas - i - 1
    for k, c in enumerate(line.strip()):
        if c in ['x', 'b', '0', '1', '2', '3', '4']:
            print(f"cell({k},{j},{c}).")

print(f"dim({total_de_filas}).")
print(f"#const n={total_de_filas}.")