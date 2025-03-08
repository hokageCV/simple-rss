class FeedManager
  def self.fetch_feeds(feed_urls)
    all_feeds_data = []
    failed_feeds = []

    threads = feed_urls.map do |url|
      Thread.new do
        feed_data = FetchFeedService.new(url).call

        if feed_data
          all_feeds_data << { url: url, name: feed_data[:name], articles: feed_data[:articles] }
        else
          failed_feeds << url
        end
      end
    end

    # doing some operation with threads so that it finishes, and function doesn't return before their execution
    threads.each(&:join)

    { feeds: all_feeds_data, failed: failed_feeds }
  end

  def self.insert_new_feeds(user_id, feeds_data)
    return [] if feeds_data.empty?

    new_feeds_data = feeds_data.map do |feed|
      { user_id: user_id, url: feed[:url], name: feed[:name], created_at: Time.current, updated_at: Time.current }
    end
    return [] if new_feeds_data.empty?

    Feed.insert_all(new_feeds_data, returning: %w[id url])
  end

  def self.save_feed_articles(feeds_data, feed_id_map = nil)
    feed_id_map =
      if feed_id_map.present?
        feed_id_map
      else
        feed_urls = feeds_data.map { |feed_data| feed_data[:url] }
        Feed
          .where(url: feed_urls)
          .index_by(&:url)
          .transform_values { |f| { "id" => f.id } }
      end

    feed_records = Feed.where(id: feed_id_map.values.map { |f| f["id"] }).index_by(&:id)

    feeds_data.each do |feed_data|
      feed_id = feed_id_map.dig(feed_data[:url], "id")
      next if not feed_id

      feed = feed_records[feed_id]
      SaveArticlesService.new(feed, feed_data[:articles]).call
    end
  end
end
