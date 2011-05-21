require_relative '../lib/java_class_parser'

module JavaClassParser
  describe JavaClass do

    before do
      @jc        = JavaClass.new("java/Sample.class")
      @constants = @jc.constants
    end

    it "should be the correct version" do
      @jc.version.should == '48.0'
    end

    it "should parse the numbers" do
      @constants.each_with_index do |c, i|
        puts "#{i} = #{c}"
      end
      constant_string = @constants.join
      constant_string.should match /72057594037927943/
      constant_string.should match /-61057594037927943/
      constant_string.should match /2147483637/
      constant_string.should match /-1047483637/
    end
  end
end

