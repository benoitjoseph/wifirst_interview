# frozen_string_literal: true

class Authenticated::BookmarksController < AuthenticatedController
  before_action :find_associated_resources
  before_action :find_resource, only: :destroy

  def create
    fetch_and_bookmark_service = Micro::Cases.flow([Cities::Fetch::Service, Bookmarks::Create::Service])
    result = fetch_and_bookmark_service.call(accuweather_key: params[:city_accuweather_key], user: current_user)

    if result.success?
      respond_with_turbo_stream
    else
      render_service_error(result.type, action: :index)
    end
  end

  def destroy
    @bookmark.destroy!

    respond_with_turbo_stream
  end

  private

  def respond_with_turbo_stream
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cities_path }
    end
  end

  def find_resource
    @bookmark = current_user.bookmarks.find(params[:id])
  end

  def find_associated_resources
    @city = City.find_by(accuweather_key: params[:city_accuweather_key])
  end
end
