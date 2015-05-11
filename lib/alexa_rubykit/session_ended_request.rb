# Session end request class.
module AlexaRubykit
  class SessionEndedRequest < Request
    attr_accessor :request_id, :reason, :type

    # TODO: Validate the reason.
    # We still don't know if all of the parameters in the request are required.
    # Checking for the presence of intent on an IntentRequest.
    def initialize(request_id, reason)
      raise ArgumentError, 'Request ID should exist on a Session Ended Request.' if request_id.nil?
      @type = 'SESSION_ENDED_REQUEST'
      @request_id = request_id
      @reason = reason
    end
    def to_s
      "Session Ended for requestID: #{@request_id} with reason #{@reason}"
    end
  end
end