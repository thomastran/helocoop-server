class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :id_conference
      t.string :name_room
      t.date :date_created
      t.string :time
      t.string :participants
      t.string :caller

      t.timestamps null: false
    end
  end
end
