class CreateExternalAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :external_accounts do |t|
      t.references :user, null: false, foreign_key: true

      t.string   :provider, null: false
      t.text     :access_token, null: false
      t.jsonb    :metadata, null: false, default: {}
      t.datetime :connected_at, null: false

      t.timestamps
    end

    add_index :external_accounts, [ :user_id, :provider ], unique: true
  end
end
