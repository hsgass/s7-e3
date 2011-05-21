require_relative 'class_parser'

module JavaClassParser
  class JavaClass
    include ClassParser

    attr_accessor :class_file, :version, :constants

    def initialize(path)
      @class_file = File.open(path) do |stream|
        raise ArgumentError.new("not a java class file") unless check_magic_number stream
        get_version stream
        get_constants stream
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
      @constants = [] << 0
      count      = read_unsigned_int16 stream
      (1..count).each do
        tag  = stream.getbyte
        proc = TAGS[tag]
        proc.call(stream, @constants) if proc
      end
    end

  end
end

