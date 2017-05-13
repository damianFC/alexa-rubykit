# AlexaRubykit
[![Gem Version](https://badge.fury.io/rb/alexa_rubykit.svg)](http://badge.fury.io/rb/alexa_rubykit)[![Build Status](https://travis-ci.org/damianFC/alexa-rubykit.svg?branch=master)](https://travis-ci.org/damianFC/alexa-rubykit)[![Build Status](https://travis-ci.org/damianFC/alexa-rubykit.svg?branch=dev)](https://travis-ci.org/damianFC/alexa-rubykit)[![Inline docs](http://inch-ci.org/github/damianFC/alexa-rubykit.svg?branch=master)](http://inch-ci.org/github/damianFC/alexa-rubykit)

This gem implements a quick back-end service for deploying applications for Amazon's Echo (Alexa).

## Installation

### Sample Application

For a sample application video tutorial, check

<a href="http://www.youtube.com/watch?feature=player_embedded&v=PwZf506UKHo" target="_blank"><img src="http://img.youtube.com/vi/PwZf506UKHo/0.jpg" 
alt="Running a sample Rubykit Demo" width="240" height="180" border="5" /></a>

Samples are provided by the alexa_rubyengine project: https://github.com/damianFC/alexa_rubyengine

### For Ruby Projects:

Add this line to your application's Gemfile:

```ruby
gem 'alexa_rubykit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alexa_rubykit

## Usage

This Gem provides methods to create and handle request and response objects to be used in your container of choice.

Sample usage:

```ruby
require 'alexa_rubykit'
response = AlexaRubykit::Response.new
response.add_speech('Ruby is running ready!')
response.build_response
```

Will generate a valid outputspeech response in JSON format:

```JSON
{
    "version": "1.0",
    "response": {
        "outputSpeech": {
            "type": "PlainText",
            "text": "Ruby is running ready!"
        },
        "shouldEndSession": true
    }
}
```

## Troubleshooting

There are two sources of troubleshooting information: the Amazon Echo app/website and the EBS logs that you can get from
the management console.
- "Error in SSL handshake" : Make sure your used the FQDN when you generated the SSL and it's also the active SSL in EBS.
- "Error communicating with the application" : Query the EBS logs from the management console and create an issue on GitHub.

## Testing

Run the tests using

```bash
bundle exec rake
```

## Contributing

1. Decide to work on the "dev" (unstable) branch or "master" (stable)
1. Fork it ( https://github.com/[my-github-username]/alexa_rubykit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

All development is done in the "dev" branch before being merged to master. Applications can use the developer
environment by adding the following line to their Gemfile:

```ruby
gem 'alexa_rubykit', :git => 'https://github.com/damianFC/alexa-rubykit.git', :branch => 'dev'
```

To use the stable/master branch, rename 'dev' to 'master' or remove :branch all together.



# <a name="team-members"></a>Team Members
* "Damian Finol" <damian.finol@gmail.com>
* "Dave Shapiro" <dss.shapiro@gmail.com>
