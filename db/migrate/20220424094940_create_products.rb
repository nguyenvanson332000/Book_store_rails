class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :quantity
      t.decimal :price
      t.string :status
      t.string :author
      t.string :publisher
      t.text :description
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
