class Category < ApplicationRecord
  has_many :products
  scope :order_by_title, -> { order(title: :desc).distinct }
  scope :sort_by_created, -> { order(created_at: :asc) }
  ransack_alias :category ,:title_or_content_cont
  validates :title, presence: true
  validates :content, presence: true
  validates :parent_id, numericality: { only_integer: true }, allow_blank: true
end
