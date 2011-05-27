require_relative 'parser'

module JCP
  module Fields
    include Parser
    extend self

    ACCESS_FLAGS = {
      0x0001 => 'public',
      0x0002 => 'private',
      0x0004 => 'protected',
      0x0008 => 'static',
      0x0010 => 'final',
      0x0040 => 'volatile',
      0x0080 => 'transient',
      0x1000 => 'synthetic',
      0x4000 => 'enum'
    }

    def parse(stream, constants)
      fields = []
      count  = read2_unsigned(stream)
      (0..count - 1).each do
        fields << Field.new(stream, constants)
      end

      fields
    end

    class Field
      include Parser

      attr_reader :access_flags, :name, :descriptor, :attributes

      def initialize(stream, constants)
        @access_flags = []
        flag_bytes    = read2_unsigned stream
        ACCESS_FLAGS.each { |k, v| @access_flags << v if (flag_bytes & k > 0) }

        @name       = constants[read2_unsigned(stream)]
        @descriptor = constants[read2_unsigned(stream)]
        get_attributes(stream)
      end

      def get_attributes(stream)
        @attributes = []
        count       = read2_unsigned(stream)
        (1..count).each do
          @attributes << Attribute.new(stream, @constants)
        end
      end

      def to_s
        "#{@attributes.join(' ')} #{@descriptor} #{@name}"
      end
    end
  end
end