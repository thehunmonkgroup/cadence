---
name: rails-coding
description: "Apply Rails and Ruby best practices and Cadence conventions when implementing, reviewing, or refactoring application code, tests, or architecture."
---

# Rails Coding

Prefer conventional Rails code with explicit business rules and clear ownership
of persistence, authorization, and side effects. Use the repository's configured
Ruby/Rails versions and nearby implementation patterns.

## Guidance by task

Read only the references relevant to the change:

- [Ruby and Rails practices](references/rails-ruby-practices.md): models, queries,
  controllers, transactions, jobs, and integrations.
- [Cadence conventions](references/project-architecture.md): Pundit authorization,
  scheduling and time semantics, background jobs, and frontend patterns.
- [Style and RuboCop](references/project-style-and-rubocop.md): style changes,
  lint findings, and autocorrection.
- [Testing](references/testing.md): test selection and the admission standard for
  every individual test change. Apply the per-test procedure in `AGENTS.md`.

Repository workflow rules live in `AGENTS.md`; setup and check commands live in
`DEVELOPMENT.md`.
