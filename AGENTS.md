# Cadence project instructions

## Project lifecycle: greenfield

Cadence is under active design and development. Breaking changes are acceptable within the requested work. Apply this context to implementation, tests, and documentation until the developer explicitly changes this policy.

- Implement the current agreed design directly. Existing application code is a starting point, not a backward-compatibility contract.
- Add compatibility layers, deprecated interfaces, transitional behavior, or legacy data conversions only for a concrete compatibility requirement explicitly identified by the developer. Earlier iterations alone do not establish such a requirement.
- Correct the source of malformed developer-generated data. Prefer regenerating that data over supporting its obsolete shape; database reset and destructive-operation permissions still apply.
- Update affected code, tests, comments, and documentation together to describe the resulting application. Remove superseded behavior and obsolete references within the changed scope, following the test-change procedure below.
- Write maintained documentation and code comments about current behavior and its rationale. Keep change history in version control rather than explanations of what used to exist or what was removed.
- Before finishing a change, review the affected files for unnecessary compatibility handling and stale descriptions of earlier designs.

## Scope and documentation

- Use the `rails-coding` skill at `.agents/skills/rails-coding/SKILL.md` when considering changes to code or tests, including Rails architecture decisions.
- Keep the system minimal. Distinguish explicit user requirements from necessary supporting behavior, proposed defaults, and unresolved questions. Do not add features unless requested or necessary for the scheduler to operate as intended.
- Keep design documents in `docs/`.
- Write documentation prose with one source line per paragraph or list item and let editors and viewers soft-wrap it. Do not insert hard line breaks to meet an 80-column or other fixed-width limit. Apply this to all Markdown, including README, development documentation, agent instructions, and skills. Preserve line breaks needed for document structure, code blocks, and other preformatted content.
- Keep the README focused on the product's purpose, availability, and documentation links. Put setup, commands, and development workflows in `DEVELOPMENT.md`. Keep agent instructions, greenfield context, and task execution reports out of product and developer documentation.

## Hard Safety Rules

- Never stage or unstage changes unless the user explicitly asks for that exact index operation. This includes `git add`, `git restore --staged`, `git reset`, partial staging, partial unstaging, or any other command that changes what is staged.
- Treat the index as user-owned review state. Do not use the index as a scratchpad, do not "clean up" staged state, and do not assume staged changes were staged by the agent unless the agent actually ran an index-mutating command.

## Specification/Documentation Writing Requirements

These rules are mandatory when creating or editing a file whose name ends in `_spec.md`, matched case-insensitively (including `*_SPEC.md`), or any file created/edited in the `docs` directory.

- Frame requirements as direct instructions stating the intended behavior, allowed scope, authoritative source, or required outcome.
- Negation governing a list of prohibited actions or alternatives is strictly prohibited, whether the list is inline or bulleted. Express the boundary by specifying the supported behavior and its scope.
- Brief, single-action negation such as "Do not X" is allowed when it states a boundary more clearly than an affirmative instruction.
- Before finalizing, review the changed specification text and rewrite negatively framed lists as direct, bounded requirements while preserving every constraint.

## Individual Test Change Procedure

This is a per-test gate. Complete the entire procedure separately for every individual test case proposed for addition, editing, or removal. One admission analysis must never authorize changes to multiple tests. Multiple changes within one test case count as one test change. If a task would change multiple test cases, finish this procedure for one test before starting it again for the next.

For each individual test change:

1. Identify the single test case and whether it will be added, edited, or removed.
2. Read the `$rails-coding` skill's `references/testing.md` in full immediately before evaluating that test change. Its testing philosophy is authoritative and mandatory.
3. Inspect the relevant implementation and existing focused tests.
4. Before modifying the test, state this test-specific admission analysis in commentary:
   - The durable business-process or domain contract this one test protects.
   - The realistic regression this one test must catch.
   - Why existing tests are insufficient, or why removing this test will not weaken meaningful coverage.
   - The most deterministic, stable evidence that proves the same contract.
5. Do not modify the test unless every admission question has a convincing answer consistent with `references/testing.md`. Otherwise, leave that test unchanged.
6. After changing the admitted test, review that test's diff against `references/testing.md` and remove every assertion that does not directly protect its admitted contract before considering another test change.
7. Run the narrowest relevant tests first, then broader tests only when the testing philosophy calls for them. Never run system tests unless the user specifically requests them.

Running existing tests without changing test code does not require this test-admission procedure.

## Rails Workflow

- Use the $rails-coding skill for all code changes in this repository
- Inspect nearby models, controllers, services, policies, views, migrations, and tests before editing.
- Keep changes small and aligned with existing app patterns.
- Keep incremental edits reviewable in the unstaged working tree unless the user chooses otherwise. If the user has staged changes, leave that staged state alone unless the user explicitly requests a commit, staging, or unstaging.
- Do not hand-edit Rails schema dumps such as `db/schema.rb`, `db/queue_schema.rb`, or `db/cache_schema.rb`.
- Run RuboCop for touched files. If full RuboCop reports unrelated existing offenses, report them without changing unrelated files.
- The `web` container, managed by Docker Compose, can be used for live access to a Rails console for this app. If it's not available when needed, stop the task and request for the developer start it.

## Database Migration Notes

- Never use migration redo/drop/reset as a shortcut for verification without explicit approval.

## Communication

- If an accidental destructive operation occurs, stop immediately, report it clearly, and focus on recovery options before doing more work.
