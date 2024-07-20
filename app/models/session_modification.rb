class SessionModification < ApplicationRecord
  belongs_to :group
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
