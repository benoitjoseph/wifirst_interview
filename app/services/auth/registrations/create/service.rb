# frozen_string_literal: true

module Auth
  module Registrations
    module Create
      # This service may be slightly overkill for this example, but a real-world signup flow
      # might includes many steps, such as generating a uid, a user config, tokens, sending mails, etc.
      class Service < Micro::Case
        attributes :name, :email, :password

        def call!
          call(CreateUser)
            .then(apply(:create_user_config))
            .then(apply(:enqueue_welcome_email))
        end

        private

        # Examples of common signup flows
        def create_user_config(user:, **)
          Success result: { user: user }
        end

        def enqueue_welcome_email(user:, **)
          Success result: { user: user }
        end
      end
    end
  end
end
