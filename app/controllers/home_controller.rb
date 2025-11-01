class HomeController < ApplicationController
  before_action :set_user

  def index
    @articles = @user.articles
      .includes(:feed)
      .where(feeds: { is_paused: false })
      .unread.recent_first.last_two_weeks
  end

  def update_feeds
    GC.start

    user_feeds = @user.feeds.active
    feed_urls = user_feeds.pluck(:url)

    result = FeedManager.fetch_feeds(feed_urls)
    all_feeds_data = result[:feeds]
    FeedManager.save_feed_articles(all_feeds_data)

    GC.start

    redirect_to home_index_path
  rescue => e
    Rails.logger.error "🚨 Error updating feeds: #{e.message}"
    redirect_to home_index_path, alert: "Failed to update some feeds. Please try again."
  end

  private

  def set_user
    @user = Current.user
  end
end
