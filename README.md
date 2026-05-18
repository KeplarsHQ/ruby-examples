# Keplars Ruby Examples

Ruby examples for integrating [Keplars](https://keplars.com) email service.

## SDK Install

```bash
gem install keplars
```

```ruby
require 'keplars'

client = Keplars::Client.new(api_key: 'kms_your_api_key')

result = client.emails.send_instant(
  to: 'user@example.com',
  from: 'hello@yourdomain.com',
  subject: 'Hello!',
  html: '<h1>Hello World</h1>'
)
```

## Examples

### SDK Example (`sdk-example/`) — Recommended

Full Sinatra demo using the official Ruby SDK. Covers transactional emails, bulk/scheduled marketing emails, webhook signature verification, and priority queue usage.

[View SDK Example →](./sdk-example/)

### API Example (`api-example/`)

Minimal script sending a single email via raw HTTP using Ruby's standard `net/http` library — no SDK required.

[View API Example →](./api-example/)

### SMTP Example (`smtp-example/`)

Minimal script sending a single email via SMTP using Ruby's standard `net/smtp` library — no SDK required.

[View SMTP Example →](./smtp-example/)

## Quick Start

```bash
cd sdk-example
cp .env.example .env
bundle install
ruby app.rb
```

Server starts on `http://localhost:8080`.

## Prerequisites

- Ruby 3.0+
- A Keplars API key ([get one here](https://dash.keplars.com))

## Related Examples

- [Go Examples](https://github.com/KeplarsHQ/go-examples) — Gin
- [Dart Examples](https://github.com/KeplarsHQ/dart-examples) — Shelf
- [Python Examples](https://github.com/KeplarsHQ/python-examples) — FastAPI
- [Node.js Examples](https://github.com/KeplarsHQ/nodejs-examples) — Express

## License

MIT
