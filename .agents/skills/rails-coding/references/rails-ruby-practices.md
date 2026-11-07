# Ruby And Rails Practices

Use the versions and dependencies established in the repository. Until they are selected, describe stack choices as proposals. Existing code, tests, project documentation, and `.rubocop.yml` take precedence over generic preferences.

## Ruby

- Use `# frozen_string_literal: true` unless the file has a reason not to.
- Prefer intention-revealing names and keyword arguments for several named concepts.
- Keep mutation local and visible; avoid unnecessary metaprogramming.
- Use Rails time helpers in application code and the configured business timezone for business dates.
- Preserve comments explaining non-obvious rules and time/range behavior.

## Models And Persistence

- Put lifecycle rules, validations, associations, scopes, and small domain predicates on models when they naturally belong there.
- Pair durable invariants with database constraints. Use foreign keys and unique indexes deliberately.
- Specify association ownership and `dependent:` behavior consciously.
- Use explicit services for workflows crossing models or external systems rather than hiding those steps in callbacks.
- Start external side effects only after relevant data commits, with durable retry behavior where needed.
- Recheck availability inside the booking transaction using the selected database's concurrency controls.
- Follow the repository's migration policy; do not hand-edit generated schema dumps.

## Queries

- Prefer relation composition and parameterized queries.
- Use eager loading intentionally to avoid N+1 queries.
- Add deterministic ordering where behavior depends on which record comes first.
- Use `pluck`, `pick`, `ids`, `exists?`, and aggregate methods when full records are not needed.
- Preserve exact range boundaries; endless ranges are inclusive at their lower bound.

## Controllers And Views

- Keep core business logic out of controllers and views.
- Scope access to authorized records and permit only attributes the actor may change.
- Use framework APIs supported by the selected Rails version.
- Sanitize untrusted HTML instead of marking it safe.
- Do not assume custom form builders, navigation helpers, or confirmation components.

## Jobs And Integrations

- Make jobs and externally retried actions idempotent or protect them with constraints.
- Pass record identifiers or supported serialized arguments.
- Recheck current appointment state before sending a scheduled reminder.
- Use the configured job backend and integration conventions; do not introduce an event framework without a concrete need.
