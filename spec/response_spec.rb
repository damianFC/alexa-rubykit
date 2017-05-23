require 'rspec'
require 'alexa_rubykit/response'

describe 'Builds appropriate response objects' do

  #TODO: Do a :before with the Response object creation

  it 'should create valid session responses' do
    # Pair values.
    response = AlexaRubykit::Response.new
    response.add_session_attribute('new', false)
    response.add_session_attribute('sessionId', 'amzn1.echo-api.session.abeee1a7-aee0-41e6-8192-e6faaed9f5ef')
    session = response.build_session
    expect(session).to include(:sessionAttributes)
    expect(session[:sessionAttributes]).to include(:new)
    expect(session[:sessionAttributes]).to include(:sessionId)

    # Empty.
    response = AlexaRubykit::Response.new
    session = response.build_session
    expect(session).to include(:sessionAttributes)
    expect(session[:sessionAttributes]).to be_empty
  end

  # TODO: Add cards.
  it 'should create a valid Alexa say response object' do
    response = AlexaRubykit::Response.new
    response.add_speech('Testing Alexa Rubykit!')
    response_object = response.build_response_object
    expect(response_object).to include(:outputSpeech)
    expect(response_object[:outputSpeech][:type]).to include('PlainText')
    expect(response_object[:outputSpeech][:text]).to include('Testing Alexa Rubykit!')

    # The say_response command should create the same object.
    response_say = AlexaRubykit::Response.new
    response_say_object = response_say.say_response('Testing Alexa Rubykit!')
    expect(response_say_object).to eq(response_object)

    # End session should be true if we didn't specify it.
    expect(response_object[:shouldEndSession]).to eq(true)
    response_object = response.build_response_object(false)
    # And to be false if we tell it to continue the session
    expect(response_object[:shouldEndSession]).to eq(false)
    # say_response should now be NOT equal thanks to endsession.
    expect(response_say_object).not_to eq(response_object)
  end

  it 'should create a valid SSML Alexa say response object' do
    response = AlexaRubykit::Response.new
    response.add_speech('<speak>Testing SSML Alexa Rubykit support!</speak>',true)
    response_object = response.build_response_object
    expect(response_object).to include(:outputSpeech)
    expect(response_object[:outputSpeech][:type]).to include('SSML')
    expect(response_object[:outputSpeech][:ssml]).to include('<speak>Testing SSML Alexa Rubykit support!</speak>')

    # The say_response command should create the same object.
    response_say = AlexaRubykit::Response.new
    response_say_object = response_say.say_response('<speak>Testing SSML Alexa Rubykit support!</speak>',true,true)
    expect(response_say_object).to eq(response_object)

    # End session should be true if we didn't specify it.
    expect(response_object[:shouldEndSession]).to eq(true)
    response_object = response.build_response_object(false)
    # And to be false if we tell it to continue the session
    expect(response_object[:shouldEndSession]).to eq(false)
    # say_response should now be NOT equal thanks to endsession.
    expect(response_say_object).not_to eq(response_object)
  end

  it 'should create a valid SSML Alexa say response object when ssml lacks speak tags' do
    response = AlexaRubykit::Response.new
    response.add_speech('Testing SSML Alexa Rubykit support!',true)
    response_object = response.build_response_object
    expect(response_object).to include(:outputSpeech)
    expect(response_object[:outputSpeech][:type]).to include('SSML')
    expect(response_object[:outputSpeech][:ssml]).to include('<speak>')
    expect(response_object[:outputSpeech][:ssml]).to include('</speak>')
    expect(response_object[:outputSpeech][:ssml]).to include('<speak>Testing SSML Alexa Rubykit support!</speak>')
  end

  it 'should create a valid minimum response (body)' do
    # Every response needs a version and a "response object", sessionAttributes is optional.
    # Response Object needs a endsession at a minimum, which we default to true.
    response = AlexaRubykit::Response.new
    response.build_response_object
    response_json = response.build_response
    sample_json = JSON.parse(File.read('fixtures/response-min.json')).to_json
    expect(response_json).to eq(sample_json)
  end

  it 'should create a valid card from a hash' do
    response = AlexaRubykit::Response.new
    response.add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )
    response_json = response.build_response_object
    sample_json = JSON.parse(File.read('fixtures/sample-card.json'))
    expect(response_json.to_json).to eq(sample_json.to_json)
  end

  it 'should create an empty valid card with a response object.' do
    response = AlexaRubykit::Response.new
    response.add_card
    response_json = response.build_response_object
    sample_json = JSON.parse(File.read('fixtures/card-min.json'))
    expect(response_json.to_json).to eq(sample_json.to_json)
  end

  it 'should create a valid response with some attributes' do
    response = AlexaRubykit::Response.new
    response.add_session_attribute('new', false)
    response.add_session_attribute('sessionId', 'amzn-xxx-yyy-zzz')
    response.build_response_object
    response_json = response.build_response
    sample_json = JSON.parse(File.read('fixtures/response-sessionAtt.json')).to_json
    expect(response_json).to eq(sample_json)
  end
  
  it 'should create a valid response with an audio stream directive' do
    response = AlexaRubykit::Response.new
    response.add_audio_url('http://test/url.mp3','token',100)
    response.build_response_object
    response_json = response.build_response
    sample_json = JSON.parse(File.read('fixtures/response-sessionAudio.json')).to_json
    expect(response_json).to eq(sample_json)
  end

  it 'should create a valid response when delegating the dialog to Alexa' do
    response = AlexaRubykit::Response.new
    response.delegate_dialog_response
    response_object = response.build_response_object
    expect(response_object).to include(:directives)
    expect(response_object[:directives]).to include({'type' => 'Dialog.Delegate'})
  end

end