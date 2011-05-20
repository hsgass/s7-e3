require_relative '../lib/java_class'

describe JavaClass do

  it "should read the class file" do
    jc = JavaClass.new("java/Sample.class")
    jc.should_not be_nil
  end

  it "should find the magic number" do
    expect {JavaClass.new("java/Sample.class")}.not_to raise_error
  end

  it "should be the correct version" do
    JavaClass.new("java/Sample.class").version.should == '50.0'
  end

  it "should read the constant pool" do
    puts JavaClass.new("java/Sample.class").constants
  end
end
