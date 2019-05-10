package ${controllerPackage};

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hanson.base.result.Result;
import com.hanson.base.result.ResultPage;
import com.hanson.base.result.ResultResponse;

<#list importClass as clazz>
import ${clazz};
</#list>



@Controller
@RequestMapping(value = "/${modelNameLowercase}")
public class ${controllerName} {
	private static final Logger logger = LoggerFactory.getLogger(${controllerName}.class);
	

	@Autowired
	private ${interfaceName} ${interfaceNameLowercase};

	@RequestMapping(value = "", method = RequestMethod.POST)
	@ResponseBody
	public Result<Long> save(@RequestBody ${modelName} ${modelNameLowercase}) {
		logger.info("insert ${moduleName} start:{}", ${modelNameLowercase});
		Long ${primaryKeyNameLowercase} =  ${interfaceNameLowercase}.insert${moduleName}(${modelNameLowercase}).getData();
		${modelNameLowercase}.set${primaryKeyName}(${primaryKeyNameLowercase});
		Result<Long> ret = new Result<Long>();
		ret.setData(${modelNameLowercase}.get${primaryKeyName}());
		logger.info("insert ${moduleName} start:{}", ret);
		return ret;
	}
	
	@RequestMapping(value = "", method = RequestMethod.PUT)
	@ResponseBody
	public Result<Long> update(@RequestBody ${modelName} ${modelNameLowercase}) {
		logger.info("update ${moduleName} start:{}",${modelNameLowercase});
		${interfaceNameLowercase}.update${moduleName}ById(${modelNameLowercase});
		Result<Long> ret = new Result<Long>();
		ret.setData(${modelNameLowercase}.get${primaryKeyName}());
		logger.info("update ${moduleName} end:{}", ret);
		return ret;
	}
	
	
	
	@RequestMapping(value="", method = RequestMethod.GET)
    @ResponseBody
    public ResultPage<${modelName}> list (${criteriaName} ${criteriaNameLowercase}) {
		logger.info("list${moduleName} start:{}", ${criteriaNameLowercase});
		ResultPage<${modelName}> result = ${interfaceNameLowercase}.find${moduleName}ForPage(${criteriaNameLowercase});
		logger.info("list${moduleName} end:{}", result);
		return result;		
	}
	
	@RequestMapping(value="/{${primaryKeyNameLowercase}}", method = RequestMethod.GET)
    @ResponseBody
    public Result<${modelName}> detail (@PathVariable Long ${primaryKeyNameLowercase}) {
		logger.info("${moduleName} detail start:{}", ${primaryKeyNameLowercase});
		//取值
		Result<${modelName}> result = ${interfaceNameLowercase}.get${moduleName}Detail(${primaryKeyNameLowercase});
		logger.info("${moduleName} detail end:{}", result);
		return result;		
	}
	
	@ResponseBody
	@RequestMapping(value="", method = RequestMethod.DELETE)
    public ResultResponse delete (@RequestBody Long[] ${primaryKeyNameLowercase}s) {
		logger.info("delete ${moduleName} start:{}", ${primaryKeyNameLowercase}s.toString());
		${loginSessionName} sessionUser = ${contextName}.getSessionUser();
		${retUserTypeName} ${retUserTypeNameLowercase} = sessionUser.getUserInfo();
		Long userId = ${retUserTypeNameLowercase}.getUserId();
		//取值
		for (Long ${primaryKeyNameLowercase} : ${primaryKeyNameLowercase}s) {
			${interfaceNameLowercase}.delete${moduleName}ById(${primaryKeyNameLowercase}, userId);
		}
		logger.info("delete ${moduleName} end:{}", ${primaryKeyNameLowercase}s.toString());
		return ResultResponse.ok();		
	}
}
