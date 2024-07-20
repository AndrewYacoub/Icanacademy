class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    chat_room = ChatRoom.find(params[:chat_room_id])
    stream_from "chat_room_#{chat_room.id}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    chat_room = ChatRoom.find(data['chat_room_id'])
    message = chat_room.messages.create!(content: data['message'], user: current_user)
    ActionCable.server.broadcast "chat_room_#{chat_room.id}_channel", message: render_message(message)
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
