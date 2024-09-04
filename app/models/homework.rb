class Homework < ApplicationRecord
  belongs_to :group
  has_many :solutions, dependent: :destroy
  has_one_attached :file
  validates :title, :lesson, :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "google_form_id", "google_form_link", "group_id", "id", "id_value", "lesson", "link", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["file_attachment", "file_blob", "group", "solutions"]
  end
  
end
