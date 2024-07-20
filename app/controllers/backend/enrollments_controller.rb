module Backend
    class EnrollmentsController < ApplicationController
      before_action :authenticate_admin_user!

      def index
        @pending_enrollments = Enrollment.where(status: 0)
      end
    
      def update
        @enrollment = Enrollment.find(params[:id])
        if params[:approve]
          @enrollment.update(status: 'pending_teacher_approval')
          redirect_to admin_enrollments_path, notice: 'Enrollment approved and pending teacher confirmation.'
        elsif params[:decline]
          @enrollment.update(status: 'declined')
          redirect_to admin_enrollments_path, alert: 'Enrollment declined.'
        end
      end

    end
end

