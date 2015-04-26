# Alexa RubyEngine
# This Engine receives and responds to Amazon Echo's (Alexa) JSON requests.
require 'sinatra'
require 'json'
require 'alexa_rubykit'

# We must return application/json as our content type.
before do
  content_type('application/json')
end

#enable :sessions
post '/' do
  # Check that it's a valid Alexa request
  request_json = JSON.parse(request.body.read.to_s)
  halt 500 if request_json['session'].nil? || request_json['version'].nil? || request_json['request'].nil?
  #
  # Creates a new Request object with the request parameter.
  request = AlexaRubykit::Request.new(request_json['request'])
  # Sets the version of our App's response to 1.0.
  request.version = '1.0'
  # Adds a session object to the response.
  request.add_session(request_json['session']['sessionId'])
  # Tells Alexa this ends the app session.
  request.shouldEndSession = true
  # Creates a speechouput json object with the text.
  request.say_response('Hello, Ruby is running ready')
  # Validates and generates the response from the previous methods into a valid JSON Object.
  request.build_response
end
