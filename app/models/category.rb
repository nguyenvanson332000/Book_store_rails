class Category < ApplicationRecord
  has_many :products
  scope :order_by_title, -> {order(title: :desc).distinct}
end
