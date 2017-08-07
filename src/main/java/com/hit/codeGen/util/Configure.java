package com.hit.codeGen.util;

import java.util.Properties;

import org.apache.commons.lang3.StringUtils;

import com.hit.codeGen.main.ServiceCodeGenerator;
import com.hit.codeGen.model.ClassModel;
import com.hit.codeGen.model.ClassType;

public class Configure {
	private static Configure instance;
	private Properties pros = new Properties();
	private String interfaceFolder;
	private String serviceFolder;
	private String controllerFolder;
	
	private Configure() {
		super();
		try {
			pros.load(ServiceCodeGenerator.class.getResourceAsStream("/conf.properties"));
			this.interfaceFolder = pros.getProperty("interfaceFolder");
			this.serviceFolder = pros.getProperty("serviceFolder");
			this.controllerFolder = pros.getProperty("controllerFolder");
		} catch (Exception e) {
			System.err.println("加载配置文件出错");
			System.exit(0);
		}
	}
	
	public static Configure getInstance(){
		if(instance != null){
			return instance;
		}else{
			return new Configure();
		}
	}
	
	public ClassModel generatorClassModelAtt() {
		ClassModel classModel = new ClassModel();
		// entity
		try {
			String genEntity = pros.getProperty("entity");
			Class<?> entity = Class.forName(genEntity);
			ClassModel.setAtt(entity, ClassType.ENTITY, classModel);
			String primaryKeyName = pros.getProperty("entityPrimaryId");
			//判断是否有自定义主键
			if(StringUtils.isNotEmpty(primaryKeyName)){
				classModel.setPrimaryKeyName(primaryKeyName);
				classModel.setPrimaryKeyNameLowercase(StringUtil.firstCharToLowerCase(primaryKeyName));
			}
			//转换主键大小写
			classModel.setPrimaryKeyName(StringUtil.firstCharToUpperCase(classModel.getPrimaryKeyName()));
			classModel.setPrimaryKeyNameLowercase(StringUtil.firstCharToLowerCase(classModel.getPrimaryKeyName()));
			
		} catch (Exception e) {
			System.err.println("无法找到entity，请检查配置");
			System.exit(0);
		}

		// criteria
		try {
			String criteriaName = pros.getProperty("criteria");
			Class<?> criteria = Class.forName(criteriaName);
			ClassModel.setAtt(criteria, ClassType.CRITERIA, classModel);
		} catch (Exception e) {
			System.err.println("无法找到criteria，请检查配置");
			System.exit(0);
		}
		// model
		try {
			String modelName = pros.getProperty("model");
			Class<?> model = Class.forName(modelName);
			ClassModel.setAtt(model, ClassType.MODEL, classModel);
		} catch (Exception e) {
			System.err.println("无法找到model，请检查配置");
			System.exit(0);
		}
		// 根据entity生成mapper信息
		try {
			String genMapper = "gen.hit." + classModel.getPackageFor() + ".mapper." + classModel.getEntityName()
					+ "Mapper";
			Class<?> mapper = Class.forName(genMapper);
			ClassModel.setAtt(mapper, ClassType.MAPPER, classModel);
		} catch (Exception e) {
			System.err.println("无法找到mapper，请检查生成代码");
			System.exit(0);
		}
		// 根据entity生成example信息
		try {
			String genExample = classModel.getEntityFullName() + "Example";
			Class<?> example = Class.forName(genExample);
			ClassModel.setAtt(example, ClassType.EXAMPLE, classModel);
		} catch (Exception e) {
			System.err.println("无法找到example，请检查生成代码");
			System.exit(0);
		}

		// 根据entity生成interface信息
		try {
			Class<?> entity = Class.forName(classModel.getEntityFullName());
			ClassModel.setAtt(entity, ClassType.SERVICE_INTERFACE, classModel);
		} catch (Exception e) {
			System.err.println("无法找到entity，请检查配置");
			System.exit(0);
		}

		// 根据entity生成service信息
		try {
			Class<?> entity = Class.forName(classModel.getEntityFullName());
			ClassModel.setAtt(entity, ClassType.SERVICE, classModel);
		} catch (Exception e) {
			System.err.println("无法找到entity，请检查配置");
			System.exit(0);
		}
		// 根据entity生成controller信息
		try {
			Class<?> entity = Class.forName(classModel.getEntityFullName());
			ClassModel.setAtt(entity, ClassType.CONTROLLER, classModel);
		} catch (Exception e) {
			System.err.println("无法找到controller，请检查配置");
			System.exit(0);
		}
//		// 生成webContext信息
//		TODO:根据webContext生成session 未做，controller包名需要可以支持自定义
//		try {
//			Class<?> webContext = Class.forName(pros.getProperty("webContext"));
//			ClassModel.setAtt(webContext, ClassType.WEB_CONTEXT, classModel);
//		} catch (Exception e) {
//			System.err.println("无法找到webContext，请检查配置");
//			System.exit(0);
//		}
		return classModel;
	}

	public String getInterfaceFolder() {
		return interfaceFolder;
	}

	public String getServiceFolder() {
		return serviceFolder;
	}

	public String getControllerFolder() {
		return controllerFolder;
	}
}
