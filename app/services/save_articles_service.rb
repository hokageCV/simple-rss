class SaveArticlesService
  def initialize(feed, articles_data)
    @feed = feed
    @articles_data = articles_data
  end

  def call
    @articles_data.each do |article|
      existing_article = @feed.articles.find_by(url: article[:url])

      # adding only last two months latest articles, to not bloat table
      if existing_article.nil? && article[:published_at] > (Time.now - 2.months)
        @feed.articles.create(article.merge(user_id: @feed.user_id))
      end
    end
  end

end
