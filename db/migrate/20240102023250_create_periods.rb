class CreatePeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :periods do |t|
      t.date :start
      t.date :end

      t.timestamps
    end
  end
end
