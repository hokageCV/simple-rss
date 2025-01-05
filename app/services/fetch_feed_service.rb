class FetchFeedService
  require "httparty"

  def initialize(url)
    @url = url
  end

  def call
    xml = HTTParty.get(@url).body
    feed = Feedjira.parse(xml)
    return nil unless feed

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
          summary: entry.summary,
          published: entry.published,
          content: entry.content
        }
      end
    }
  end
end
