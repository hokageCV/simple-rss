# AGENTS.md

## Stack
- Ruby 3.3.4, Rails 8
- PostgreSQL (dev/test/prod; dev port 5432, test port 5433)
- Testing: Minitest
- Styling: Tailwind CSS
- Linting: Rubocop (rails-omakase)

## Commands
```
bundle install                          # deps
rails db:migrate                        # migrate
rails db:seed                           # seed
rails db:reset                          # reset (migrate+seed)
rails db:migrate RAILS_ENV=test
rails tailwindcss:build                 # build CSS
rails tailwindcss:watch                 # dev watch
rails server                            # dev server
rails s -e production                   # prod
./bin/test                              # all tests (starts test PG via docker-compose.test.yml, prepares schema)
./bin/test test/models/user_test.rb     # single file (same passthrough args as rails test)
rails test:system                       # system tests
rails console                           # dev console
```

## Code Navigation & File Reading

**Primary principle: minimize context consumption.** Read outlines first, then targeted sections. Be surgical.

### Tool Hierarchy
| Need | Primary Tool | Approach |
|------|--------------|----------|
| Cross-file flows & dependencies | graphify | query / browse — maps macro-structural connections and documentation links |
| Directory overview | grepika | `toc` |
| Find code (NL/regex) | grepika | `search` (requires index) |
| File structure | grepika | `outline` → `get` with line range |
| Symbol definitions | tilth | `search` — definition-first |
| What calls X? | tilth | `search kind:callers` |

### Quick Decision
- "How do structural components interact across the repository?" → graphify (macro-architecture & dependencies)
- "Find files about X topic" → **grepika** (NL search)
- "Where is Y defined?" → **tilth** (structural)
- "What calls Z?" → **tilth** (callers)
- Regex/text pattern → **grepika** (grep mode)

## Code Style

### Naming
- PascalCase classes/modules (UserFeed, ArticleService)
- snake_case methods/vars (fetch_feeds, article_count)
- snake_case files matching class name (user_feed.rb)

### Layout
- app/{models,controllers,views,helpers,services}/
- 2-space indent, 120 char max, no trailing whitespace

### Frontend
- ERB + Tailwind CSS classes
- Stimulus for JS; Turbo for SPA interactions
- Partials: _partial_name.html.erb

### Database
- ActiveRecord queries (where, joins, includes)
- Use migrations, use transactions for multi-step ops
- Avoid raw SQL

### Error Handling
- Custom exceptions (FeedFetchError < StandardError)
- Rescue specific types; propagate in services; handle in controllers

### Testing
- Tests in test/ with fixtures
- Test edge cases and error conditions
- Always run tests via `./bin/test`, never bare `rails test`: it starts the
  test Postgres container (docker-compose.test.yml, port 5433) and runs
  `db:test:prepare` first. Bare `rails test` fails with connection refused
  if the container is down.
- Keep the test DB seed-free: running `db:prepare`/`db:seed` with
  RAILS_ENV=test leaves seed rows (feeds, feed_folders) that clash with
  fixtures and fail with FK violations. If that happens, reset with
  `RAILS_ENV=test rails db:drop db:create db:schema:load`.
- Rubocop is not installed in the bundle (`bundle exec rubocop` fails), so
  no lint step currently.

## Notes
- GoodJob: ActiveJob adapter for async jobs
- API keys in .env.example; never commit secrets

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, invoke the `skill` tool with `skill: "graphify"` before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
