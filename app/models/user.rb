class User < ApplicationRecord
  has_secure_password

  has_many :expenses, dependent: :destroy

  before_validation { self.email = email.to_s.strip.downcase }

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "no tiene un formato válido" }
  validates :password, length: { minimum: 8 }, if: -> { password.present? || new_record? }
  validates :current_balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
