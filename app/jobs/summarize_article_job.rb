class SummarizeArticleJob < ApplicationJob
  queue_as :summarization

  retry_on RubyLLM::RateLimitError, attempts: 5, wait: :exponentially_longer
  retry_on StandardError, attempts: 3

  def perform(article_id)
    article = Article.find_by(id: article_id)
    return if article.blank?
    return if article.summary.present?
    return if article.user.api_key.blank?

    SummarizeArticle.new(article).call
  rescue RubyLLM::AuthenticationError => e
    Rails.logger.error("Summarization auth error: #{e.message}")
  end
end
