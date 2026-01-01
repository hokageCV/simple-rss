class SummarizeArticle
  def initialize(article)
    @article = article
    @instructions = summarize_instructions

    @user_context = RubyLLM.context do |config|
      config.openai_api_key = Current.user.api_key
    end
  end

  def call
    response = @user_context
      .chat(model: summarize_model, provider: :openai)
      .with_instructions(@instructions)
      .with_temperature(0.4)
      .ask(@article.content)

    @article.summary = Kramdown::Document.new(response.content).to_html
    @article.save
  rescue RubyLLM::Error => e
    handle_gem_error(e)
  end

  private

  def summarize_instructions
    ENV.fetch("SUMMARIZE_INSTRUCTIONS")
  end

  def summarize_model
    ENV.fetch("SUMMARIZE_MODEL")
  end

  def handle_gem_error(error)
    case error
    when RubyLLM::AuthenticationError
      raise "Invalid API Key."
    when RubyLLM::RateLimitError
      raise "Rate limit exceeded."
    else
      raise "AI Error: #{error.message}"
    end
  end
end
