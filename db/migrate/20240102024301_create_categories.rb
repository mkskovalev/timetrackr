class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id, index: true

      t.timestamps
    end

    add_reference :periods, :category, index: true
  end
end
