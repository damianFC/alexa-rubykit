# Session end request class.
module AlexaRubykit
  class SessionEndedRequest < Request
    attr_accessor :reason

    # TODO: Validate the reason.
    # We still don't know if all of the parameters in the request are required.
    # Checking for the presence of intent on an IntentRequest.
    def initialize(json_request)
      super
      @type = 'SESSION_ENDED_REQUEST'
      @reason = json_request['request']['reason']
    end

    # Ouputs the request_id and the reason why.
    def to_s
      "Session Ended for requestID: #{request_id} with reason #{reason}"
    end
  end
end