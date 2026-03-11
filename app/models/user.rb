class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Define our two roles. Anyone who signs up is a student by default.
  enum :role, { student: 0, teacher: 1 }, default: :student

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
