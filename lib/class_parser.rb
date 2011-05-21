module JavaClassParser
  module ClassParser
    extend self

    TAGS = {
      1  => lambda { |stream, constants| parse_string stream, constants },
      3  => lambda { |stream, constants| parse_integer stream, constants },
      4  => lambda { |stream, constants| parse_float stream, constants },
      5  => lambda { |stream, constants| parse_long stream, constants },
      6  => lambda { |stream, constants| parse_double stream, constants },
      7  => lambda { |stream, constants| parse_class_ref stream, constants },
      8  => lambda { |stream, constants| parse_string_ref stream, constants },
      9  => lambda { |stream, constants| parse_field_ref stream, constants },
      10 => lambda { |stream, constants| parse_method_ref stream, constants },
      11 => lambda { |stream, constants| parse_interface_method_ref stream, constants },
      12 => lambda { |stream, constants| parse_name_and_type_ref stream, constants }
    }

    def twos_complement(value)
       [value].pack('q').unpack('q').first
#      (value & ~(1 << 63)) - (value & (1 << 63))
#      out = ~value + 1
    end

    def read_unsigned_int16(stream)
      stream.read(2).unpack('n').first
    end

    def parse_string(stream, constants)
      byte_count = read_unsigned_int16 stream
      constants << stream.read(byte_count).unpack("A#{byte_count}").first
    end

    def parse_integer(stream, constants)
      constants << twos_complement(stream.read(4).unpack('N').first)
    end

    def parse_float(stream, constants)
      constants << stream.read(4).unpack('g').first
    end

    def parse_long(stream, constants)
#      bytes = []
#      8.times do
#        bytes << stream.readbyte
#      end
#     value = 0
#      7.downto(0) do |i|
#        value += bytes[i] << i * 8
#      end
      value = stream.read(8).unpack('N').first
constants << [value].pack('q').unpack('q').first
#      constants << twos_complement(reversed)
#      constants << nil
    end

    def parse_double(stream, constants)
      constants << stream.read(8).unpack('G').first
      constants << nil
    end

    def parse_class_ref(stream, constants)
      constants << read_unsigned_int16(stream)
    end

    def parse_string_ref(stream, constants)
      constants << read_unsigned_int16(stream)
    end

    def parse_field_ref(stream, constants)
      constants << [read_unsigned_int16(stream), read_unsigned_int16(stream)]
    end

    def parse_method_ref(stream, constants)
      constants << [read_unsigned_int16(stream), read_unsigned_int16(stream)]
    end

    def parse_interface_method_ref(stream, constants)
      constants << [read_unsigned_int16(stream), read_unsigned_int16(stream)]
    end

    def parse_name_and_type_ref(stream, constants)
      constants << [read_unsigned_int16(stream), read_unsigned_int16(stream)]
    end

  end
end
