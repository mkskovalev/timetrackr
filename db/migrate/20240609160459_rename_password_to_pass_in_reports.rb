class RenamePasswordToPassInReports < ActiveRecord::Migration[7.1]
  def change
    rename_column :reports, :password, :pass
  end
end
