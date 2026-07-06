class Task < ApplicationRecord
  belongs_to :project, inverse_of: :tasks

  validates :title, presence: true, length: { maximum: 255 }
  validates :completed, inclusion: { in: [ true, false ] }
end
