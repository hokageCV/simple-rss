# AGENTS.md - Development Guide for simple-rss

## Project Overview

A Rails 8 RSS aggregator application with features including RSS feed subscription, article reading, OPML import/export, Raindrop.io integration, AI-powered summaries (OpenAI), and text-to-speech playback.

## Technology Stack

- Ruby: 3.3.4 (see `.ruby-version`)
- Rails: 8.0.1
- Database: SQLite (dev/test), PostgreSQL (production)
- Testing: Minitest (Rails default)
- Styling: Tailwind CSS
- Linting: Rubocop (rails-omakase style)

---

## Build/Lint/Test Commands

### Setup
```bash
bundle install          # Install dependencies
rails db:migrate       # Run migrations
rails tailwindcss:build # Build assets
```

### Running the Application
```bash
rails server           # Start dev server (localhost:3000)
rails s -e production  # Run in production mode
```

### Testing
```bash
rails test                      # Run all tests
rails test test/models/user_test.rb              # Run single test file
rails test test/models/user_test.rb -n test_name # Run specific test
rails test:system             # System tests only (requires Chrome)
```

### Linting & Code Quality
```bash
rubocop                        # Run rubocop on all files
rubocop app/models/user.rb     # Lint specific file
rubocop --a                    # Auto-fix issues
```

### Database
```bash
rails db:migrate              # Run migrations
rails db:rollback             # Rollback last migration
rails db:seed                 # Seed database
rails db:reset                # Reset database (migrate + seed)
rails db:migrate RAILS_ENV=test  # Run migrations in test env
```

### Assets
```bash
rails tailwindcss:watch       # Watch mode for dev
rails tailwindcss:build       # Build for production
```

### Console
```bash
rails console                 # Development console
rails console -e staging      # Staging console
```

---

## Code Style Guidelines

### General Principles
- Follow Rails conventions and RESTful routing
- Use idiomatic Ruby and Rails patterns
- Prefer convention over configuration

### Naming Conventions
- Classes/Modules: `PascalCase` (e.g., `UserFeed`, `ArticleService`)
- Methods/variables: `snake_case` (e.g., `fetch_feeds`, `article_count`)
- Database tables: `snake_case`, plural (e.g., `users`, `feed_folders`)
- Files: `snake_case` matching class names (e.g., `user_feed.rb`)

### File Organization
- Models in `app/models/`
- Controllers in `app/controllers/`
- Views in `app/views/` (matching controller/controller/action structure)
- Helpers in `app/helpers/`
- Services/queries in `app/models/` or `app/services/` (use subdirectories)

### Imports
```ruby
require "rails_helper"  # In test files

# Standard library
require "json"
require "open-uri"

# Gems
require "feedjira"
require "httparty"
```

### Formatting
- 2-space indentation (no tabs)
- Max line length: 120 characters (rubocop default)
- Use empty lines to separate logical sections
- No trailing whitespace

### Error Handling
- Use custom exceptions for domain-specific errors:
  ```ruby
  class FeedFetchError < StandardError; end
  ```
- Rescue specific exceptions, avoid bare `rescue`
- Use `raise` with descriptive messages
- Let exceptions propagate in service objects; handle at controller level

### Database/AR Patterns
- Use ActiveRecord query methods (`where`, `joins`, `includes`)
- Avoid raw SQL unless necessary
- Use migrations for schema changes (`rails g migration`)
- Use transactions for multi-step database operations

### Views
- Use ERB with Tailwind CSS classes
- Avoid inline JavaScript; use Stimulus controllers
- Use Turbo/Stimulus for SPA-like interactions
- Follow Rails naming for partials (`_partial_name.html.erb`)

### Testing
- Write model/controller tests in `test/`
- Use fixtures for test data
- Test edge cases and error conditions
- Follow Rails testing conventions

---

## Important Notes

- GoodJob: ActiveJob adapter is configured for async job processing
- Environment Variables: See `.env.example` for required vars (API keys, encryption keys)
- Secrets: Never commit secrets; use environment variables
