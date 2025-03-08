class SaveArticlesService
  def initialize(feed, articles_data, options = {})
    @feed = feed
    @articles_data = articles_data
    @include_all_articles = options[:include_all_articles] || false
  end

  def call
    return if @articles_data.empty?

    urls = @articles_data.map { |article| article[:url] }
    existing_articles_set = Set.new(@feed.articles.where(url: urls).pluck(:url))

    new_articles = @articles_data.filter do |article|
      article_not_exist = !existing_articles_set.include?(article[:url])
      article_not_exist && include_article?(article)
    end
    return if new_articles.empty?

    @feed.articles.insert_all(
      new_articles.map { |article| article.merge(user_id: @feed.user_id) }
    )
  end

  private

  def include_article?(article)
    @time_threshold ||= 2.weeks.ago
    @include_all_articles || article[:published_at] > @time_threshold
  end
end
