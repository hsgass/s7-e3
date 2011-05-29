module JCP
  module Interfaces
    include Parser
    extend self

    def parse(stream, constant_pool)
      interfaces = []
      count      = read2_bytes stream
      (1..count).each do
        interfaces << constant_pool[read2_bytes(stream)].gsub(/\//, '.')
      end
      interfaces
    end
  end
end