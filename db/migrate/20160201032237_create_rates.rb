class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.integer :user_id
      t.float :point
      t.integer :voter_id
      t.string :voter_name
      t.integer :log_id

      t.timestamps null: false
    end
  end
end
