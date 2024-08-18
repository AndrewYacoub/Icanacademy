class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)

      redirect_to profile_path, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end
  private

  def user_params
    if current_user.type = "Teacher"
      params.require(:teacher).permit(:first_name, :last_name, :phone_number, :education_level, :country, :address, :teaching)
    else
      params.require(:student).permit(:first_name, :last_name, :phone_number, :education_level, :country, :address, :parent_phone_number)
    end
  end
end
