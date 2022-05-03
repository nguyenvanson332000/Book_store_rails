class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :role
      t.string :password_digest
      t.string :id_card
      t.string :phone_number
      t.string :address

      t.timestamps
    end
  end
end
