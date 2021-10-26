package nilvera.xmlvalidatior.api.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import nilvera.xmlvalidatior.business.concretes.ValidatorManager;
import nilvera.xmlvalidatior.entity.TypeModel;
import nilvera.xmlvalidatior.entity.ValidateModel;

@RestController
@RequestMapping("/validator/")
public class ValidatorController {

	private ValidatorManager validatorManager;

	@Autowired
	public ValidatorController(ValidatorManager validatorManager) {
		this.validatorManager = validatorManager;
	}

	@RequestMapping(value = { "process" }, method = { RequestMethod.POST })
	public String[] XsdValidator2(MultipartFile file, ValidateModel Model, TypeModel typeModel) throws IOException {
		return this.validatorManager.validator(file, Model, typeModel);
	}
}