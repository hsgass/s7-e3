require_relative 'class_parser'
module JavaClassParser
  class Constant
    include ClassParser

    attr_accessor :constants, :name, :value, :value_ref, :class_ref,
                  :name_type_ref, :name_ref

    def initialize(stream, constants)
      @constants = constants
      @constants << self

      tag = stream.getbyte
      h   = TAGS[tag]
      if h
        proc = h[:proc]
        proc.call(stream, self)
      end
    end

    def name
      ref = @name_ref
      ref = @class_ref unless ref
      ref = @name_type_ref unless ref
      @constants[ref].value if ref
    end

    def value
      if @value_ref
        @value = @constants[@value_ref].value unless @value
      end
      @value
    end

    def to_s
      "#{name} = #{value}"
    end
  end
end