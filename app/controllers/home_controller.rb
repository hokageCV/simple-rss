class HomeController < ApplicationController
  def index
    @user = Current.user
    @articles = @user.articles
  end
end
