# AlexaRubykit

This gem implements a quick back-end service for deploying applications for Amazon's Echo (Alexa), the gem,
and samples are provided as-is and are in current development.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alexa_rubykit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alexa_rubykit

## Usage

For running the sample "say" application:
* Configure your endpoint for SSL and load the certificate in the developer portal.
* Execute alexa_rubyengine under the bin folder
Sinatra will run in the background and serve a say command when it receives a LoginRequest command from
the Alexa app.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/alexa_rubykit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
