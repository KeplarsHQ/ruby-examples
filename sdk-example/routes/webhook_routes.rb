require 'sinatra/base'
require 'json'
require 'openssl'

module WebhookRoutes
  def self.registered(app)
    app.post '/webhooks/keplars' do
      signature = request.env['HTTP_X_KEPLARS_SIGNATURE'].to_s
      timestamp = request.env['HTTP_X_KEPLARS_TIMESTAMP'].to_s
      raw_body  = request.body.read

      unless verify_signature(raw_body, signature, timestamp, WEBHOOK_SECRET)
        halt 401, { error: 'Invalid signature' }.to_json
      end

      payload = JSON.parse(raw_body, symbolize_names: true)
      event   = payload[:event]
      data    = payload[:data] || {}

      case event
      when 'email.delivered'  then puts "Email delivered: #{data[:job_id]}"
      when 'email.bounced'    then puts "Email bounced: #{data[:job_id]} reason: #{data[:reason]}"
      when 'email.complained' then puts "Spam complaint: #{data[:job_id]}"
      when 'email.opened'     then puts "Email opened: #{data[:job_id]}"
      when 'email.clicked'    then puts "Link clicked: #{data[:job_id]} url: #{data[:url]}"
      when 'email.failed'     then puts "Email failed: #{data[:job_id]} reason: #{data[:reason]}"
      else                         puts "Unknown event: #{event}"
      end

      { received: true }.to_json
    end
  end

  def self.verify_signature(payload, signature, timestamp, secret)
    return false if timestamp.empty? || secret.empty?

    ts = timestamp.to_i
    return false if (Time.now.to_i - ts).abs > 300

    signed   = "#{timestamp}.#{payload}"
    expected = OpenSSL::HMAC.hexdigest('SHA256', secret, signed)
    Rack::Utils.secure_compare(signature, expected)
  rescue StandardError
    false
  end
end
