class AddDeleteAtToOrderDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :order_details, :deleted_at, :datetime
    add_index :order_details, :deleted_at
  end
end
