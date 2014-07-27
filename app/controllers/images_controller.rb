class ImagesController < ApplicationController
  load_and_authorize_resource :image, except: [:show]
  load_resource :image, only: [:show]

  def index
    @q = Image.unscoped.includes([:album]).search(params[:q])
    @images = @q.result
    @images = @images.order('id DESC') if params[:q].nil?
    @images = @images.page(params[:page])
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
    if @image.update_attributes(image_params)
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

private

  def image_params
    params.require(:image).permit(
      :asset, :asset_cache, :album_id, :title, :title_ua, :desc, :desc_ua, :place, :place_ua, :date,
      :updated_at, :published_at_checkbox, :tags, :tags_resolved,
      :is_for_sale, :image_width, :image_height
    )
  end
end
