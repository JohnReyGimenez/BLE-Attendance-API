class Classroom < ApplicationRecord
  has_many :students, dependent: :nullify

  validates :name, presence: true

  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.archived ||= false
  end
end
