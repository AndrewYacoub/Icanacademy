class SessionModificationsController < ApplicationController
    before_action :set_course_and_group
  
    def create
      @session_modification = @group.session_modifications.new(session_modification_params)
      if @session_modification.save
        redirect_to [@course, @group], notice: 'Session modification was successfully created.'
      else
        render 'groups/show'
      end
    end
  
    private
  
    def set_course_and_group
      @course = Course.find(params[:course_id])
      @group = @course.groups.find(params[:group_id])
    end
  
    def session_modification_params
      params.require(:session_modification).permit(:date, :start_time, :end_time)
    end
  end