module JCP
  module Attributes
    include Parser
    extend self

    def parse(stream, constant_pool)
      class_name  = constant_pool[read2_unsigned(stream)]
      limit = stream.read(4).unpack('N').first

      attribute_class = Attributes.const_get(class_name) || NoClass
      attribute_class.new(stream, constant_pool, limit)
    end

    class ConstantValue
      include Parser

      def initialize(stream, constant_pool, limit)
        @value = constant_pool[read2_unsigned(stream)]
      end

      def to_s
        @value.to_s
      end
    end

    class Code
      include Parser

      def initialize(stream, constant_pool, limit)
        limit.times { stream.readbyte unless stream.eof? }
      end

      def to_s
        "Code"
      end
    end

    class NoClass
      include Parser

      def initialize(stream, constant_pool, limit)
        limit.times { stream.readbyte unless stream.eof? }
      end
    end
  end
end