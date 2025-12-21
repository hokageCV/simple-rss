class SaveArticleToRaindrop
  def initialize(article:, user:)
    @article = article
    @user = user
  end

  def call
    raindrop_account = user.external_accounts.find_by!(provider: "raindrop")

    Providers::Raindrop::Exporter
      .new(raindrop_account)
      .export(article)

    article.toggle_status!
  end

  private

  attr_reader :article, :user
end
