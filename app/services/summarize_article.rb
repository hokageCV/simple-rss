class SummarizeArticle
  require "httparty"

  def initialize(article)
    @article = article
  end

  def call
    data = HTTParty.get("https://dummyjson.com/quotes/random").body
    @article.summary = JSON.parse(data)["quote"]
    @article.save
  end
end
