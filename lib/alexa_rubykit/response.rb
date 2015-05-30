module AlexaRubykit
  class Response
    require 'json'
    attr_accessor :version, :session, :response_object, :session_attributes, :speech, :reprompt, :response, :card

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

    def add_reprompt(speech_text)
      @reprompt = { "outputSpeech" => { :type => 'PlainText', :text => speech_text } }
      @reprompt
    end

    #
    #"type": "string",
    #    "title": "string",
    #    "subtitle": "string",
    #    "content": "string"
    def add_card(type = nil, title = nil , subtitle = nil, content = nil)
      # A Card must have a type which the default is Simple.
      @card = Hash.new()
      @card[:type] = 'Simple' if type.nil?
      @card[:title] = title unless title.nil?
      @card[:subtitle] = subtitle unless subtitle.nil?
      @card[:content] = content unless content.nil?
      @card
    end

    # The JSON Spec says order shouldn't matter.
    def add_hash_card(card)
      card[:type] = 'Simple' if card[:type].nil?
      @card = card
      @card
    end

    # Adds a speech to the object, also returns a outputspeech object.
    def say_response(speech, end_session = true)
      output_speech = add_speech(speech)
      { :outputSpeech => output_speech, :shouldEndSession => end_session }
    end

    # Incorporates reprompt in the SDK 2015-05
    def say_response_with_reprompt(speech, reprompt_speech, end_session = true)
      output_speech = add_speech(speech)
      reprompt_speech = add_reprompt(reprompt_speech)
      { :outputSpeech => output_speech, :reprompt => reprompt_speech, :shouldEndSession => end_session }
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
      @response[:card] = @card unless @card.nil?
      @response[:reprompt] = @reprompt unless session_end && @reprompt.nil?
      @response[:shouldEndSession] = session_end
      @response
    end

    # Builds a response.
    # Takes the version, response and should_end_session variables and builds a JSON object.
    def build_response(session_end = true)
      response_object = build_response_object(session_end)
      response = Hash.new
      response[:version] = @version
      response[:sessionAttributes] = @session_attributes unless @session_attributes.empty?
      response[:response] = response_object
      response.to_json
    end

    # Outputs the version, session object and the response object.
    def to_s
      "Version => #{@version}, SessionObj => #{@session}, Response => #{@response}"
    end
  end
end