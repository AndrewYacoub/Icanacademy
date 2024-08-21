class MessagesController < ApplicationController
  def create
    @message = current_user.messages.build(content: msg_params[:content],
                                           room_id: params[:room_id],
                                           file: msg_params[:file])

    # Process the audio file if present
    if params[:message][:audio].present?
      audio_data = params[:message][:audio].gsub(/^data:audio\/wav;base64,/, "")
      audio_file = StringIO.new(Base64.decode64(audio_data))
      audio_file.class.class_eval { attr_accessor :original_filename, :content_type }
      audio_file.original_filename = "recording.wav"
      audio_file.content_type = "audio/wav"
      @message.audio.attach(io: audio_file, filename: "recording.wav", content_type: "audio/wav")
    end

    if @message.save
      # Broadcast the message to other users in the room
      # Assuming you are using ActionCable for real-time messaging
      ActionCable.server.broadcast "room_#{params[:room_id]}_channel", 
                                   { message: render_message(@message) }
    else
      # Handle save failure
      render json: { error: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def msg_params
    params.require(:message).permit(:content, :file, :audio)
  end

  def render_message(message)
    ApplicationController.render(
      partial: 'messages/message',
      locals: { message: message }
    )
  end
end
