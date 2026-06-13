class AddFetchIntervalToFeeds < ActiveRecord::Migration[8.0]
  def change
    add_column :feeds, :last_refreshed_at, :datetime
    add_column :feeds, :fetch_interval, :integer
  end
end
