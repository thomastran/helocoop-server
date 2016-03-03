class CreateLogVoips < ActiveRecord::Migration
  def change
    create_table :log_voips do |t|
      t.string :id_conference
      t.string :name_room
      t.string :time
      t.string :participants
      t.string :caller
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
