class EventsController < ApplicationController
  load_and_authorize_resource :event, except: [:show]
  load_resource :event, only: [:show]

  def index
    authorize!(:manage, Event)
    @events = @events.includes([:images])
  end

  def show
    @images = @event.images.published.page(params[:page]).per(Image::PER_PAGE)
  end
end
