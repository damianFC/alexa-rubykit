require 'rspec'
require 'alexa_rubykit/request'

describe 'Request handling' do

  it 'should accept a proper alexa launch request object' do
    sample_request = JSON.parse(File.read('fixtures/LaunchRequest.json'))
    request = AlexaRubykit::Request.new(sample_request)
    expect(request.type).to eq('LAUNCH')
  end

  it 'should raise an exception when an invalid request is sent' do
    sample_request = 'invalid object!'
    expect { AlexaRubykit::Request.new(sample_request)}.to raise_exception
    sample_request = nil
    expect { AlexaRubykit::Request.new(sample_request)}.to raise_exception
  end

end