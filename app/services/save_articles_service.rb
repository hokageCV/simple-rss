class SaveArticlesService
  def initialize(feed, articles_data, options = {})
    @feed = feed
    @articles_data = articles_data
    @include_all_articles = options[:include_all_articles] || false
  end

  def call
    urls = @articles_data.map { |article| article[:url] }
    existing_articles_set = Set.new

    @feed.articles
      .where(url: urls)
      .find_each(batch_size: 500) { |article| existing_articles_set.add(article.url) }

    @articles_data.each do |article|
      article_not_exist = !existing_articles_set.include?(article[:url])

      if article_not_exist && include_article?(article)
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
