class AddUserRefToCategoryAndPeriod < ActiveRecord::Migration[7.1]
  def change
    add_reference :categories, :user, null: false, foreign_key: true
    add_reference :periods, :user, null: false, foreign_key: true
  end
end
