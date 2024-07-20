class TeachersController < ApplicationController
    before_action :authenticate_user!

    def search
        if params[:query].present?
            @teachers = Teacher.where("email LIKE ?", "%#{params[:query]}%")  # Adjust according to your User model
        else
            @teachers = Teacher.all  # Or limit to some default scope
        end
    end

    def show
        @teacher = User.find(params[:id])
        @course = @teacher.courses.first
        @groups = @teacher.courses.first.groups

        @users = User.where.not(id: current_user&.id)

        @rooms = Room.public_rooms
        @room = Room.new
        @room_name = get_name(@teacher, current_user)
        @single_room = Room.where(name: @room_name).first || Room.create_private_room([@teacher, current_user], @room_name)
        current_user.update_without_password(room_id: @single_room.id)

        @message = Message.new
        @messages = @single_room.messages.order(created_at: :asc)
        render 'rooms/index'
    end

    def pending_enrollments
        @pending_enrollments = Enrollment.where(status: :pending_teacher_approval)
    end

    private

    def get_name(user1, user2)
        users = [user1, user2].pluck(:id).sort
        "private_#{User.find(users[0]).email}_#{User.find(users[1]).email}"
    end
end