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
end
