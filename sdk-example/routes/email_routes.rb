require 'sinatra/base'
require 'json'

module EmailRoutes
  def self.registered(app)
    app.post '/api/emails/welcome' do
      body = JSON.parse(request.body.read, symbolize_names: true)
      result = KEPLARS_CLIENT.emails.send(
        to: body[:email],
        from: 'hello@yourdomain.com',
        subject: "Welcome, #{body[:firstName]}!",
        html: "<h1>Welcome, #{body[:firstName]}!</h1><p>Thanks for joining.</p>"
      )
      result.to_json
    end

    app.post '/api/emails/otp' do
      body = JSON.parse(request.body.read, symbolize_names: true)
      result = KEPLARS_CLIENT.emails.send_instant(
        to: body[:email],
        from: 'hello@yourdomain.com',
        subject: 'Your verification code',
        html: "<h1>Your code: <strong>#{body[:otp]}</strong></h1><p>Expires in 10 minutes.</p>"
      )
      result.to_json
    end

    app.post '/api/emails/password-reset' do
      body = JSON.parse(request.body.read, symbolize_names: true)
      result = KEPLARS_CLIENT.emails.send_high(
        to: body[:email],
        from: 'hello@yourdomain.com',
        subject: 'Reset your password',
        html: "<h1>Reset your password</h1><p><a href=\"#{body[:resetLink]}\">Click here</a> to reset. Link expires in 1 hour.</p>"
      )
      result.to_json
    end

    app.post '/api/emails/order-confirmation' do
      body = JSON.parse(request.body.read, symbolize_names: true)
      result = KEPLARS_CLIENT.emails.send_high(
        to: body[:email],
        from: 'hello@yourdomain.com',
        subject: "Order confirmed: #{body[:orderId]}",
        html: "<h1>Order confirmed!</h1><p>Order <strong>#{body[:orderId]}</strong> — total: #{body[:total]}</p>"
      )
      result.to_json
    end

    app.post '/api/emails/newsletter' do
      body = JSON.parse(request.body.read, symbolize_names: true)
      recipients = body[:recipients].map { |e| { email: e } }
      result = KEPLARS_CLIENT.emails.send_bulk(
        to: recipients,
        from: 'newsletter@yourdomain.com',
        subject: body[:subject],
        html: body[:html]
      )
      result.to_json
    end

    app.post '/api/emails/newsletter/schedule' do
      body = JSON.parse(request.body.read, symbolize_names: true)
      recipients = body[:recipients].map { |e| { email: e } }
      result = KEPLARS_CLIENT.emails.schedule(
        to: recipients,
        from: 'newsletter@yourdomain.com',
        subject: body[:subject],
        html: body[:html],
        scheduled_for: body[:scheduledFor],
        timezone: body[:timezone] || 'UTC'
      )
      result.to_json
    end
  end
end
