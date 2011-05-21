require_relative 'parser'

module JCP
  class Interfaces
    include Parser

    def initialize(stream, constants)
      @constants  = constants
      @interfaces = []
      count       = read_unsigned_int16 stream
      (1..count).each do
        @interfaces << get_dereferenced_string(stream, @constants)
      end
    end

    def method_missing(name, *args)
      if @interfaces.respond_to? name
        if args.empty?
          @interfaces.send(name)
        else
          @interfaces.send(name, *args)
        end
      end
    end

    def to_s
      @interfaces.join ', '
    end
  end
end