class SessionsController < ApplicationController
    before_action :set_course
    before_action :set_group
    before_action :set_session, only: [:show, :edit, :update, :destroy]
  
    def index
      @sessions = @group.sessions.all
      events = @sessions.map do |session|
        {
          id: session.id,
          title: session.group.name,
          start: session.start_time,
          end: session.end_time,
          url: session.google_meet_link,
          description: session.group.name
        }
      end

      render json: events
    end
  
    def show
        
    end

    def new
        @day_names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
        @session = @group.sessions.build  # Initializes a new session within the group
    end
      
    
    def edit
    @session = @group.sessions.find(params[:id])
    end

    def create
        @session = @group.sessions.build(session_params)
        if @session.save
         redirect_to course_group_path(@course, @group), notice: 'Session was successfully created.'
        else
          Rails.logger.debug @session.errors.full_messages.join(", ")  # Log validation errors
          render :new
        end
    end      
  
    def update
      if @session.update(session_params)
        redirect_to course_group_session_path(@course, @group, @session), notice: 'Session was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @session.destroy
      redirect_to course_group_sessions_path(@course, @group), notice: 'Session was successfully destroyed.'
    end
  
    private
      def set_course
        @course = Course.find(params[:course_id])
      end
  
      def set_group
        @group = Group.find(params[:group_id])
      end
  
      def set_session
        @session = Session.find(params[:id])
      end
  
      def session_params
        params.require(:session).permit(:start_time, :end_time, :duration, recurrence_days: [])
      end
      
  end
  