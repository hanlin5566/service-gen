package com.hit.codeGen.main;

import com.hit.codeGen.model.ClassModel;
import com.hit.codeGen.util.Configure;
import com.hit.codeGen.util.FileUtils;

public class ServiceCodeGenerator {
	public static void main(String[] args) {
		Configure instance = Configure.getInstance();
		ClassModel classModel = instance.generatorClassModelAtt();
		FileUtils.gen(classModel, "interfaceCode.ftl",FileUtils.getFullPath(instance.getInterfaceFolder(), classModel.getInterfaceFullName()));
		FileUtils.gen(classModel, "serviceCode.ftl",FileUtils.getFullPath(instance.getServiceFolder(), classModel.getServiceFullName()));
	}
}
