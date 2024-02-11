class AddUniqueIndexToGoalsOnUserIdAndCategoryId < ActiveRecord::Migration[7.1]
  def change
    add_index :goals, [:user_id, :category_id], unique: true
  end
end
