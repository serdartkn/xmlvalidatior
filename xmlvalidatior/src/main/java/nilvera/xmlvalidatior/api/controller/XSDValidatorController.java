package nilvera.xmlvalidatior.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import nilvera.xmlvalidatior.business.concretes.XSDValidatiorManager;
import nilvera.xmlvalidatior.entity.TransformType;
import nilvera.xmlvalidatior.entity.serdar;

@RestController
@RequestMapping("/api/xsdvalidatior/")
public class XSDValidatorController {
	
	private XSDValidatiorManager _xSDValidatiorManager;
	@Autowired
	public XSDValidatorController(XSDValidatiorManager xSDValidatiorManager) 
	{
		this._xSDValidatiorManager = xSDValidatiorManager;
	}
	
	@RequestMapping(value = "xsd1", method = RequestMethod.POST)
	public boolean ValidationXml1(MultipartFile file, TransformType type)
	{
		return this._xSDValidatiorManager.XsdValidator1(file, type.toString());
	}
	
	@RequestMapping(value = "xsd2", method = RequestMethod.POST)
	public boolean ValidationXml2(MultipartFile file, TransformType type)
	{
		return this._xSDValidatiorManager.XsdValidator2(file, type.toString());
	}
	
	@RequestMapping(value = "xsd3", method = RequestMethod.GET)
	public boolean ValidationXml3(serdar type)
	{
		return this._xSDValidatiorManager.deneme(type.name());
	}
	
}