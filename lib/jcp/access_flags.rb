require_relative 'parser'

module JCP
  class AccessFlags
    include Parser

    def initialize(stream)
      flag_bytes    = read_unsigned_int16 stream
      @access_flags = []
      @access_flags << 'public' if flag_bytes & 0x0001 > 0
      @access_flags << 'final' if flag_bytes & 0x0010 > 0
      @access_flags << 'super' if flag_bytes & 0x0020 > 0
      @access_flags << 'interface' if flag_bytes & 0x0200 > 0
      @access_flags << 'abstract' if flag_bytes & 0x0400 > 0
      @access_flags << 'synthetic' if flag_bytes & 0x1000 > 0
      @access_flags << 'annotation' if flag_bytes & 0x2000 > 0
      @access_flags << 'enum' if flag_bytes & 0x4000 > 0
    end

    def method_missing(name, *args)
      if @access_flags.respond_to? name
        if args.empty?
          @access_flags.send(name)
        else
          @access_flags.send(name, *args)
        end
      end
    end

    def to_s
      @access_flags.join ' '
    end
  end
end