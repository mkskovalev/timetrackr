class AddTelegramFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :telegram_id, :integer
    add_column :users, :telegram_username, :string
  end
end
