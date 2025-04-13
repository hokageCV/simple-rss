class AddImageUrlToArticle < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :image_url, :string, null: true
  end
end
