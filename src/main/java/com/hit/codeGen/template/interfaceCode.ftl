package ${interfacePackage};

import java.util.List;

import com.hit.base.result.Result;
import com.hit.base.result.ResultPage;
import com.hit.base.result.ResultResponse;
import ${criteriaFullName};
import ${modelFullName};

/**
 * 
 * @author huhl
 *
 */
public interface ${interfaceName} {
	/**
	 * 插入一条信息
	 * 
	 * @param ${modelNameLowercase}
	 * @return
	 */
	Result<Long> insert${moduleName}(${modelName} ${modelNameLowercase});
	
	/**
	 * 批量插入信息
	 * @param ${modelNameLowercase}
	 * @return
	 */
	ResultResponse insert${moduleName}Batch(List<${modelName}> ${modelNameLowercase}List);

	/**
	 * 根据主键删除，根据输入${modelNameLowercase}Id去删除，operatorId为当前登录用户的Id
	 * 
	 * @param ${modelNameLowercase}Id
	 * @param operatorId
	 * @return
	 */
	ResultResponse delete${moduleName}ById(Long ${modelNameLowercase}Id, Long operatorId);

	/**
	 * 根据输入的条件批量删除，operatorId为当前登录用户的Id
	 * @param ${criteriaNameLowercase}
	 * @param operatorId
	 * @return
	 */
	ResultResponse delete${moduleName}ByCondition(${criteriaName} ${criteriaNameLowercase},Long operatorId);

	/**
	 * 根据输入的${modelNameLowercase}去更改${modelName}信息
	 * 
	 * @param ${modelNameLowercase}
	 * @return
	 */
	ResultResponse update${moduleName}ById(${modelName} ${modelNameLowercase});

	/**
	 * 根据输入的条件批量更改信息
	 * @param ${modelNameLowercase}
	 * @param ${criteriaNameLowercase}
	 * @return
	 */
	ResultResponse update${moduleName}ByCondition(${modelName} ${modelNameLowercase},${criteriaName} ${criteriaNameLowercase});
	
	/**
	 * 根据${modelNameLowercase}Id得到一条信息
	 * 
	 * @param ${modelNameLowercase}Id
	 * @return
	 */
	Result<${modelName}> get${moduleName}(Long ${modelNameLowercase}Id);

	/**
	 * 根据${modelNameLowercase}Id得到一条信息以及其他关联信息
	 * 
	 * @param ${modelNameLowercase}Id
	 * @return
	 */
	Result<${modelName}> get${moduleName}Detail(Long ${modelNameLowercase}Id);
	
	/**
	 * 根据输入的${criteriaName}条件分页查询
	 * @param ${criteriaNameLowercase}
	 * @return
	 */
	ResultPage<${modelName}> find${moduleName}ForPage(${criteriaName} ${criteriaNameLowercase});
	
	/**
	 * 根据输入的${criteriaName}条件查询
	 * @param ${criteriaNameLowercase}
	 * @return
	 */
	Result<List<${modelName}>> find${moduleName}List(${criteriaName} ${criteriaNameLowercase});
	
	
	/**
	 * 根据输入的${criteriaName}条件分页查询关联信息
	 * @param ${criteriaNameLowercase}
	 * @return
	 */
	ResultPage<${modelName}> find${moduleName}DetailForPage(${criteriaName} ${criteriaNameLowercase});
	
	/**
	 * 根据输入的${criteriaName}条件查询关联信息
	 * @param ${criteriaNameLowercase}
	 * @return
	 */
	Result<List<${modelName}>> find${moduleName}DetailList(${criteriaName} ${criteriaNameLowercase});
	
	/**
	 * 根据输入的${criteriaName}条件统计信息的总数 
	 * @param ${criteriaNameLowercase}
	 * @return
	 */
	public Result<Long> count${moduleName}ByCondition(${criteriaName} ${criteriaNameLowercase});
}
