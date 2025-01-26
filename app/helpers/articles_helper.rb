module ArticlesHelper
  def render_summary(article)
    content_tag(:div, class: "bg-baseBg-5 p-4 max-w-fit rounded rounded-lg my-5") do
      content_tag(:p, "Summary", class: "text-xl") +
      content_tag(:div, class: "text-sm", id: dom_id(article, :summary)) do
        content_tag(:p, article.summary)
      end
    end
  end
end
