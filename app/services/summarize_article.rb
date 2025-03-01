class SummarizeArticle
  require "httparty"
  require "json"

  def initialize(article)
    @article = article
    @api_key = Current.user.api_key
    @instructions = fetch_instructions
  end

  def call
    input_text = @article.content
    url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=#{@api_key}"

    body = {
      contents: [
        {
          role: "user",
          parts: [ { text: input_text } ]
        }
      ],
      systemInstruction: {
        role: "user",
        parts: [ { text: @instructions } ]
      },
      generationConfig: {
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8000,
        responseMimeType: "text/plain"
      }
    }.to_json

    response = HTTParty.post(
      url,
      body: body,
      headers: { "Content-Type" => "application/json" }
    )

    handle_api_error(response) if not response.success?

    summarized_content = format_response(response)
    @article.summary = summarized_content
    @article.save
  end

  private

  def fetch_instructions
    File.read(Rails.root.join("config", "summarize_instructions.txt"))
  end

  def format_response(response)
    markdown_content = response["candidates"].first["content"]["parts"].first["text"]
    Kramdown::Document.new(markdown_content).to_html
  end

  def handle_api_error(response)
    case response.code
    when 401
      raise "Invalid API Key. Please check your key."
    when 403
      raise "Unauthorized access. API Key might not have permissions."
    when 429
      raise "Rate limit exceeded. Try again later."
    else
      raise "Something went wrong while communicating with Gemini API (#{response.code})."
    end
  end
end
