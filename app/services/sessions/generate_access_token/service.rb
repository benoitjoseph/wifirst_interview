# frozen_string_literal: true

module Sessions
  module GenerateAccessToken
    class Service < Micro::Case
      include AuthConfig

      attributes :user

      def call!
        access_token = JWT.encode(payload, HMAC_SECRET, ENCRYPTION_ALGORITHM)

        Success(result: { access_token: access_token })
      end

      private

      def payload
        { user_id: user.id, exp: EXPIRES_IN.from_now.to_i }
      end
    end
  end
end
