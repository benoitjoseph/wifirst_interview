# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  helper_method :current_user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def render_service_error(error, action: 'new', status: :bad_request)
    flash.now[:danger] = I18n.t("errors.types.#{error}")

    render action, status: status
  end

  def render_resource_error(resource, action: 'new', status: :unprocessable_entity)
    flash.now[:danger] = resource.errors.full_messages.join(', ')

    render action, status: status
  end
end
