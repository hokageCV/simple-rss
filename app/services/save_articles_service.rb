class SaveArticlesService
  def initialize(feed, articles_data, options = {})
    @feed = feed
    @articles_data = articles_data
    @include_all_articles = options[:include_all_articles] || false
  end

  def call
    return if @articles_data.blank?

    new_articles = @articles_data.filter { |article| include_article?(article) }
    return if new_articles.blank?

    @feed.articles.insert_all(
      new_articles.map { |article| article.merge(user_id: @feed.user_id) },
      unique_by: :index_articles_on_feed_id_and_url
    )

    if should_summarize_articles?
      new_article_urls = new_articles.map { |article| article[:url] }
      article_ids = @feed.articles.where(url: new_article_urls).pluck(:id)
      article_ids.each { |id| SummarizeArticleJob.perform_later(article_id: id) }
    end
  end

  private

  def include_article?(article)
    @time_threshold ||= 2.weeks.ago
    @include_all_articles || article[:published_at] > @time_threshold
  end

  def should_summarize_articles?
    @feed.user.ai_configured? && !@feed.skip_summarization
  end
end
