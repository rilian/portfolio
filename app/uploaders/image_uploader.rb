# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

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
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :span2 do
    process :resize_to_limit => [160, 120]
  end
  version :span2_vertical do
    process :resize_to_limit => [120, 160]
  end
  version :span3 do
    process :resize_to_limit => [260, 180]
  end
  version :span3_vertical do
    process :resize_to_limit => [180, 260]
  end
  version :span4 do
    process :resize_to_limit => [360, 268]
  end
  version :span4_vertical do
    process :resize_to_limit => [268, 360]
  end
  version :big do
    process :resize_to_limit => [1024, 768]
  end
  version :big_vertical do
    process :resize_to_limit => [768, 1024]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
