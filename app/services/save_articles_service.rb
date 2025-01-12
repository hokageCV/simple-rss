class SaveArticlesService
  def initialize(feed, articles_data, options = {})
    @feed = feed
    @articles_data = articles_data
    @include_all_articles = options[:include_all_articles] || false
  end

  def call
    @articles_data.each do |article|
      existing_article = @feed.articles.find_by(url: article[:url])

      if existing_article.nil? && (include_article?(article))
        @feed.articles.create(article.merge(user_id: @feed.user_id))
      end
    end
  end

  private

  def include_article?(article)
    # adding only last two months latest articles as default, to not bloat table
    @include_all_articles || article[:published_at] > (Time.now - 2.months)
  end
end
