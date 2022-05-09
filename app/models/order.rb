class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  scope :ordered_by_price, ->{order(:total_money)}
  enum status: {pending: 0, approve: 1, not_accept: 2, cancel: 3}
  validates :name_customer, presence: true,
            length: {minimum: Settings.validate.length.digist_2}
  validates :address, presence: true,
            length: {minimum: Settings.validate.length.digist_6}
  validates :phone_number, presence: true,
            length: {minimum: Settings.validate.length.digist_6},
            format: {with: Settings.PHONE_NUMBER_REGEX}
end
