# Konekt

A Ruby (and optionally Rails) library to interact with the Konekt cloud.

Current features:

* Webhook to receive messages - "Custom Webhook Url (your own App)"
  * Automatic authentication to webhook key
  * Decodes payload JSON
  * Decodes data base64
  * Basically, all data passed in to Konekt is passed out as an easy to consume object - per tag, where ever in your app you wish to subscribe.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'konekt'
```

And then execute:

`$ bundle`

Or install it yourself as:

`$ gem install konekt`

#### Setup

The endpoint defaults to '/konekt_processor'. If you're app is at `https://example.com/` then you should set your webhook URL in Konekt to `https://example.com/konekt_processor`

`ENV['KONEKT_WEBHOOK_KEY']` should be set to to the "Webhook Key" value from the Konekt _applcation_ for this webhook.

Or you can override these in configuration:

```ruby
  # In an appropriate initializer
  Konekt.configure do |config|
    config.mount_point = '/some/other/path'
    config.auth_token = ENV['KONEKT_WEBHOOK_KEY']
  end
```

__Rack/Sinatra:__

```ruby
  # config.ru
  require 'konekt/middleware'
  use Konekt::Middleware
```

__Rails:__ This middleware is registered automatically.


### Subscribing to Tags

Subscribe to the tags you care about:

```ruby
Konekt.subscribe 'parcel_shipped' do |event|
  puts event
  # Do something with event
  # You probably want to fire a background task
end
```

In Rails this could live at `config/initalizers/konekt.rb`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/konekt/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
