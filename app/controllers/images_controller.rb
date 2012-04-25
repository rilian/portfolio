class ImagesController < ApplicationController
  load_and_authorize_resource :image, :except => [:cache_uploader]

  def index
    @q = Image.includes([:category]).search(params[:q])
    @images = @q.result(:distinct => true).page(params[:page]).per(100)
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

  def cache_uploader
    begin
      @uploader = ImageUploader.new
      @uploader.cache!(params[:file])
      json_response = create_json_responce(@uploader)
    rescue Exception => e
      json_response = {:error => e.message}
    end
    render :inline => json_response.to_json
  end

private

    def create_json_responce(uploader)
      {
        filename: uploader.filename,
        name: uploader.cache_name,
        size: uploader.size,
        url: uploader.url,
        thumbnail_url: uploader.thumb.url,
        type: 'image'
      }
    end
end
