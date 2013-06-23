class EventsController < ApplicationController
  load_resource :event

  def index
    @events = @events.unscoped if params[:q] && params[:q][:s]
    @q = @events.search(params[:q])
    @events = @q.result
  end

  def show
  end
end
