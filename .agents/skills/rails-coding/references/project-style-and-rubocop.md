# Project Style And RuboCop

Read `.rubocop.yml` when it exists before changing style, lint configuration, or generated code. Do not assume plugins, target versions, line lengths, or metric exceptions that have not been configured for Cadence.

## Required Workflow

- After code changes, run `bundle exec rubocop` when the bundle and RuboCop are available; fix offenses until the check passes.
- If tooling is not configured, report the limitation. Documentation-only work does not require application lint or tests.
- Do not use `rubocop -A` as a substitute for review. Autocorrections can change semantics.
- For intentionally delicate logic, prefer a narrow local disable with a comment explaining why.

## Style Guidance

- Prefer readable Rails code over clever Ruby.
- Preserve comments explaining business rules and fragile behavior.
- Do not compress delicate code solely to reduce line count or appease metrics.
- Use structured APIs and Rails helpers instead of ad hoc string manipulation.
- Preserve file/path to constant mapping for Zeitwerk.
- Follow established local conventions for tests, helpers, and services when present.

## Autocorrect Review

Check inclusive versus exclusive range boundaries, business timezone behavior, nil handling, regex captures, HTML sanitization, and association ownership before accepting an autocorrection that touches those concerns. Active Record endless ranges include their lower bound.
