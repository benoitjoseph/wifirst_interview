# frozen_string_literal: true

module AuthenticationHelper
  def sign_in(user)
    session[:user_id] = user.id
  end
end
