# frozen_string_literal: true

class Auth::RegistrationsController < AuthController
  def new
    @user = User.new
  end

  def create
    Auth::Registrations::Create::Service
      .call(**create_params)
      .on_success { |result| sign_in_and_redirect(result[:user]) }
      .on_failure do |result|
      @user = result[:user]
      render_resource_error(@user, action: :new)
    end
  end

  private

  def create_params
    params.require(:user).permit(:name, :email, :password)
  end
end
