# app/models/chat_room.rb
class ChatRoom < ApplicationRecord
    has_many :messages, dependent: :destroy
  end
  
  # app/models/message.rb
  class Message < ApplicationRecord
    belongs_to :user
    belongs_to :chat_room
  
    after_create_commit { MessageBroadcastJob.perform_later(self) }
  end
  
  # app/models/user.rb
  class User < ApplicationRecord
    has_many :messages
  end
  