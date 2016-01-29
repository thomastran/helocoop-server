class AddDateCreatedToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :date_created, :datetime
  end
end
