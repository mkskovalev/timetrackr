class ChangeStartAndEndToBeStringInPeriods < ActiveRecord::Migration[7.1]
  def up
    change_column :periods, :start, :string
    change_column :periods, :end, :string
  end

  def down
    change_column :periods, :start, 'timestamp using start::timestamp without time zone'
    change_column :periods, :end, 'timestamp using "end"::timestamp without time zone'
  end
end
