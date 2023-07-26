# frozen_string_literal: true

module Bookmarks
  module Create
    class Service < Micro::Case::Strict
      attributes :city, :user

      def call!
        bookmark = user.bookmarks.find_or_initialize_by(city: city)
        bookmark.save!

        Success(result: { city: city })
      end
    end
  end
end
