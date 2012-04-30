class ImagesController < ApplicationController
  load_and_authorize_resource :image

  def index
    @q = Image.includes([:category]).search(params[:q])
    @images = @q.result(:distinct => true).page(params[:page]).per(50)
  end

  def show
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
