FROM texlive/texlive:latest

# The texlive/texlive:latest image includes a full TeX Live installation
# with all packages needed for the assignment template (amsmath, tikz, etc.)

# Install Noto Color Emoji font for Unicode emoji support (including flags)
RUN apt-get update && apt-get install -y --no-install-recommends \
    fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# No fixed entrypoint - allows running any TeX tool (latexmk, latexindent, chktex, etc.)
# LaTeX Workshop will specify the command directly