require 'dotenv/load'
require 'net/smtp'

smtp_host     = ENV['SMTP_HOST']
smtp_port     = ENV['SMTP_PORT'].to_i
smtp_user     = ENV['SMTP_USER']
smtp_password = ENV['SMTP_PASSWORD']
from_email    = ENV['FROM_EMAIL']
to_email      = ENV['TO_EMAIL']

message = <<~MSG
  From: #{from_email}
  To: #{to_email}
  Subject: Test Email from Keplars SMTP
  MIME-Version: 1.0
  Content-Type: text/html; charset=UTF-8

  <p>This is a <strong>test email</strong> sent via Keplars SMTP service.</p>
MSG

begin
  Net::SMTP.start(smtp_host, smtp_port, 'localhost', smtp_user, smtp_password, :plain) do |smtp|
    smtp.send_message(message, from_email, to_email)
  end

  puts 'Email sent successfully!'
  puts "Sent from: #{from_email}"
  puts "Sent to:   #{to_email}"
rescue StandardError => e
  puts "Error sending email: #{e.message}"
end
