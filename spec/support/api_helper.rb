# frozen_string_literal: true

module ApiHelper
  def parsed_body
    JSON.parse(response.body)
  end
end
