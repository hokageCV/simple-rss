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
    return render_youtube_content(article) if article.feed.generator == Feed::GENERATORS[:youtube]
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

  def render_youtube_content(article)
    safe_join([
      render_youtube_hero(article),
      render_youtube_actions(article),
      render_youtube_description(article)
    ])
  end

  def render_youtube_hero(article)
    return unless article.image_url.present?

    content_tag(:div, class: "my-6 rounded-xl overflow-hidden border border-baseBg-3/30") do
      image_tag(article.image_url, alt: article.title,
                class: "w-full aspect-video object-cover")
    end
  end

  def render_youtube_actions(article)
    content_tag(:div, class: "flex flex-wrap items-center gap-3 my-5") do
      safe_join([
        link_to(article.url, target: "_blank", rel: "noopener noreferrer",
          class: "inline-flex items-center gap-2 px-5 py-2.5 bg-red-600 hover:bg-red-700 text-white text-sm font-medium rounded-lg transition-colors") do
          safe_join([
            content_tag(:svg, class: "w-4 h-4", fill: "currentColor", viewBox: "0 0 24 24") do
              "<path d='M19.615 3.184c-3.604-.246-11.631-.245-15.23 0-3.897.266-4.356 2.62-4.385 8.816.029 6.185.484 8.549 4.385 8.816 3.6.245 11.626.246 15.23 0 3.897-.266 4.356-2.62 4.385-8.816-.029-6.185-.484-8.549-4.385-8.816zm-10.615 12.816v-8l8 3.993-8 4.007z'/>".html_safe
            end,
            "Watch on YouTube"
          ])
        end,
        link_to(article.feed, class: "inline-flex items-center gap-1.5 px-4 py-2.5 text-text-3 hover:text-accent text-sm font-medium transition-colors") do
          safe_join([
            content_tag(:svg, class: "w-4 h-4", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do
              "<path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9'/>".html_safe
            end,
            article.feed.name
          ])
        end
      ])
    end
  end

  def render_youtube_description(article)
    return unless article.description.present?

    content_tag(:div, class: "prose-rss prose-inherit text-text-1 pb-3 max-w-screen-md") do
      safe_join([
        content_tag(:h3, "Description", class: "text-xl font-semibold mb-3 mt-6 text-text-2"),
        content_tag(:div, sanitize(article.description), class: "text-text-3 text-base leading-relaxed")
      ])
    end
  end
end
