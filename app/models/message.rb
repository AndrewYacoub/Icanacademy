class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one_attached :file
  has_one_attached :image
  after_create_commit { broadcast_append_to room }
  before_create :confirm_participant
  has_one_attached :audio

  def self.ransackable_associations(auth_object = nil)
    ["audio_attachment", "audio_blob", "file_attachment", "file_blob", "image_attachment", "image_blob", "room", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "id_value", "room_id", "updated_at", "user_id"]
  end
  
  def confirm_participant
    if room.is_private
      is_participant = Participant.where(user_id: user.id, room_id: room.id).first
      throw :abort unless is_participant
    end
  end
end