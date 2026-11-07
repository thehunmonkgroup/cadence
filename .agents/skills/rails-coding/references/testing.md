# Testing

Use this reference when adding, editing, or removing an individual test.

## Test Admission Standard

Before adding, editing, or removing a test, decide whether the resulting coverage earns its maintenance cost.

A test is worth adding when it protects a meaningful current behavior contract, documents non-obvious domain behavior, or would catch a realistic regression not covered by existing tests.

Test the intended current behavior, not the removed implementation or historical bug. Avoid tests whose main claim is "the old thing no longer happens"; prefer positive assertions of the supported behavior. Before adding a regression test, ask whether it would still make sense to someone who never saw the bug.

A test is usually not worth adding when it mostly mirrors implementation shape, asserts simple framework/helper behavior, locks down incidental presentation details, or exists only because code changed.

A requested implementation or UI detail does not, by itself, create a new test contract. Determine whether the behavior is durable, whether a realistic regression warrants coverage, and whether existing focused tests already provide enough confidence.

If existing focused tests adequately verify the affected path, run those and do not add a new test.

Remove a test only when its contract is obsolete or meaningful coverage remains elsewhere.

## Business Behavior And Evidence

Tests protect business processes and domain behavior. A display change warrants test coverage only when the test proves such a contract, not merely that a user sees particular presentation.

Prefer deterministic assertions against public outcomes: persisted objects and attributes, relationships, state transitions, side effects, authorization results, jobs, audit records, response status, and structured errors. Use the most direct stable evidence that fully proves the contract; do not substitute a lower-level assertion that fails to prove the real behavior.

Content matching is a last resort. Use it only when content is indispensable evidence of the business-process contract and no deterministic assertion can prove that contract. Match only the smallest stable fragment; never assert full output or exact wording unless exact text is itself a business requirement.

## Required Workflow

- Verify each code change with the narrowest useful check.
- Prefer existing focused tests that exercise the changed path.
- Add or modify tests only when they protect a meaningful current behavior contract not already covered.
- Run broad `bin/rails test` only when the change is broad.
- Never run system tests unless the user specifically asks for them to be run.
- If you do not run a relevant test, say why.

## Test Framework

- Prefer Rails' conventional Minitest setup unless the developer chooses another framework.
- Inspect `test/test_helper.rb` and existing fixtures or factories when present; do not assume FactoryBot or custom helpers are installed.
- Browser/system tests are intentionally outside the default verification loop and require an explicit request to run.
- Follow the established test framework rather than mixing framework idioms.

## Test Selection

- Model validation/invariant: model test, plus DB constraint coverage when useful.
- Service object: focused service test under the corresponding `test/services/...` path.
- Controller workflow: integration/controller test for status, redirects, authorization, params, persistence, and rendered behavior.
- View/page load strict-loading regression: prefer a thin controller/integration test proving the page renders.
- Job enqueue: Active Job test helpers.
- Mailer behavior: mailer test plus trigger test when needed.
- Browser-only JavaScript behavior: system test only with explicit user approval.

## Test Design

- Test behavior, not private implementation.
- Test the current behavior contract, not the absence of old implementation details.
- Do not add bespoke "it no longer does X" tests just because X existed before a refactor or bug fix.
- If invalid input handling is part of the current contract, test it with a representative invalid value, not with a historical value from the removed implementation.
- Prefer positive assertions of the intended supported states and behavior over negative assertions about removed states.
- Before adding a regression test, ask: "Would this test still make sense to someone who never saw the old bug?" If not, do not add it.
- Use scenario names that state the expected behavior.
- Keep setup explicit and deterministic.
- Multiple assertions are acceptable when they verify one behavior.
- Use fixed strings and fixed dates.
- Use `travel_to` for time-dependent behavior.
- Avoid `sleep`; use Capybara waiting matchers in system tests.
- Do not over-DRY complex tests until the behavior becomes hard to see.

## Time And Timezone Tests

- Use Rails time helpers for time-sensitive behavior.
- For business-local dates, construct dates in the configured business timezone.
- Do not replace business-local date construction with system-local `Date.today` or `Time.now`.

## Scheduling Tests

- Read relevant availability, booking, overlap, and cutoff tests when present before changing implementation.
- Preserve exact boundary behavior: `<=`, `<`, `>=`, `>`, cleanup intervals, day boundaries, and daylight-saving transitions matter.
- Run the narrowest affected tests first, then related neighboring tests if range behavior changed.
