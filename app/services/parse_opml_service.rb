class ParseOpmlService
  require "nokogiri"

  def initialize(uploaded_file)
    @uploaded_file = uploaded_file
  end

  def call
    reader = Nokogiri::XML::Reader(@uploaded_file.tempfile)

    reader.map do |node|
      node.attributes["xmlUrl"] if node.name == "outline" && node.attributes["xmlUrl"]
    end.compact
  end
end
