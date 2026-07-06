class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy, inverse_of: :project

  validates :name, presence: true, length: { maximum: 255 }
end
