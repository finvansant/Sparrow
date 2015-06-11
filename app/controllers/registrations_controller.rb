class RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def sign_up_params
    params.require(:user).permit(:email, :phone, :name, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:email, :phone, :name, :password, :password_confirmation, :current_password)
  end
end
