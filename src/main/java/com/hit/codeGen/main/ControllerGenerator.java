package com.hit.codeGen.main;

import java.util.ArrayList;
import java.util.List;

import com.hit.codeGen.model.ClassModel;
import com.hit.codeGen.util.Configure;
import com.hit.codeGen.util.FileUtils;
import com.hit.codeGen.util.StringUtil;

public class ControllerGenerator {
	public static void main(String[] args) throws Exception {
		Configure instance = Configure.getInstance();
		ClassModel classModel = instance.generatorClassModelAtt();
		List<String> clearImportClass = new ArrayList<String>();
		for (String importClass : classModel.getImportClass()) {
			//controller不需要引用Entity、Mapper、Example与Impl
			if(StringUtil.hasSpecifiedString(importClass, "Entity") ||
			    StringUtil.hasSpecifiedString(importClass, "Mapper")||
			    StringUtil.hasSpecifiedString(importClass, "Example")||
				StringUtil.hasSpecifiedString(importClass, "Impl")){
				continue;
			}
			clearImportClass.add(importClass);
		}
		classModel.setImportClass(clearImportClass);
		FileUtils.gen(classModel, "controllerCode.ftl",FileUtils.getFullPath(instance.getControllerFolder(), classModel.getControllerFullName()));
	}
	
	
}
