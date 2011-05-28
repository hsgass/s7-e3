require_relative '../lib/jcp'

module JCP
  describe JavaClass do

    before :all do
      @jc            = JavaClass.new("java/Sample.class")
      @constant_pool = @jc.constant_pool
    end

    it "should be the correct version" do
      puts "\n"
      puts @jc
      puts "\nFields\n"
      puts @jc.fields
      puts "\nMethods\n"
      puts @jc.methods
      puts "\n"

      @jc.version.should == '50.0'
    end

    it "should find the correct numbers" do
      constant_string = @constant_pool.join
      constant_string.should match /72057594037927943/
      constant_string.should match /-61057594037927943/
      constant_string.should match /2147483637/
      constant_string.should match /-1047483637/
    end

    it "should find the class" do
      @jc.class.should == 'Sample'
    end

    it "should find the superclass" do
      @jc.superclass.should == 'java.util.ArrayList'
    end

    it "should be public final super" do
      @jc.access_flags.include? 'Public'
      @jc.access_flags.include? 'Final'
      @jc.access_flags.include? 'Super'
      @jc.access_flags.size.should == 3
    end

    it "should find an interface" do
      @jc.interfaces.size.should == 1
      @jc.interfaces[0].should == 'java.util.List'
    end

    it "should find fields" do
      @jc.fields.empty?.should be_false
      @jc.fields.each do |f|
        f.name.should_not be_nil
      end
    end

    it "should find methods" do
      @jc.methods.empty?.should be_false
      @jc.methods.each do |m|
        m.name.should_not be_nil
      end
    end
  end
end

