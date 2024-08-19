class StudentsController < ApplicationController
	before_action :authenticate_user!
  def show
    @student = User.find(params[:id])
    @users = User.where.not(id: current_user&.id)

    @rooms = Room.public_rooms
    @room = Room.new
    @room_name = get_name(@student, current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@student, current_user], @room_name)
    current_user.update_without_password(room_id: @single_room.id)

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
    render 'rooms/index'
  end

  def enrolled_groups
    @groups = []
    @enrollements =  current_user.enrollments.where(status: "approved_by_teacher")
    @enrollements.each do |enrollement|
       @groups << current_user.groups.select{|group| group.id == enrollement.group_id}
    end
    @groups
  end

  private

  def get_name(user1, user2)
    users = [user1, user2].pluck(:id).sort
    "private_#{User.find(users[0]).email}_#{User.find(users[1]).email}"
  end
end