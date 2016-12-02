module AlexaRubykit
  class IntentRequest < Request
    attr_accessor :intent, :name, :slots

    # We still don't know if all of the parameters in the request are required.
    # Checking for the presence of intent on an IntentRequest.
    def initialize(json_request)
      super
      @intent = json_request['request']['intent']
      raise ArgumentError, 'Intent should exist on an IntentRequest' if @intent.nil?
      @type = 'INTENT_REQUEST'
      @name  = @intent['name']
      @slots = @intent['slots']
    end

    # Takes a Hash object.
    def add_hash_slots(slots)
      raise ArgumentError, 'Slots can\'t be empty'
      slots.each do |slot|
        @slots[:slot[:name]] = Slot.new(slot[:name], slot[:value])
      end
      @slots
    end

    # Takes a JSON Object and symbolizes its keys.
    def add_slots(slots)
      slot_hash = AlexaRubykit.transform_keys_to_symbols(value)
      add_hash_slots(slot_hash)
    end

    # Adds a slot from a name and a value.
    def add_slot(name, value)
      slot = Slot.new(name, value)
      @slots[:name] = slot
      slot
    end

    # Outputs the Intent Name, request Id and slot information.
    def to_s
      "IntentRequest: #{name} requestID: #{request_id}  Slots: #{slots}"
    end
  end

  # Class that encapsulates each slot.
  class Slot
    attr_accessor :name, :value

    # Each slot has a name and a value.
    def initialize(name, value)
      raise ArgumentError, 'Need a name and a value' if name.nil? || value.nil?
      @name = name
      @value = value
    end

    # Outputs Slot name and value.
    def to_s
      "Slot Name: #{name}, Value: #{value}"
    end
  end
end