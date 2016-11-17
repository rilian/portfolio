# encoding: utf-8

require 'carrierwave/processing/mime_types'

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :get_version_dimensions

  version :big do
    process resize_to_limit: [900, 700]
    # process :add_watermark
  end
  version :span2 do
    process resize_to_limit: [900, 110]
  end

  def extension_white_list
    ['jpg', 'jpeg', 'gif', 'png', '']
  end

protected

  def get_version_dimensions
    begin
      model.image_width, model.image_height = `identify -format "%wx%h" #{file.path}`.split(/x/)
    rescue
      model.image_width = 0
      model.image_height = 0
    end
  end

  ##
  # Adds watermark over the image
  #
  def add_watermark
    path = "#{Rails.root}/config/watermark.png"
    if File.exists? path
      begin
        manipulate! do |img|
          img.composite(MiniMagick::Image.open path) do |c|
            c.gravity 'SouthEast'
          end
        end
      rescue
        puts "Could not add watermark for #{path}"
      end
    end
  end
end
