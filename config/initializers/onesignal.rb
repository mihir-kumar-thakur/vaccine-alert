require 'onesignal'

OneSignal.configure do |config|
  config.app_id = ENV["ONE_SIGNAL_APP_ID"]
  config.api_key = ENV["ONE_SIGNAL_REST_API_KEY"]
  config.active = false
  config.logger = Logger.new # Any Logger compliant implementation
end
