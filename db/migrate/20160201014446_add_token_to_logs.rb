class AddTokenToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :token, :string
  end
end
