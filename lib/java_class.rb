class JavaClass

  attr_accessor :class_file, :version, :constants

  def self.parse_string(io)
    byte_count = io.read(2).unpack('n').join.to_i
    puts io.read(byte_count).unpack("A#{byte_count}").join
  end

  def self.parse_int32(io)
    puts io.read(4).unpack('l4').first
  end

  def self.parse_float(io)
    puts io.read(4).unpack('F').join
  end

  def self.parse_long(io)
    puts io.read(8).unpack('q').join
  end

  def self.parse_double(io)
    puts io.read(8).unpack('G').join
  end

  def self.parse_class_ref(io)
    index = io.read(2).unpack('n').join
    puts index
  end

  def self.parse_string_ref(io)
    index = io.read(2).unpack('n').join
    puts index
  end

  def self.parse_field_ref(io)
    puts "class=#{io.read(2).unpack('n').first}"
    puts "descriptor=#{io.read(2).unpack('n').first}"
  end

  def self.parse_method_ref(io)
    puts "class=#{io.read(2).unpack('n').first}"
    puts "descriptor=#{io.read(2).unpack('n').first}"
  end

  def self.parse_interface_method_ref(io)
    puts "class=#{io.read(2).unpack('n').first}"
    puts "descriptor=#{io.read(2).unpack('n').first}"
  end

  def self.parse_name_and_type_ref(io)
    puts "class=#{io.read(2).unpack('n').first}"
    puts "descriptor=#{io.read(2).unpack('n').first}"
  end

  TAGS = {
    1  => Proc.new { |io| parse_string io },
    3  => Proc.new { |io| parse_int32 io },
    4  => Proc.new { |io| parse_float io },
    5  => Proc.new { |io| parse_long io },
    6  => Proc.new { |io| parse_double io },
    7  => Proc.new { |io| parse_class_ref io },
    8  => Proc.new { |io| parse_string_ref io },
    9  => Proc.new { |io| parse_field_ref io },
    10 => Proc.new { |io| parse_method_ref io },
    11 => Proc.new { |io| parse_interface_method_ref io },
    12 => Proc.new { |io| parse_name_and_type_ref io }
  }

  def initialize(path)
    @class_file = File.open(path) do |io|
      raise ArgumentError.new("not a java class file") unless check_magic_number io
      get_version io
      get_constants io
    end
  end


  private
  def check_magic_number(io)
    'cafebabe' == io.read(4).unpack('H8').join
  end

  def get_version(io)
    minor    = io.read(2).unpack('n').first
    major    = io.read(2).unpack('n').first
    @version = "#{major}.#{minor}"
  end

  def get_constants(io)
    @constants = []
    count      = io.read(2).unpack('n').first
    puts "count=#{count}"
    (1..count).each do |i|
      tag = io.getbyte
      p   = TAGS[tag]
      puts "TAG=#{p}"
      p.call(io) if p
    end
  end

  def twos_complement(value)
    [value].pack('q').unpack('q').first
  end

end
