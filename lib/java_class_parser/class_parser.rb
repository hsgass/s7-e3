module JavaClassParser
  module ClassParser
    extend self

    TAGS = {
      1  => Proc.new { |stream, constants| parse_string stream, constants },
      3  => Proc.new { |stream, constants| parse_integer stream, constants },
      4  => Proc.new { |stream, constants| parse_float stream, constants },
      5  => Proc.new { |stream, constants| parse_long stream, constants },
      6  => Proc.new { |stream, constants| parse_double stream, constants },
      7  => Proc.new { |stream, constants| parse_class_ref stream, constants },
      8  => Proc.new { |stream, constants| parse_string_ref stream, constants },
      9  => Proc.new { |stream, constants| parse_field_ref stream, constants },
      10 => Proc.new { |stream, constants| parse_method_ref stream, constants },
      11 => Proc.new { |stream, constants| parse_interface_method_ref stream, constants },
      12 => Proc.new { |stream, constants| parse_name_and_type_ref stream, constants }
    }

    def twos_complement(value, bits)
      (value & ~(1 << bits)) - (value & (1 << bits))
    end

    def read_unsigned_int16(stream)
      stream.read(2).unpack('n').first
    end

    def parse_string(stream, constants)
      byte_count = read_unsigned_int16 stream
      constants << stream.read(byte_count).unpack("A#{byte_count}").first
    end

    def parse_integer(stream, constants)
      constants << twos_complement(stream.read(4).unpack('N').first, 31)
    end

    def parse_float(stream, constants)
      constants << stream.read(4).unpack('g').first
    end

    def parse_long(stream, constants)
      # longs are big-endian and there's no pattern to parse them,
      # so read the bytes one at a time.
      bytes = []
      8.times { bytes << stream.readbyte }

      # shift each byte into the value according to its position,
      # starting at the smallest number.
      bytes.reverse!
      value = (0..7).inject(0) { |v, i| v += (bytes[i] << (8 * i)) }

      # 8-byte values take 2 places in the constant table
      constants << twos_complement(value, 63)
      constants << nil
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
