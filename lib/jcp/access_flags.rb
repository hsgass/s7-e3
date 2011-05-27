require_relative 'parser'

module JCP
  module AccessFlags
    include Parser
    extend self

    FLAGS = {
      0x0001 => 'public',
      0x0010 => 'final',
      0x0020 => 'super',
      0x0200 => 'interface',
      0x0400 => 'abstract',
      0x1000 => 'synthetic',
      0x2000 => 'annotation',
      0x4000 => 'enum'
    }

    def parse(stream)
      access_flags = []
      flag_bytes   = read2_unsigned stream
      FLAGS.each { |k, v| access_flags << v if (flag_bytes & k > 0) }
      access_flags
    end
  end
end