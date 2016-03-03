class CreateRateVoips < ActiveRecord::Migration
  def change
    create_table :rate_voips do |t|
      t.integer :user_id
      t.integer :voter_id
      t.string :voter_name
      t.string :user_name
      t.string :room_name
      t.string :rate_status
      t.integer :log_id

      t.timestamps null: false
    end
  end
end
