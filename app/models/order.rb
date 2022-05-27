class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  scope :ordered_by_price, -> { order(:total_money) }
  scope :sort_by_created, -> { order(created_at: :asc) }
  scope :approved, ->{where(status: :approve)}
  scope :find_date_accept, (lambda do |date|
    where("created_at LIKE ? AND status = ?", "%#{date}%",
          Order.statuses[:approve])
  end)
  scope :is_pending, -> { where(status: :pending).count }
  scope :find_sum_day, ->{group(:status).sum(:total_money)}
  scope :find_sum_day_status_approve_a_day, (lambda do |date|
    where("created_at LIKE ? AND status = ?", "%#{date}%",
          Order.statuses[:approve]).sum(:total_money)
  end)
  delegate :email, :name, to: :user, prefix: true
  enum status: { pending: 0, approve: 1, not_accept: 2, cancel: 3 }
  validates :name_customer, presence: true,
                            length: { minimum: Settings.validate.length.digist_2 }
  validates :address, presence: true,
                      length: { minimum: Settings.validate.length.digist_6 }
  validates :phone_number, presence: true,
                           length: { minimum: Settings.validate.length.digist_6 },
                           format: { with: Settings.PHONE_NUMBER_REGEX }

  def update_status status
    update_attributes(status: status)
  end

  def cancel_order_quantity
    order_details.each do |item|
      item.product.update!(quantity: item.product.quantity + item.quantity)
    end
  end
end
