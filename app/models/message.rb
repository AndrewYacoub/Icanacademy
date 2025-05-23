class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one_attached :file
  has_one_attached :image
  after_create_commit { broadcast_append_to room }
  before_create :confirm_participant
  has_one_attached :audio

  def confirm_participant
    if room.is_private
      is_participant = Participant.where(user_id: user.id, room_id: room.id).first
      throw :abort unless is_participant
    end
  end
end