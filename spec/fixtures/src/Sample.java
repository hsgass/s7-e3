import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public final class Sample extends ArrayList implements List {

    public static final  long   positiveLongField = 72057594037927943L;
    public static final  long   negativeLongField = -61057594037927943L;
    private static final int    positiveIntField  = 2147483637;
    private static final int    negativeIntField  = -1047483637;
    public static final  double doubleField       = 123456789.123456789D;
    public static final  double negativeDouble    = -123456789.123456789D;
    public static final  String stringField       = "I am a string.";

    private boolean booleanField;
    private Date    dateField;
    private String  privateString;

    public Sample(int i, String privateString) {
        super(i);
        this.privateString = privateString;
    }

    public Sample() {
    }

    public boolean isBooleanField() {
        return booleanField;
    }

    public void setBooleanField(boolean booleanField) {
        this.booleanField = booleanField;
    }

    public Date getDateField() {
        return dateField;
    }

    public void setDateField(Date dateField) {
        this.dateField = dateField;
    }

    public String getPrivateString() {
        return privateString;
    }

    public void setPrivateString(String privateString) {
        this.privateString = privateString;
    }
}
