class ImagesController < ApplicationController
  #before_filter :authenticate_user!

  load_and_authorize_resource :post, :except => [:cache_uploader]

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    redirect_to post_path(@image.post)
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
        "filename"      => uploader.filename,
        "name"          => uploader.cache_name,
        "size"          => uploader.size,
        "url"           => uploader.url,
        "thumbnail_url" => uploader.thumb.url,
        "type"          => "image"
      }
    end
end
