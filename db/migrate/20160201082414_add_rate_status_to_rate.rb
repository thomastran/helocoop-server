class AddRateStatusToRate < ActiveRecord::Migration
  def change
    add_column :rates, :rate_status, :string
  end
end
