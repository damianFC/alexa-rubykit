require 'alexa_rubykit/request'
require 'alexa_rubykit/version'
module AlexaRubykit
  def self.print_json(json)
    p json
  end

  def self.print_version
    p AlexaRubykit::VERSION
  end

  # Returns true if all the Alexa request objects are set.
  def self.valid_alexa?(request_json)
    !request_json.nil? || !request_json['session'].nil? ||
        !request_json['version'].nil? || !request_json['request'].nil?
  end
end