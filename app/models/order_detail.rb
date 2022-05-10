class OrderDetail < ApplicationRecord
  acts_as_paranoid
  belongs_to :order
  belongs_to :product
  before_save :set_total_price
  after_create :change_product_quantity

  delegate :name, :price, :image, to: :product, prefix: true
  validate :product_present
  validate :order_present

  def unit_price
    if persisted?
      self[:price]
    else
      product.price
    end
  end

  def total_price
    unit_price * quantity
  end

  private

  def set_total_price
    self[:price] = total_price
  end

  def change_product_quantity
    product.update(quantity: product.quantity - quantity)
  end

  def product_present
    return if product.present?

    errors.add(:product, I18n.t("product.not_valid"))
  end

  def order_present
    return if order.present?

    errors.add(:order, I18n.t("order.not_valid"))
  end
end
