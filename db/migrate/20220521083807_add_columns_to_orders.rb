class AddColumnsToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :paid, :boolean, :default => false
    add_column :orders, :token, :string
  end
end
