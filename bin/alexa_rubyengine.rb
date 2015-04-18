# Alexa RubyEngine
# This Engine receives and responds to Amazon Echo's (Alexa) JSON requests.

require 'sinatra'
require 'json'
require 'alexa_rubykit'


enable :sessions
post '/' do
  # Check that it's a valid Alexa request
  halt 500 if params[:session].nil? || params[:version].nil? || params[:request].nil?
  request = AlexaRubykit::Request.new(params)
  request.version = '1.0'
  request.should_end_session = true
  request.say_response('Hello, this is a test')
  request.build_response
end
