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
    feeds = @user.feeds.includes(:folders).alphabetically
    by_folder = feeds.each_with_object({}) do |feed, hash|
      if feed.folders.any?
        feed.folders.each { |folder| (hash[folder.name] ||= []) << feed }
      else
        (hash[nil] ||= []) << feed
      end
    end

    lines = []

    by_folder.each do |folder_name, folder_feeds|
      if folder_name
        lines << "\t\t<outline text=\"#{folder_name}\" title=\"#{folder_name}\">"
        folder_feeds.each { |f| lines << feed_outline(f, depth: 3) }
        lines << "\t\t</outline>"
      else
        folder_feeds.each { |f| lines << feed_outline(f, depth: 2) }
      end
    end

    lines.join("\n")
  end

  def feed_outline(feed, depth:)
    tabs = "\t" * depth
    "#{tabs}<outline type=\"rss\" text=\"#{feed.name}\" title=\"#{feed.name}\" xmlUrl=\"#{feed.url}\" />"
  end
end
