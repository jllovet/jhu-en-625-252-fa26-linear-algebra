.PHONY: build build-image clean watch format lint help

# Default target
help:
	@echo "LaTeX Docker Build Commands:"
	@echo "  make build-image  - Build the Docker image (run once)"
	@echo "  make build FILE=path/to/file.tex  - Compile a .tex file"
	@echo "  make watch FILE=path/to/file.tex  - Watch and rebuild on changes"
	@echo "  make format FILE=path/to/file.tex - Format a .tex file"
	@echo "  make lint FILE=path/to/file.tex   - Lint a .tex file"
	@echo "  make clean        - Remove auxiliary files"
	@echo ""
	@echo "Example:"
	@echo "  make build FILE=assignment-0/assignment-0.tex"

# Build the Docker image
build-image:
	docker compose build

# Compile a specific .tex file
build:
ifndef FILE
	$(error FILE is required. Usage: make build FILE=path/to/file.tex)
endif
	docker compose run --rm latex latexmk -pdf -interaction=nonstopmode -file-line-error $(FILE)

# Watch for changes and rebuild
watch:
ifndef FILE
	$(error FILE is required. Usage: make watch FILE=path/to/file.tex)
endif
	docker compose run --rm latex latexmk -pdf -interaction=nonstopmode -file-line-error -pvc -view=none $(FILE)

# Format a .tex file
format:
ifndef FILE
	$(error FILE is required. Usage: make format FILE=path/to/file.tex)
endif
	docker compose run --rm latex latexindent -w $(FILE)

# Lint a .tex file
lint:
ifndef FILE
	$(error FILE is required. Usage: make lint FILE=path/to/file.tex)
endif
	docker compose run --rm latex chktex -wall -n22 -n30 -q $(FILE)

# Clean auxiliary files
clean:
	find . -type f \( \
		-name "*.aux" -o \
		-name "*.bbl" -o \
		-name "*.blg" -o \
		-name "*.log" -o \
		-name "*.out" -o \
		-name "*.toc" -o \
		-name "*.lof" -o \
		-name "*.lot" -o \
		-name "*.fls" -o \
		-name "*.fdb_latexmk" -o \
		-name "*.synctex.gz" -o \
		-name "*.nav" -o \
		-name "*.snm" \
	\) -delete
