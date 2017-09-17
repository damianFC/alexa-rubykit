module AlexaRubykit
  # Represents the encapsulation of Amazon Alexa Dialog Interface
  # https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/dialog-interface-reference
  class Dialog
    DELEGATE_TYPE       = "Dialog.Delegate".freeze
    ELICIT_SLOT_TYPE    = "Dialog.ElicitSlot".freeze
    CONFIRM_SLOT_TYPE   = "Dialog.ConfirmSlot".freeze
    CONFIRM_INTENT_TYPE = "Dialog.ConfirmIntent".freeze

    class << self
      def delegate_directive(updated_intents)
        {
          'type' => DELEGATE_TYPE,
          'updatedIntent' => updated_intents
        }
      end

      def elicit_slot_directive(slot, updated_intents)
        {
          'type' => ELICIT_SLOT_TYPE,
          'slotToElicit' => slot,
          'updatedIntent' => updated_intents
        }
      end

      def confirm_slot_directive(slot, updated_intents)
        {
          'type' => CONFIRM_SLOT_TYPE,
          'slotToConfirm' => slot,
          'updatedIntent' => updated_intents
        }
      end

      def confirm_intent_directive(updated_intents)
        {
          'type' => CONFIRM_INTENT_TYPE,
          'updatedIntent' => updated_intents
        }
      end
    end
  end
end