require 'onesignal'

OneSignal.configure do |config|
  config.app_id = ENV["ONE_SIGNAL_APP_ID"]
  config.api_key = ENV["ONE_SIGNAL_REST_API_KEY"]
  #config.api_url = "https://onesignal.com/api/v1"
  config.active = true
  #config.logger = Logger.new # Any Logger compliant implementation
end
