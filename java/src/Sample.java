import java.util.ArrayList;
import java.util.List;

public final class Sample extends ArrayList implements List {

    private long   positiveLongField = 72057594037927943L;
    private long   negativeLongField = -61057594037927943L;
    private int    positiveIntField  = 2147483637;
    private int    negativeIntField  = -1047483637;
    private double doubleField       = 123456789.123456789D;
    private String stringField       = "I am a string.";

    public long getPositiveLongField() {
        return positiveLongField;
    }

    public long getNegativeLongField() {
        return negativeLongField;
    }

    public int getPositiveIntField() {
        return positiveIntField;
    }

    public int getNegativeIntField() {
        return negativeIntField;
    }

    public double getDoubleField() {
        return doubleField;
    }

    public String getStringField() {
        return stringField;
    }
}
