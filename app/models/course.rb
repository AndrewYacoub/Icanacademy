class Course < ApplicationRecord
    belongs_to :teacher
    has_many :groups, dependent: :destroy

    validates :title, presence: true
    validates :description, length: { minimum: 10 }
end
  