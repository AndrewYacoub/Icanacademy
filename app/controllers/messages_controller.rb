class MessagesController < ApplicationController
  def create
    @message = current_user.messages.create(content: msg_params[:content],
                                            room_id: params[:room_id],
                                            file: msg_params[:file])

  end

  private

  def msg_params
    params.require(:message).permit(:content, :file)
  end
end