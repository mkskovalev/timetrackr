class AddLevelToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :level, :integer, default: 0
  end
end
