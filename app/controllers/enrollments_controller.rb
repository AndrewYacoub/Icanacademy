class EnrollmentsController < ApplicationController
    before_action :set_group
  
    def create
      @enrollment = @group.enrollments.build(student_id: current_user.id)  # Assumes current_user is a student
      if @enrollment.save
        redirect_to @group, notice: 'Successfully enrolled.'
      else
        redirect_to @group, alert: 'Enrollment failed.'
      end
    end
  
    def destroy
      @enrollment = @group.enrollments.find_by(student_id: current_user.id)
      @enrollment.destroy
      redirect_to @group, notice: 'Enrollment was successfully cancelled.'
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
      def set_group
        @group = Group.find(params[:group_id])
      end
  end
  