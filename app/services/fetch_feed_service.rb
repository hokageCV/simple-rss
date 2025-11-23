class FetchFeedService
  require "httparty"

  def initialize(url)
    @url = url
  end

  def call
    Timeout.timeout(30) do
      response = fetch_feed
      return nil if response&.body&.blank?

      feed = parse_feed(response&.body)
      return nil if feed&.nil?

      format_feed(feed)
    end
  rescue Timeout::Error
    Rails.logger.error "⏰ Timeout fetching feed: #{@url}"
    nil
  rescue => e
    Rails.logger.error "🚨 Unexpected error in FetchFeedService for #{@url}: #{e.message}"
    nil
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
    response = HTTParty.get(@url, timeout: 20)
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
end
