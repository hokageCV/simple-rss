class FetchFeedService
  require "httparty"

  def initialize(url)
    @url = url
  end

  def call
    response = fetch_feed
    return nil if response.body.nil?

    feed = parse_feed(response.body)
    return nil if feed.nil?

    format_feed(feed)
  end

  private

  def format_feed(feed_data)
    {
      name: feed_data.title,
      url: @url,
      articles: feed_data.entries.map do |entry|
        {
          title: entry.title,
          url: entry.url,
          description: entry.summary,
          published_at: entry.published,
          image_url: article_image_url(entry),
          content: entry.content
        }
      end
    }
  end

  def fetch_feed
    response = HTTParty.get(@url)
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
    feed = Feedjira.parse(xml)
    return feed if feed

    Rails.logger.info "🚧 Feedjira failed to parse feed: #{@url}"
    nil
  rescue StandardError => e
    Rails.logger.info "🚧 Feedjira error while parsing feed: #{@url}, Error: #{e.message}"
    nil
  end

  def article_image_url(article)
    if article.media_thumbnail_url.present? # youtube
      article.media_thumbnail_url
    elsif article.enclosure_url.present? # substack
      article.enclosure_url
    else
      nil
    end
  end
end
