class SummarizeArticleJob < ApplicationJob
  queue_as :summarization

  RATE_LIMIT_GAP = 1.second

  def perform(article_id:)
    article = Article.find_by(id: article_id)
    return if article.blank?
    return if article.is_read?
    return if article.summary.present?

    SummarizeArticle.new(article).call

    sleep RATE_LIMIT_GAP
  end
end
