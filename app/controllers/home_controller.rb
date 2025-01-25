class HomeController < ApplicationController
  def index
    @user = Current.user
    @articles = @user.articles.unread.recent_first.of_this_week
  end
end
