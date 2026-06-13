class TestApiKeyService
  def initialize(provider, api_key, model)
    @provider = provider
    @api_key = api_key
    @model = model
  end

  def call
    ctx = User.build_llm_context(@provider, @api_key)

    response = ctx.chat(model: @model, provider: @provider.to_sym)
      .ask("Say ok")

    { ok: true }
  rescue RubyLLM::Error => e
    { ok: false, error: e.message }
  rescue StandardError => e
    { ok: false, error: "Unexpected error: #{e.message}" }
  end
end
