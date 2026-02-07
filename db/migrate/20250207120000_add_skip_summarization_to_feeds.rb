class AddSkipSummarizationToFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :skip_summarization, :boolean, null: false, default: false
  end
end
