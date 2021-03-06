package nilvera.xmlvalidatior.business.concretes;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringWriter;

import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.SAXException;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;
import nilvera.xmlvalidatior.business.concretes.utilities.XSDErrorHandler;
import nilvera.xmlvalidatior.entity.TypeModel;
import nilvera.xmlvalidatior.entity.ValidateModel;

@Service
public class ValidatorManager {

	private Processor saxonProc;
	private XsltCompiler xsltCompiler;
	private XsltExecutable xsltExecutable;
	private XsltTransformer xsltTransformer;
	private Source xmlSource;
	private File doc;

	public String[] validator(MultipartFile xmlFile, ValidateModel validateModel, TypeModel typeModel)
			throws IOException {

		if (xmlFile.getOriginalFilename().endsWith("xml") && xmlFile.isEmpty() != true) {
			doc = new File("\\" + xmlFile.getOriginalFilename());
			doc.createNewFile();

			FileOutputStream outputStream = new FileOutputStream(doc);
			outputStream.write(xmlFile.getBytes());
			outputStream.close();
		} else {
			return new String[] { "The File is Empty or Incorrect" };
		}

		switch (validateModel.name()) {
		case "SCHEMATRON":
			try {
				FileInputStream schFile = new FileInputStream(new File("etc//UBL-TR_Main_Schematron.xsl"));
//				FileInputStream schFile = new FileInputStream(new File("./src/main/resources/static/UBL-TR_Main_Schematron.xsl"));
				Source xsltSource = new StreamSource(schFile);

				saxonProc = new Processor(false);
				xsltCompiler = saxonProc.newXsltCompiler();
				xsltExecutable = xsltCompiler.compile(xsltSource);
				xsltTransformer = xsltExecutable.load();

				FileInputStream file = new FileInputStream(new File("\\" + xmlFile.getOriginalFilename()));
				xmlSource = new StreamSource(file);

				StringWriter resultWriter = new StringWriter();
				Serializer result = saxonProc.newSerializer(resultWriter);

				xsltTransformer.setSource(xmlSource);
				xsltTransformer.setDestination(result);
				xsltTransformer.transform();

				doc.delete();

				String resultString = resultWriter.toString();
				return new String[] { resultString };

			} catch (Exception e) {
				e.printStackTrace();
			}
			break;

		case "SCHEMA":
			SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
			String filePath = "";
			switch (typeModel.name()) {
			case "INVOICE":
				filePath = "etc//maindoc//UBL-Invoice-2.1.xsd";
//				filePath = "./src/main/resources/static/UBLTR_1.2.1_Paketi/xsdrt/maindoc/UBL-Invoice-2.1.xsd";
				break;
			case "DESPATCH_ADVICE":
				filePath = "etc//maindoc//UBL-DespatchAdvice-2.1.xsd";
//				filePath = "./src/main/resources/static/UBLTR_1.2.1_Paketi/xsdrt/maindoc/UBL-DespatchAdvice-2.1.xsd"; // irsaliye
				break;
			case "RECEIPT_ADVICE":
				filePath = "etc//maindoc//UBL-ReceiptAdvice-2.1.xsd";
//				filePath = "./src/main/resources/static/UBLTR_1.2.1_Paketi/xsdrt/maindoc/UBL-ReceiptAdvice-2.1.xsd";
				break;
			case "APPLICATION_RESPONSE":
				filePath = "etc//maindoc//UBL-ApplicationResponse-2.1.xsd";
//				filePath = "./src/main/resources/static/UBLTR_1.2.1_Paketi/xsdrt/maindoc/UBL-ApplicationResponse-2.1.xsd";
				break;
			case "CREDIT_NOTE":
				filePath = "etc//maindoc//UBL-CreditNote-2.1.xsd";
//				filePath = "./src/main/resources/static/UBLTR_1.2.1_Paketi/xsdrt/maindoc/UBL-CreditNote-2.1.xsd";
				break;
			}
			XSDErrorHandler xsdValidationErrorHandler = new XSDErrorHandler();
			try {
				Schema schema = factory.newSchema(new File(filePath));
				Validator validator = schema.newValidator();
				validator.setErrorHandler(xsdValidationErrorHandler);
				validator.validate(new StreamSource(new File("\\" + xmlFile.getOriginalFilename())));
				doc.delete();

				String[] errorList = xsdValidationErrorHandler.getErrors().split("- ");
				if (errorList.length == 1) {
					return new String[] {};
				}
				return errorList;
			} catch (SAXException | IOException e) {
				return new String[] { e.getMessage() };
			}
		}
		return new String[] { "" };
	}
}