class GenerateOpmlService
  def initialize(user)
    @user = user
  end

  def call
    opml_text = <<~OPML
      <?xml version="1.0" encoding="UTF-8"?>
      <opml version="2.0">
        <head>
          <title>Simple RSS subscriptions</title>
          <ownerName>#{@user.name}</ownerName>
          <ownerEmail>#{@user.email_address}</ownerEmail>
          <docs>https://opml.org/spec2.opml</docs>
        </head>
        <body>
        #{generate_outlines}
        </body>
      </opml>
    OPML

    opml_text
  end

  private

  def generate_outlines
    @user.feeds.alphabetically.map do |feed|
      "\t\t<outline type=\"rss\" text=\"#{feed.name}\" title=\"#{feed.name}\" xmlUrl=\"#{feed.url}\" />"
    end.join("\n")
  end
end
