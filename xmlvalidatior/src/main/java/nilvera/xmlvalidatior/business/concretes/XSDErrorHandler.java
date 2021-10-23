package nilvera.xmlvalidatior.business.concretes;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class XSDErrorHandler implements ErrorHandler{

	 private String errors = "";

	    public String getErrors() {
	        return errors;
	    }

	    public void setErrors(String errors) {
	        this.errors = errors;
	    }

	    public void warning(SAXParseException ex) {
	        errors += "WARNING:: at Line: {" + ex.getLineNumber() + "} Column: {" + ex.getColumnNumber()
	                + "} Message: {" + ex.getMessage() + "}";
	        errors += "\n";
	    }

	    public void error(SAXParseException ex) {
	        errors += "ERROR:: at Line: {" + ex.getLineNumber() + "} Column: {" + ex.getColumnNumber()
	                + "} Message: {" + ex.getMessage() + "}";
	        errors += "\n";
	    }

	    public void fatalError(SAXParseException ex) throws SAXException {
	        errors += "FATAL ERROR:: at Line: {" + ex.getLineNumber() + "} Column: {" + ex.getColumnNumber()
	                + "} Message: {" + ex.getMessage() + "}";
	        errors += "\n";
	    }

}
