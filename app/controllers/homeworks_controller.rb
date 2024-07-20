class HomeworksController < ApplicationController
  before_action :set_course
  before_action :set_group
  before_action :set_homework, only: %i[show edit update destroy]

  def index
    @homeworks = @group.homeworks
  end

  def show
    # Your show logic here
  end

  def new
    @homework = Homework.new
  end

  def create
    @homework = @group.homeworks.new(homework_params)
    questions = params[:questions].values.map(&:to_unsafe_h)

    google_form_service = GoogleFormsService.new
    google_form = google_form_service.create_form(@homework.title, questions)

    @homework.google_form_id = google_form.form_id
    @homework.google_form_link = google_form.responder_uri

    if @homework.save
      redirect_to course_group_homework_path(@course, @group, @homework), notice: 'Homework was successfully created.'
    else
      render :new
    end
  end

  def edit
    # Your edit logic here
  end

  def update
    if @homework.update(homework_params)
      redirect_to course_group_homework_path(@course, @group, @homework), notice: 'Homework was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @homework.destroy
    redirect_to course_group_homeworks_path(@course, @group), notice: 'Homework was successfully destroyed.'
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_group
    @group = @course.groups.find(params[:group_id])
  end

  def set_homework
    @homework = @group.homeworks.find(params[:id])
  end

  def homework_params
    params.require(:homework).permit(:title, :lesson, :description, :link, :file)
  end
end
