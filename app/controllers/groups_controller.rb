class GroupsController < ApplicationController
  before_action :set_course
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  
    def index
      @groups = @course.groups  # Lists only groups that belong to the set course
    end
  
    def show
      @course = Course.find(params[:course_id])
      @group = @course.groups.find(params[:id])
    end
  
    def new
        @day_names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
        @group = @course.groups.build
    end
  
    def create
      @group = @course.groups.build(group_params)
      if @group.save
        create_sessions_for_group(@group)
        redirect_to [@course, @group], notice: 'Group was successfully created.'
      else
        render :new
      end
    end

    def create_modification
      @group = Group.find(params[:group_id])
      @modification = @group.session_modifications.build(session_modification_params)
      if @modification.save
        redirect_to group_path(@group), notice: 'Session modification was successfully created.'
      else
        render 'show'
      end
    end  

    def edit
    end
  
    def update
        if @group.update(group_params)
            redirect_to [@course, @group], notice: 'Group was successfully updated.'
        else
            render :edit
        end
    end
  
    def destroy
      @group.destroy
      redirect_to course_path(@course), notice: 'Group was successfully destroyed.'
    end
  

    def enroll
      @group = @course.groups.find(params[:id])
      existing_enrollment = @group.enrollments.find_by(student_id: current_user.id)
      if existing_enrollment
        redirect_to course_group_path(@course, @group), alert: 'You are already enrolled in this group.'
      else
        enrollment = @group.enrollments.create(student_id: current_user.id, status: 0)
        if enrollment.persisted?
          redirect_to course_group_path(@course, @group), notice: 'Enrollment request sent. Awaiting admin approval.'
        else
          redirect_to course_group_path(@course, @group), alert: 'Unable to process your enrollment request.'
        end
      end
    end


    private
    
    def session_modification_params
      params.require(:session_modification).permit(:date, :start_time, :end_time)
    end

    def set_course
        @course = Course.find_by(id: params[:course_id])
        redirect_to root_path, alert: 'Course not found.' unless @course
    end
    
    def set_group
        @group = @course.groups.find_by(id: params[:id])
        redirect_to course_groups_path(@course), alert: 'Group not found.' unless @group
    end

    def group_params
      params.require(:group).permit(
        :name, 
        :start_date, 
        :end_date, 
        recurrence_days: [], 
        start_times: {}, 
        end_times: {}
      )
    end

    def create_sessions_for_group(group)
      group.recurrence_days.each do |day|
        occurrences = group.calculate_session_occurrences(day)
    
        occurrences.each do |occurrence|
          # Find the corresponding start and end times for this day
          start_time_str = group.start_times[day]
          end_time_str = group.end_times[day]
    
          # Parse the start and end times to create a DateTime object
          start_time = DateTime.parse("#{occurrence.to_date} #{start_time_str}") if start_time_str.present?
          end_time = DateTime.parse("#{occurrence.to_date} #{end_time_str}") if end_time_str.present?
    
          if start_time && end_time
            session = group.sessions.create!(
              start_time: start_time,
              end_time: end_time
            )
            session.update!(google_meet_link: group.create_google_meet_link(group, session))
          end
        end
      end
    end    
end
  