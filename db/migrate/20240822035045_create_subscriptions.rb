class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :subscription_type, null: false
      t.boolean :email, default: false
      t.boolean :telegram, default: false
      t.timestamps
    end

    add_index :subscriptions, [:user_id, :subscription_type], unique: true
  end
end
