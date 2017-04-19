require 'rspec'
require 'alexa_rubykit'

describe 'Request handling' do

  it 'should accept a proper alexa launch request object' do
    sample_request = JSON.parse(File.read('fixtures/LaunchRequest.json'))
    request = AlexaRubykit::build_request(sample_request)
    expect(request.type).to eq('LAUNCH_REQUEST')
  end

  it 'should correctly identify valid AWS requests' do
    sample_bad_request = { foo: 'bar' }
    expect(AlexaRubykit::valid_alexa?(sample_bad_request)).to be false

    sample_good_request = JSON.parse(File.read('fixtures/sample-IntentRequest.json'))
    expect(AlexaRubykit::valid_alexa?(sample_good_request)).to be true
  end

  it 'should raise an exception when an invalid request is sent' do
    sample_request = 'invalid object!'
    expect { AlexaRubykit::build_request(sample_request)}.to raise_error(ArgumentError)
    sample_request = nil
    expect { AlexaRubykit::build_request(sample_request)}.to raise_error(ArgumentError)
  end

  it 'should create valid intent request type' do
    sample_request = JSON.parse(File.read('fixtures/sample-IntentRequest.json'))
    intent_request = AlexaRubykit::build_request(sample_request)
    expect(intent_request.type).to eq('INTENT_REQUEST')
    expect(intent_request.request_id).not_to be_empty
    expect(intent_request.intent).not_to be_empty
    expect(intent_request.name).to eq('GetZodiacHoroscopeIntent')
    expect(intent_request.slots).not_to be_empty
  end

  it 'should create a valid session end request type' do
    sample_request = JSON.parse(File.read('fixtures/sample-SessionEndedRequest.json'))
    intent_request = AlexaRubykit::build_request(sample_request)
    expect(intent_request.type).to eq('SESSION_ENDED_REQUEST')
    expect(intent_request.request_id).not_to be_empty
    expect(intent_request.reason).to eq('USER_INITIATED')
  end

  it 'should create valid sessions with attributes' do
    sample_request = JSON.parse(File.read('fixtures/sample-IntentRequest.json'))
    intent_request = AlexaRubykit::build_request(sample_request)
    expect(intent_request.session.new?).to be_falsey
    expect(intent_request.session.has_attributes?).to be_truthy
    expect(intent_request.session.user_defined?).to be_truthy
    expect(intent_request.session.attributes).not_to be_empty
  end
  
  it 'transform_keys_to_symbols' do
    string_keys_hash = { "test1" => 'value', "test2" => { "test3" => 'value' } }
    symbol_keys_hash = { test1: 'value', test2: { test3: 'value' } }
    expect(AlexaRubykit.transform_keys_to_symbols(string_keys_hash)).to eq(symbol_keys_hash)
  end
end
