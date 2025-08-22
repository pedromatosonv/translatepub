# TranslatePub

**TranslatePub turns EPUBs into translated chapter HTMLs using your `gemini` CLI and a reusable prompt — optimized for fast, repeatable book translation workflows.**

Bring your own EPUB, choose a prompt, and run a single Make target to unzip, batch-translate `text/*.html`, and save clean, parallel outputs to `translated/`. TranslatePub favors practicality: predictable file mapping, minimal setup, and scripts you can tweak to fit your workflow or LLM preferences.

## Features

- **Prompt-driven translations**: Central prompt file (editable) applied consistently across chapters.
- **One-shot workflow**: `make translate-epub` unzips and translates in a single step.
- **Directory or curated lists**: Translate all `text/*.html` or only specific files.
- **Predictable outputs**: Preserves basenames; writes to `translated/` alongside sources.
- **Minimal setup**: `.env` + `gemini` CLI; no heavy runtime or dependencies.

## Requirements

- `gemini` CLI available on PATH (authenticated if required).
- `unzip` utility.
- `bash` and `make`.

## Setup

- Copy the example env and adjust values:
  - `cp .env.example .env`
- Verify your `gemini` CLI works (e.g., login or set `GEMINI_API_KEY`).
- Inspect or edit the prompt at `prompts/v2.md` (default).

## Usage

- Show effective environment:
  - `make env`

- One-shot: unzip then translate all `text/*.html`:
  - `make translate-epub EPUB=path/to/book.epub WORKDIR=work`
  - Unzips into `work/` and writes outputs to `work/translated/`.

- Translate an existing unzipped directory:
  - `make translate-dir WORKDIR=work`

- Translate a custom list of files:
  - Edit `translate-from-list.sh` to populate `FILES_LIST=( ... )`
  - `make translate-list WORKDIR=work`

- Unzip only:
  - `make unzip EPUB=path/to/book.epub WORKDIR=work`

Notes
- The Makefile resolves `TRANSLATOR_PROMPT` to an absolute path so it works even when running inside `WORKDIR`.
- `translate-from-directory.sh` translates every `text/*.html` and writes to `translated/`.
- `translate-from-list.sh` passes `-m $MODEL` to `gemini`; the directory script relies on your CLI default unless you modify it.

## Environment Variables

- `MODEL`: Model for `gemini` (default in `.env.example`: `gemini-2.5-pro`).
- `TRANSLATOR_PROMPT`: Path to the translation prompt (default: `prompts/v2.md`).
- Optional convenience for Makefile targets:
  - `EPUB`: Input `.epub` path.
  - `WORKDIR`: Working directory used for unzip/translation.
- If needed by your CLI: `GEMINI_API_KEY`.

## Repository Layout

- `translate-from-directory.sh` — Translate all `text/*.html` to `translated/`.
- `translate-from-list.sh` — Translate a curated list, passes `-m $MODEL`.
- `prompts/` — Prompt templates (default: `v2.md`).
- `Makefile` — Targets: `help`, `env`, `unzip`, `translate-dir`, `translate-list`, `translate-epub`.
- `.env.example` — Template for `.env`.

## Troubleshooting

- `gemini: command not found`: Install the CLI and ensure it’s on PATH.
- Authentication errors: Set `GEMINI_API_KEY` or run the CLI’s login.
- No outputs: Ensure `WORKDIR/text/` contains `.html` files and the prompt path is valid.

## Contributing

Changes should be minimal and focused. Avoid unrelated refactors. Do not commit real secrets; use `.env.example` to document variables.
