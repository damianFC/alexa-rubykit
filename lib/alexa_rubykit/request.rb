module AlexaRubykit
# Echo can send 3 types of requests
# - LaunchRequest: The start of the app.
# - IntentRequest: The intent of the app.
# - SessionEndedRequest: Session has ended.
  class Request
    require 'json'
    require 'alexa_rubykit/session'
    attr_accessor :version, :response, :shouldEndSession, :type, :session

    # Adds a specific session.
    def add_session(session)
      @session = session
    end
  end

  # Builds a new request for Alexa.
  def self.build_request(json_request)
    raise ArgumentError, 'Invalid Alexa Request.' unless AlexaRubykit.valid_alexa?(json_request)
    @request = nil
    # TODO: We probably need better session handling.
    session = AlexaRubykit::Session.new(json_request['session'])
    case json_request['request']['type']
      when /Launch/
        @request = LaunchRequest.new(json_request['request']['requestId'])
      when /Intent/
        @request = IntentRequest.new(json_request['request']['requestId'], json_request['request']['intent'])
      when /SessionEnded/
        @request = SessionEndedRequest.new(json_request['request']['requestId'], json_request['request']['reason'])
      else
        raise ArgumentError, 'Invalid Request Type.'
    end
    @request.add_session(session)
    @request
  end

  # Take keys of hash and transform those to a symbols
  def self.transform_keys_to_symbols(value)
    return value if not value.is_a?(Hash)
    hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = self.transform_keys_to_symbols(v); memo}
    return hash
  end
end
