---
name: obsidian-tasks
description: Manage and query tasks in an Obsidian vault with daily notes, Tasks.md, and pending_tasks.md.
platforms: [linux, macos, windows]
category: note-taking
---

# Obsidian Tasks Management

User maintains tasks in TWO parallel locations — handle both when querying for "today's remaining tasks":

## Task sources

1. **Daily note tasks** (`Journal/<YYYY>/<MM>/<YYYY-MM-DD> <Www>.md`)
   - Bullet checkboxes under `## Tasks` section
   - User tracks habits and work items directly in daily notes
   
2. **Separate Tasks.md file** (`/mnt/d/RAM/Tasks.md`)
   - Categorized as: Urgent (Full, Side) and Not Urgent (Full, Side)
   - Plus a "Completed" section
   - User manually or semi-automatically moves completed items here
   
3. **Pending tasks backlog** (`Journal/pending_tasks.md`)
   - All historical uncompleted tasks from Journal entries
   - Organized by month (Jan 2026 – Jul 2026 in current data)

## Workflow for "remaining tasks today"

1. Resolve today's date via `terminal` (`date +%Y`, `date +%m`, `date +'%Y-%m-%d %a'`)
2. Build daily note path using the vault pattern
3. Check daily note's `## Tasks` section first
4. If empty or missing, check `/mnt/d/RAM/Tasks.md` for Not Urgent/Full items
5. For complete backlog view, read `Journal/pending_tasks.md`

## Pitfalls

- Never guess today's date from memory — always resolve from system time
- Check BOTH task sources; daily note may be empty while Tasks.md has items
- Old backlog tasks in pending_tasks.md are historical context, not necessarily "today's" tasks
- Wikilinks in filenames like `[[2026-07-24 Fri|next-day>>]]` help navigate but date format can vary by locale

## References

- Main vault path: `/mnt/d/RAM/` (or `$OBSIDIAN_VAULT_PATH` env var)
- Journal subfolder: `Journal/<YYYY>/<MM>/`
- Tasks.md: `/mnt/d/RAM/Tasks.md` (fallback file)
- Pending tasks: `Journal/pending_tasks.md`
