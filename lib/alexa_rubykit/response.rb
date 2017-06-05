module AlexaRubykit
  class Response
    class SlotNotFound < StandardError; end

    require 'json'
    require 'alexa_rubykit/response/dialog'

    attr_accessor :version, :session, :response_object, :session_attributes,
                  :speech, :reprompt, :response, :card, :intents, :request

    # Every response needs a shouldendsession and a version attribute
    # We initialize version to 1.0, use add_version to set your own.
    def initialize(request=nil, version='1.0')
      @session_attributes = Hash.new
      @version = version
      @request = request
      @intents = request.intent if request && request.type == "INTENT_REQUEST"
      @directives = []
    end

    # Adds a key,value pair to the session object.
    def add_session_attribute(key, value)
      @session_attributes[key.to_sym] = value
    end

    def add_speech(speech_text, ssml = false)
      if ssml
        @speech = { :type => 'SSML', :ssml => check_ssml(speech_text) }
      else
        @speech = { :type => 'PlainText', :text => speech_text }
      end
      @speech
    end
    
    def add_audio_url(url, token='', offset=0)
      @directives << {
        'type' => 'AudioPlayer.Play',
        'playBehavior' => 'REPLACE_ALL',
        'audioItem' => {
          'stream' => {
            'token' => token,
            'url' => url,
            'offsetInMilliseconds' => offset
          }
        }
      }
    end

    def delegate_dialog_response
      @directives = [Dialog.delegate_directive(intents)]
    end

    def elicit_dialog_response(slot)
      @directives = [Dialog.elicit_slot_directive(slot, intents)]
    end

    def confirm_dialog_slot(slot)
      @directives = [Dialog.confirm_slot_directive(slot, intents)]
    end

    def confirm_dialog_intent
      @directives = [Dialog.confirm_intent_directive(intents)]
    end

    def modify_slot(name, value, confirmation_status)
      raise SlotNotFound if @intents['slots'][name].nil?

      @intents['slots'][name]['value'] = value
      @intents['slots'][name]['confirmationStatus'] = confirmation_status
    end

    def add_reprompt(speech_text, ssml = false)
      if ssml
        @reprompt = { "outputSpeech" => { :type => 'SSML', :ssml => check_ssml(speech_text) } }
      else
        @reprompt = { "outputSpeech" => { :type => 'PlainText', :text => speech_text } }
      end
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
      @card[:type] = type || 'Simple'
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
    def say_response(speech, end_session = true, ssml = false)
      output_speech = add_speech(speech,ssml)
      { :outputSpeech => output_speech, :shouldEndSession => end_session }
    end

    # Incorporates reprompt in the SDK 2015-05
    def say_response_with_reprompt(speech, reprompt_speech, end_session = true, speech_ssml = false, reprompt_ssml = false)
      output_speech = add_speech(speech,speech_ssml)
      reprompt_speech = add_reprompt(reprompt_speech,reprompt_ssml)
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
      @response[:directives] = @directives unless @directives.empty?
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

    private

      def check_ssml(ssml_string)
        ssml_string = ssml_string.strip[0..6] == "<speak>" ? ssml_string : "<speak>" + ssml_string
        ssml_string.strip[-8..1] == "</speak>" ? ssml_string : ssml_string + "</speak>"
      end
  end
end