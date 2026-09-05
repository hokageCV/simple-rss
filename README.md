# Simple RSS

Simple-RSS is an RSS aggregator that allows users to subscribe to their favorite RSS feeds, view the latest updates, and read content directly within the app.

![simple-rss-demo][media]

## Features

- Subscribe to and manage multiple RSS feeds
- Read articles directly within the app
- Clean and user-friendly interface for easy navigation
- Export & Import your feeds via OPML
- Save articles to [Raindrop.io](https://raindrop.io)
- AI-powered article summaries (OpenAI, using your own API key)
- Text-to-speech playback for summaries

## Installation

### Prerequisites

- Ruby version specified in [.ruby-version](.ruby-version)
- Docker (or Podman with a Docker-compatible CLI) for the local PostgreSQL databases

### Setup

The whole local environment (containerized PostgreSQL + Rails server + Tailwind watcher) starts with a single command:

```bash
git clone https://github.com/hokageCV/simple-rss.git
cd simple-rss
./bin/setup   # installs deps, starts Postgres, migrates DB, starts the app
```

After the first setup, start the app any time with:

```bash
./bin/dev     # starts Postgres + Rails server + Tailwind watcher
```

Before the first run, copy the environment config and fill in the API keys you have:

```bash
cp .env.example .env
```

Seed the database with sample users (test/dev only; raises in production):

```bash
rails db:seed
```

The seeded users (password: `Test@123`):
- `shoyo@gmail.com` — has 3 feeds in a `newsletters` folder
- `kakashi@gmail.com` — no feeds

Clear all data (test/dev only; raises in production):

```bash
rails db:clean
```

Workflow to reset demo data: `rails db:clean && rails db:seed`

### Running the pieces separately

- PostgreSQL only: `docker compose up -d`
- Rails server only: `rails server`
- Rails + Tailwind via Procfile: `foreman start -f Procfile.dev`

## Testing

Run the test suite with a single command (starts the test Postgres container, preps the test database, then runs the tests):

```bash
./bin/test                    # full suite
./bin/test test/models/user_test.rb     # single file
./bin/test test/controllers/feeds_controller_test.rb:22  # single test
```

The equivalent manual steps, if you prefer to run them separately:

- Start the test database (PostgreSQL on port 5433)
```bash
docker compose -f docker-compose.test.yml up -d
```
- Prepare the test database (RAILS_ENV=test keeps the env check on the test DB, so the dev database isn't required)
```bash
RAILS_ENV=test rails db:test:prepare
```
- Run tests
```bash
rails test
```

The dev and test databases are isolated containers managed by separate compose files: `docker compose up -d` starts only the dev database, and `docker compose -f docker-compose.test.yml up -d` starts only the test database.

[media]: https://res.cloudinary.com/dmtacem5p/image/upload/v1739462281/github/simple-rss.gif
