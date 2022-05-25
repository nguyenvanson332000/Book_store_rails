class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :lockable,
         :omniauthable , omniauth_providers: [:facebook, :google_oauth2]
  has_many :rates, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :suggests, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  before_save :downcase_email

  ransack_alias :user, :name_or_email_or_phone_number
  scope :order_by_name, ->{order :name}
  validates :name, presence: true,
                   length: { minimum: Settings.validate.length.digist_2 },
                   allow_nil: true

  validates :email, presence: true,
                    length: { maximum: Settings.validate.length.digist_255 },
                    format: { with: Settings.VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  validates :phone_number, presence: true,
                           length: { minimum: Settings.validate.length.digist_6 },
                           format: { with: Settings.PHONE_NUMBER_REGEX }, uniqueness: { case_sensitive: false },
                           allow_nil: true

  validates :id_card, presence: true,
                      length: { minimum: Settings.validate.length.digist_6 },
                      format: { with: Settings.ID_CARD_REGEX }, uniqueness: { case_sensitive: false },
                      allow_nil: true
  class << self
    def from_omniauth auth
      result = User.find_by email: auth.info.email
      return result if result

      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.uid = auth.uid
        user.provider = auth.provider

        user.skip_confirmation!
      end
    end
  end

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    email.downcase!
  end
end
