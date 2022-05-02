class Product < ApplicationRecord
  has_many :rates, dependent: :destroy
  has_many :order_details, dependent: :destroy
  belongs_to :category

  delegate :title, to: :category, prefix: true
  validates :name, presence: true, length: {minimum: Settings.validate.length.length_min,
                                            message: :min_8}
  validates :price, presence: true, numericality: {greater_than_or_equal_to:
                                                  Settings.validate.length.price_min}
  validates :quantity, presence: true, numericality: {greater_than_or_equal_to:
                                                     Settings.validate.length.quantity_min}
  validates :author, presence: true
  validates :publisher, presence: true
  scope :ordered_by_price, ->{order(price: :asc)}
  scope :sort_by_created, ->{order(created_at: :desc)}
end
