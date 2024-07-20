class Enrollment < ApplicationRecord
    belongs_to :group
    belongs_to :student
  
    # Validate uniqueness of student within the same group
    validates :student_id, uniqueness: { scope: :group_id, message: "is already enrolled in this group" }
    def self.ransackable_associations(auth_object = nil)
      %w[student group]  # Array of associations that are safe to search
    end

    def self.ransackable_attributes(auth_object = nil)
      %w[id student_id group_id status created_at updated_at]  # Safely searchable attributes
    end

    enum status: {
      pending_admin_approval: 0,
      declined_by_admin: 1,    # Added status for admin decline
      pending_teacher_approval: 2,
      approved_by_teacher: 3,
      declined_by_teacher: 4,  # Added status for teacher decline
      fully_approved: 5        # Final approval state
    }
  end
  