module JCP
  module Parser
    extend self

    def twos_complement(value, bits)
      (value & ~(1 << bits)) - (value & (1 << bits))
    end

    def read2_unsigned(stream)
      value = stream.read(2)
      value.unpack('n').first if value
    end

    def parse_string(stream)
      byte_count = read2_unsigned(stream)
      stream.read(byte_count).unpack("A#{byte_count}").first
    end

    def parse_integer(stream)
      twos_complement(stream.read(4).unpack('N').first, 31)
    end

    def parse_float(stream)
      stream.read(4).unpack('g').first
    end

    def parse_long(stream)
      # longs are big-endian and there's no pattern to parse them,
      # so read the bytes one at a time.
      bytes = []
      8.times { bytes << stream.readbyte }

      # shift each byte into the value according to its position,
      # starting at the smallest number.
      bytes.reverse!
      value = (0..7).inject(0) { |v, i| v += (bytes[i] << (8 * i)) }

      twos_complement(value, 63)
    end

    def parse_double(stream)
      stream.read(8).unpack('G').first
    end

    def parse_single_ref(stream)
      read2_unsigned(stream)
    end

    def parse_multi_ref(stream)
      [read2_unsigned(stream), read2_unsigned(stream)]
    end

    def get_dereferenced_string(stream, constant_pool)
      index = constant_pool[read2_unsigned(stream)]
      constant_pool[index]
    end

  end
end
