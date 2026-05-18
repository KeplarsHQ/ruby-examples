require 'dotenv/load'
require 'sinatra/base'
require 'json'
require 'keplars'

require_relative 'routes/email_routes'
require_relative 'routes/webhook_routes'

class KeplarsApp < Sinatra::Base
  configure do
    set :bind, '0.0.0.0'
    set :port, ENV.fetch('PORT', 8080).to_i
  end

  before do
    content_type :json
  end

  KEPLARS_CLIENT = Keplars::Client.new(api_key: ENV['KEPLARS_API_KEY'])
  WEBHOOK_SECRET = ENV.fetch('KEPLARS_WEBHOOK_SECRET', '')

  register EmailRoutes
  register WebhookRoutes

  run! if app_file == $0
end
