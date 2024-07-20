class Teacher < User
    has_many :courses, foreign_key: 'teacher_id', dependent: :destroy
end