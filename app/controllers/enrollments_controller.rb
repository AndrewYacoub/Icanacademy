class EnrollmentsController < ApplicationController
  before_action :set_course, only: [:create, :destroy]
    before_action :set_group, only: [:create, :destroy]
    def create
      @enrollment = @group.enrollments.build(student_id: current_user.id, status:0)  # Assumes current_user is a student
      if @enrollment.save
        redirect_to course_group_path(@group.course_id, @group), notice: 'Successfully enrolled.'
      else
        redirect_to course_group_path(@group.course_id, @group), alert: 'Enrollment failed.'
      end
    end
    
  
    def destroy
      @enrollment = @group.enrollments.find_by(student_id: current_user.id)
      @enrollment.destroy
      redirect_to course_group_path(@group.course_id, @group), notice: 'Enrollment was successfully cancelled.'
    end

    def approve_by_teacher
      enrollment = Enrollment.find(params[:id])
      enrollment.update(status: 'approved_by_teacher')
      # Implement additional logic if needed, e.g., sending notifications
      redirect_to teacher_pending_enrollments_path, notice: 'Enrollment approved by teacher.'
    end
    
    def decline_by_teacher
      enrollment = Enrollment.find(params[:id])
      enrollment.update(status: 'declined_by_teacher')
      redirect_to teacher_pending_enrollments_path, notice: 'Enrollment approved by teacher.'
    end
    private

      def set_course
        @course = Course.find_by(id: params[:course_id])
      end

      def set_group
        @group = Group.find(params[:group_id])
      end
end
  