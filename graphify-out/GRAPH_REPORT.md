# Graph Report - simple-rss  (2026-07-17)

## Corpus Check
- 121 files · ~11,303 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 420 nodes · 403 edges · 97 communities (46 shown, 51 thin omitted)
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 59 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e66e5395`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]
- [[_COMMUNITY_Community 44|Community 44]]
- [[_COMMUNITY_Community 45|Community 45]]
- [[_COMMUNITY_Community 46|Community 46]]
- [[_COMMUNITY_Community 48|Community 48]]
- [[_COMMUNITY_Community 54|Community 54]]
- [[_COMMUNITY_Community 55|Community 55]]
- [[_COMMUNITY_Community 56|Community 56]]
- [[_COMMUNITY_Community 57|Community 57]]
- [[_COMMUNITY_Community 58|Community 58]]
- [[_COMMUNITY_Community 59|Community 59]]
- [[_COMMUNITY_Community 60|Community 60]]
- [[_COMMUNITY_Community 61|Community 61]]
- [[_COMMUNITY_Community 63|Community 63]]
- [[_COMMUNITY_Community 64|Community 64]]
- [[_COMMUNITY_Community 65|Community 65]]
- [[_COMMUNITY_Community 66|Community 66]]
- [[_COMMUNITY_Community 90|Community 90]]
- [[_COMMUNITY_Community 91|Community 91]]
- [[_COMMUNITY_Community 92|Community 92]]
- [[_COMMUNITY_Community 93|Community 93]]

## God Nodes (most connected - your core abstractions)
1. `User` - 23 edges
2. `FeedsController` - 15 edges
3. `ArticlesController` - 14 edges
4. `FoldersController` - 13 edges
5. `UsersController` - 10 edges
6. `FetchFeedService` - 10 edges
7. `Error` - 10 edges
8. `Client` - 9 edges
9. `RaindropController` - 6 edges
10. `Current` - 6 edges

## Surprising Connections (you probably didn't know these)
- `open_article_in_new_tab?()` --calls--> `Feed`  [INFERRED]
  app/helpers/articles_helper.rb → app/models/feed.rb
- `resume_session()` --calls--> `Session`  [INFERRED]
  app/controllers/concerns/authentication.rb → app/models/session.rb
- `start_new_session_for()` --calls--> `Session`  [INFERRED]
  app/controllers/concerns/authentication.rb → app/models/session.rb
- `terminate_session()` --calls--> `Session`  [INFERRED]
  app/controllers/concerns/authentication.rb → app/models/session.rb
- `render_content()` --calls--> `Feed`  [INFERRED]
  app/helpers/articles_helper.rb → app/models/feed.rb

## Import Cycles
- None detected.

## Communities (97 total, 51 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.08
Nodes (9): UsersController, ApplicationJob, Current, ApiError, Error, RateLimited, TokenRefreshed, Unauthorized (+1 more)

### Community 1 - "Community 1"
Cohesion: 0.07
Nodes (7): Connection, AdminConstraint, ApplicationController, HomeController, User, RaindropController, TestApiKeyService

### Community 2 - "Community 2"
Cohesion: 0.13
Nodes (3): ArticlesController, render_summary(), SummarizeArticle

### Community 3 - "Community 3"
Cohesion: 0.10
Nodes (6): resume_session(), start_new_session_for(), terminate_session(), RegistrationsController, SessionsController, Session

### Community 7 - "Community 7"
Cohesion: 0.27
Nodes (10): connect(), destroyTomSelect(), destroyTomSelects(), disconnect(), fetchModels(), initTomSelect(), providerChanged(), setTesting() (+2 more)

### Community 8 - "Community 8"
Cohesion: 0.31
Nodes (8): open_article_in_new_tab?(), render_content(), render_image(), render_youtube_actions(), render_youtube_content(), render_youtube_description(), render_youtube_hero(), Feed

### Community 9 - "Community 9"
Cohesion: 0.32
Nodes (4): getContent(), startSpeech(), togglePlayPause(), updatePlayPauseButton()

### Community 15 - "Community 15"
Cohesion: 0.15
Nodes (3): SummarizeArticleJob, Article, SaveArticleToRaindrop

### Community 18 - "Community 18"
Cohesion: 0.50
Nodes (3): confirmButton, dialog, messageElement

### Community 44 - "Community 44"
Cohesion: 0.17
Nodes (11): command, enabled, type, mcp, grepika, tilth, plugin, $schema (+3 more)

## Knowledge Gaps
- **34 isolated node(s):** `$schema`, `type`, `enabled`, `command`, `type` (+29 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **51 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `User` connect `Community 1` to `Community 0`, `Community 2`, `Community 5`, `Community 6`?**
  _High betweenness centrality (0.097) - this node is a cross-community bridge._
- **Why does `Error` connect `Community 0` to `Community 10`, `Community 1`, `Community 2`, `Community 3`?**
  _High betweenness centrality (0.077) - this node is a cross-community bridge._
- **Why does `ArticlesController` connect `Community 2` to `Community 15`?**
  _High betweenness centrality (0.058) - this node is a cross-community bridge._
- **Are the 16 inferred relationships involving `User` (e.g. with `.set_current_user()` and `.matches?()`) actually correct?**
  _`User` has 16 INFERRED edges - model-reasoned connections that need verification._
- **What connects `$schema`, `type`, `enabled` to the rest of the system?**
  _34 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.08275862068965517 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.07196969696969698 - nodes in this community are weakly interconnected._