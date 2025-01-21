class AddUniqueConstraintToFeeds < ActiveRecord::Migration[8.0]
  def change
    add_index :feeds, [ :user_id, :url ], unique: true
  end
end
