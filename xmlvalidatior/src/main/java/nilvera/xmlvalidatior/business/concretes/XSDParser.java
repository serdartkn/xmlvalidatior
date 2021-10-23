package nilvera.xmlvalidatior.business.concretes;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.SAXException;

import nilvera.xmlvalidatior.entity.TypeModel;

@Service
public class XSDParser {
	
//    public static final String XML_FILE = "C:\\Users\\Nilvera\\Desktop\\000ba375-7c60-4445-b607-337515437245.xml";
//    public static final String SCHEMA_FILE = "C:\\Users\\Nilvera\\Desktop\\UBL-TR1.2.1_Paketi\\UBLTR_1.2.1_Paketi\\xsdrt\\maindoc\\UBL-Invoice-2.1.xsd";
//
//	
//	 public static String[] validateXml()throws IOException {
//	        SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
//	        XSDErrorHandler xsdValidationErrorHandler = new XSDErrorHandler();
//	        try 
//	        {
//	            Schema schema = schemaFactory.newSchema(new File(SCHEMA_FILE));
//	            Validator validator = schema.newValidator();
//	            validator.setErrorHandler(xsdValidationErrorHandler);
//	            validator.validate(new StreamSource(XML_FILE));
//		        List<String> xsdErrors = new ArrayList<>();
//	            xsdErrors.add(xsdValidationErrorHandler.getErrors());
//
//	        } catch (SAXException | IOException e) {
//	             e.getMessage();
//	        }
//	        return errorsArray;
//
//	    }
}
