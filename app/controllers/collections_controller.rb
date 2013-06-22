class CollectionsController < ApplicationController
  load_and_authorize_resource :collection, except: [:show]
  load_resource :collection, only: [:show]

  def index
    authorize! :manage, Collection
    @collections = @collections.unscoped if params[:q] && params[:q][:s]
    @q = @collections.includes([:images]).search(params[:q])
    @collections = @q.result
  end

  def show
    @images = @collection.images.published.page(params[:page]).per(Image::PER_PAGE)
  end

  def new
  end

  def create
    if @collection.save
      redirect_to collections_path
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @collection.update_attributes(params[:collection])
      redirect_to collection_path(@collection)
    else
      render :edit
    end
  end

  def destroy
    @collection.destroy
    redirect_to collections_path
  end
end
