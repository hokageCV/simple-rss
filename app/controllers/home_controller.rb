class HomeController < ApplicationController
  before_action :set_user

  def index
    @articles = @user.articles.includes(:feed).unread.recent_first.last_two_weeks
  end

  def update_feeds
    user_feeds = @user.feeds
    feed_urls = user_feeds.pluck(:url)

    result = FeedManager.fetch_feeds(feed_urls)
    all_feeds_data = result[:feeds]
    FeedManager.save_feed_articles(all_feeds_data)

    @articles = @user.articles.unread.recent_first.of_this_week
    redirect_to home_index_path
  end

  private

  def set_user
    @user = Current.user
  end
end
