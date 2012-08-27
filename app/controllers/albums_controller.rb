class AlbumsController < ApplicationController
  load_and_authorize_resource :album, :except => [:show]
  load_resource :album, :only => [:show]

  def index
    authorize!(:manage, Album)
    @albums = @albums.includes([:images])
  end

  def show
    @images = @album.images.published.page(params[:page]).per(Image::PER_PAGE)
  end

  def new
  end

  def create
    if @album.save
      redirect_to albums_path
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