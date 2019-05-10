package com.hanson.codeGen.util;

import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

/**
 *  * 类相关的工具类  *  
 *
 */
public class FindClassMethod {
	public static void main(String[] args) {
		FindClassMethod find = new FindClassMethod();
		String packageName = "com.hanson.school.service.impl";
		// List<String> classNames = getClassName(packageName);
		List<String> classNames = find.getClassName(packageName, false);
		if (classNames != null) {
			for (String className : classNames) {
				try {
					find.checkService(className);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	private List<String> getnormalList(String className){
		//按照规则应该有的方法
		List<String> normalList = new ArrayList<String>();
		//放置应有规则的方法名
		normalList.add(String.format("insert%s", className));
		normalList.add(String.format("insert%sBatch", className));
		normalList.add(String.format("delete%sById", className));
		normalList.add(String.format("delete%sByCondition", className));
		normalList.add(String.format("update%sById", className));
		normalList.add(String.format("update%sByCondition", className));
		normalList.add(String.format("get%s", className));
		normalList.add(String.format("get%sDetail", className));
		normalList.add(String.format("find%sListForPage", className));
		normalList.add(String.format("find%sList", className));
		normalList.add(String.format("find%sDetailListForPage", className));
		normalList.add(String.format("find%sDetailList", className));
		normalList.add(String.format("count%sByCondition", className));
		return normalList;
	}

	/**
	 * 方法检测类
	 * @param className
	 * @throws Exception
	 */
	private void checkService(String className) throws Exception{
		String serviceName = this.getServiceName(className);
		List<String> normalList = this.getnormalList(serviceName);
		//规则之外的方法
		List<String> errorList = new ArrayList<String>();
		//规则之内的方法
		List<String> defindList = new ArrayList<String>();
		System.out.println("\r\r****************"+serviceName+"**********************");
		Class<?> clazz = Class.forName(className);
		List<String> methods = this.getMethodNameAndParams(clazz);
		
		for (String method : methods) {
			if(!normalList.contains(method)){
				//非规定方法
				errorList.add(method);
			}else{
				//移除规定方法
				defindList.add(normalList.remove(normalList.indexOf(method)));
			}
		}
		System.out.println("\r符合规定方法：");
		//打印规定方法
		for (String defindMethod : defindList) {
			System.out.println(defindMethod);
		}
		System.out.println("\r非规定方法：");
		//打印非规定方法
		for (String errorMethod : errorList) {
			System.err.println(errorMethod);
		}
		
		System.out.println("\r规定方法未定义：");
		//打印规定方法但未实现的方法
		for (String undefindMethod : normalList) {
			System.err.println(undefindMethod);
		}
		System.out.println("\r\r-----------------"+serviceName+"----------------------");
		
	}
	
	private String getServiceName(String className){
		String serviceName = className.substring(className.lastIndexOf(".")+1);
		return serviceName.split("Service")[0];
	}
	
	public List<String> getMethodNameAndParams(Class<?> clazz){
		List<String> methodList = new ArrayList<String>();
		Method[] declaredMethods = clazz.getDeclaredMethods();
		for (Method method : declaredMethods) {
			StringBuilder sb = new StringBuilder();
			String methodName = method.getName();
			sb.append(methodName);
			//暂时移除参数
//			sb.append("(");
//			Parameter[] parameters = method.getParameters();
//			for (Parameter parameter : parameters) {
//				String type = parameter.getType().getName();
//				String paramName = parameter.getName();
//				sb.append(type+" ");
//				sb.append(paramName);
//				sb.append(" ");
//			}
//			sb.append(")");
			methodList.add(sb.toString());
		}
		return methodList;
	}
	
	/**
	 * 获取某包下（包括该包的所有子包）所有类
	 * @param packageName 包名
	 * @return 类的完整名称
	 */
	public List<String> getClassName(String packageName) {
		return getClassName(packageName, true);
	}
	
	/**
	 * 获取某包下所有类
	 * @param packageName 包名
	 * @param childPackage 是否遍历子包
	 * @return 类的完整名称
	 */
	public List<String> getClassName(String packageName, boolean childPackage) {
		List<String> fileNames = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		String packagePath = packageName.replace(".", "/");
		URL url = loader.getResource(packagePath);
		if (url != null) {
			String type = url.getProtocol();
			if (type.equals("file")) {
				fileNames = getClassNameByFile(url.getPath(), null, childPackage);
			} else if (type.equals("jar")) {
				fileNames = getClassNameByJar(url.getPath(), childPackage);
			}
		} else {
			fileNames = getClassNameByJars(((URLClassLoader) loader).getURLs(), packagePath, childPackage);
		}
		return fileNames;
	}
	
	/**
	 * 从项目文件获取某包下所有类
	 * @param filePath 文件路径
	 * @param className 类名集合
	 * @param childPackage 是否遍历子包
	 * @return 类的完整名称
	 */
	private List<String> getClassNameByFile(String filePath, List<String> className, boolean childPackage) {
		List<String> myClassName = new ArrayList<String>();
		File file = new File(filePath);
		File[] childFiles = file.listFiles();
		for (File childFile : childFiles) {
			if (childFile.isDirectory()) {
				if (childPackage) {
					myClassName.addAll(getClassNameByFile(childFile.getPath(), myClassName, childPackage));
				}
			} else {
				String childFilePath = childFile.getPath();
				if (childFilePath.endsWith(".class")) {
					childFilePath = childFilePath.substring(childFilePath.indexOf("\\classes") + 9, childFilePath.lastIndexOf("."));
					childFilePath = childFilePath.replace("\\", ".");
					myClassName.add(childFilePath);
				}
			}
		}

		return myClassName;
	}
	
	/**
	 * 从jar获取某包下所有类
	 * @param jarPath jar文件路径
	 * @param childPackage 是否遍历子包
	 * @return 类的完整名称
	 */
	@SuppressWarnings("resource")
	private List<String> getClassNameByJar(String jarPath, boolean childPackage) {
		List<String> myClassName = new ArrayList<String>();
		String[] jarInfo = jarPath.split("!");
		String jarFilePath = jarInfo[0].substring(jarInfo[0].indexOf("/"));
		String packagePath = jarInfo[1].substring(1);
		try {
			Enumeration<JarEntry> entrys = new JarFile(jarFilePath).entries();
			while (entrys.hasMoreElements()) {
				JarEntry jarEntry = entrys.nextElement();
				String entryName = jarEntry.getName();
				if (entryName.endsWith(".class")) {
					if (childPackage) {
						if (entryName.startsWith(packagePath)) {
							entryName = entryName.replace("/", ".").substring(0, entryName.lastIndexOf("."));
							myClassName.add(entryName);
						}
					} else {
						int index = entryName.lastIndexOf("/");
						String myPackagePath;
						if (index != -1) {
							myPackagePath = entryName.substring(0, index);
						} else {
							myPackagePath = entryName;
						}
						if (myPackagePath.equals(packagePath)) {
							entryName = entryName.replace("/", ".").substring(0, entryName.lastIndexOf("."));
							myClassName.add(entryName);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return myClassName;
	}
	
	/**
	 * 从所有jar中搜索该包，并获取该包下所有类
	 * @param urls URL集合
	 * @param packagePath 包路径
	 * @param childPackage 是否遍历子包
	 * @return 类的完整名称
	 */
	private List<String> getClassNameByJars(URL[] urls, String packagePath, boolean childPackage) {
		List<String> myClassName = new ArrayList<String>();
		if (urls != null) {
			for (int i = 0; i < urls.length; i++) {
				URL url = urls[i];
				String urlPath = url.getPath();
				// 不必搜索classes文件夹
				if (urlPath.endsWith("classes/")) {
					continue;
				}
				String jarPath = urlPath + "!/" + packagePath;
				myClassName.addAll(getClassNameByJar(jarPath, childPackage));
			}
		}
		return myClassName;
	}

}

class MethodObj{
	private String methodName;
	private List<ParamObj> paramList;
	public String getMethodName() {
		return methodName;
	}
	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}
	public List<ParamObj> getParamList() {
		return paramList;
	}
	public void setParamList(List<ParamObj> paramList) {
		this.paramList = paramList;
	}
}

class ParamObj{
	private String paramName;
	private String type;
	
	public String getParamName() {
		return paramName;
	}
	public void setParamName(String paramName) {
		this.paramName = paramName;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
}
