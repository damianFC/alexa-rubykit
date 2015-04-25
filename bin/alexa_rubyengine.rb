#!/usr/bin/env ruby
# Alexa RubyEngine
# This Engine receives and responds to Amazon Echo's (Alexa) JSON requests.
require 'sinatra'
require 'json'
require 'alexa_rubykit'

enable :sessions
post '/' do
  # Check that it's a valid Alexa request
  request_json = JSON.parse(request.body.read.to_s)
  halt 500 if request_json['session'].nil? || request_json['version'].nil? || request_json['request'].nil?

  p "1"
  request = AlexaRubykit::Request.new(request_json['request'])
  p "2"
  request.version = '1.0'
  p "3"
  #request.shouldEndSession = true
  #request.say_response('Hello, this is a test')
  #request.build_response
end
