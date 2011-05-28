module JCP
  class ConstantPool
    include Parser, JCP

    TAGS = {
      5 =>  { :action => :parse_long, :extra_bytes => true },
      6 =>  { :action => :parse_double, :extra_bytes => true },
      1 =>  { :action => :parse_string },
      3 =>  { :action => :parse_integer },
      4 =>  { :action => :parse_float },
      7 =>  { :action => :parse_single_ref }, # class ref
      8 =>  { :action => :parse_single_ref }, # string ref
      9 =>  { :action => :parse_multi_ref },  # field ref
      10 => { :action => :parse_multi_ref },  # method ref
      11 => { :action => :parse_multi_ref },  # interface
      12 => { :action => :parse_multi_ref }   # name/type
    }

    def initialize(stream)
      # the constant pool index starts at 1,
      # so fill in the zeroth index of the array
      @constants = [] << 0

      # limit indicates the number of "slots" in the constant pool.
      # longs and doubles consume 2 slots, so there must
      # be one less read per long or double value.
      limit = (read2_unsigned stream) - 1
      skip  = false
      (1..limit).each do
        if skip
          @constants << nil
          skip = false
        else
          tag  = stream.getbyte
          hash = TAGS[tag]
          skip = hash[:extra_bytes]
          @constants << send(hash[:action], stream)
        end
      end
    end

    def [](index)
      return index if index.is_a? String or index.nil?
      v = @constants[index]
      v = @constants[v] if v.is_a? Fixnum
      v = [self[v[0]], self[v[1]]] if v.is_a? Array
      v
    end

    def each
      @constants.each
    end

    def join
      @constants.join
    end
  end
end