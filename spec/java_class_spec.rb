require_relative '../lib/java_class_parser'

module JavaClassParser
  describe JavaClass do

    before do
      @jc        = JavaClass.new("java/Sample.class")
      @constants = @jc.constants
#      puts @jc.inspect
    end

    it "should be the correct version" do
      @jc.version.should == '50.0'
    end

    it "should find the correct numbers" do
#      @constants.each_with_index do |c, i|
#        puts "#{i} = #{c}"
#      end
      constant_string = @constants.join
      constant_string.should match /72057594037927943/
      constant_string.should match /-61057594037927943/
      constant_string.should match /2147483637/
      constant_string.should match /-1047483637/
    end

    it "should find the class" do
      @jc.class.should == 'Sample'
    end

    it "should find the superclass" do
      @jc.superclass.should == 'java/util/ArrayList'
    end

    it "should be public" do
      @jc.access_flags.include? 'Public'
      @jc.access_flags.size.should == 1
    end

    it "should find an interface" do
      @jc.interfaces.size.should == 1
      @jc.interfaces[0].should == 'java/util/List'
    end

    it "should find fields" do
      @jc.fields.size.should > 1
      @jc.fields[0].should == 'java/util/List'
    end
  end
end

