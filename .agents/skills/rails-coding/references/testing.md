# Testing

Apply this reference to each individual test change using the procedure in
`AGENTS.md`.

## Admission standard

A test earns its maintenance cost when it protects a durable business-process or
domain contract and catches a realistic regression that existing tests miss.
A requested code or UI change alone is insufficient reason to add coverage.

For each proposed test change, identify the contract, realistic regression,
coverage gap, and most deterministic evidence. Use existing focused tests when
they already prove the affected behavior. Remove a test only when its contract
is obsolete or meaningful coverage remains elsewhere.

Test supported current behavior. A regression test should make sense to someone
who never saw the original bug. Tests that mirror implementation structure,
exercise simple framework behavior, or lock down incidental presentation usually
add maintenance cost without useful protection.

## Evidence

Prefer public outcomes: persisted state, relationships, transitions, side effects,
authorization results, enqueued jobs, response status, and structured errors.
Choose the most direct stable evidence that fully proves the contract; a
lower-level assertion is insufficient if the actual behavior can still fail.

Use content matching only when content is indispensable evidence of the business
contract and deterministic alternatives cannot prove it. Match the smallest
stable fragment; assert exact wording only when it is itself a requirement.
A display change warrants coverage when it proves a business-process contract.

## Framework and selection

Cadence uses Minitest, Rails test helpers, and FactoryBot configured in
`test/test_helper.rb`. Follow existing test idioms and create only the data the
scenario needs.

- Model invariants: model tests, with database constraint coverage where useful.
- Coordinated workflows: focused service or integration tests.
- Request boundaries: integration tests for authorization, permitted input,
  response, and persisted effects.
- Background work: Active Job helpers for enqueue behavior and job tests for
  execution.
- Mail: mailer tests and a trigger test when each protects a distinct contract.
- Browser-dependent interactions: system tests, run only on explicit user request.

Run the narrowest useful existing tests first. Broaden verification when the
change affects shared behavior or focused checks leave a material gap.

## Test design

- Name scenarios for the supported outcome; assert behavior through public
  interfaces.
- Keep setup explicit and deterministic. Use representative invalid values when
  invalid-input handling belongs to the contract.
- Multiple assertions may prove one behavior; keep each assertion relevant to
  that test's admitted contract.
- Use fixed dates and Rails `travel_to` for time-sensitive behavior. Construct
  business-local times in the business timezone.
- Cover meaningful scheduling boundaries: overlap, cleanup, cancellation cutoffs,
  and daylight-saving changes.
- Use Capybara's waiting assertions for asynchronous browser behavior.
