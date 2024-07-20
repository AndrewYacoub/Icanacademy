class Student < User
    has_many :enrollments, foreign_key: :student_id, dependent: :destroy
    has_many :groups, through: :enrollments
    has_many :courses, through: :groups
end