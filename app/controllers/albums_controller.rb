class AlbumsController < ApplicationController
  load_and_authorize_resource :album

  def index
    authorize! :manage, Album
    @albums = @albums.unscoped if params[:q] && params[:q][:s]
    @q = @albums.includes([:images]).search(params[:q])
    @albums = @q.result
  end

  def show
    @images = @album.images.published.page(params[:page]).per(Image::PER_PAGE)
  end

  def new
  end

  def create
    @album.weight = begin Album.order('weight DESC').first.weight rescue 0 end if @album.weight == 0
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
