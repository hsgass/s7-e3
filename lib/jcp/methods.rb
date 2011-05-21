require_relative 'parser'

module JCP
  class Methods
    include Parser

    def initialize(stream, constants)
      @constants = constants
      @methods   = []
      count      = read_unsigned_int16(stream)
      (0..count - 1).each do
        @methods << Method.new(stream, @constants)
      end
    end

    def method_missing(name, *args)
      if @methods.respond_to? name
        if args.empty?
          @methods.send(name)
        else
          @methods.send(name, *args)
        end
      end
    end

    def to_s
      @methods.join '  '
    end
  end

  class Method
    include Parser

    attr_accessor :access_flags, :name, :descriptor, :attributes

    def initialize(stream, constants)
      @constants = constants
      get_access_flags(stream)
      index = read_unsigned_int16(stream)
      if index
        @name       = @constants[index]
        @descriptor = @constants[index]
        get_attributes(stream)
      end
    end

    def get_access_flags(stream)
      flag_bytes    = read_unsigned_int16(stream)
      @access_flags = []
      @access_flags << :public if flag_bytes & 0x0001
      @access_flags << :private if flag_bytes & 0x0002
      @access_flags << :protected if flag_bytes & 0x0004
      @access_flags << :static if flag_bytes & 0x00080
      @access_flags << :final if flag_bytes & 0x00100
      @access_flags << :synchronized if flag_bytes & 0x00200
      @access_flags << :bridge if flag_bytes & 0x00400
      @access_flags << :varargs if flag_bytes & 0x00800
      @access_flags << :native if flag_bytes & 0x01000
      @access_flags << :abstract if flag_bytes & 0x04000
      @access_flags << :strictfp if flag_bytes & 0x08000
      @access_flags << :synthetic if flag_bytes & 0x10000
    end

    def get_attributes(stream)
      @attributes = []
      count       = read_unsigned_int16(stream)
      (1..count-1).each do
        @attributes << Attribute.new(stream, @constants)
      end if count < 10
    end

    def to_s
      "#{@name}"
    end
  end

end