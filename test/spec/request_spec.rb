require 'rspec'
require 'alexa_rubykit/request'

describe 'Request handling' do

  it 'should accept a proper alexa launch request object' do
    sample_request = JSON.parse(File.read('fixtures/LaunchRequest.json'))
    request = AlexaRubykit::Request.new(sample_request)
    request.type.should == 'LAUNCH'
  end

  it 'should raise an exception when an invalid request is sent' do
    sample_request = 'invalid object!'
    expect { AlexaRubykit::Request.new(sample_request)}.to raise_exception
    sample_request = nil
    expect { AlexaRubykit::Request.new(sample_request)}.to raise_exception
  end

  # Possibly add a response object that handles an alexa response.
  it 'should create a valid Alexa say object' do

  end
end