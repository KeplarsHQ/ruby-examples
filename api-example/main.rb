require 'dotenv/load'
require 'net/http'
require 'json'
require 'uri'

api_base_url = ENV['API_BASE_URL']
api_key      = ENV['API_KEY']
to_email     = ENV['TO_EMAIL']
user_name    = ENV['USER_NAME']

uri = URI("#{api_base_url}/send-email/instant")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = uri.scheme == 'https'

request = Net::HTTP::Post.new(uri.request_uri)
request['Authorization'] = "Bearer #{api_key}"
request['Content-Type']  = 'application/json'
request.body = {
  to:      [to_email],
  subject: "Welcome #{user_name}!",
  body:    "<h1>Welcome #{user_name}!</h1><p>Thank you for joining our platform.</p>",
  is_html: true
}.to_json

begin
  response = http.request(request)
  result   = JSON.parse(response.body)

  if response.code.to_i < 300
    puts 'Email sent successfully!'
    puts "Response: #{result}"
  else
    puts "Error sending email (status #{response.code}): #{result}"
  end
rescue StandardError => e
  puts "Error sending email: #{e.message}"
end
