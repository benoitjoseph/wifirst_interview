# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :bookmarks, dependent: :destroy

  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def access_token
    result = Sessions::GenerateAccessToken::Service.call(user: self)
    result[:access_token]
  end
end
