module AlexaRubykit
# Echo can send 3 types of requests
# - LaunchRequest: The start of the app.
# - IntentRequest: The intent of the app.
# - SessionEndedRequest: Session has ended.
  class Request
    require 'json'
    require 'sinatra'
    require 'alexa_rubykit'
    attr_accessor :version, :session_return, :response, :shouldEndSession, :type

    @request = ''
    @type = ''
    def initialize(json_request)
      halt 500 unless AlexaRubykit.valid_alexa?(json_request)
      @request = json_request
      case @request['request']['type']
        when /Launch/
          @type = 'LAUNCH'
        when /Intent/
          @type = 'INTENT'
        when /SessionEnded/
          @type = 'SESSIONENDED'
        else
          halt 500
      end
    end
  end
end