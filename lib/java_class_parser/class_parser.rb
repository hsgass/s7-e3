module JavaClassParser
  module ClassParser
    extend self

    TAGS = {
      1 => { :proc => Proc.new { |s, c| parse_string s, c } },
      3 => { :proc => Proc.new { |s, c| parse_integer s, c } },
      4 => { :proc => Proc.new { |s, c| parse_float s, c } },
      5 => { :proc        => Proc.new { |s, c| parse_long s, c },
             :extra_bytes => true },
      6 => { :proc        => Proc.new { |s, c| parse_double s, c },
             :extra_bytes => true },
      7 => { :proc => Proc.new { |s, c| parse_single_ref s, c } }, #class ref
      8 => { :proc => Proc.new { |s, c| parse_single_ref s, c } }, # string ref
      9 => { :proc => Proc.new { |s, c| parse_multi_ref s, c } }, # field ref
      10 => { :proc => Proc.new { |s, c| parse_multi_ref s, c } }, # method ref
      11 => { :proc => Proc.new { |s, c| parse_multi_ref s, c } }, # interface
      12 => { :proc => Proc.new { |s, c| parse_multi_ref s, c } } # name/type
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

    def parse_single_ref(stream, constants)
      constants << read_unsigned_int16(stream)
    end

    def parse_multi_ref(stream, constants)
      constants << [read_unsigned_int16(stream), read_unsigned_int16(stream)]
    end

    def get_dereferenced_string(stream, constants)
      index = constants[read_unsigned_int16 stream]
      constants[index]
    end

  end
end
