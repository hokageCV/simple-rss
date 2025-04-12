class CreateFeedFolders < ActiveRecord::Migration[8.0]
  def change
    create_table :feed_folders do |t|
      t.references :feed, null: false, foreign_key: true
      t.references :folder, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :feed_folders, [:feed_id, :folder_id], unique: true
  end
end
