module JCP
  class JavaClass
    include ClassParser

    attr_accessor :version, :constants, :access_flags, :class, :superclass,
                  :interfaces, :fields, :methods, :attributes

    def initialize(path)
      File.open(path) do |stream|
        raise ArgumentError.new("not a java class file") unless check_magic_number stream
        get_version(stream)
        @constants    = Constants.new(stream)
        @access_flags = AccessFlags.new(stream)
        @class        = get_dereferenced_string(stream, @constants)
        @superclass   = get_dereferenced_string(stream, @constants)
        @interfaces   = Interfaces.new(stream, constants)
        @fields       = Fields.new(stream, @constants)
        @methods      = Methods.new(stream, @constants)
      end
    end

    def to_s
      "#{access_flags} class #{@class} extends #{@superclass} implements #{@interfaces}"
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
  end
end

