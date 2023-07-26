# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  helper_method :current_user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def render_service_error(error, action: 'new', status: :bad_request)
    flash.now[:danger] = I18n.t("errors.types.#{error}")

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('flashes', partial: 'shared/flashes') }
      format.html { render action, status: status }
    end
  end

  def render_resource_error(resource, action: 'new', status: :unprocessable_entity)
    flash.now[:danger] = resource.errors.full_messages.join(', ')

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('flashes', partial: 'shared/flashes') }
      format.html { render action, status: status }
    end
  end
end
