---
name: rails-coding
description: "Use when considering, changing, or reviewing Rails/Ruby code, tests, or architecture in Cadence. Applies the repository's current conventions and focused verification rules to this greenfield scheduling project."
---

# Rails Coding

Cadence is a greenfield scheduling project with a Rails skeleton; product behavior is still in the application design phase. Use this skill when considering changes to code or tests, and for Rails architecture decisions. Read `AGENTS.md` first. Never stage changes unless the developer explicitly directs it.

## Default Workflow

1. Inspect before editing:
   - Read nearby implementation, tests, and relevant design documents when present.
   - Inspect `.ruby-version`, `Gemfile`, `Gemfile.lock`, and `.rubocop.yml` when present; do not assume versions, dependencies, or configuration that have not been established.
   - Check schema, migrations, and associations before changing persistence behavior.
   - Before adding, editing, or removing tests, apply `references/testing.md` and any test-change procedure actually defined in `AGENTS.md`.
2. For changes to access or visibility, identify who can perform the action, which records they can reach, and which fields they can submit or see. Read the project's authorization documentation and policies when present. Keep client information and practitioner-only notes separated.
3. Make the smallest conventional Rails change that solves the task. Distinguish proposals from approved requirements; do not add features merely because other schedulers have them.
4. Preserve established Cadence patterns unless they are wrong for the task. During design work, do not scaffold an application or introduce dependencies without an implementation request.
5. After code changes, run `bundle exec rubocop` and fix offenses when the Rails bundle and RuboCop are available. If tooling is not yet configured, report that limitation rather than claim a successful check.
6. Verify with existing focused tests first. Add or change individual tests only when they meet the admission standard in `references/testing.md`.
7. Run broad `bin/rails test` only when the change warrants the full suite. Never run system tests unless the user specifically asks.
8. Report what changed, what was verified, and any verification limitations.

## Project Rules

- Treat the app as greenfield. Do not add compatibility branches or data migrations solely for malformed developer-owned local data when correcting its generator and rebuilding that data is appropriate.
- Follow the schema and migration policy established in this repository. Do not invent a special initializer migration or hand-edit generated schema dumps.
- Do not run formatters or autocorrect blindly on sensitive code. Review behavior-preserving claims against the code.
- Prefer narrow RuboCop disables with an explanatory comment for intentional delicate logic.
- Preserve comments that explain business rules, time boundaries, or concurrency constraints.
- Use the configured business timezone for business dates and working hours; do not substitute system-local dates.

## Reference Routing

- Rails architecture and project conventions: `references/project-architecture.md`
- RuboCop and style decisions: `references/project-style-and-rubocop.md`
- Test strategy and selection: `references/testing.md`
- Ruby and Rails implementation guidance: `references/rails-ruby-practices.md`
