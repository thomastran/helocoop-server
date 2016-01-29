class RemoveDateCreatedFromLogs < ActiveRecord::Migration
  def change
    remove_column :logs, :date_created, :date
  end
end
