# encoding: utf-8

require 'carrierwave/processing/mime_types'

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, 'default.png'].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  process :get_version_dimensions

  # Create different versions of your uploaded files:
  version :big do
    process resize_to_limit: [900, 700]
    process :add_watermark
  end
  version :span2 do
    process resize_to_limit: [900, 110]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  #def filename
  #  super.chomp(File.extname(super)) + '.png'
  #end

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
    path = "#{Rails.root}/app/assets/images/watermark.png"
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
