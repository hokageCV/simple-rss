class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :feeds, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true
  validates :password, length: { minimum: 10 }, if: -> { new_record? || changes[:password_digest] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:password_digest] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:password_digest] }
end
