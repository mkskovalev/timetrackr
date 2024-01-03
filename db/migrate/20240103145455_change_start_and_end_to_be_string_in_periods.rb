class ChangeStartAndEndToBeStringInPeriods < ActiveRecord::Migration[7.1]
  def up
    change_column :periods, :start, :string
    change_column :periods, :end, :string
  end

  def down
    change_column :periods, :start, :datetime
    change_column :periods, :end, :datetime
  end
end
