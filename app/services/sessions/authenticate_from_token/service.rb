# frozen_string_literal: true

module Sessions
  module AuthenticateFromToken
    class Service < Micro::Case
      include AuthConfig

      attributes :token

      def call!
        user = user_from_access_token

        Success(result: { user: user })
      rescue JWT::ExpiredSignature, JWT::DecodeError, ActiveRecord::RecordNotFound => e
        Failure(:authentication_failure, result: { error: e.message })
      end

      private

      def user_from_access_token
        payload, _headers = JWT.decode(token, HMAC_SECRET, VALIDATE_SIGNATURE, { algorithm: ENCRYPTION_ALGORITHM })

        User.find(payload['user_id'])
      end
    end
  end
end
