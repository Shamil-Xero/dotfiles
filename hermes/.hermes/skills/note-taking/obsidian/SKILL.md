---
name: obsidian
description: Read, search, create, and edit notes in the Obsidian vault.
platforms: [linux, macos, windows]
---

# Obsidian Vault

Filesystem-first Obsidian work: read, list, search, create, append, link notes.

## Vault path

Resolve before using file tools. Use `OBSIDIAN_VAULT_PATH` env var if set, else `/mnt/d/RAM/`. File tools don't expand shell vars — always pass a concrete absolute path, never `$OBSIDIAN_VAULT_PATH` literally. `terminal` is OK only to resolve the path; switch back to file tools after.

## Resolve "today"

Never guess the date from memory/training data. Before any daily-note read/write, run `terminal`:
`date +%Y` (year), `date +%m` (month), `date +'%Y-%m-%d %a'` (day+weekday).
Use these for "today"; compute offsets from them for "yesterday"/"tomorrow"/etc. Re-check if session spans midnight.

## Daily notes

Path: `Journal/<YYYY>/<MM>/<YYYY-MM-DD> <Www>.md` (e.g. `Journal/2026/07/2026-07-23 Thu.md`).

1. Resolve date (above).
2. Build path from pattern.
3. Verify with `search_files` (`target:"files"`, `pattern:"*.md"`, folder `Journal/<YYYY>/<MM>/`) — weekday format can vary by locale.
4. If missing, create using the format/frontmatter of nearby `Journal/` notes, not blank.

## Core operations

- **Read**: `read_file` (gives line numbers/pagination; better than `cat`).
- **List**: `search_files`, `target:"files"`, `pattern:"*.md"` under vault/subfolder path (better than `find`/`ls`).
- **Search content**: `search_files`, `target:"content"`, regex `pattern`, `file_glob:"*.md"`.
- **Create**: `write_file` with full content (avoids shell quoting issues).
- **Append**: `read_file` then `patch` (anchored append after a heading/before trailing block) or `write_file` (full rewrite). `terminal` OK only for simple, no-context appends.
- **Targeted edit**: `patch` when context is stable.
- **Wikilinks**: `[[Note Name]]` to link related notes.