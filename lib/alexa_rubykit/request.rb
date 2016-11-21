module AlexaRubykit
# Echo can send 3 types of requests
# - LaunchRequest: The start of the app.
# - IntentRequest: The intent of the app.
# - SessionEndedRequest: Session has ended.
  class Request
    require 'json'
    require 'alexa_rubykit/session'
    attr_accessor :version, :type, :session, :json # global
    attr_accessor :request_id, :locale # on request

    def initialize(json_request)
      @request_id = json_request['request']['requestId']
      raise ArgumentError, 'Request ID should exist on all Requests' if @request_id.nil?
      @version = json_request['version']
      @locale = json_request['request']['locale']
      @json   = json_request

      # TODO: We probably need better session handling.
      @session = AlexaRubykit::Session.new(json_request['session'])
    end
  end

  # Builds a new request for Alexa.
  def self.build_request(json_request)
    raise ArgumentError, 'Invalid Alexa Request.' unless AlexaRubykit.valid_alexa?(json_request)
    @request = nil
    case json_request['request']['type']
      when /Launch/
        @request = LaunchRequest.new(json_request)
      when /Intent/
        @request = IntentRequest.new(json_request)
      when /SessionEnded/
        @request = SessionEndedRequest.new(json_request)
      else
        raise ArgumentError, 'Invalid Request Type.'
    end
    @request
  end

  # Take keys of hash and transform those to a symbols
  def self.transform_keys_to_symbols(value)
    return value if not value.is_a?(Hash)
    hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = self.transform_keys_to_symbols(v); memo}
    return hash
  end
end
