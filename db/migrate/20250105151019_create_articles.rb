class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.references :feed, null: false, foreign_key: { on_delete: :cascade }
      t.string :title, null: false
      t.string :url, null: false
      t.datetime :published_at
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.string :status, default: 'unread'
      t.text :content
      t.text :description

      t.timestamps
    end
  end
end
