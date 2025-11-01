class FeedManager
  def self.fetch_feeds(feed_urls)
    all_feeds_data = []
    failed_feeds = []

    feed_urls.each_with_index do |url, index|
      begin
        feed_data = FetchFeedService.new(url).call

        if feed_data
          all_feeds_data << { url: url, name: feed_data[:name], articles: feed_data[:articles] }
        else
          failed_feeds << url
        end
      rescue => e
        failed_feeds << url
        Rails.logger.error "🚨 Error processing feed #{url}: #{e.message}"
      end

      GC.start if (index + 1) % 5 == 0
    end

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
    return if feeds_data.empty?

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

    feeds_data.each_with_index do |feed_data, index|
      begin
        feed_id = feed_id_map.dig(feed_data[:url], "id")
        next unless feed_id

        feed = Feed.find_by(id: feed_id)
        next unless feed

        SaveArticlesService.new(feed, feed_data[:articles]).call

        GC.start if (index + 1) % 3 == 0
      rescue => e
        Rails.logger.error "🚨 Error saving articles for feed #{feed_data[:url]}: #{e.message}"
      end
    end
  end
end
