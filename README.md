# Cadence

Cadence is a greenfield scheduling application. The Rails foundation and development
tooling are in place; booking behavior and sign-in are still being designed.

## Stack

Ruby **4.0.5**, Rails **8.1.4.1**, MySQL/MariaDB, Solid Queue, Solid Cache,
Importmap, Turbo, Stimulus, Tailwind CSS, and DaisyUI. Dependencies are locked in
`Gemfile.lock`. Rails 8.1 defaults are enabled. JSON 3 is supported without a
compatibility constraint.

## Local development

Install the pinned Ruby version and MySQL/MariaDB, including the native client
development library needed by `mysql2`, then run:

```sh
bin/setup
```

Setup installs dependencies, prepares databases, builds CSS, and starts the web
server, CSS watcher, and reloading job worker. Use `bin/setup --skip-server` for
setup alone, then `bin/dev` for subsequent starts. Neither command resets data
or clears logs. `RAILS_ENV=test bin/setup --skip-server` prepares only test databases.

The default URL is `http://localhost:3000`. Use `PORT=3100 bin/dev` to change it.
The default root page is Rails' development welcome page; `/up` is the health endpoint.

Database connection settings:

| Variable | Default |
| --- | --- |
| `CADENCE_MYSQL_USERNAME` | `root` |
| `CADENCE_MYSQL_PASSWORD` | unset |
| `CADENCE_MYSQL_SOCK` | `/var/run/mysqld/mysqld.sock` |
| `CADENCE_MYSQL_HOST` | unset; setting it selects TCP instead of a socket |
| `CADENCE_MYSQL_PORT` | `3306` |

Each environment has primary, queue, and cache databases, named
`cadence_<environment>`, `cadence_<environment>_queue`, and
`cadence_<environment>_cache`. The database user needs permission to create these
during initial setup. Keep `config/master.key` private and supply the matching key
separately for a fresh checkout.

## Docker development

Docker Compose uses the host MySQL/MariaDB socket, as in the reference app:

```sh
docker compose up --build -d
docker compose logs -f web jobs css
docker compose stop
```

A one-time `setup` service installs gems and prepares databases before the three
long-running services start. Gems and temporary files use named volumes. The
shared temporary volume lets web requests display emails captured by workers.
Source files are bind-mounted for live changes.

The web port is bound to localhost. Use `CADENCE_PORT=3100 docker compose up -d`
if another app uses port 3000. Override `CADENCE_MYSQL_SOCKET_DIR` when the host
socket directory differs from `/run/mysqld`; the filename must be `mysqld.sock`.
Compose forwards the database username/password variables above.

Run commands inside the configured environment with, for example:

```sh
docker compose exec web bin/rails console
docker compose exec web bin/ci
```

Browser tests require a local Chrome installation; the development image does
not include a browser. The separate production `Dockerfile` remains a deployment
starting point and needs hosting, mail, database, and process configuration.

## Jobs, mail, and authorization

- `bin/jobs-dev` restarts workers when app/configuration files change and propagates
  worker exit failures. `bin/jobs` runs workers without the development watcher.
- `default` and `mailers` have separate workers. Configure their process counts with
  `JOB_CONCURRENCY` and `MAILER_JOB_CONCURRENCY`. Add worker configuration when adding queues.
- Application jobs enqueue after the application transaction commits; rollbacks
  do not enqueue them. Job arguments are omitted from Active Job log messages.
- Development mail uses Letter Opener Web at `/letter_opener`, with no external
  delivery or automatic browser launch. This route exists only in development.
- Mission Control Jobs is mounted at `/admin/jobs`. Access is denied until
  authentication supplies a verified actor with the `practitioner` or `admin`
  role. No development bypass or default account exists.

See [tooling conventions](docs/tooling.md) for the authorization integration
contract and reusable UI helpers.

## Checks

```sh
bin/ci
bin/rails test test/policies/jobs_dashboard_policy_test.rb
COVERAGE=1 bin/rails test
```

CI forces `RAILS_ENV=test`, prepares test databases, and runs RuboCop, bundler-audit
with updated advisories, importmap auditing, Brakeman, Zeitwerk, and Minitest.
It does not reset databases, run seeds, or run browser tests by default.
Security audits require network access and a writable advisory cache.

Coverage is opt-in and written to ignored `coverage/`. FactoryBot is available;
add domain factories only when actual models need them.

With an explicit developer request, use `bin/ci --system` or
`bin/rails test:system`. Headless Chrome is the default; `TEST_GUI=1` selects
visible Chrome. No system tests have been run as part of this tooling port.

Rails was upgraded using Bundler and the standard Rails update task. See
[upgrade and verification details](docs/tooling.md#rails-8141-upgrade) for the
configuration review and validation results.

## Logging

Logs include request IDs. Development/test default to `log/<environment>.log`;
production defaults to stdout. Set `RAILS_LOG_TO_STDOUT=1` for stdout, or set it
to `0` and use `RAILS_LOGFILE_PATH` for a file. `RAILS_LOG_LEVEL` controls verbosity.

Development retains SQL query tags, job-enqueue locations, redirect diagnostics,
and view filename annotations. Sensitive request parameters include passwords,
tokens, email, phone, address, notes, intake, and card fields. Debug SQL/mail logs
can still contain application data; parameter filtering does not redact every
possible log source.

## Product design

- [User story executive summary](docs/user-story-executive-summary.md)
- [Technical plan and developer questions](docs/technical-plan-executive-summary.md)
- [Repository instructions](AGENTS.md)

Active Storage, Action Mailbox, Action Text, Action Cable, Jbuilder, Kamal, and
Devise remain unconfigured. Business timezone and identity flows await product decisions.
Leave changes unstaged unless the developer explicitly directs staging.
