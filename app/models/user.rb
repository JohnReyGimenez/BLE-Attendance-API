class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :role, { student: 0, teacher: 1 }, default: :student

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
