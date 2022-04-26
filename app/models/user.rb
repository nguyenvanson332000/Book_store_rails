class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  PHONE_NUMBER_REGEX = /(84|0[3|5|7|8|9])+([0-9]{8})\b/i.freeze
  ID_CARD_REGEX = /([0-9]{9})||([0-9]{8})\b/i.freeze
  before_save :downcase_email

  validates :name, :email, :password, :password_confirmation, presence: true
  validates :name,
            length: {minimum: Settings.validate.length.digist_2}

  validates :email,
            length: {maximum: Settings.validate.length.digist_255},
            format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false },
            presence: true

  validates :phone_number, presence: true,
            length: {minimum: Settings.validate.length.digist_6},
            format: {with: PHONE_NUMBER_REGEX}, uniqueness: true

  validates :id_card, presence: true,
            length: {minimum: Settings.validate.length.digist_6},
            format: {with: ID_CARD_REGEX}, uniqueness: true

  has_secure_password

  validates :password, length: { minimum: Settings.validate.length.digist_6 },
                       presence: true

  private

  def downcase_email
    email.downcase!
  end
end
