class HomeController < ApplicationController
  before_action :set_user

  def index
    @articles = @user.articles.includes(:feed).unread.recent_first.of_this_week
  end

  def update_feeds
    @user.feeds.each do |feed|
      feed_data = FetchFeedService.new(feed.url).call
      SaveArticlesService.new(feed, feed_data[:articles]).call
    end

    @articles = @user.articles.unread.recent_first.of_this_week
    redirect_to home_index_path
  end

  private

  def set_user
    @user = Current.user
  end
end
