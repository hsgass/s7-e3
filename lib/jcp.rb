require_relative 'jcp/access_flags'
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

  def parse_descriptor(constant_pool, stream)
    d           = constant_pool[read2_unsigned(stream)]
    d.gsub! /[\(\)]/, ''
    descriptor = DESCRIPTORS[d]
    unless descriptor
      descriptor = d[1..-1].gsub(/\//, '.').chop if d[0] == 'L'
      descriptor = "#{d[1..-1]}[]" if d[0] == '['
    end
    descriptor
  end

end
