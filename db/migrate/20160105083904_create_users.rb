class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone_number
      t.string :email
      t.string :code
      t.string :address
      t.string :name

      t.timestamps null: false
    end
  end
end
