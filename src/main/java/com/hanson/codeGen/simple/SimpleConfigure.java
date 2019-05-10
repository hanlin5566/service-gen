package com.hanson.codeGen.simple;

import java.util.Properties;

import com.hanson.codeGen.main.ServiceCodeGenerator;
import com.hanson.codeGen.util.StringUtil;

public class SimpleConfigure {
	private static SimpleConfigure instance;
	private static Properties pros = new Properties();
	
	private SimpleConfigure(String fileName) {
		super();
		try {
			pros.load(ServiceCodeGenerator.class.getResourceAsStream("/"+fileName));
			String entity = pros.getProperty("entity");
			pros.setProperty("entityLower", StringUtil.getEntityLower(entity,'.'));
			pros.setProperty("entityUpper", StringUtil.getEntityUpper(entity,'.'));
		} catch (Exception e) {
			System.err.println("加载配置文件出错");
			System.exit(0);
		}
	}
	
	public static String getProValue(String key) {
		if(!pros.containsKey(key)) {
			System.err.println("未找到配置："+key);
			System.exit(0);
		}
		return (String) pros.get(key);
	}
	
	public static void setProValue(String key,String value) {
		pros.put(key,value);
	}
	
	public static Properties getPros() {
		return pros;
	}
	
	
	
	public static SimpleConfigure getInstance(String fileName){
		if(instance != null){
			return instance;
		}else{
			return new SimpleConfigure(fileName);
		}
	}
}
