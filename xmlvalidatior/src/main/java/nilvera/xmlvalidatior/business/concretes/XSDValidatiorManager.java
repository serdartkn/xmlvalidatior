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

import nilvera.xmlvalidatior.entity.TransformType;

@Service
public class XSDValidatiorManager 
{
	public boolean deneme(String type) 
	{
		HashMap<String, String> linkler = new HashMap<String, String>();
		linkler.put("INVOICE", "\\UBL-Invoice-2.1.xsd");
		linkler.put("ARCHIVE_INVOICE", "C:\\UBL-Invoice-2.1.xsd");
		linkler.put("DESPATCH_ADVICE", "C:\\UBL-DespatchAdvice-2.1.xsd");
		linkler.put("RECEIPT_ADVICE", "C:\\UBL-ReceiptAdvice-2.1.xsd");
		System.out.println(type);
		return true;
	}
		
	public boolean XsdValidator1(MultipartFile file, String Type) 
	{
		HashMap<String, String> linkler = new HashMap<String, String>();
		linkler.put("INVOICE", "\\UBL-Invoice-2.1.xsd");
		linkler.put("ARCHIVE_INVOICE", "C:\\UBL-Invoice-2.1.xsd");
		linkler.put("DESPATCH_ADVICE", "C:\\UBL-DespatchAdvice-2.1.xsd");
		linkler.put("RECEIPT_ADVICE", "C:\\UBL-ReceiptAdvice-2.1.xsd");
		System.out.println(linkler.get(Type));
		try
		{			
			File doc = new File("\\" + file.getOriginalFilename());
    		doc.createNewFile();
    			
    		FileOutputStream outputStream = new FileOutputStream(new File("\\" + file.getOriginalFilename()));
    		outputStream.write(file.getBytes());
    		outputStream.close();
    		
			FileInputStream xmlFile = new FileInputStream(new File("\\" + file.getOriginalFilename()));
			Source xmlSource = new StreamSource(xmlFile);
    		
    		SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
//			Schema schema1 = factory.newSchema(new File("etc\\UBL-Invoice-2.1.xsd"));
//    		Schema schema1 = factory.newSchema(new File(linkler.get("INVOICE")));
    		Schema schema1 = factory.newSchema(new File("C:\\UBL-Invoice-2.1.xsd"));
	
    		Validator validator1 = schema1.newValidator();
            validator1.validate(new StreamSource(new File("C:\\MONDI MOBILYA SAN.TIC.A.S-VMF2021000003278.xml")));
    		
		}
		catch (IOException | SAXException e)
		{
			e.printStackTrace();
			System.out.println(e.fillInStackTrace());
			return false;
			
		}
		return true;
		
	}
	
	public boolean XsdValidator2(MultipartFile file, String type) 
	{	
		try
		{
			File doc = new File("\\" + file.getOriginalFilename());
			doc.createNewFile();
				
			FileOutputStream outputStream = new FileOutputStream(new File("\\" + file.getOriginalFilename()));
			outputStream.write(file.getBytes());
			outputStream.close();
			
			FileInputStream xmlFile = new FileInputStream(new File("\\" + file.getOriginalFilename()));
			Source xmlSource = new StreamSource(xmlFile);
			
			SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_INSTANCE_NS_URI);
			

			switch (type)
			{
			case "INVOICE":
	
	//			Schema schema1 = factory.newSchema(new File("etc\\UBL-Invoice-2.1.xsd"));
				Schema schema1 = factory.newSchema(new File("\\UBL-Invoi465ce-2.1.xsd"));
				
		   		Validator validator1 = schema1.newValidator();
	            validator1.validate(xmlSource);
	
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
			// TODO: handle exception
		}
		return true;		
	}	
}