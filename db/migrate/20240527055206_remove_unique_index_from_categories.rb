class RemoveUniqueIndexFromCategories < ActiveRecord::Migration[7.1]
  def up
    remove_index :categories, name: "index_categories_on_parent_id_and_position"
  end

  def down
    add_index :categories, [:parent_id, :position], unique: true, name: "index_categories_on_parent_id_and_position"
  end
end
