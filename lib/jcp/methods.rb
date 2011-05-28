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

    def parse(stream, constant_pool)
      methods = []
      count   = read2_unsigned(stream)
      (0..count - 1).each do
        methods << Method.new(stream, constant_pool) unless stream.eof?
      end

      methods
    end

    class Method
      include Parser

      attr_reader :access_flags, :name, :descriptor, :attributes

      def initialize(stream, constant_pool)
        @access_flags = []
        flag_bytes    = read2_unsigned(stream)
        ACCESS_FLAGS.each { |k, v| @access_flags << v if (flag_bytes & k > 0) }

        index = read2_unsigned(stream)
        if index
          @name       = constant_pool[index]
          @descriptor = constant_pool[index]
          get_attributes(stream, constant_pool)
        end
      end

      def get_attributes(stream, constant_pool)
        @attributes = []
        count       = read2_unsigned(stream)
        (1..count).each do
          @attributes << Attributes.parse(stream, constant_pool)
        end
      end

      def to_s
        "#{@name}"
      end
    end
  end
end