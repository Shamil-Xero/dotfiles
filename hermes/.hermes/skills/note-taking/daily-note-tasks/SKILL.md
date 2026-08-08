---
name: daily-note-tasks
description: "Extract tasks and journal info from Obsidian daily notes."
version: 1.0.0
author: Hermes + User Workflow
tags: [notes, journal, obsidian, tasks, habits]
---

# Daily Note Tasks Extraction

Read user's Obsidian daily notes to extract pending tasks, completed items, and habit tracking for a given date.

## Trigger

When the user asks to:
- "List my tasks for today"
- "What did I work on?"
- "Show me my journal entries"
- "What habits do I need to track?"

## Workflow

1. **Determine the target date**: 
   - If no date specified, assume current session date (e.g., 2026-07-25)
   - Accept user-provided filenames/dates: `2026-07-25 Sat.md`, `YYYY-MM-DD ddd.md`

2. **Search for journal files**:
   - Look in `/mnt/d/RAM/Journal/YYYY/MM/` (Arch Linux/D drive mount)
   - Search for files matching the date pattern, including space-prefixed: `YYYY-MM-DD ddd.md`
   - Also check `.md` files without explicit extension

3. **Parse the daily note structure**:
   
   Standard sections to extract:
   ```markdown
   ## Tasks
   - [ ] pending task
   - [x] completed task
   
   ## Habits
   - [ ] habit name
   
   ## Post-Mortem
   Win of the Day:: 
   ```

4. **Handle different formats**:
   - Tasks plugin completion format: `[x]` / `[ ]`
   - Check wikilink dates in notes for cross-reference
   - Look for Urgent/Not Urgent/Side categorization if present (from `/mnt/d/RAM/Tasks.md`)

5. **Output format**:
   ```text
   Based on your journal file, here are today's tasks:
   
   ## Completed:
   - [x] task 1
   
   ## Pending Tasks:
   - [ ] task 2
   - [ ] task 3
   
   ## Habits to Track:
   - [ ] Habit 1
   ```

## Known Locations

Arch Linux (D drive mount):
- Main journal: `/mnt/d/RAM/Journal/2026/07/2026-07-25 Sat.md`
- Alternative format: `/mnt/d/RAM/Journal/YYYY/YYYY-MM-DD ddd.md`
- Master task list: `/mnt/d/RAM/Tasks.md`

## Pitfalls

⚠️ **File location matters** - Daily notes are NOT in the default Obsidian vault path. They're stored at `/mnt/d/RAM/Journal/`. Do not search the home directory or use standard Obsidian paths.

⚠️ **Date format variations**: Files can be:
- `2026-07-25 Sat.md` (YYYY-MM-DD ddd.md)
- `2026-07-25 Saturday.md` (YYYY-MM-DD dddd.md)

⚠️ **Spaces in filenames**: The format includes a space before the date: `/mnt/d/RAM/Journal/YYYY/MM/ YYYY-MM-DD ddd.md` - include this when searching.

⚠️ **Today's note may have different name** - Always check recent journal files if the expected file is missing or empty.

## References

See `references/obsidian-daily-notes-format.md` for documented note structure examples.

See `references/task-completion-formats.md` for parsing completion markers.
