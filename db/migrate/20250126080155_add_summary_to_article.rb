class AddSummaryToArticle < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :summary, :text, default: ""
  end
end
