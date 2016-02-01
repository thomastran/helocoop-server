class RemoveTokenFromLog < ActiveRecord::Migration
  def change
    remove_column :logs, :token, :string
  end
end
