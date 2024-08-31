class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :set_group
  before_action :set_room, only: [:destroy]
  before_action :load_users_and_rooms, only: [:index, :show, :create]

  def index
    @room = @group.room.new
  end

  def create
    @room = Room.new(room_params)
    @room.group_id = @group.id
    @room.save
  end

  def show
    @single_room = @group.room
    current_user.update_without_password(room_id: @single_room.id) unless @single_room == nil

    @room = Room.new
    @message = Message.new

    @messages = @single_room.messages.order(created_at: :asc) unless @single_room == nil
    render 'index'
  end

  def destroy
    @current_room = Room.find(params[:id])
    
    # Handling dependencies manually
    @current_room.users.update_all(room_id: nil)  # or use @room.users.destroy_all if you want to delete them
  
    @current_room.destroy
    redirect_to course_group_path(@current_room.group.course, @current_room.group), notice: 'Room was successfully deleted.'
  rescue ActiveRecord::InvalidForeignKey
    redirect_to course_group_path(@current_room.group.course, @current_room.group), alert: "Cannot delete room due to associated records."
  end

  private

  def set_room
    @current_room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name)
  end

  def set_course
    @course = Course.find_by(id: params[:course_id])
    redirect_to root_path, alert: 'Course not found.' unless @course
  end

  def set_group
    @group = @course.groups.find(params[:group_id])
  end

  def load_users_and_rooms
    @users = @group.enrollments.where(status: 'approved_by_teacher').map(&:student)
    @room_creator = User.find(@course.teacher_id)
    @users <<  @room_creator
    @rooms = Room.where(group_id: @group.id)
  end
end