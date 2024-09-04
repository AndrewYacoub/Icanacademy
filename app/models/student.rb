class Student < User
    has_many :enrollments, foreign_key: :student_id, dependent: :destroy
    has_many :groups, through: :enrollments
    has_many :courses, through: :groups

    def self.ransackable_attributes(auth_object = nil)
        ["address", "confirmation_sent_at", "confirmation_token", "confirmed_at", "country", "created_at", "current_sign_in_at", "current_sign_in_ip", "education_level", "email", "encrypted_password", "first_name", "id", "id_value", "last_name", "last_seen_at", "last_sign_in_at", "last_sign_in_ip", "parent_phone_number", "phone_number", "profile_picture_url", "remember_created_at", "reset_password_sent_at", "reset_password_token", "room_id", "sign_in_count", "teaching", "type", "unconfirmed_email", "updated_at"]
    end
end