class HomeController < ApplicationController
  def index
    @user = Current.user
    @articles = @user.articles.recent_first
  end
end
