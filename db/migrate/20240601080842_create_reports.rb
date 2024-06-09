class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :unique_identifier, null: false
      t.string :pass, null: false

      t.timestamps
    end
    add_index :reports, :unique_identifier, unique: true
  end
end
