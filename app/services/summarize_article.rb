class SummarizeArticle
  require "httparty"
  require "json"

  def initialize(article)
    @article = article
    @api_key = ENV["GEMINI_API_KEY"]
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
      headers: { "Content-Type" => "application/json"}
    )

    if not response.success?
      raise "Error: #{response.code} - #{response.message}"
    end

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
end
