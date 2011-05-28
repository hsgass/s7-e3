module JCP
  module Interfaces
    include JCP
    extend self

    def parse(stream, constant_pool)
      interfaces = []
      count      = read2_unsigned stream
      (1..count).each do
        interfaces << constant_pool[read2_unsigned(stream)].gsub(/\//, '.')
      end
      interfaces
    end
  end
end