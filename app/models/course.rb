class Course < ApplicationRecord
    belongs_to :teacher
    has_many :groups, dependent: :destroy

    validates :title, presence: true
    validates :description, length: { minimum: 10 }
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "description", "id", "id_value", "teacher_id", "title", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["groups", "teacher"]
    end
end
  