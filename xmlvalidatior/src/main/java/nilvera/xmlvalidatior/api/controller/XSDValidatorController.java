package nilvera.xmlvalidatior.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import nilvera.xmlvalidatior.business.concretes.XSDValidatiorManager;
import nilvera.xmlvalidatior.entity.EnumTypeModel;

@RestController
@RequestMapping("/api/xsdvalidatior/")
public class XSDValidatorController {
	
	private XSDValidatiorManager _xSDValidatiorManager;
	@Autowired
	public XSDValidatorController(XSDValidatiorManager xSDValidatiorManager) 
	{
		this._xSDValidatiorManager = xSDValidatiorManager;
	}
	
	@RequestMapping(value = "xsd", method = RequestMethod.POST)
	public boolean XsdValidator1(MultipartFile file, EnumTypeModel type)
	{
		return this._xSDValidatiorManager.XsdValidator1(file, type);
	}
	
	@RequestMapping(value = "xsd2", method = RequestMethod.POST)
	public boolean XsdValidator2(MultipartFile file, EnumTypeModel type)
	{
		return this._xSDValidatiorManager.XsdValidator2(file, type);
	}
	
	@RequestMapping(value = "xsd3", method = RequestMethod.POST)
	public boolean XsdValidator3(String file, String type)
	{
		return this._xSDValidatiorManager.xsdValidator3(file, type);
	}


}