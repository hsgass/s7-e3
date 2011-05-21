require_relative 'class_parser'

module JavaClassParser
  class JavaClass
    include ClassParser

    attr_accessor :version, :constants, :access_flags, :class, :superclass,
                  :interfaces, :fields, :methods, :attributes

    def initialize(path)
      File.open(path) do |stream|
        raise ArgumentError.new("not a java class file") unless check_magic_number stream
        get_version stream
        get_constants stream
        get_access_flags stream
        @class      = get_string stream
        @superclass = get_string stream
#        get_interfaces stream
#        get_fields stream
#        get_methods stream
#        get_attributes stream
      end
    end


    private
    def check_magic_number(stream)
      'cafebabe' == stream.read(4).unpack('H8').first
    end

    def get_version(stream)
      minor    = read_unsigned_int16 stream
      major    = read_unsigned_int16 stream
      @version = "#{major}.#{minor}"
    end

    def get_constants(stream)
      # the constant pool index starts at 1,
      # so fill in the zeroth index of the array
      @constants = [] << 0

      # count indicates the number of "slots" in the constant pool.
      # longs and doubles consume 2 slots, so there must
      # be one less read per long or double value.
      count = read_unsigned_int16 stream
      read  = 1
      while (read < count)
        tag  = stream.getbyte
        hash = TAGS[tag]
        if hash
          hash[:proc].call(stream, @constants)
          read += 1
          read += 1 if hash[:extra_bytes]
        end
      end
    end

    def get_access_flags(stream)
      @access_flags = []
      flag_bytes    = read_unsigned_int16 stream
    end

    def get_string(stream)
      index = @constants[read_unsigned_int16 stream]
      puts "index=#{index}"
      @constants[index]
    end

    def get_interfaces(stream)
      @interfaces = [] << 0
      count       = read_unsigned_int16 stream
      puts count
      (1..count).each do
        tag  = stream.getbyte
        hash = TAGS[tag]
        hash[:proc].call(stream, @interfaces) if hash
      end
    end

#    def get_fields(stream)
#      @fields = [] << 0
#      count   = read_unsigned_int16 stream
#      (1..count).each do
#        tag  = stream.getbyte
#        hash = TAGS[tag]
#        hash[:proc].call(stream, @fields) if hash
#      end
#    end
#
#    def get_methods(stream)
#      @methods = [] << 0
#      count    = read_unsigned_int16 stream
#      (1..count).each do
#        tag  = stream.getbyte
#        hash = TAGS[tag]
#        hash[:proc].call(stream, @methods) if hash
#      end
#    end
#
#    def get_attributes(stream)
#      @attributes = [] << 0
#      count       = read_unsigned_int16 stream
#      (1..count).each do
#        tag  = stream.getbyte
#        hash = TAGS[tag]
#        hash[:proc].call(stream, @attributes) if hash
#      end
#    end
  end
end

