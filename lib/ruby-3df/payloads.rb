
module Ruby3DF

  class Payload

  end

  class UInt8Bit < Payload

    attr_reader :aTemplateString, :size

    def initialize
      super

      @aTemplateString = 'C'

      @size = 1

    end

    def validate_value( value )

      raise InvalidValue unless value.is_a? Integer and value < 2**8

    end

  end

end
