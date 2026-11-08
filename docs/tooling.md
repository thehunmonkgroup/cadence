# Tooling conventions

This guide covers authorization, interface helpers, and testing conventions. For setup, runtime configuration, and check commands, see the [development guide](../DEVELOPMENT.md).

## Authorization contract

`ApplicationController` includes Pundit, requires explicit authorization for every action, and additionally requires a policy scope for `index` actions. An intentionally public action must explicitly use `skip_authorization`; a public collection must also use `skip_policy_scope`. Keep those exceptions narrow and documented.

`ApplicationPolicy` denies the standard actions by default. Its base scope raises until a policy defines which records the actor can reach. Future resource controllers must scope record lookup, authorize the action, and allow only permitted attributes. Pundit's verification hooks check that calls occurred; each policy still needs to implement the actual access rules.

`ApplicationController#current_user` is the authentication integration point and currently returns `nil`. Replace it with a verified, server-resolved identity when the sign-in flow is chosen. The actor contract for the job dashboard is a `role` string equal to `practitioner` or `admin`. A client role grants no dashboard access. Request parameters, arbitrary email addresses, and client-supplied role values must never establish that identity.

Every Mission Control engine action, including retry, discard, and pause, inherits the `Admin::JobsController` authorization callback. Engine-wide staff authorization deliberately skips client record scoping. Its built-in Basic Auth is disabled because this Pundit gate is authoritative. Until authentication is wired, requests receive 403. The health endpoint and development-only email engine have their own framework controllers.

## Reusable interface tools

DaisyUI 5.5.23 is vendored as a Tailwind standalone plugin, using its standard light theme. Its JavaScript module is build tooling, not a browser dependency. Importmap, Turbo, and Stimulus handle browser behavior without an npm build pipeline.

`flash_messages` renders string flash values as escaped text in DaisyUI alerts. Use `notice`/`success`, `alert`/`error`, or `warning`; other string keys get an info style.

`heroicon(:calendar_days, class: 'size-6')` renders a decorative icon. Supply `aria_label: 'Calendar'` or `title: 'Calendar'` when the icon conveys information without adjacent text. Names are limited to the helper's explicit path map. Upstream attribution is in `vendor/heroicons-LICENSE.txt`.

The `form-submit` Stimulus controller provides pending feedback for native and Turbo forms, preserves submitter name/value, and restores state on completion, Turbo caching, or browser history navigation. Example wiring:

```erb
<%= form_with url: some_path,
              data: { controller: 'form-submit',
                      action: 'submit->form-submit#start turbo:submit-start->form-submit#turboStart turbo:submit-end->form-submit#reset turbo:before-cache@document->form-submit#reset pageshow@window->form-submit#reset' } do |form| %>
  <%= form.submit 'Save', class: 'btn btn-primary' %>
  <span class="loading loading-spinner invisible" aria-hidden="true" data-form-submit-target="spinner"></span>
  <span role="status" data-form-submit-target="status" data-message="Saving…"></span>
<% end %>
```

This is submission feedback, not proof that a booking succeeded or a replacement for server-side idempotency. The eventual booking flow must provide its own saved confirmation state.

The `tabs` controller supports click, Left/Right arrows, Home, and End. Give the container `data-controller="tabs"`; use a `list` target with `role="tablist"`, `tab` targets with `role="tab"`, and `panel` targets with `role="tabpanel"`. Each tab's `aria-controls` must match its panel ID; each panel's `aria-labelledby` must match its tab ID. Wire `click->tabs#select keydown->tabs#navigate` on each tab. Use `aria-selected="true"` on the initial tab. Panels remain available without JavaScript; the controller hides inactive panels on connection.

## Test conventions

Minitest and FactoryBot are configured in `test/test_helper.rb`. The current tests protect job dashboard access, Pundit enforcement, job commit/rollback behavior, and escaping of client-provided flash text.

The two controller tests deliberately use `ActionController::TestCase` to supply an actor or probe verification hooks without introducing application routes or a temporary authentication system. HTTP integration tests also exercise the mounted engine's anonymous read and mutation boundaries.

`COVERAGE=1` starts SimpleCov before Rails loads and uses one test worker for a straightforward combined report. Coverage percentages are diagnostic, with no arbitrary threshold. System-test support is available through `ApplicationSystemTestCase`; see the development guide for opt-in commands.
