json.extract! article, :id, :feed_id, :title, :url, :published_at, :user_id, :status, :created_at, :updated_at
json.url article_url(article, format: :json)
