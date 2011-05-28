# Java Class Parser
Retrieves field and method information from a Java class file.

## Example Usage

    require 'jcp'
    #=> true
    java_class = JCP::JavaClass.new('java/Sample.class')
    #=> public final super class Sample extends java.util.ArrayList implements java.util.List
    puts java_class.fields
    #=> private long positiveLongField
    #=> private long negativeLongField
    #=> private int positiveIntField
    #=> private int negativeIntField
    #=> private double doubleField
    #=> private java.lang.String stringField
    #=> nil
    puts java_class.methods
    #=> public  <init>()
    #=> public long getPositiveLongField()
    #=> public long getNegativeLongField()
    #=> public int getPositiveIntField()
    #=> public int getNegativeIntField()
    #=> public double getDoubleField()
    #=> public java.lang.String getStringField()
    #=> nil

`rake` to run the tests.

