# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :ensure_user_is_authenticated

  private

  def ensure_user_is_authenticated
    render_unauthorized unless current_user
  end

  def render_unauthorized
    head :unauthorized
  end

  helper_method :current_user
  def current_user
    @current_user ||= find_user_by_token
  end

  def find_user_by_token
    auth_header = request.headers['Authorization']
    token = auth_header.split('Bearer ').last if auth_header

    return if token.blank?

    result = Sessions::AuthenticateFromToken::Service.call(token: token)
    result[:user] if result.success?
  end
end
