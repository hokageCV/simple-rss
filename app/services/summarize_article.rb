class SummarizeArticle
  def initialize(article)
    @article = article
    @instructions = summarize_instructions
    @provider = article.user.provider
    @model = article.user.model
    @user_context = article.user.llm_context
  end

  def call
    response = RubyLLM::Instrumentation.with(user_id: @article.user_id) do
      @user_context
        .chat(model: @model, provider: @provider.to_sym)
        .with_instructions(@instructions)
        .with_temperature(0.4)
        .ask(@article.content)
    end

    @article.summary = Kramdown::Document.new(response.content).to_html
    @article.save
  rescue RubyLLM::Error => e
    handle_gem_error(e)
  end

  private

  def summarize_instructions
    ENV.fetch("SUMMARIZE_INSTRUCTIONS")
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
