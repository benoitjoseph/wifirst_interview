# frozen_string_literal: true

class Auth::SessionsController < AuthController
  def new
    @user = User.new
  end

  def create
    Auth::Sessions::Create::Service
      .call(**create_params)
      .on_success { |result| sign_in_and_redirect(result[:user]) }
      .on_failure do |result|
      @user = result[:user]
      render_service_error(result.type)
    end
  end

  def destroy
    sign_out_user

    redirect_to sign_in_path
  end

  private

  def create_params
    params.require(:user).permit(:email, :password)
  end
end
