module JCP
  class JavaClass
    include Parser

    attr_accessor :version, :constant_pool, :access_flags, :class, :superclass,
                  :interfaces, :fields, :methods, :attributes

    def initialize(path)
      File.open(path) do |stream|
        raise ArgumentError.new("not a java class file") unless check_magic_number stream
        get_version(stream)
        @constant_pool    = ConstantPool.new(stream)
        @access_flags = AccessFlags.parse(stream)
        @class        = get_dereferenced_string(stream, @constant_pool).gsub(/\//, '.')
        @superclass   = get_dereferenced_string(stream, @constant_pool).gsub(/\//, '.')
        @interfaces   = Interfaces.parse(stream, constant_pool)
        @fields       = Fields.parse(stream, @constant_pool)
        @methods      = Methods.parse(stream, @constant_pool)
      end
    end

    def to_s
      "#{access_flags.join(' ')} class #{@class} extends #{@superclass}"+
        " implements #{@interfaces.join ' '}"
    end

    private

    def check_magic_number(stream)
      'cafebabe' == stream.read(4).unpack('H8').first
    end

    def get_version(stream)
      minor    = read2_unsigned stream
      major    = read2_unsigned stream
      @version = "#{major}.#{minor}"
    end
  end
end

