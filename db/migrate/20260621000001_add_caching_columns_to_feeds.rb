class AddCachingColumnsToFeeds < ActiveRecord::Migration[8.0]
  def change
    add_column :feeds, :etag, :string
    add_column :feeds, :last_modified, :string
    add_column :feeds, :content_hash, :string
  end
end
