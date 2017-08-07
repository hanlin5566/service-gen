package com.hit.codeGen.util;

public class StringUtil {
	public static String firstCharToLowerCase(String str) {
		return String.valueOf(str.charAt(0)).toLowerCase().concat(str.substring(1));
	}
	public static String firstCharToUpperCase(String str) {
		return String.valueOf(str.charAt(0)).toUpperCase().concat(str.substring(1));
	}
	public static boolean hasSpecifiedString(String str,String specified){
		return str.indexOf(specified)>=0;
	}
	
}
