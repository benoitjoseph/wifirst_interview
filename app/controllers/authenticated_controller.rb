# frozen_string_literal: true

class AuthenticatedController < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    redirect_to sign_in_path unless current_user
  end
end
