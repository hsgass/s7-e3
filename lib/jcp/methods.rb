require_relative 'parser'

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

    def parse(stream, constants)
      methods = []
      count   = read2_unsigned(stream)
      (0..count - 1).each do
        methods << Method.new(stream, constants)
      end

      methods
    end

    class Method
      include Parser

      attr_reader :access_flags, :name, :descriptor, :attributes

      def initialize(stream, constants)
        @access_flags = []
        flag_bytes    = read2_unsigned(stream)
        ACCESS_FLAGS.each { |k, v| @access_flags << v if (flag_bytes & k > 0) }

        index = read2_unsigned(stream)
        if index
          @name       = constants[index]
          @descriptor = constants[index]
          get_attributes(stream)
        end
      end

      def get_attributes(stream)
        @attributes = []
        count       = read2_unsigned(stream)
        (1..count-1).each do
          @attributes << Attribute.new(stream, @constants)
        end if count < 10
      end

      def to_s
        "#{@name}"
      end
    end
  end
end