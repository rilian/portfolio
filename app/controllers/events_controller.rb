class EventsController < ApplicationController
  load_resource :event

  def index
    @events = @events.includes([:images])
  end

  def show
    @images = @event.images.published.page(params[:page]).per(Image::PER_PAGE)
  end
end
