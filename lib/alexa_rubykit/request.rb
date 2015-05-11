module AlexaRubykit
# Echo can send 3 types of requests
# - LaunchRequest: The start of the app.
# - IntentRequest: The intent of the app.
# - SessionEndedRequest: Session has ended.
  class Request
    require 'json'
    attr_accessor :version, :session_return, :response, :shouldEndSession, :type
  end

  def self.build_request(json_request)
    raise ArgumentError, 'Invalid Alexa Request.' unless AlexaRubykit.valid_alexa?(json_request)
    @request = nil
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
    @request
  end

  # Let's monkey patch Hash.
  refine Hash do
    # Take keys of hash and transform those to a symbols
    def self.transform_keys_to_symbols(value)
      return value if not value.is_a?(Hash)
      hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = Hash.transform_keys_to_symbols(v); memo}
      return hash
    end
  end
end