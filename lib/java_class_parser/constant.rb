require_relative 'class_parser'
module JavaClassParser
  class Constant
    attr_reader :tag, :value, :references
    include ClassParser

    def initialize(stream, constants)
      @constants  = constants

      tag  = stream.getbyte
      proc = TAGS[tag]
      proc.call(stream, @constants) if proc
    end

    def name

    end

    def value

    end

  end
end