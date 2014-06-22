class PhotosController < ApplicationController
  load_and_authorize_resource :photo

  def destroy
    @photo.destroy
    redirect_to url_for(controller: @photo.owner_type.underscore.pluralize, action: 'edit', id: @photo.owner_id), alert: 'Photo deleted'
  end

private

  def photo_params
    params.require(:photo).permit(
      :asset, :asset_cache, :owner_id, :owner_type, :desc, :desc_ua,
      :image_width, :image_height, :is_cover, :weight
    )
  end
end
