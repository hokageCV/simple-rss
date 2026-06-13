class AddProviderAndModelToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :provider, :string, default: "openai", null: false
    add_column :users, :model, :string
  end
end
