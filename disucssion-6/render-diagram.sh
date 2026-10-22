#!/usr/bin/env bash
# Render a Graphviz .dot file with LaTeX labels (texlbl) via dot2tex.
#
# Usage: ./render-diagram.sh [file.dot]   (default: invertible-matrix-theorem.dot)
#
# Produces:
#   <name>-figure.tex  bare tikzpicture, for \input{} into another document
#   <name>.pdf         compiled diagram
#   <name>.png         PNG of the compiled diagram (300 dpi)
#
# Requires: graphviz (dot), dot2tex (pipx install dot2tex), pdflatex,
#           pdftoppm (brew install poppler)
set -euo pipefail

# pipx installs into ~/.local/bin, which may not be on PATH
export PATH="$HOME/.local/bin:$PATH"

cd "$(dirname "$0")"

src="${1:-invertible-matrix-theorem.dot}"
name="${src%.dot}"

for cmd in dot dot2tex pdflatex pdftoppm; do
    command -v "$cmd" >/dev/null || { echo "error: $cmd not found" >&2; exit 1; }
done

# -traw:      pass texlbl through to LaTeX unescaped
# --autosize: size nodes to the typeset labels rather than the plain-text ones
dot2tex --autosize -ftikz -traw "$src" > "$name.tex"
dot2tex --autosize -ftikz -traw --figonly "$src" > "$name-figure.tex"

# dot2tex exits 0 even when it crashes, so check that it actually produced TikZ.
# (If it crashed in pyparsing: pipx runpip dot2tex install 'pyparsing<3.1')
grep -q tikzpicture "$name-figure.tex" \
    || { echo "error: dot2tex produced no output" >&2; exit 1; }

pdflatex -interaction=nonstopmode -halt-on-error "$name.tex" >/dev/null \
    || { echo "error: pdflatex failed, see $name.log" >&2; exit 1; }

pdftoppm -png -r 300 -singlefile "$name.pdf" "$name"

# Remove intermediates (kept on failure above, so the .log is there to debug)
rm -f "$name.tex" "$name.aux" "$name.log" "$name-figure.tex"

echo "Wrote $name-figure.tex, $name.pdf, $name.png"
