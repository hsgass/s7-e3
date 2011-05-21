require_relative 'parser'

module JCP
  class Fields
    include Parser

    def initialize(stream, constants)
      @constants = constants
      @fields    = []
      count      = read_unsigned_int16(stream)
      (0..count - 1).each do
        @fields << Field.new(stream, @constants)
      end
    end

    def method_missing(name, *args)
      if @fields.respond_to? name
        if args.empty?
          @fields.send(name)
        else
          @fields.send(name, *args)
        end
      end
    end

    def to_s
      @fields.join '  '
    end
  end

  class Field
    include Parser

    attr_accessor :access_flags, :name, :descriptor, :attributes

    def initialize(stream, constants)
      @constants = constants
      get_access_flags(stream)
      @name       = @constants[read_unsigned_int16(stream)]
      @descriptor = @constants[read_unsigned_int16(stream)]
      get_attributes(stream)
    end

    def get_access_flags(stream)
      flag_bytes    = read_unsigned_int16(stream)
      @access_flags = []
      @access_flags << :public if flag_bytes & 0x0001 > 0
      @access_flags << :private if flag_bytes & 0x0002 > 0
      @access_flags << :protected if flag_bytes & 0x0004 > 0
      @access_flags << :static if flag_bytes & 0x0008 > 0
      @access_flags << :final if flag_bytes & 0x0010 > 0
      @access_flags << :volatile if flag_bytes & 0x0040 > 0
      @access_flags << :transient if flag_bytes & 0x0080 > 0
      @access_flags << :synthetic if flag_bytes & 0x1000 > 0
      @access_flags << :enum if flag_bytes & 0x4000 > 0
    end

    def get_attributes(stream)
      @attributes = []
      count       = read_unsigned_int16(stream)
      (1..count).each do
        @attributes << Attribute.new(stream, @constants)
      end
    end

    def to_s
      "#{@attributes.join(' ')} #{@descriptor} #{@name}"
    end
  end

end