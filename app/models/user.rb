class User < ApplicationRecord
  has_many :rates, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :suggests, dependent: :destroy
  attr_accessor :remember_token

  before_save :downcase_email

  validates :name, :email, :password, :password_confirmation, presence: true
  validates :name,
            length: {minimum: Settings.validate.length.digist_2}

  validates :email,
            length: {maximum: Settings.validate.length.digist_255},
            format: {with: Settings.VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  validates :phone_number, presence: true,
            length: {minimum: Settings.validate.length.digist_6},
            format: {with: Settings.PHONE_NUMBER_REGEX}, uniqueness: {case_sensitive: false}

  validates :id_card, presence: true,
            length: {minimum: Settings.validate.length.digist_6},
            format: {with: Settings.ID_CARD_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password

  validates :password,
            length: {minimum: Settings.validate.length.digist_6}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def downcase_email
    email.downcase!
  end
end
