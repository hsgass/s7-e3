module JCP
  module Methods
    include Parser
    extend self

    ACCESS_FLAGS = {
      0x0001  => 'public',
      0x0002  => 'private',
      0x0004  => 'protected',
      0x00080 => 'static',
      0x00100 => 'final',
      0x00200 => 'synchronized',
      0x00400 => 'bridge',
      0x00800 => 'varargs',
      0x01000 => 'native',
      0x04000 => 'abstract',
      0x08000 => 'strictfp',
      0x10000 => 'synthetic'
    }

    def parse(stream, constant_pool)
      parse_elements(Method, stream, constant_pool)
    end

    class Method
      include Parser

      attr_reader :access_flags, :name, :descriptor, :attributes

      def initialize(stream, constant_pool)
        @access_flags = parse_access_flags ACCESS_FLAGS, stream
        @name         = constant_pool[read_2_bytes(stream)]
        @descriptor   = parse_descriptor(stream, constant_pool)
        @attributes   = parse_attributes(stream, constant_pool)
      end

      def to_s
        "#{@access_flags.join(' ')} #{@descriptor} #{@name} #{@attributes}"
      end
    end
  end
end