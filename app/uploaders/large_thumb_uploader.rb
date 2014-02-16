class LargeThumbUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process :resize_to_fill => [665,375]
  if Rails.env.staging? || Rails.env.production?
    storage :fog
  end
end