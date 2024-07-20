class Solution < ApplicationRecord
  belongs_to :homework
  belongs_to :user
  has_one_attached :file
  validates :file, presence: true
end
