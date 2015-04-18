module AlexaRubyKit
  module Slot
    require 'json'
    # An Alexa Slot is an optional parameter in the main intent schema.
    # In the case of an app called with an intent 'GetStockQuotes' a slot would be
    # the stock symbol and the date.
    # 'Alexa get the quote for {stockname|Amazon}', the slot name in this case is the stockname and the value 'Amazon'.
    attr_accessor slot_name
    attr_accessor slot_value

    # Builds a JSON representation of the slot.
    # Type defaults to 'literal' if nothing is specified.
    def self.builder(name, value)
      slot = { :name => name, :value => value}
      slot.to_json
    end

    def self.parse(response_json)
      parsed_hash = JSON.parse(response_json)
      @slot_name = parsed_hash[:name]
      @slot_value = parsed_hash[:value]
    end

    # Checks if the slot_value is empty.
    def self.empty?
      @slot_value.nil?
    end

    # Checks if the slot_name is defined.
    def self.nil?
      @slot_name.nil?
    end

  end
end