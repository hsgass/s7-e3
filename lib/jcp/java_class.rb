module JCP
  class JavaClass
    include JCP

    attr_accessor :version, :constant_pool, :access_flags, :class,
                  :superclass, :interfaces, :fields, :methods

    ACCESS_FLAGS = {
      0x0001 => 'public',
      0x0010 => 'final',
      0x0020 => 'super',
      0x0200 => 'interface',
      0x0400 => 'abstract',
      0x1000 => 'synthetic',
      0x2000 => 'annotation',
      0x4000 => 'enum'
    }

    def initialize(path)
      File.open(path) do |stream|
        raise ArgumentError.new("not a class") unless check_magic_number stream
        get_version(stream)
        @constant_pool = ConstantPool.new(stream)
        @access_flags  = parse_access_flags ACCESS_FLAGS, stream
        @class         = @constant_pool[read2_unsigned(stream)].gsub(/\//, '.')
        @superclass    = @constant_pool[read2_unsigned(stream)].gsub(/\//, '.')
        @interfaces    = Interfaces.parse(stream, constant_pool)
        @fields        = Fields.parse(stream, @constant_pool)
        @methods       = Methods.parse(stream, @constant_pool)
      end
    end

    def to_s
      "#{access_flags.join(' ')} class #{@class} extends #{@superclass}" +
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

