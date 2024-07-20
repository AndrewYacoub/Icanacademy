class Homework < ApplicationRecord
  belongs_to :group
  has_many :solutions, dependent: :destroy
  has_one_attached :file
  validates :title, :lesson, :description, presence: true
end
