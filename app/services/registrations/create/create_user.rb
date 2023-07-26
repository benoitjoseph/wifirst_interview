# frozen_string_literal: true

module Registrations
  module Create
    class CreateUser < Micro::Case
      attributes :name, :email, :password

      def call!
        user = User.new(name: name, email: email, password: password)

        if user.save
          Success result: { user: user }
        else
          Failure result: { user: user }
        end
      end
    end
  end
end
