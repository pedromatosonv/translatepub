# Agents Guide

This document explains how to work on this repository as an AI coding agent using Codex CLI. It covers the repository purpose, common workflows, environment and tooling, and contribution guidelines tailored for agents.

## Purpose

Translate unzipped EPUB HTML files using a local `gemini` CLI and a prompt. Two scripts drive translations and a Makefile orchestrates the workflow.

## Repository Overview

- Scripts
  - `translate-from-directory.sh`: Translates every `text/*.html` into `translated/` using `TRANSLATOR_PROMPT`.
  - `translate-from-list.sh`: Translates a curated list of files into `translated/` and passes `-m $MODEL` to `gemini`.
- Prompts
  - `prompts/v2.md` (default), `prompts/v1.md` (older variant).
- Environment
  - `.env`: Real values (not for committing secrets). Loaded automatically by Makefile.
  - `.env.example`: Template for local setup.
- Orchestration
  - `Makefile`: Provides `help`, `env`, `unzip`, `translate-dir`, `translate-list`, `translate-epub`, `clean`.

## Environment Variables

- `MODEL`: Model name for the `gemini` CLI (default: `gemini-2.5-pro`).
- `TRANSLATOR_PROMPT`: Path to the prompt file (default: `prompts/v2.md`).
- Optional for workflows (not required by scripts):
  - `EPUB`: Path to an input `.epub` file.
  - `WORKDIR`: Directory where the EPUB is unzipped and translations run.
- Secrets: If the `gemini` CLI requires an API key, set `GEMINI_API_KEY` (do not commit real keys).

## Dependencies

- `gemini` CLI available on PATH (and authenticated if needed).
- `unzip` for extracting EPUBs.
- Standard Unix shell utilities.

## Common Workflows

1) Quick environment check
- `cp .env.example .env` (edit values as needed)
- `make env` to confirm what will be used

2) Unzip and translate a new EPUB
- `make translate-epub EPUB=path/to/book.epub WORKDIR=work`
  - Runs `unzip` into `work/`, then translates `work/text/*.html` into `work/translated/`.

3) Translate an already-unzipped directory
- `make translate-dir WORKDIR=work`

4) Translate a custom file list
- Edit `translate-from-list.sh` to populate `FILES_LIST=( ... )`
- `make translate-list WORKDIR=work`

Notes
- The Makefile resolves `TRANSLATOR_PROMPT` to an absolute path so running inside `WORKDIR` still finds the prompt in the repo.
- `translate-from-directory.sh` currently does not pass `-m "$MODEL"`. If needed, update the script or rely on the CLI default model.

## Agent Operating Guidelines

- Scope & Changes
  - Make focused, minimal changes aligned with a user request.
  - Fix root causes rather than adding superficial patches.
  - Do not introduce unrelated refactors or features without explicit instruction.
  - Keep changes consistent with the existing style and patterns.

- Files & Secrets
  - Prefer editing existing scripts and Makefile over introducing new tools.
  - Do not add license headers unless requested.
  - Never commit real secrets. Use `.env.example` for documentation.

- Code Quality
  - Avoid one-letter variable names in new code.
  - Add brief, targeted documentation when behavior changes.
  - Do not add formatters or unrelated CI unless asked.

- Testing & Verification
  - Run specific commands to validate the exact behavior you changed (e.g., `make translate-dir`).
  - Do not attempt to fix unrelated broken tests or workflows.
  - Where applicable, keep verification steps small and local to the change.

- Tooling in Codex CLI
  - Planning: Use the plan tool for multi-step or ambiguous tasks; keep plans short, ordered, and with one step in progress.
  - Shell: Prefer fast search tools if available; read files in small chunks; avoid long, noisy commands.
  - Patches: Use `apply_patch` to create or modify files. Do not use other patch tools.
  - Approvals/Sandbox: Ask for elevated permissions only when necessary; otherwise work within the workspace sandbox.

## Extension Ideas (When Asked)

- Add a `check` target to verify `gemini`, `unzip`, env, and prompt paths.
- Add a `DRY_RUN` option that prints commands instead of executing them.
- Add a `MODEL` flag to `translate-from-directory.sh` for symmetry with the list script.
- Add a `postprocess` script for cleaning HTML or merging outputs back into an EPUB.

## Troubleshooting

- `gemini: command not found`: Ensure the CLI is installed and on PATH.
- Authentication errors: Set `GEMINI_API_KEY` or follow the CLI’s login steps.
- No files translated: Verify `WORKDIR/text/` contains `.html` files, and the prompt path is correct.

---

For questions or to propose larger changes, outline a short plan and request confirmation before proceeding.

