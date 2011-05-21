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
        @class      = get_dereferenced_string stream, @constants
        @superclass = get_dereferenced_string stream, @constants
        get_interfaces stream
        get_fields stream
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
      flag_bytes    = read_unsigned_int16 stream
      @access_flags = []
      @access_flags << 'Public' if flag_bytes & 0x0001 > 0
      @access_flags << 'Final' if flag_bytes & 0x0010 > 0
      @access_flags << 'Super' if flag_bytes & 0x0020 > 0
      @access_flags << 'Interface' if flag_bytes & 0x0200 > 0
      @access_flags << 'Abstract' if flag_bytes & 0x0400 > 0
      @access_flags << 'Synthetic' if flag_bytes & 0x1000 > 0
      @access_flags << 'Annotation' if flag_bytes & 0x2000 > 0
      @access_flags << 'Enum' if flag_bytes & 0x4000 > 0
    end

    def get_interfaces(stream)
      @interfaces = []
      count       = read_unsigned_int16 stream
      (1..count).each do
        @interfaces << get_dereferenced_string(stream, @constants)
      end
    end

    def get_fields(stream)
      @fields = []
      count   = read_unsigned_int16 stream
      (1..count).each do
        @fields << @constants[read_unsigned_int16 stream]
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

