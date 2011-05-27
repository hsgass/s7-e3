require_relative 'parser'

module JCP
  module Interfaces
    include Parser
    extend self

    def parse(stream, constants)
      interfaces = []
      count      = read2_unsigned stream
      (1..count).each do
        interfaces << get_dereferenced_string(stream, constants)
      end
      interfaces
    end
  end
end