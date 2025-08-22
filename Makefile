# Makefile to streamline translation workflow
#
# Usage examples:
#   make env
#   make unzip EPUB=book.epub WORKDIR=work
#   make translate-dir WORKDIR=work
#   make translate-list WORKDIR=work
#   make translate-epub EPUB=book.epub WORKDIR=work   # unzip + directory translation

.PHONY: help env unzip translate-dir translate-list translate-epub clean

# Load environment variables from .env if present
-include .env
export MODEL
export TRANSLATOR_PROMPT

SHELL := /bin/bash
REPO_ROOT := $(CURDIR)
PROMPT_ABS := $(abspath $(TRANSLATOR_PROMPT))

help:
	@echo "Targets:"
	@echo "  env               - Show effective environment variables"
	@echo "  unzip             - Unzip EPUB into WORKDIR (EPUB, WORKDIR required)"
	@echo "  translate-dir     - Run translate-from-directory.sh (optionally in WORKDIR)"
	@echo "  translate-list    - Run translate-from-list.sh (optionally in WORKDIR)"
	@echo "  translate-epub    - Unzip then translate-dir (EPUB, WORKDIR required)"
	@echo ""
	@echo "Variables:"
	@echo "  MODEL             - Model name (from .env or env)"
	@echo "  TRANSLATOR_PROMPT - Path to prompt file (from .env or env)"
	@echo "  EPUB              - Path to .epub for unzip-related targets"
	@echo "  WORKDIR           - Directory to unzip/run inside (e.g., work)"

env:
	@echo "MODEL=$(MODEL)"
	@echo "TRANSLATOR_PROMPT=$(TRANSLATOR_PROMPT)"
	@echo "EPUB=$(EPUB)"
	@echo "WORKDIR=$(WORKDIR)"

unzip:
	@test -n "$(EPUB)" || (echo "EPUB not set. Usage: make unzip EPUB=book.epub WORKDIR=work" && exit 1)
	@test -n "$(WORKDIR)" || (echo "WORKDIR not set. Usage: make unzip EPUB=book.epub WORKDIR=work" && exit 1)
	@mkdir -p "$(WORKDIR)"
	@echo "Unzipping $(EPUB) -> $(WORKDIR)"
	@unzip -o "$(EPUB)" -d "$(WORKDIR)"

translate-dir:
	@echo "Translating directory with MODEL=$(MODEL), PROMPT=$(TRANSLATOR_PROMPT)"
	@if [ -n "$(WORKDIR)" ]; then \
	  echo "Running in $(WORKDIR)"; \
	  cd "$(WORKDIR)" && TRANSLATOR_PROMPT="$(PROMPT_ABS)" "$(REPO_ROOT)/translate-from-directory.sh"; \
	else \
	  TRANSLATOR_PROMPT="$(PROMPT_ABS)" "$(REPO_ROOT)/translate-from-directory.sh"; \
	fi

translate-list:
	@echo "Translating list with MODEL=$(MODEL), PROMPT=$(TRANSLATOR_PROMPT)"
	@if [ -n "$(WORKDIR)" ]; then \
	  echo "Running in $(WORKDIR)"; \
	  cd "$(WORKDIR)" && TRANSLATOR_PROMPT="$(PROMPT_ABS)" "$(REPO_ROOT)/translate-from-list.sh"; \
	else \
	  TRANSLATOR_PROMPT="$(PROMPT_ABS)" "$(REPO_ROOT)/translate-from-list.sh"; \
	fi

translate-epub: unzip
	@$(MAKE) translate-dir WORKDIR="$(WORKDIR)"

clean:
	@echo "Nothing to clean in repo root. Remove WORKDIR manually if desired: $(WORKDIR)"
