# Simple RSS

Simple-RSS is an RSS aggregator that allows users to subscribe to their favorite RSS feeds, view the latest updates, and read content directly within the app.

![simple-rss-demo][media]

## Features

- Subscribe to and manage multiple RSS feeds.
- Read articles directly within the app.
- Clean and user-friendly interface for easy navigation.
- Export & Import your feeds via OPML.
- Save article in [Raindrop.io](https://raindrop.io).
- Article summarization using Gemini API.
  - Listen the summary using web speech API.

## Installation

### Prerequisites

Install the minimum version of ruby mentioned in .ruby-version

### Setup
- Clone repository
```bash
git clone https://github.com/hokageCV/simple-rss.git
cd simple-rss
```
- Install dependencies
```bash
bundle install
```
- Migrate database
```bash
rails db:migrate
```
- Tailwind live reload
```bash
rails tailwindcss:watch
```
- Start server
```bash
rails server
```

The application should now be running.

[media]: https://res.cloudinary.com/dmtacem5p/image/upload/v1739462281/github/simple-rss.gif
