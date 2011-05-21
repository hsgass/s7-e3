module JCP
  class Constants
    include ClassParser

    TAGS = {
      1 => { :proc => Proc.new { |s, c| ClassParser.parse_string(s, c) } },
      3 => { :proc => Proc.new { |s, c| ClassParser.parse_integer(s, c) } },
      4 => { :proc => Proc.new { |s, c| ClassParser.parse_float(s, c) } },
      5 => { :extra_bytes => true,
             :proc        => Proc.new { |s, c| ClassParser.parse_long(s, c) }
      },
      6 => { :extra_bytes => true,
             :proc        => Proc.new { |s, c| ClassParser.parse_double(s, c) }
      },
      # class ref:
      7 => { :proc => Proc.new { |s, c| ClassParser.parse_single_ref(s, c) } },
      # string ref:
      8 => { :proc => Proc.new { |s, c| ClassParser.parse_single_ref(s, c) } },
      # field ref:
      9 => { :proc => Proc.new { |s, c| ClassParser.parse_multi_ref(s, c) } },
      # method ref:
      10 => { :proc => Proc.new { |s, c| ClassParser.parse_multi_ref(s, c) } },
      # interface:
      11 => { :proc => Proc.new { |s, c| ClassParser.parse_multi_ref(s, c) } },
      # name/type:
      12 => { :proc => Proc.new { |s, c| ClassParser.parse_multi_ref(s, c) } }
    }

    def initialize(stream)

      # the constant pool index starts at 1,
      # so fill in the zeroth index of the array
      @constants = [] << 0

      # count indicates the number of "slots" in the constant pool.
      # longs and doubles consume 2 slots, so there must
      # be one less read per long or double value.
      count = read_unsigned_int16 stream
      read  = 1
      while (read < count)
        tag  = stream.getbyte
        hash = TAGS[tag]
        if hash
          hash[:proc].call(stream, @constants)
          read += 1
          read += 1 if hash[:extra_bytes]
        end
      end
    end

    def method_missing(name, *args)
      if args.empty?
        @constants.send(name)
      else
        @constants.send(name, *args)
      end
    end
  end
end