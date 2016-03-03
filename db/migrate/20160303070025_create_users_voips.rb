class CreateUsersVoips < ActiveRecord::Migration
  def change
    create_table :users_voips do |t|
      t.string :phone_number
      t.string :email
      t.string :code
      t.string :address
      t.string :name
      t.string :token
      t.string :latitude
      t.string :longitude
      t.boolean :available
      t.string :instance_id
      t.string :description

      t.timestamps null: false
    end
  end
end
