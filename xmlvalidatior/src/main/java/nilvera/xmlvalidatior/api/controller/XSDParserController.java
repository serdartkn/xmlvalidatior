package nilvera.xmlvalidatior.api.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import nilvera.xmlvalidatior.business.concretes.XSDParser;
import nilvera.xmlvalidatior.business.concretes.XSDValidatiorManager;
import nilvera.xmlvalidatior.entity.TypeModel;

@RestController
@RequestMapping("/api/xsdparser/")
public class XSDParserController {
	
	private XSDParser _XsdParser;
	@Autowired
	public XSDParserController(XSDParser XsdParser) 
	{
		this._XsdParser = XsdParser;
	}
	
//	@RequestMapping(value = "xsd", method = RequestMethod.POST)
//	public String[] XsdValidator1() throws IOException
//	{
//		return this._XsdParser.validateXml();
//	}

}
