package nilvera.xmlvalidatior.business.concretes;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import nilvera.xmlvalidatior.entity.TypeModel;

@Service
public class XSDValidatiorManager 
{
    public static final String XML_FILE = "C:\\Users\\Nilvera\\Desktop\\000ba375-7c60-4445-b607-337515437245.xml";
    public static final String SCHEMA_FILE = "C:\\Users\\Nilvera\\Desktop\\UBL-TR1.2.1_Paketi\\UBLTR_1.2.1_Paketi\\xsdrt\\maindoc\\UBL-Invoice-2.1.xsd";
	 
  
	public boolean XsdValidator2(MultipartFile file, TypeModel type) 
	{	
		try
		{
			File doc = new File("\\" + file.getOriginalFilename());
			doc.createNewFile();
	
			FileOutputStream outputStream = new FileOutputStream(new File("\\" + file.getOriginalFilename()));
			outputStream.write(file.getBytes());
			outputStream.close();
	
			SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
			String filePath = "";

			switch (type.name())
			{
			
			case "INVOICE":
				filePath = "C:\\Users\\Nilvera\\Desktop\\UBL-TR1.2.1_Paketi\\UBLTR_1.2.1_Paketi\\xsdrt\\maindoc\\UBL-Invoice-2.1.xsd";
			    break;
			case "ARCHIVE_INVOICE":
				filePath = "./src/main/java/nilvera/xmlvalidatior/business/utilities/UBL-Invoice-2.1.xsd" ;
				break;
			case "DESPATCH_ADVICE":
				filePath = "./src/main/java/nilvera/xmlvalidatior/business/utilities/UBL-DespatchAdvice-2.1.xsd" ;    
				break;
			case "RECEIPT_ADVICE":
				filePath = "./src/main/java/nilvera/xmlvalidatior/business/utilities/UBL-ReceiptAdvice-2.1.xsd" ;
				break;
			default:
				break;
			}
	
			Schema schema = factory.newSchema(new File(filePath));
			Validator validator = schema.newValidator();
			validator.setErrorHandler(new MyErrorHandler());
			validator.validate(new StreamSource(new File("\\" + file.getOriginalFilename())));
			
			doc.delete();
		}
		catch (Exception e)
		{
			e.printStackTrace(); 
			return false;
		}
		return true;
		
	}	
	
	private static class MyErrorHandler implements ErrorHandler 
	{
		public void warning(SAXParseException e) throws SAXException 
		{
	        printException(e);
	    }
		 
	    public void error(SAXParseException e) throws SAXException 
	    { 
	        printException(e);
	    }
	     
	    public void fatalError(SAXParseException e) throws SAXException 
	    {
	        printException(e);
	    }
	     
	    private void printException(SAXParseException e) 
	    {

	    	System.out.println("LN:" + e.getLineNumber());
	    	System.out.println("LN:" + e.getColumnNumber());
	    	System.out.println("LN:" + e.getMessage());
	    }
	}
	
	public boolean XsdValidator1(MultipartFile file, TypeModel type) 
	{
		HashMap<String, String> linkler = new HashMap<String, String>();
		linkler.put("INVOICE", "C:\\Users\\Nilvera\\Desktop\\UBL-TR1.2.1_Paketi\\UBLTR_1.2.1_Paketi\\xsdrt\\maindoc\\UBL-Invoice-2.1.xsd");
		linkler.put("ARCHIVE_INVOICE", "\\UBL-Invoice-2.1.xsd");
		linkler.put("DESPATCH_ADVICE", "\\UBL-DespatchAdvice-2.1.xsd");
		linkler.put("RECEIPT_ADVICE", "\\UBL-ReceiptAdvice-2.1.xsd");
		try
		{			
			File doc = new File("\\" + file.getOriginalFilename());
    		doc.createNewFile();
    			
    		FileOutputStream outputStream = new FileOutputStream(new File("\\" + file.getOriginalFilename()));
    		outputStream.write(file.getBytes());
    		outputStream.close();
    		
//			FileInputStream xmlFile = new FileInputStream(new File("\\" + file.getOriginalFilename()));
//			Source xmlSource = new StreamSource(xmlFile);
    		
    		SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
//			Schema schema1 = factory.newSchema(new File("etc\\UBL-Invoice-2.1.xsd"));
    		Schema schema1 = factory.newSchema(new File(linkler.get(type.name())));
	
    		Validator validator1 = schema1.newValidator();
            validator1.validate(new StreamSource(new File("\\" + file.getOriginalFilename())));
    		
		}
		catch (IOException | SAXException e)
		{
			System.out.println(e.getMessage());
			return false;
		}
		return true;
	}
	
	public static String[] validateXMLSchema() throws SAXException{
		
		String[] abc = {"abc"};
        
        try {
            SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            Schema schema = factory.newSchema(new File(SCHEMA_FILE));
            Validator validator = schema.newValidator();
            validator.validate(new StreamSource(new File(XML_FILE)));
        } 
        catch(IOException a){
        	a.fillInStackTrace();
        } catch (SAXParseException e) {
   
        	String[] errors = {e.getLineNumber() + e.getColumnNumber() + e.getMessage()};
            return errors;
        }
        
        return abc;

    }
	
	public boolean xsdValidator3() 
	{
		SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		
		try
		{
			Schema schema = schemaFactory.newSchema(new File(SCHEMA_FILE));

	        Validator validator = schema.newValidator();
	        validator.validate(new StreamSource(new File(XML_FILE)));
	        return true;
	    }
		catch (SAXException | IOException e) 
		{
			e.printStackTrace();
	        return false;
	    }
	}
}