module ArticlesHelper
  def render_summary(article)
    content_tag(:div, class: "bg-baseBg-5 p-4 max-w-screen-md rounded rounded-lg my-5", data: { controller: "read" }) do
      content_tag(:p, "Summary", class: "text-xl") +
      content_tag(:button, "Read Aloud", class: "bg-sidebarBg-5 pr-3", data: { action: "click->read#getContent" }) +
      content_tag(:button, "\u23F8", data: {  read_target: "playPauseBtn", action: "click->read#togglePlayPause" }, style: "display: none;"
      ) +
      content_tag(:div, class: " prose-rss", id: dom_id(article, :summary), data: { read_target: "summary" }) do
        raw(sanitize(article.summary))
      end
    end
  end

  def render_content(article)
    return if not article.content
    return if not [ Feed::GENERATORS[:default], Feed::GENERATORS[:substack] ].include?(article.feed.generator)

    safe_join([
      render("summary", article: article),
      render_image(article),
      content_tag(
        :article,
        sanitize(article.content),
        class: "prose-rss prose-inherit text-text-1 pb-3 max-w-screen-md"
      )
    ])
  end

  def render_image(article)
    return if article.image_url.blank?

    content_tag(:div, class: "pb-4") do
      image_tag(article.image_url, alt: article.title, class: "rounded-lg max-w-full h-auto")
    end
  end
end
