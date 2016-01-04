# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  version :thumb do
    process resize_to_fill: [50,50]
  end

  version :comment_thumb do
    process resize_to_limit: [300,300]
  end

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def logical_delete(file_path)
    file_name = File.basename(file_path)
    del_key = Digest::SHA256.hexdigest file_name + Rails.application.secrets.secret_key_base
    File.rename(file_path, file_path+del_key)
  end

  def logical_delete_all
    logical_delete(path)
    versions.each_value{|v| logical_delete(v.path)}
  end

  def logical_restore(file_path)
    file_name = File.basename(file_path)
    del_key = Digest::SHA256.hexdigest file_name + Rails.application.secrets.secret_key_base
    File.rename(file_path+del_key, file_path)
  end

  def logical_restore_all
    logical_restore(path)
    versions.each_value{|v| logical_restore(v.path)}
  end

  def url
    if super and File.exist?(path)
      super
    else
      "/NoImage.png"
    end
  end
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

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
