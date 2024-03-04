class AddPositionToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :position, :integer, default: 0

    Category.reset_column_information

    Category.order(:parent_id, :id).select(:id, :parent_id).group_by(&:parent_id).each do |parent_id, categories|
      categories.each_with_index do |category, index|
        Category.where(id: category.id).update_all(position: index + 1)
      end
    end

    change_column_null :categories, :position, false
    change_column_default :categories, :position, nil

    add_index :categories, [:parent_id, :position], unique: true
  end
end
