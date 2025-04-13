class ParseOpmlService
  require "nokogiri"

  def initialize(uploaded_file)
    @uploaded_file = uploaded_file
  end

  def call
    content = @uploaded_file.tempfile.read
    sanitized_file = content.gsub(/&(?!\w+;|#\d+;)/, "&amp;")
    reader = Nokogiri::XML::Reader(sanitized_file)

    reader.map do |node|
      node.attributes["xmlUrl"] if node.name == "outline" && node.attributes["xmlUrl"]
    end.compact
  end
end
