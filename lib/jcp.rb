require_relative 'jcp/parser'
require_relative 'jcp/constant_pool'
require_relative 'jcp/fields'
require_relative 'jcp/interfaces'
require_relative 'jcp/java_class'
require_relative 'jcp/methods'
require_relative 'jcp/attributes'

module JCP

  DESCRIPTORS = {
    'B' => 'byte',
    'C' => 'char',
    'D' => 'double',
    'F' => 'float',
    'I' => 'int',
    'J' => 'long',
    'L' => 'reference',
    'S' => 'short',
    'Z' => 'boolean'
  }

  def parse_descriptor(stream, constant_pool)
    d = constant_pool[read2_unsigned(stream)]
    d.gsub! /[\(\)]/, ''
    descriptor = DESCRIPTORS[d]
    unless descriptor
      descriptor = d[1..-1].gsub(/\//, '.').chop if d[0] == 'L'
      descriptor = "#{d[1..-1]}[]" if d[0] == '['
    end
    descriptor
  end

  def parse_elements(clazz, stream, constant_pool)
    arr   = []
    count = read2_unsigned(stream)
    (1..count).each do
      arr << clazz.new(stream, constant_pool) unless stream.eof?
    end
    arr
  end

  def parse_access_flags(flag_hash, stream)
    access_flags = []
    flag_bytes   = read2_unsigned stream
    flag_hash.each { |k, v| access_flags << v if (flag_bytes & k > 0) }
    access_flags
  end

  def read2_unsigned(stream)
    value = stream.read(2)
    value.unpack('n').first if value
  end

  def get_attributes(stream, constant_pool)
    attributes = []
    count      = read2_unsigned(stream)
    (1..count).each do
      attributes << Attributes.parse(stream, constant_pool)
    end
    attributes
  end
end
