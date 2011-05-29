module JCP
  module Parser
    extend self

    DESCRIPTORS = {
      'B' => 'byte',
      'C' => 'char',
      'D' => 'double',
      'F' => 'float',
      'I' => 'int',
      'J' => 'long',
      'S' => 'short',
      'Z' => 'boolean'
    }

    def parse_descriptor(stream, constant_pool)
      d = constant_pool[read2_unsigned(stream)]
      d.gsub! /[\(\)]/, ''

      descriptor = DESCRIPTORS[d]

      if descriptor.nil?
        descriptor = d[1..-1].gsub(/\//, '.').chop if d[0] == 'L'
        descriptor = "#{d[1..-1]}[]" if d[0] == '['
      end

      descriptor
    end

    def parse_elements(clazz, stream, constant_pool)
      elements   = []
      count = read2_unsigned(stream)
      (1..count).each do
        elements << clazz.new(stream, constant_pool) unless stream.eof?
      end

      elements
    end

    def parse_access_flags(flag_hash, stream)
      access_flags = []
      flag_bytes   = read2_unsigned stream
      flag_hash.each { |k, v| access_flags << v if (flag_bytes & k > 0) }

      access_flags
    end

    def parse_attributes(stream, constant_pool)
      attributes = []
      count      = read2_unsigned(stream)
      (1..count).each do
        attributes << Attributes.parse(stream, constant_pool)
      end

      attributes
    end

    def read2_unsigned(stream)
      stream.read(2).unpack('n').first
    end

    def twos_complement(value, bits)
      (value & ~(1 << bits)) - (value & (1 << bits))
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
      value = (0..7).inject(0) { |v, i| v + (bytes[i] << (8 * i)) }

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
  end
end
