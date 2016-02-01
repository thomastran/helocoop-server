class RemoveDateCreatedFromLog < ActiveRecord::Migration
  def change
    remove_column :logs, :date_created, :string
  end
end
