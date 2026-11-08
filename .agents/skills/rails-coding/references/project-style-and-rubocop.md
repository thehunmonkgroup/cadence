# Style and RuboCop

Use `.rubocop.yml` as the source of truth for style, enabled plugins, and limits.

- Prefer readable Rails code over clever Ruby or compression to satisfy metrics.
- Run RuboCop on touched Ruby files. Handle unrelated offenses according to
  `AGENTS.md`.
- Review autocorrections for semantic changes, especially range boundaries,
  timezones, nil handling, regex captures, escaping, and association ownership.
- Use narrow local disables with an explanation when a rule obscures necessary
  logic. Preserve comments explaining business rules or fragile behavior.

Documentation-only changes do not require application lint or tests.
