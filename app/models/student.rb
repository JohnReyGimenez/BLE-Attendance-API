class Student < ApplicationRecord
  belongs_to :classroom, optional: true

  has_one :tag, dependent: :nullify
  has_many :attendance_records, dependent: :destroy

  validates :name, presence: true
  validates :student_id_number, presence: true, uniqueness: true
end
