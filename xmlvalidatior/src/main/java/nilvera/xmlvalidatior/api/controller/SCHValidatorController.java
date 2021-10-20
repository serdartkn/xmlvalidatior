package nilvera.xmlvalidatior.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import nilvera.xmlvalidatior.business.concretes.SCHValidatiorManager;

@RestController
@RequestMapping("/api/schvalidatior/")
public class SCHValidatorController {
	
	private SCHValidatiorManager _sCHValidatorManager;
	@Autowired
	public SCHValidatorController(SCHValidatiorManager sCHValidatorManager)
	{
		this._sCHValidatorManager = sCHValidatorManager;
	}
		
	@RequestMapping(value = "schematron", method = RequestMethod.POST, consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	public String ValidationXmlWithFile(MultipartFile file)
	{
		return this._sCHValidatorManager.SchValidatior(file);
	}
}