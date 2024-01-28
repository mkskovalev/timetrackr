class AddColorToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :color, :string, default: 'bg-white'
  end
end
