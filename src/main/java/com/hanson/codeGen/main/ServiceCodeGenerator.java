package com.hanson.codeGen.main;

import com.hanson.codeGen.model.ClassModel;
import com.hanson.codeGen.util.Configure;
import com.hanson.codeGen.util.FileUtils;

public class ServiceCodeGenerator {
	public static void main(String[] args) {
		Configure instance = Configure.getInstance("conf_simple.properties");
		ClassModel classModel = instance.generatorClassModelAtt();
		FileUtils.gen(classModel, "interfaceCode.ftl",FileUtils.getFullPath(instance.getInterfaceFolder(), classModel.getInterfaceFullName()));
		FileUtils.gen(classModel, "serviceCode.ftl",FileUtils.getFullPath(instance.getServiceFolder(), classModel.getServiceFullName()));
	}
}
