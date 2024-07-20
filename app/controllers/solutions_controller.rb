class SolutionsController < ApplicationController
  before_action :set_homework, only: [:create]
  before_action :set_solution, only: [:show, :provide_feedback]
  before_action :authenticate_teacher!, only: [:provide_feedback]

  def show
  end

  def create
    @solution = @homework.solutions.build(solution_params)
    @solution.users_id = current_user.id

    if @solution.save
      redirect_to group_homework_path(@homework.group, @homework), notice: 'Solution was successfully submitted.'
    else
      render 'homeworks/show'
    end
  end

  def provide_feedback
    if @solution.update(feedback_params)
      redirect_to [@homework.group, @homework, @solution], notice: 'Feedback was successfully submitted.'
    else
      render :show
    end
  end

  private

  def set_homework
    @homework = Homework.find(params[:homework_id])
  end

  def set_solution
    @solution = Solution.find(params[:id])
  end

  def solution_params
    params.require(:solution).permit(:file)
  end

  def feedback_params
    params.require(:solution).permit(:feedback, :score)
  end
end
