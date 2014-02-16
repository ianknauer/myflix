CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => 'AKIAIUFJTF5VELMZSNHQ',                        # required
      :aws_secret_access_key  => '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',                        # required
    }
    config.fog_directory  = 'iank-myflix'                # required
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end