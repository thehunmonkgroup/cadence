# Tooling conventions

The approved ports adapt the reference Rails app's infrastructure while keeping
Cadence's models, forms, policies, factories, and scheduling logic independent.
Rails is pinned to 8.1.4.1 and Ruby to 4.0.5.

## Authorization contract

`ApplicationController` includes Pundit, requires explicit authorization for every
action, and additionally requires a policy scope for `index` actions. An intentionally
public action must explicitly use `skip_authorization`; a public collection must
also use `skip_policy_scope`. Keep those exceptions narrow and documented.

`ApplicationPolicy` denies the standard actions by default. Its base scope raises
until a policy defines which records the actor can reach. Future resource controllers
must scope record lookup, authorize the action, and allow only permitted attributes.
Pundit's verification hooks check that calls occurred; each policy still needs to
implement the actual access rules.

`ApplicationController#current_user` is the authentication integration point and
currently returns `nil`. Replace it with a verified, server-resolved identity when
the sign-in flow is chosen. The actor contract for the job dashboard is a `role`
string equal to `practitioner` or `admin`. A client role grants no dashboard access.
Request parameters, arbitrary email addresses, and client-supplied role values
must never establish that identity.

Every Mission Control engine action, including retry, discard, and pause, inherits
the `Admin::JobsController` authorization callback. Engine-wide staff authorization
deliberately skips client record scoping. Its built-in Basic Auth is disabled because
this Pundit gate is authoritative. Until authentication is wired, requests receive 403.
The health endpoint and development-only email engine have their own framework controllers.

## Reusable interface tools

DaisyUI 5.5.23 is vendored as a Tailwind standalone plugin, using its standard light
theme. Its JavaScript module is build tooling, not a browser dependency. Importmap,
Turbo, and Stimulus handle browser behavior without an npm build pipeline.

`flash_messages` renders string flash values as escaped text in DaisyUI alerts.
Use `notice`/`success`, `alert`/`error`, or `warning`; other string keys get an info
style. Structured rich HTML flash tokens from the reference app were unnecessary.

`heroicon(:calendar_days, class: 'size-6')` renders a decorative icon. Supply
`aria_label: 'Calendar'` or `title: 'Calendar'` when the icon conveys information
without adjacent text. Names are limited to the helper's explicit path map.
Upstream attribution is in `vendor/heroicons-LICENSE.txt`.

The `form-submit` Stimulus controller provides pending feedback for native and
Turbo forms, preserves submitter name/value, and restores state on completion,
Turbo caching, or browser history navigation. Example wiring:

```erb
<%= form_with url: some_path,
              data: { controller: 'form-submit',
                      action: 'submit->form-submit#start turbo:submit-start->form-submit#turboStart turbo:submit-end->form-submit#reset turbo:before-cache@document->form-submit#reset pageshow@window->form-submit#reset' } do |form| %>
  <%= form.submit 'Save', class: 'btn btn-primary' %>
  <span class="loading loading-spinner invisible" aria-hidden="true" data-form-submit-target="spinner"></span>
  <span role="status" data-form-submit-target="status" data-message="Saving…"></span>
<% end %>
```

This is submission feedback, not proof that a booking succeeded or a replacement
for server-side idempotency. The eventual booking flow must provide its own saved
confirmation state.

The `tabs` controller supports click, Left/Right arrows, Home, and End. Give the
container `data-controller="tabs"`; use a `list` target with `role="tablist"`,
`tab` targets with `role="tab"`, and `panel` targets with `role="tabpanel"`.
Each tab's `aria-controls` must match its panel ID; each panel's `aria-labelledby`
must match its tab ID. Wire `click->tabs#select keydown->tabs#navigate` on each tab.
Use `aria-selected="true"` on the initial tab. Panels remain available without
JavaScript; the controller hides inactive panels on connection.

## Test conventions

Minitest and FactoryBot are configured in `test/test_helper.rb`. The current tests
protect job dashboard access, Pundit enforcement, job commit/rollback behavior,
and escaping of client-provided flash text. No domain factories are invented.

The two controller tests deliberately use `ActionController::TestCase` to supply
an actor or probe verification hooks without introducing application routes or a
temporary authentication system. HTTP integration tests also exercise the mounted
engine's anonymous read and mutation boundaries.

`COVERAGE=1` starts SimpleCov before Rails loads and uses one test worker for a
straightforward combined report. Coverage percentages are diagnostic, with no
arbitrary threshold. System-test support is available through
`ApplicationSystemTestCase`; execution requires an explicit request.

## Verification and known limitations

The port was verified with lint, eager loading, Minitest, opt-in coverage, production
asset compilation, Docker Compose build/start, both queue workers, worker reloads,
local mail capture, HTTP health/access checks, and file/stdout logging checks.
These are infrastructure checks; they do not validate scheduling behavior.

Authentication and the practitioner/client data model remain deferred. There is
no accessible staff dashboard until the verified identity hook is implemented.
Chrome/browser tests and a production deployment were not exercised.

## Rails 8.1.4.1 upgrade

On November 7, 2026, Cadence moved from Rails 8.1.3.1 to the
[latest stable release, 8.1.4.1](https://rubygems.org/gems/rails/versions/8.1.4.1),
following the [Rails upgrade guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html).

The sequence was baseline tests/lint, updating the Rails requirement, running
`bundle update rails`, running `bin/rails app:update --skip`, reviewing generated
configuration and upstream template differences, and rerunning verification.
The `--skip` collision option preserved Cadence's customized files; the generator
templates were compared between both installed Rails versions and were identical.
No upstream template changes needed merging. The updater's generated
`new_framework_defaults_8_1.rb` was removed after review because `config.load_defaults 8.1`
already enables those defaults. No application schema migrations were needed.

The temporary JSON 2.x pin was removed. The updated bundle selects JSON 3.1.0;
[Rails 8.1.4 added compatible JSON decoding](https://github.com/rails/rails/releases/tag/v8.1.4).
The Rails release supplies security and compatibility fixes while Cadence retains
its existing authorization, logging, queue, and UI behavior.

Upgrade verification passed: the full `bin/ci` run (11 tests, 21 assertions),
RuboCop, Zeitwerk, Brakeman, importmap audit, and the refreshed dependency audit
with no vulnerabilities reported. Production assets compiled successfully.
Docker web/worker startup, the health endpoint, dashboard denial for anonymous
requests, and database-backed worker JSON serialization were checked on the new
versions. Verification services were stopped afterward. Browser tests were not run.
