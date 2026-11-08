# Ruby and Rails Practices

## Models and persistence

- Keep validations, associations, scopes, and small domain predicates on the
  model that owns them. Use a service when a workflow coordinates multiple
  models or external systems; keep those steps explicit rather than hiding them
  in callbacks.
- Enforce durable invariants with database constraints as well as validations.
  Choose foreign keys, unique indexes, and association `dependent:` behavior
  according to ownership.
- Use transactions for changes that must succeed together. Choose locking or
  constraints to protect against concurrent writes; a prior validation or
  availability check alone cannot prevent a race.
- Keep network calls outside database locks. Start external side effects after
  commit and provide durable retry or reconciliation where delivery matters.

## Queries

- Compose relations and parameterize queries. Load associations deliberately to
  avoid N+1 queries.
- Use `pluck`, `pick`, `ids`, `exists?`, and aggregates when full records are
  unnecessary.
- Specify ordering when behavior depends on which record comes first.
- Preserve inclusive and exclusive range boundaries; Active Record endless
  ranges include their lower bound.

## Controllers and views

- Let controllers load authorized records, accept permitted input, invoke domain
  behavior, and select a response. Keep business rules in models or services.
- Apply record scopes and attribute permissions on the server.
- Prefer Rails rendering and escaping helpers. Sanitize supported user HTML;
  treat ordinary user content as text.
- Match file paths to constants for Zeitwerk. Check eager loading when adding or
  renaming constants.

## Jobs and integrations

- Make retried operations idempotent through stable operation identifiers,
  constraints, or state checks.
- Pass record identifiers or supported serialized arguments and reload the state
  needed to decide whether delayed work still applies.
- Choose retry behavior for recoverable failures and retain enough context to
  diagnose permanent failures without logging sensitive data.

## Ruby

- Use intention-revealing names and keyword arguments for distinct named concepts.
- Keep mutation local and visible. Prefer direct code over unnecessary
  metaprogramming.
- Preserve comments that explain business rules, concurrency, or boundary semantics.
