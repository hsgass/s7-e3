# Java Class Parser
Retrieves field and method information from a Java class file.

## Example Usage

    require 'jcp'
    #=> true
    java_class = JCP::JavaClass.new('spec/fixtures/Sample.class')
    #=> public final super class Sample extends java.util.ArrayList implements java.util.List
    puts java_class.fields
    #=> public static final long positiveLongField [72057594037927943]
    #=> public static final long negativeLongField [-61057594037927943]
    #=> private static final int positiveIntField [2147483637]
    #=> private static final int negativeIntField [-1047483637]
    #=> public static final double doubleField [123456789.12345679]
    #=> public static final double negativeDouble [-123456789.12345679]
    #=> public static final java.lang.String stringField [I am a string.]
    #=> private boolean booleanField []
    #=> private java.util.Date dateField []
    #=> private java.lang.String privateString []
    #=> nil
    puts java_class.methods
    #=> public  <init> [Code]
    #=> public  <init> [Code]
    #=> public boolean isBooleanField [Code]
    #=> public  setBooleanField [Code]
    #=> public java.util.Date getDateField [Code]
    #=> public java.util.Date; setDateField [Code]
    #=> public java.lang.String getPrivateString [Code]
    #=> public java.lang.String; setPrivateString [Code]
    #=> nil

`rake` to run the tests.

