# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

This is a freshly generated Rails 8.1 application (app name/module: `Day2`) — currently just the
`rails new` scaffold with no custom models, controllers, or routes yet. There is no `db/schema.rb`
or migrations yet either. Expect to be building the app's actual domain logic from here.

## Stack

- Ruby 3.4.9 (see `.ruby-version`), Rails ~> 8.1.3
- SQLite3 via `solid_cache` / `solid_queue` / `solid_cable` (no Redis) — separate SQLite DBs per
  environment for primary/cache/queue/cable, all under `storage/` (see `config/database.yml`)
- Propshaft asset pipeline + Importmap (no Node/webpack build step)
- Hotwire (Turbo + Stimulus) for frontend interactivity
- Puma web server, Thruster for asset caching/compression/X-Sendfile
- Kamal for deployment (see `.kamal/`, `Dockerfile`)

## Common commands

Setup (idempotent — installs gems, prepares DB, clears logs, starts server):
```
bin/setup
bin/setup --skip-server   # setup without launching the server
bin/setup --reset         # also resets the database
```

Run the dev server (Rails server via `bin/dev`):
```
bin/rails server
bin/dev
```

Tests (Minitest, not RSpec):
```
bin/rails test                          # full test suite
bin/rails test test/models/foo_test.rb  # single file
bin/rails test test/models/foo_test.rb:12  # single test at line number
bin/rails test:system                   # system tests (Capybara + Selenium)
```

Full CI pipeline locally (mirrors `.github/workflows/ci.yml` via `bin/ci` / `config/ci.rb`,
using Rails' `ActiveSupport::ContinuousIntegration`):
```
bin/ci
```

Linting (RuboCop, Omakase style via `rubocop-rails-omakase`, config in `.rubocop.yml`):
```
bin/rubocop
bin/rubocop -f github   # format used in CI
```

Security scanning:
```
bin/brakeman --no-pager   # static analysis for Rails vulnerabilities
bin/bundler-audit         # audits gem dependencies for known CVEs
bin/importmap audit       # audits JS dependencies pulled in via importmap
```

Database:
```
bin/rails db:prepare       # create + migrate, used in setup/CI
bin/rails db:reset
bin/rails db:test:prepare  # prep test DB, run before `test` in CI
```

## Architecture notes

- Standard Rails autoloaded structure under `app/` (`controllers`, `models`, `jobs`, `mailers`,
  `views`, `helpers`, `javascript`). `config/application.rb` uses `config.autoload_lib(ignore:
  %w[assets tasks])`, so new code placed in `lib/` (outside `assets`/`tasks`) is autoloaded like
  `app/` code.
- Routes are defined in `config/routes.rb`; only the Rails health check (`/up`) is currently wired
  up. PWA manifest/service-worker routes exist in `app/views/pwa/` but are commented out in routes.
- CI (`.github/workflows/ci.yml`) runs four independent jobs: `scan_ruby` (Brakeman + bundler-audit),
  `scan_js` (importmap audit), `lint` (RuboCop), `test` (Minitest), and `system-test` (Capybara
  system tests, screenshots uploaded on failure). Mirror these locally with the commands above
  before pushing.
- Production DB config in `config/database.yml` splits into four separate SQLite databases
  (primary, cache, queue, cable) each with their own migration path (`db/cache_migrate`,
  `db/queue_migrate`, `db/cable_migrate`) — keep this in mind when adding migrations for
  solid_cache/solid_queue/solid_cable-related tables vs. application tables.
