package com.hit.codeGen.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringWriter;

import com.hit.codeGen.main.ControllerGenerator;
import com.hit.codeGen.model.ClassModel;

import freemarker.cache.ClassTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;
import freemarker.template.TemplateException;

public class FileUtils {
	public static File createFile(String targetFolder) throws IOException {
		String folderName = targetFolder.substring(0, targetFolder.lastIndexOf("\\"));
//		String fileName = targetFolder.substring(targetFolder.lastIndexOf("\\")+1,targetFolder.length());
		File folder = new File(folderName);
		File file = new File(targetFolder);
		//不存在则创建
		if(!folder.exists()){
			folder.mkdirs();
		}
		if(!file.exists()){
			file.createNewFile();
		}
		return file;
	}
	
	public static String getFullPath(String folder,String classFullName){
		folder += "\\src\\main\\java";
		classFullName = classFullName.replaceAll("\\.", "\\\\");
		return folder +"\\"+ classFullName+".java";
	}
	
	public static void gen(ClassModel classModel, String templateName,String targetFolder) {
		Configuration configuration = new Configuration();
		configuration.setObjectWrapper(new DefaultObjectWrapper());
		configuration.setTemplateLoader(new ClassTemplateLoader(ControllerGenerator.class, "/com/hit/codeGen/template"));
		try {
			Template template = configuration.getTemplate(templateName);
			StringWriter writer = new StringWriter();
			File file = FileUtils.createFile(targetFolder);
			FileOutputStream fos = new FileOutputStream(file);
			template.process(ClazzUtil.convertBean(classModel), writer);
			fos.write(writer.toString().getBytes());
			fos.flush();
			fos.close();
			System.err.println("output:   "+targetFolder);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (TemplateException e) {
			e.printStackTrace();
		}
	}
}
