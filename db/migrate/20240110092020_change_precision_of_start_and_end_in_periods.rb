class ChangePrecisionOfStartAndEndInPeriods < ActiveRecord::Migration[7.1]
  def up
    change_column :periods, :start, 'timestamp(0) without time zone USING start::timestamp(0) without time zone'
    change_column :periods, :end, 'timestamp(0) without time zone USING "end"::timestamp(0) without time zone'
  end

  def down
    change_column :periods, :start, 'timestamp USING start::timestamp'
    change_column :periods, :end, 'timestamp USING "end"::timestamp'
  end
end
