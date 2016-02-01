class AddRoomNameToRate < ActiveRecord::Migration
  def change
    add_column :rates, :room_name, :string
  end
end
