
module Ruby3DF

  class File

    DEFAULT_BODY_OFFSET = 1024

    def initialize( filename )

      @filename = filename

      self.open

      if @f
        @header = FileHeader.new
        self.read_header  
      else
        raise ErrorOpeningFile
      end

    end

    protected

    def create_header
      # body_offset
      @f.pos = 0
      @f.write [ DEFAULT_BODY_OFFSET ].pack( 'S' )

      # x_min, x_max, z_min, z_max, y_min, y_max
      @f.pos = 2
      @f.write [ 0, 0, 0, 0, 0, 0 ].pack( 'S*' )

      # Set the pos to the start of the data section
      @f.pos = DEFAULT_BODY_OFFSET - 1
      
    end

    def read_header

      # Read body_offset
      @f.pos = 0
      @header.body_offset = @f.read( 2 ).unpack( 'S' )[0]
      @header.x_min = @f.read( 2 ).unpack( 'S' )[0]
      @header.x_max = @f.read( 2 ).unpack( 'S' )[0]
      @header.z_min = @f.read( 2 ).unpack( 'S' )[0]
      @header.z_max = @f.read( 2 ).unpack( 'S' )[0]
      @header.y_min = @f.read( 2 ).unpack( 'S' )[0]
      @header.y_max = @f.read( 2 ).unpack( 'S' )[0]

      payload_name = @f.read( 64 )
      if payload_name
        
        @header.payload = Object.const_get("Ruby3DF").const_get( payload_name.gsub(/\x00/, '' ) ).new
      end


      # Set the pos to the start of the data section
      @f.pos = DEFAULT_BODY_OFFSET - 1

    end
    
    public

    def set_size( x_range, z_range, y_range )

      # Valid X Range Input
      if x_range.is_a? Integer
        @x_range = [0, x_range]
      elsif x_range.is_a? Array and x_range.length == 2
        @x_range = x_range
      else
        raise InvalidCoordinate
      end  

      # Valid Z Range Input
      if z_range.is_a? Integer
        @z_range = [0, z_range]
      elsif z_range.is_a? Array and z_range.length == 2
        @z_range = z_range
      else
        raise InvalidCoordinate
      end  

      # Valid Y Range Input
      if y_range.is_a? Integer
        @y_range = [0, y_range]
      elsif y_range.is_a? Array and y_range.length == 2
        @y_range = y_range
      else
        raise InvalidCoordinate
      end  

    end

    def set_payload( payload )

      @f.pos = 16
      @f.write payload.class.name.split('::')[-1]

      self.read_header

    end

    def value_at( coordinates, value = false )

      # Validate coordinates
      raise InvalidCoordinate unless coordinates.length == 3

      x = coordinates[0]
      z = coordinates[1]
      y = coordinates[2]

      self.set_pos( x, z, y )

      if value
        self.value value
      else
        self.value
      end

    end

    def set_pos( x, z, y )

      # Validate coordinates

      raise CoordinateOutOfRange if x <= @x_range[0] or x >= @x_range[1]
      raise CoordinateOutOfRange if z <= @z_range[0] or z >= @z_range[1]
      raise CoordinateOutOfRange if y <= @y_range[0] or y >= @y_range[1]


      # Calculate position in file to store value

      x_offset = @x_range[1] - @x_range[0]
      z_offset = @z_range[1] - @z_range[0]
      y_offset = @y_range[1] - @y_range[0]

      x_ajusted = x + (0 - @x_range[0])
      z_ajusted = z + (0 - @z_range[0])
      y_ajusted = y + (0 - @y_range[0])

      pos = ( (y_ajusted*(x_offset*z_offset)) + (z_ajusted*x_offset) * @header.payload.size ) + x_ajusted

      @pos = @header.body_offset + pos

    end

    def value( value = false )

      # Validate value - Does it match the Payload type specified?
      @header.payload.validate_value value if value
      
      raise ErrorWritingFile unless @f
      @f.pos = @pos

      if value
        puts "Writing value: #{value} to file position: #{@pos}"
        @f.write [ value ].pack( @header.payload.aTemplateString )
      else
        p @f.read( @header.payload.size ).unpack( @header.payload.aTemplateString )[0]
      end

    end

    def open

      if ::File.exists?( @filename )
        @f = ::File.open(@filename, 'r+')
      else
        new_file = true
        @f = ::File.open(@filename, 'w+')
      end


      if new_file
        self.create_header
      end

    end

    def close

      ensure @f.close

    end

  end

end
