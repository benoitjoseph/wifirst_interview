# frozen_string_literal: true

module Sessions
  module AuthConfig
    ENCRYPTION_ALGORITHM = 'HS256'
    EXPIRES_IN = 3.months
    HMAC_SECRET = 'my_secret_key' # should be something like: Rails.application.credentials.jwt[:secret_key]
    VALIDATE_SIGNATURE = true
  end
end
