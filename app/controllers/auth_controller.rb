# frozen_string_literal: true

class AuthController < ApplicationController
  layout 'auth'

  before_action :redirect_if_signed_in, only: %i[new create]

  private

  def sign_in_and_redirect(user)
    sign_in_user(user)

    redirect_to dashboard_path
  end

  def sign_in_user(user)
    session[:user_id] = user.id
  end

  def sign_out_user
    session[:user_id] = nil
  end

  def redirect_if_signed_in
    redirect_to dashboard_path if current_user
  end
end
