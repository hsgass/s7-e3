module JCP
  module Fields
    include JCP
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

    def parse(stream, constant_pool)
      parse_elements(Field, stream, constant_pool)
    end

    class Field
      include JCP

      attr_reader :access_flags, :name, :descriptor, :attributes

      def initialize(stream, constant_pool)
        @access_flags = parse_access_flags ACCESS_FLAGS, stream
        @name         = constant_pool[read2_unsigned(stream)]
        @descriptor   = parse_descriptor(stream, constant_pool)
        @attributes   = get_attributes(stream, constant_pool)
      end

      def to_s
        "#{@access_flags.join(' ')} #{@descriptor} #{@name}"
      end
    end
  end
end