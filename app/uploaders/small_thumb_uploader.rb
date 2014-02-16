class SmallThumbUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process :resize_to_fill => [166,236]
  if Rails.env.staging? || Rails.env.production?
    storage :fog
  end
end