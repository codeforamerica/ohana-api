CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
        provider:              'AWS',                        # required
        aws_access_key_id:     ENV['S3_ACCESS_KEY'],                        # required unless using use_iam_profile
        aws_secret_access_key: ENV['S3_SECRET']                       # required unless using use_iam_profile
    #   use_iam_profile:       true                        # optional, defaults to false
    #   region:                'eu-west-1',                  # optional, defaults to 'us-east-1'
    #   host:                  's3.example.com',             # optional, defaults to nil
    #   endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = 'fsl-dev-io-labs'                                      # required
    # config.fog_public     = false                                                 # optional, defaults to true
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}

    #For Dev
    config.ignore_integrity_errors = false
    config.ignore_processing_errors = false
    config.ignore_download_errors = false
end