class ApplicationController < ActionController::Base
  before_action :permit_devise_parameters, if: :devise_controller?
  before_action :set_groups
  
  before_action :update_last_seen_at, if: :user_signed_in?
  def permit_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :type, :password, :password_confirmation])
  end

  def set_groups
    @groups = current_user.groups if current_user  # Always check for a logged-in user
  end

  def after_sign_in_path_for(user)
    root_path
  end


  private

  def update_last_seen_at
    current_user.update_column(:last_seen_at, Time.current)
  end
end
