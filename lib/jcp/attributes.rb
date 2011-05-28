module JCP
  module Attributes
    include JCP
    extend self

    def self.parse(stream, constant_pool)
      name  = constant_pool[read2_unsigned(stream)]
      limit = stream.read(4).unpack('N').first
      begin
        clazz = Attributes.const_get(name) || NoClass
      rescue
        clazz = NoClass
      end
      clazz.new(stream, constant_pool, limit)
    end

    class ConstantValue
      include JCP
      def initialize(stream, constant_pool)
        @value = constant_pool[read2_unsigned(stream)]
      end

      def to_s
        @value
      end
    end

    class NoClass
      include JCP
      def initialize(stream, constant_pool, limit)
        @value = constant_pool[read2_unsigned(stream)]
        (limit - 2).times { stream.readbyte unless stream.eof? }
      end

      def to_s
        @value
      end
    end
  end
end