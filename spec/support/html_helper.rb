# frozen_string_literal: true

module HtmlHelper
  def html_element(selector)
    document = Nokogiri::HTML(response.body)
    document.at_css(selector)
  end
end
