module DevisePermittedParameters
  extend ActiveSupport::Concern

  included do
    before_action :configure_permitted_parameters, if: :devise_controller?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :education_level, :country, :address, :teaching, :parent_phone_number, :profile_picture_url])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :education_level, :country, :address, :teaching, :parent_phone_number, :profile_picture_url])
  end
end

Rails.application.configure do
  config.to_prepare do
    Devise::RegistrationsController.include DevisePermittedParameters
  end
end