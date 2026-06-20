class AddUniqueIndexOnFeedIdAndUrlToArticles < ActiveRecord::Migration[8.0]
  def change
    add_index :articles, [:feed_id, :url], unique: true
  end
end
