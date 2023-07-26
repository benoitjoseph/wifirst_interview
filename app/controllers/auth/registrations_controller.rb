# frozen_string_literal: true

class Auth::RegistrationsController < AuthController
  def new
    @user = User.new
  end

  def create
    Registrations::Create::Service.call(**create_params)
                                  .on_success { |result| sign_in_and_redirect(result[:user]) }
                                  .on_failure { |result| render_registration_error(result) }
  end

  private

  def create_params
    params.require(:user).permit(:name, :email, :password)
  end

  def render_registration_error(result)
    @user = result[:user]

    render_service_error(result.type, action: :new)
  end
end
