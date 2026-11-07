# Project Architecture

Cadence is a greenfield scheduling application. Consult `docs/` for its design and unresolved decisions. Design proposals are not evidence that a dependency or subsystem already exists.

## Application Shape

- Inspect the repository before assuming an application structure, Ruby/Rails version, database, authentication library, authorization library, frontend stack, or job backend.
- Once present, `.ruby-version`, `Gemfile`, `Gemfile.lock`, application configuration, and the schema establish the implemented stack.
- Prefer conventional Rails structure and the smallest architecture that supports approved requirements. Do not create infrastructure for speculative features.
- Follow Zeitwerk naming. After adding or renaming constants in a runnable app, run `bin/rails zeitwerk:check`.

## Business Workflows

- Keep controllers focused on loading authorized records, accepting permitted input, invoking behavior, and responding.
- Keep simple invariants on models. Use a service object when a workflow coordinates several business steps, such as booking, rescheduling, or interacting with a payment processor.
- Follow existing service conventions when present; do not assume a custom base class or event framework exists.
- Make scheduling rules deterministic and explicit. Preserve the distinction between appointment duration, cleanup time, available working hours, and booking eligibility.
- Availability displayed earlier is not a reservation. Recheck conflicts atomically when saving a booking or reschedule.

## Authorization And Privacy

- Read relevant authorization documentation and policies when they exist.
- Scope record access and submitted attributes to the actor. Knowing a client's email address is not proof of identity.
- Keep practitioner notes and other clients' information out of client-visible responses.
- Use the chosen authentication and authorization approach consistently; do not assume custom form builders, policy configuration, or confirmation components exist.

## Data And Time

- Follow the repository's established migration policy and preserve generated schema dumps unless the normal schema-generation workflow updates them.
- Match durable model invariants with database constraints where appropriate.
- Record business timezone semantics explicitly. Use UTC instants for appointment comparisons and the business timezone for local working hours and dates.
- Preserve exact overlap and cutoff boundaries; test meaningful edge cases when implementing them.
- Correct generating code and rebuild developer-owned data instead of adding compatibility logic solely for malformed local state.
