class AddIsPausedToFeeds < ActiveRecord::Migration[8.0]
  def change
    add_column :feeds, :is_paused, :boolean, default: false
    add_column :feeds, :generator, :string, default: ""

    Feed.update_all(is_paused: false, generator: "")

    change_column_null :feeds, :is_paused, false
    change_column_null :feeds, :generator, false
  end
end
