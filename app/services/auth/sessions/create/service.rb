# frozen_string_literal: true

module Auth
  module Sessions
    module Create
      # Same thing here, kinda overkill but we might want to log the user's IP, browser, etc,
      # in which case a service object is a good place to do it.
      class Service < Micro::Case
        attributes :email, :password

        def call!
          user = User.find_or_initialize_by(email: email)

          if user&.authenticate(password)
            Success(result: { user: user })
          else
            Failure(:authentication_failure, result: { user: user })
          end
        end
      end
    end
  end
end
