class AlbumsController < ApplicationController
  load_and_authorize_resource :album, :except => [:index, :show]
  load_resource :album, :only => [:index, :show]

  def index
    @albums = @albums.includes([:images])
  end

  def show
    @images = @album.images.page(params[:page]).per(24)
  end

  def new
  end

  def create
    if @album.save
      redirect_to album_path(@album)
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @album.update_attributes(params[:album])
      redirect_to album_path(@album)
    else
      render :edit
    end
  end

  def destroy
    @album.destroy
    redirect_to albums_path
  end
end