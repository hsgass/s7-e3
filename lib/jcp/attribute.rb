module JCP
  class Attribute
    include Parser

    def initialize(stream, constants)
      index = read_unsigned_int16(stream)
      if index
        @name  = constants[index]
        length = stream.read(4).unpack('N').first
        @info  = stream.readbyte
      end
    end
  end
end