package com.hanson.codeGen.simple;

import java.io.IOException;
import java.util.Scanner;

public class SimpleServiceCodeGenerator {
	private static Scanner sc;

	public static void main(String[] args) throws IOException {
		System.out.println("小心！！！！此程序会覆盖原有文件，请输入yes确定继续执行。");
		sc = new Scanner(System.in);
		String nextLine = sc.nextLine();
		if(!"yes".equals(nextLine)) {
			System.out.println("程序退出");
			System.exit(0);
		}
		//加载配置
		SimpleConfigure.getInstance("conf_simple.properties");
		//生成文件
		SimpleConfigure.setProValue("template", "interfaceCode_simple.ftl");
		SimpleFileUtils.gen();
		SimpleConfigure.setProValue("template", "serviceCode_simple.ftl");
		SimpleFileUtils.gen();
		SimpleConfigure.setProValue("template", "controllerCode_simple.ftl");
		SimpleFileUtils.gen();
	}
}
