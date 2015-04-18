require 'sinatra'
require 'json'
require 'lib/alexa_rubykit'


enable :sessions
post '/' do
  # Check that it's a valid Alexa request
  request_json = JSON.parse(request.body.read.to_s)
  #halt 500 if request_json['session'].nil? || request_json['version'].nil? || request_json['request'].nil?
  p request_json

  #request_json.each do |key, array|
  #  puts "#{key}-----"
  #  puts array
  #end
  #request = AlexaRubykit::Request.new(request_json['request'])
  #request.version = '1.0'
  #request.should_end_session = true
  #request.say_response('Hello, this is a test')
  #request.build_response
end