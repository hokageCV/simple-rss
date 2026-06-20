class FetchFeedService
  require "httparty"
  require "digest"

  def initialize(url, feed: nil)
    @url = url
    @feed = feed
  end

  def call
    Timeout.timeout(30) do
      response = fetch_feed
      return failure_result unless response
      return not_modified_result if response.code == 304

      body = response.body
      return failure_result if body.blank?

      content_hash = Digest::SHA256.hexdigest(body)

      feed = parse_feed(body)
      return failure_result unless feed

      feed_data = format_feed(feed)

      {
        status: 200,
        feed_data: feed_data,
        etag: response.headers["etag"],
        last_modified: response.headers["last-modified"],
        content_hash: content_hash
      }
    end
  rescue Timeout::Error
    Rails.logger.error "⏰ Timeout fetching feed: #{@url}"
    failure_result
  rescue => e
    Rails.logger.error "🚨 Unexpected error in FetchFeedService for #{@url}: #{e.message}"
    failure_result
  end

  private

  def format_feed(feed_data)
    formatted_feed = {
      name: feed_data.try(:title).presence || "Feed Title",
      url: @url,
      articles: feed_data&.entries&.map do |entry|
        {
          title: entry.try(:title).presence || "Untitled Article",
          url: entry.url,
          description: entry.summary,
          published_at: entry.published,
          image_url: article_image_url(entry),
          content: entry.content
        }
      end
    }

    feed_data = nil
    GC.start if formatted_feed[:articles]&.size.to_i > 50

    formatted_feed
  end

  def fetch_feed
    options = { timeout: 20 }
    options[:headers] = conditional_headers if @feed

    response = HTTParty.get(@url, options)
    return response if response.code == 304
    return response if response.success?

    Rails.logger.info "🚧 Failed to fetch feed: #{@url}, HTTP Code: #{response.code}, Error: #{response.message}"
    nil
  rescue HTTParty::Error => e
    Rails.logger.info "🚧 HTTParty error while fetching feed: #{@url}, Error: #{e.message}"
    nil
  rescue StandardError => e
    Rails.logger.info "🚧 Unexpected error fetching feed: #{@url}, Error: #{e.message}"
    nil
  end

  def conditional_headers
    headers = {}
    headers["If-None-Match"] = @feed.etag if @feed.etag.present?
    headers["If-Modified-Since"] = @feed.last_modified if @feed.last_modified.present?
    headers
  end

  def parse_feed(xml)
    return nil if xml.blank?

    feed = Feedjira.parse(xml)
    return feed if feed.present?

    Rails.logger.info "🚧 Feedjira failed to parse feed: #{@url}"
    nil
  rescue StandardError => e
    Rails.logger.info "🚧 Feedjira error while parsing feed: #{@url}, Error: #{e.message}"
    nil
  end

  def article_image_url(article)
    if article.respond_to?(:media_thumbnail_url) && article.media_thumbnail_url.present? # youtube
      article.media_thumbnail_url
    elsif article.respond_to?(:enclosure_url) && article&.enclosure_url.present? # substack
      article.enclosure_url
    else
      nil
    end
  end

  def not_modified_result
    { status: 304, feed_data: nil, etag: nil, last_modified: nil, content_hash: nil }
  end

  def failure_result
    { status: 0, feed_data: nil, etag: nil, last_modified: nil, content_hash: nil }
  end
end
