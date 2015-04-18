module AlexaRubykit
# Echo can send 3 types of requests
# - LaunchRequest: The start of the app.
# - IntentRequest: The intent of the app.
# - SessionEndedRequest: Session has ended.
  class Request
    require 'json'
    require 'sinatra'
    attr_accessor :version, :session_attributes, :response, :should_end_session

    @request = ''
    @type = ''
    def initialize(json_request)
      halt 500 if json_request.nil?
      @request = json_request
      case @request['type']
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

    # Builds a response.
    # Takes the version, response and should_end_session variables and builds a JSON object.
    def build_response
      # Need to set all 3 parameters or the response is invalid
      halt 500 if @version.nil? || @response.nil? || @should_end_session.nil?
      response = Hash.new
      response[:version] = @version
      response[:response] = @response
      response[:should_end_session] = @should_end_session
      response.to_json
    end

    # Creates a outputspeech JSON object for responding with voice.
    # Data type:
    #"outputSpeech": {
    #    "type": "string",
    #    "text": "string"
    #}
    def say_response(speech)
      output_speech = { :type => 'string', :text => speech }
      @response = { :outputSpeech => output_speech }
    end
  end
end