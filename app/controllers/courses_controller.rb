class CoursesController < ApplicationController
    before_action :set_course, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_teacher!
  
    def index
        Rails.logger.debug "Current User Type: #{current_user.class.name}"  # This will print the class type in your logs
        @courses = current_user.courses
    end
  
    def show
    end
  
    def new
        @course = Course.new
        Rails.logger.debug "New course initialized: #{@course.inspect}"
    end

    def create
      @course = current_user.courses.build(course_params)
      if @course.save
        redirect_to @course, notice: 'Course was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @course.update(course_params)
        redirect_to @course, notice: 'Course was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @course.destroy
      redirect_to courses_url, notice: 'Course was successfully destroyed.'
    end
  
    private
      def set_course
        @course = Course.find(params[:id])
      end
  
      def course_params
        params.require(:course).permit(:title, :description)
      end
  
      def authenticate_teacher!
        redirect_to root_path unless current_user.is_a?(Teacher)
      end
  end
  