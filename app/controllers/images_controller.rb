class ImagesController < ApplicationController
  load_and_authorize_resource :image, except: [:show]
  load_resource :image, only: [:show]

  def index
    @q = Image.unscoped.includes([:album]).search(params[:q])
    @images = @q.result
    @images = @images.order('id DESC') if params[:q].nil?
    @images = @images.page(params[:page]).per(Image::PER_PAGE)
  end

  def show
    unless @image.published_at.present? || user_signed_in?
      redirect_to root_path, alert: 'Image is not published yet'
    end
  end

  def create
    if @image.save
      redirect_to image_path(@image)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @image.update_attributes(params[:image])
      redirect_to image_path(@image)
    else
      render :edit
    end
  end

  def new
  end

  def destroy
    @image.destroy
    redirect_to images_path
  end
end
