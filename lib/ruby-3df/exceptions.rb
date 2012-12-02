
module Ruby3DF

  class InvalidCoordinate < StandardError
    def initialize(msg = "Invalid coordinate value")
      super(msg)
    end
  end

  class CoordinateOutOfRange < StandardError
    def initialize(msg = "Coordinate out of range")
      super(msg)
    end
  end

  class InvalidValue < StandardError
    def initialize(msg = "Invalid value supplied")
      super(msg)
    end
  end

  class FileExists < StandardError
    def initialize(msg = "File exists")
      super(msg)
    end
  end

  class ErrorOpeningFile < StandardError
    def initialize(msg = "Error opening to file")
      super(msg)
    end
  end

  class ErrorWritingFile < StandardError
    def initialize(msg = "Error writing to file")
      super(msg)
    end
  end

end
