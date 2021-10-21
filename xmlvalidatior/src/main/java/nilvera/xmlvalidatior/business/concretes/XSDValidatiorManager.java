package nilvera.xmlvalidatior.business.concretes;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;

import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.SAXException;

import nilvera.xmlvalidatior.entity.EnumTypeModel;
import nilvera.xmlvalidatior.entity.TransformType;

@Service
public class XSDValidatiorManager 
{
		
	public boolean XsdValidator1(MultipartFile file, EnumTypeModel type) 
	{
		HashMap<String, String> linkler = new HashMap<String, String>();
		linkler.put("INVOICE", "C:\\Users\\Nilvera\\git\\repository\\xmlvalidatior\\src\\main\\java\\nilvera\\xmlvalidatior\\business\\utilities\\UBL-Invoice-2.1.xsd");
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
			e.printStackTrace();
			System.out.println(e.fillInStackTrace());
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
			
			switch (type.name())
			{
			case "INVOICE":
	//			Schema schema1 = factory.newSchema(new File("etc\\UBL-Invoice-2.1.xsd"));
				Schema schema1 = factory.newSchema(new File("C:\\Users\\Nilvera\\git\\repository\\xmlvalidatior\\src\\main\\java\\nilvera\\xmlvalidatior\\business\\utilities\\UBL-Invoice-2.1.xsd"));
				
		   		Validator validator1 = schema1.newValidator();
		   		validator1.validate(new StreamSource(new File("\\" + file.getOriginalFilename())));
		    	break;
			case "ARCHIVE_INVOICE":				
	//			Schema schema2 = factory.newSchema(new File("etc\\UBL-Invoice-2.1.xsd"));
				Schema schema2 = factory.newSchema(new File("./src/main/java/nilvera/xmlvalidatior/business/utilities/UBL-Invoice-2.1.xsd"));
				 
	    		Validator validator2 = schema2.newValidator();
	            validator2.validate(new StreamSource(new File("\\" + file.getOriginalFilename())));
				break;
			case "DESPATCH_ADVICE":				
	//			Schema schema3 = factory.newSchema(new File("etc\\UBL-DespatchAdvice-2.1.xsd"));
				Schema schema3 = factory.newSchema(new File("./src/main/java/nilvera/xmlvalidatior/business/utilities/UBL-DespatchAdvice-2.1.xsd"));
					    		
	    		Validator validator3 = schema3.newValidator();
	            validator3.validate(new StreamSource(new File("\\" + file.getOriginalFilename())));
				break;
			case "RECEIPT_ADVICE":				
	//			Schema schema4 = factory.newSchema(new File("etc\\UBL-ReceiptAdvice-2.1.xsd"));
				Schema schema4 = factory.newSchema(new File("./src/main/java/nilvera/xmlvalidatior/business/utilities/UBL-ReceiptAdvice-2.1.xsd"));
	    		
	    		Validator validator4 = schema4.newValidator();
	            validator4.validate(new StreamSource(new File("\\" + file.getOriginalFilename())));
				break;
			default:
				break;
			}		
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			System.out.println(e.fillInStackTrace());
			return false;
		}
		return true;		
	}	
}