require 'alexa_rubykit/request'
require 'alexa_rubykit/version'
module AlexaRubykit
  def self.print_json(json)
    p json
  end

  def self.print_version
    p AlexaRubykit::VERSION
  end
end