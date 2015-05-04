module AlexaRubykit
  class Response
    require 'json'
    attr_accessor :version, :session, :response_object, :session_attributes, :speech, :response

    # Every response needs a shouldendsession and a version attribute
    # We initialize version to 1.0, use add_version to set your own.
    def initialize(version = '1.0')
      @session_attributes = Hash.new
      @version = version
    end

    # Adds a key,value pair to the session object.
    def add_session_attribute(key, value)
      @session_attributes[key.to_sym] = value
    end

    def add_speech(speech_text)
      @speech = { :type => 'PlainText', :text => speech_text }
      @speech
    end

    # Adds a speech to the object, also returns a outputspeech object.
    def say_response(speech, end_session = true)
      output_speech = add_speech(speech)
      { :outputSpeech => output_speech, :shouldEndSession => end_session }
    end


    # Creates a session object. We pretty much only use this in testing.
    def build_session
      # If it's empty assume user doesn't need session attributes.
      @session_attributes = Hash.new if @session_attributes.nil?
      @session = { :sessionAttributes => @session_attributes }
      @session
    end

    # The response object (with outputspeech, cards and session end)
    # Should rename this, but Amazon picked their names.
    # The only mandatory field is end_session which we default to true.
    def build_response_object(session_end = true)
      @response = Hash.new
      @response[:outputSpeech] = @speech unless @speech.nil?
      # TODO: We need cards too
      #response[:card] = @cards
      @response[:shouldEndSession] = session_end
      @response
    end

    # Builds a response.
    # Takes the version, response and should_end_session variables and builds a JSON object.
    def build_response
      response_object = build_response_object
      response = Hash.new
      response[:version] = @version
      response[:sessionAttributes] = @session_attributes unless @session_attributes.empty?
      response[:response] = response_object
      response.to_json
    end

    # TODO: Update this.
    def to_s
      "Version => #{@version}, SessionObj => #{@session}, Response => #{@response}"
    end
  end
end