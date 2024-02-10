class CreateDataConversions < ActiveRecord::Migration[7.1]
  def change
    create_table :data_conversions do |t|
      t.integer :version, default: 0
      t.datetime :completed_at

      t.timestamps
    end
  end
end
