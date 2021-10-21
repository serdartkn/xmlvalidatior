package nilvera.xmlvalidatior.business.concretes;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Objects;

import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;


import nilvera.xmlvalidatior.entity.EnumTypeModel;
import nilvera.xmlvalidatior.entity.TransformType;

@Service
public class XSDValidatiorManager 
{
    public static final String XML_FILE = "C:\\Users\\Nilvera\\Desktop\\MONDI MOBILYA SAN.TIC.A.S-VMF2021000003278.xml";
    public static final String SCHEMA_FILE = "C:\\Users\\Nilvera\\Desktop\\UBL-TR1.2.1_Paketi\\UBLTR_1.2.1_Paketi\\xsdrt\\maindoc\\UBL-Invoice-2.1.xsd";
	 
	public boolean xsdValidator3(String xmlFile, String schemaFile) 
	{
		SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		
		try
		{
			Schema schema = schemaFactory.newSchema(new File("C:\\Users\\Nilvera\\Desktop\\UBL-TR1.2.1_Paketi\\UBLTR_1.2.1_Paketi\\xsdrt\\maindoc\\UBL-Invoice-2.1.xsd"));

	        Validator validator = schema.newValidator();
	        validator.validate(new StreamSource(new File("C:\\Users\\Nilvera\\Desktop\\MONDIMOBILYASAN.TIC.A.S-VMF2021000003278.xml")));
	        return true;
	    }
		catch (SAXException | IOException e) 
		{
			e.printStackTrace();
	        return false;
	    }
	}
	
	
	public boolean XsdValidator1(MultipartFile file, EnumTypeModel type) 
	{
		HashMap<String, String> linkler = new HashMap<String, String>();
		linkler.put("INVOICE", "C:\\Users\\Nilvera\\Desktop\\UBL-TR1.2.1_Paketi\\UBLTR_1.2.1_Paketi\\xsdrt\\maindoc\\UBL-Invoice-2.1.xsd");
		linkler.put("ARCHIVE_INVOICE", "\\UBL-Invoice-2.1.xsd");
		linkler.put("DESPATCH_ADVICE", "\\UBL-DespatchAdvice-2.1.xsd");
		linkler.put("RECEIPT_ADVICE", "\\UBL-ReceiptAdvice-2.1.xsd");
		System.out.println(linkler.get(type.name()));
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
	
	public boolean XsdValidator2(MultipartFile file, EnumTypeModel type) 
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
	     
	    private String[] printException(SAXParseException e) 
	    {
	    	String[] cars = {"Line Number: " + e.getLineNumber(),  "Column Number: " + e.getColumnNumber(), "Message: " +e.getMessage()};
	    	return cars;
	    }
	}
}