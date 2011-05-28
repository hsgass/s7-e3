module JCP
  class ConstantPool
    include Parser

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
      @constant_pool = [] << 0

      # count indicates the number of "slots" in the constant pool.
      # longs and doubles consume 2 slots, so there must
      # be one less read per long or double value.
      limit = read2_unsigned stream
      read  = 1
      while (read < limit)
        tag  = stream.getbyte
        hash = TAGS[tag]
        if hash
          Parser.send(hash[:action], stream, @constant_pool)
          read += hash[:extra_bytes] ? 2 : 1
        end
      end
    end

    def [](index)
      return index if index.is_a? String or index.nil?
      v = @constant_pool[index]
      v = @constant_pool[v] if v.is_a? Fixnum
      v = [self[v[0]], self[v[1]]] if v.is_a? Array
      v
    end

    def each
      @constant_pool.each
    end

    def join
      @constant_pool.join
    end
  end
end