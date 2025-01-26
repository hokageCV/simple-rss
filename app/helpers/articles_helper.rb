module ArticlesHelper
  def render_summary(article)
    content_tag(:div, class: "bg-baseBg-5 p-4 max-w-screen-md rounded rounded-lg my-5") do
      content_tag(:p, "Summary", class: "text-xl") +
      content_tag(:div, class: " prose-rss", id: dom_id(article, :summary)) do
        raw(sanitize(article.summary))
      end
    end
  end
end
