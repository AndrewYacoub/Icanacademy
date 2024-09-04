class Session < ApplicationRecord
    belongs_to :group
    def self.ransackable_associations(auth_object = nil)
        ["group", "course"]
    end

    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "duration", "end_time", "google_meet_link", "group_id", "id", "id_value", "recurrence_days", "start_time", "updated_at"]
    end
end
  