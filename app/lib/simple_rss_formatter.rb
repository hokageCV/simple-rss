class SimpleRssFormatter < SemanticLogger::Formatters::Color
  GREY = "\e[38;5;235m"

  def time
    "#{GREY}#{super}#{color_map.clear}"
  end

  def process_info
    "#{GREY}#{super}#{color_map.clear}"
  end
end
