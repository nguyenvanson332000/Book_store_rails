class Product < ApplicationRecord
  acts_as_paranoid
  has_many :rates, dependent: :destroy
  has_many :order_details, dependent: :destroy
  belongs_to :category
  has_one_attached :image

  ransack_alias :product, :name_or_author_cont
  delegate :title, to: :category, prefix: true
  enum statuses: { Hot: 0, New: 1, Trend: 2 }
  validates :name, presence: true, length: { minimum: Settings.validate.length.length_min,
                                             message: :min_8 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: Settings.validate.length.price_min }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: Settings.validate.length.quantity_min }
  validates :author, presence: true
  validates :publisher, presence: true
  validates :image, content_type: { in: %w(image/jpeg image/gif image/png),
                                    message: I18n.t("image.invalid") },
                    size: { less_than: 5.megabytes, message: I18n.t("image.min") }
  scope :ordered_by_price, -> { order(price: :asc) }
  scope :ordered_by_price_desc, -> { order(price: :desc) }
  scope :sort_by_created, -> { order(created_at: :desc) }
  scope :total_categori, ->(id) { where(category_id: id).size }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :by_status, ->(id) { where(status: id) if id.present? }
  scope :search_publisher, ->(publisher) { where(publisher: publisher) }
  scope :total_publisher, ->(publisher) { where(publisher: publisher).size }
  scope :search_author, ->(author) { where(author: author) }
  # scope :total_quantity_by_order_detail, ->(id) { where(id: id).sum(:quantity) }
  scope :total_sales_of_all_books, -> { joins(:order_details).sum(:quantity) }

  def display_image
    image.variant resize_to_limit: [120, 120]
  end

  def display_image_client
    image.variant resize_to_limit: [150, 150]
  end

  def display_image_client_update
    image.variant resize_to_limit: [250, 250]
  end

  def display_image_client_show
    image.variant resize_to_limit: [500, 500]
  end

  def check_enough_quantity?(quantity_params)
    quantity_params.positive? && quantity >= quantity_params
  end
end
