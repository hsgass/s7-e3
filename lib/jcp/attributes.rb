module JCP
  module Attributes
    extend Parser

    def self.parse(stream, constant_pool)
      index = read2_unsigned(stream)

      name  = constant_pool[index]
      limit = stream.read(4).unpack('N').first
      begin
        clazz = Attributes.const_get(name) || NoClass
      rescue
        clazz = NoClass
      end
      clazz.new(stream, constant_pool, limit)
    end

    class ConstantValue
      def initialize(stream, constant_pool)
        @value = constant_pool[read2_unsigned(stream)]
      end

      def to_s
        @value
      end
    end

    class NoClass
      def initialize(stream, constant_pool, limit)
        limit.times { stream.readbyte unless stream.eof? }
      end
    end
  end
end