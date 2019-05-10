package com.hanson.codeGen.simple;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringWriter;

import freemarker.cache.ClassTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;
import freemarker.template.TemplateException;

public class SimpleFileUtils {
	public static File createFile() throws IOException {
		//获得目标目录
		String targetFolder = SimpleConfigure.getProValue("targetFolder");
		//根据类名生成最终文件
		String fullPath = SimpleFileUtils.getFullPath(targetFolder);
		//目标输出目录targetFolder+ "\\src\\main\\java"
		File folder = new File(fullPath);
		//添加类型名称
		String template = SimpleConfigure.getProValue("template");
		String type = "ServiceImpl";
		//为文件名添加后缀 XXXXXServiceImpl/XXXXXService/XXXXXController
		if(template.indexOf("service")>=0) {
			type = "ServiceImpl";
		}else if(template.indexOf("interface")>=0) {
			type = "Service";
		}
		else if(template.indexOf("controller")>=0) {
			type = "Controller";
		}
		//目标输出文件targetFolder+ "\\src\\main\\java" + entityUpper.java
		File file = new File(fullPath+ SimpleConfigure.getProValue("entityUpper")+type+".java");
		
		//不存在则创建
		if(!folder.exists()){
			folder.mkdirs();
		}
		if(!file.exists()){
			file.createNewFile();
		}
		return file;
	}
	
	public static String getFullPath(String folder){
		String basepackage = SimpleConfigure.getProValue("basepackage");
		folder += "\\src\\main\\java";
		basepackage = basepackage.replaceAll("\\.", "\\\\");
		folder += "\\"+basepackage +"\\";
		//添加类型名称
		String template = SimpleConfigure.getProValue("template");
		if(template.indexOf("controller")>=0) {
			folder += "controller\\";
		}else if(template.indexOf("interface")>=0) {
			folder += "service\\";
		}else if(template.indexOf("service")>=0) {
			folder += "service\\impl\\";
		}
		return folder;
	}
	
	public static void gen() {
		Configuration configuration = new Configuration();
		configuration.setObjectWrapper(new DefaultObjectWrapper());
		configuration.setTemplateLoader(new ClassTemplateLoader(SimpleServiceCodeGenerator.class, "/com/hanson/codeGen/template"));
		try {
			Template template = configuration.getTemplate(SimpleConfigure.getProValue("template"));
			StringWriter writer = new StringWriter();
			File file = SimpleFileUtils.createFile();
			FileOutputStream fos = new FileOutputStream(file);
			template.process(SimpleConfigure.getPros(),writer);
			fos.write(writer.toString().getBytes());
			fos.flush();
			fos.close();
			System.err.println("output:   "+file.getPath());
		} catch (IOException e) {
			e.printStackTrace();
		} catch (TemplateException e) {
			e.printStackTrace();
		}
	}
}
