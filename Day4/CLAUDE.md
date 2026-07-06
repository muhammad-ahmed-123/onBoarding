# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

This started as a freshly generated Rails 8.1 scaffold and now has its first domain feature: `Project`
(`has_many :tasks, dependent: :destroy`) and `Task` (`belongs_to :project`), with full nested CRUD.
There is no authentication system (`bcrypt`/`has_secure_password` is still commented out in the Gemfile)
and no `User` model — don't assume one exists.

## Stack

- Ruby 3.4.9 (see `.ruby-version`), Rails ~> 8.1.3
- SQLite3 for all databases (primary, cache, queue, cable) — see `config/database.yml`
- Solid Queue (jobs), Solid Cache (caching), Solid Cable (Action Cable) — all DB-backed, no Redis
- Propshaft for the asset pipeline (not Sprockets)
- Hotwire (Turbo + Stimulus) for frontend interactivity; Importmap for JS (no Node/bundler build step)
- Puma web server, Thruster for asset caching/compression/X-Sendfile in production
- Kamal for deployment (see `config/deploy.yml`, `.kamal/`)

## Commands

Setup (idempotent — installs gems, prepares DB, clears logs):
```
bin/setup            # also starts the dev server unless --skip-server is passed
bin/setup --skip-server
bin/setup --reset    # also resets the database
```

Run the dev server:
```
bin/dev               # runs bin/rails server
```

Tests — **two test suites coexist, both required for full coverage**:
```
bin/rails test                          # Minitest: full suite (models + controllers)
bin/rails test test/models/foo_test.rb  # single file
bin/rails test test/models/foo_test.rb:12   # single test at line 12
bin/rails test:system                   # system tests (Capybara + Selenium)

bundle exec rspec                       # RSpec: full suite
bundle exec rspec spec/models/project_spec.rb        # single file
bundle exec rspec spec/models/project_spec.rb:12      # single example at line 12
```
Minitest is the original/primary suite (fixtures in `test/fixtures/*.yml`, parallelized across
processors). RSpec was added later and reuses the *same* Minitest fixtures rather than FactoryBot —
`spec/rails_helper.rb` points `config.fixture_paths` at `test/fixtures` and sets
`config.global_fixtures = :all`, so `projects(:alpha)`/`tasks(:alpha_one)` work in specs exactly like
in Minitest tests. `shoulda-matchers` is configured there too, for `have_many`/`validate_presence_of`
one-liners. When adding a new model test, prefer matching whichever suite already covers that model
(check both `test/models/` and `spec/models/`) rather than picking one arbitrarily.

Linting and security (Omakase RuboCop style):
```
bin/rubocop
bin/brakeman --no-pager
bin/bundler-audit
bin/importmap audit
```

Full CI pipeline locally (mirrors `.github/workflows/ci.yml`):
```
bin/ci
```
This runs setup, rubocop, bundler-audit, importmap audit, brakeman, `bin/rails test`, `bundle exec rspec`,
and a seed replant check, in that order (defined in `config/ci.rb` via
`ActiveSupport::ContinuousIntegration`). Both test suites are required steps — a change that only
updates one of `test/` or `spec/` still needs the other suite to keep passing.

Database:
```
bin/rails db:prepare       # create/migrate as needed (idempotent)
bin/rails db:migrate
env RAILS_ENV=test bin/rails db:seed:replant   # what CI runs to validate seeds
```

## Architecture notes

- Three auxiliary SQLite databases beyond the primary one (`cache`, `queue`, `cable`), each with its
  own migration path (`db/cache_migrate`, `db/queue_migrate`, `db/cable_migrate`) and schema file
  (`db/cache_schema.rb`, `db/queue_schema.rb`, `db/cable_schema.rb`). In production these are configured
  as separate entries under `production:` in `config/database.yml`; in development/test they share the
  single default database connection.
- Recurring/scheduled jobs are configured in `config/recurring.yml` (Solid Queue's recurring task
  format), not cron or a separate scheduler gem.
- `config.autoload_lib` ignores `lib/assets` and `lib/tasks` — other `lib/` subdirectories are
  autoloaded/eager-loaded, so new code placed there should follow Zeitwerk naming conventions.
- No `bcrypt`/`has_secure_password` yet (commented out in Gemfile) — add it explicitly if building
  authentication.
- CI security scanning (Brakeman, bundler-audit, importmap audit) runs as separate required jobs in
  GitHub Actions (`.github/workflows/ci.yml`), in addition to being part of `bin/ci`.

### Project/Task nested resource pattern

`Task` has no independent identity in the UI — routes are **fully nested**
(`/projects/:project_id/tasks/...`, not shallow) specifically so every task action can be scoped to its
parent project. When adding similar child resources, follow the same pattern established in
`app/controllers/tasks_controller.rb`:
- `before_action :set_project` loads `Project.find(params[:project_id])` first, so a bogus `project_id`
  404s before any task lookup happens.
- `set_task` looks up via `@project.tasks.find(params[:id])`, **not** `Task.find(params[:id])` — this is
  what makes a task ID belonging to a different project 404 instead of being readable/writable through
  the wrong project's URL. Preserve this scoping pattern for any new nested resource.
- 404s (`ActiveRecord::RecordNotFound`) are handled once, centrally, in `ApplicationController` via
  `rescue_from`, format-aware (HTML renders `public/404.html`, JSON renders an error body). Don't add
  per-controller `rescue_from`/rescue for missing records — extend the central handler instead.
- `ApplicationController` also has `skip_before_action :verify_authenticity_token, if: -> { request.format.json? }`.
  This app is `ActionController::Base` (not API-only) and serves both HTML forms and JSON from the same
  controllers, so default CSRF protection otherwise rejects every JSON `POST`/`PATCH`/`DELETE` with a 422
  (there's no page-supplied token for a non-browser JSON client to send). HTML form submissions remain
  CSRF-protected. Any new controller serving JSON writes inherits this automatically via
  `ApplicationController` — no per-controller action needed. This gap only surfaces when actually curling
  the running server; the test suites don't catch it (`config/environments/test.rb` disables forgery
  protection entirely).
- Controllers use `respond_to` blocks for `format.html`/`format.json` on `create`/`update`/`destroy`,
  with `status: :unprocessable_content` (422) on validation failure and `status: :see_other` on the
  HTML destroy redirect (so Turbo issues a GET, not a DELETE, on the redirect target). JSON views are
  jbuilder partials (`app/views/*/_*.json.jbuilder`) with an explicit attribute allow-list, not bare
  `render json: @model`.
