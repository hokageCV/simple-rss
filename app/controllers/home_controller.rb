class HomeController < ApplicationController
  def index
    @articles = @user.articles
  end
end
