package com.hit.${packageFor}.service.impl;

import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hit.base.core.EntityHelper;
import com.hit.base.enums.Status;
import com.hit.base.model.PageInfo;
import com.hit.base.result.Result;
import com.hit.base.result.ResultPage;
import com.hit.base.result.ResultResponse;
import com.hit.base.result.ResultSupport;
import com.hit.base.web.utils.BeanUtils;
import com.hit.base.web.utils.CommonUtils;
import com.hit.redis.common.service.UtilService;

<#list importClass as clazz>
import ${clazz};
</#list>
import ${exampleFullName}.Criteria;

/**
 *
 * @author huhl
 *
 */
@Service
public class ${serviceName} implements ${interfaceName} {
	private static final Logger logger = LoggerFactory.getLogger(${serviceName}.class);

	@Autowired 
	private ${mapperName} ${mapperNameLowercase};
	@Autowired
	private UtilService utilService;

	@Override
	public Result<Long> insert${moduleName}(${modelName} ${modelNameLowercase}){
		logger.debug("insert${moduleName} start ${modelNameLowercase}:{}", ${modelNameLowercase});
		if (!this.checkNeccesaryAttribute(${modelNameLowercase})) {
			return ResultSupport.paramError();
		}
		Result<Long> result = new Result<Long>();
		${entityName} ${entityNameLowercase} = BeanUtils.copyProperties(${modelNameLowercase}, ${entityName}.class);
		${entityNameLowercase}.set${primaryKeyName}(utilService.getNextIndex(${entityName}.class));
		EntityHelper.setCreateStatusFields(${entityNameLowercase}, Status.NORMAL, ${modelNameLowercase}.operatorId());
		this.${mapperNameLowercase}.insertSelective(${entityNameLowercase});
		result.setData(${entityNameLowercase}.get${primaryKeyName}());
		logger.debug("insert${moduleName} end : result({})", result);
		return result;
	}
	
	@Override
	public ResultResponse insert${moduleName}Batch(List<${modelName}> ${modelNameLowercase}List){
		logger.debug("insert${moduleName}Batch start : ({})",${modelNameLowercase}List);
		if (!CollectionUtils.isEmpty(${modelNameLowercase}List)) {
			for (${modelName} ${modelNameLowercase} : ${modelNameLowercase}List) {
				this.insert${moduleName}(${modelNameLowercase});
			}
		}
		logger.debug("insert${moduleName}Batch end ");
		return ResultResponse.ok();
	}
	
	@Override
	public ResultResponse delete${moduleName}ById(Long ${primaryKeyNameLowercase}, Long operatorId){
		logger.debug("delete${moduleName}ById start{}", ${primaryKeyNameLowercase});
		// 校验传入参数
		if (CommonUtils.valueOf(${primaryKeyNameLowercase}) < 1L && CommonUtils.valueOf(operatorId) < 1L) {
			return ResultSupport.paramError();
		}
		// 确认修改字段
		${entityName} ${entityNameLowercase} = new ${entityName}();
		${entityNameLowercase}.set${primaryKeyName}(${primaryKeyNameLowercase});
		EntityHelper.setUpdateStatusFields(${entityNameLowercase}, Status.DELETED, operatorId);
		Integer resultCode = ${mapperNameLowercase}.updateByPrimaryKeySelective(${entityNameLowercase});
		logger.debug("delete${moduleName}ById end:{}", resultCode);
		return ResultResponse.ok();
	}

	@Override
	public ResultResponse delete${moduleName}ByCondition(${criteriaName} ${criteriaNameLowercase}, Long operatorId) {
		logger.debug("delete${moduleName}ByCondition start : ({})",${criteriaNameLowercase});
		${entityName} ${entityNameLowercase} = new ${entityName}();
		EntityHelper.setUpdateStatusFields(${entityNameLowercase}, Status.DELETED, operatorId);
		${exampleName} example = this.createExample(${criteriaNameLowercase});
		${mapperNameLowercase}.updateByExampleSelective(${entityNameLowercase}, example);
		logger.debug("delete${moduleName}ByCondition end");
		return ResultResponse.ok();
	}

	@Override
	public ResultResponse update${moduleName}ById(${modelName} ${modelNameLowercase}) {
		logger.debug("update${moduleName}ById start:{}", ${modelNameLowercase});
		if (null == ${modelNameLowercase} || CommonUtils.valueOf(${modelNameLowercase}.get${primaryKeyName}()) < 1L) {
			return ResultSupport.paramError();
		}
		${entityName} ${entityNameLowercase} = BeanUtils.copyProperties(${modelNameLowercase}, ${entityName}.class);
		EntityHelper.setUpdateFields(${entityNameLowercase}, ${modelNameLowercase}.operatorId());
		Integer resultCode = this.${mapperNameLowercase}.updateByPrimaryKeySelective(${entityNameLowercase});
		logger.debug("update${moduleName}ById end:{}", resultCode);
		return ResultResponse.ok();
	}
	

	@Override
	public ResultResponse update${moduleName}ByCondition(${modelName} ${modelNameLowercase},${criteriaName} ${criteriaNameLowercase}) {
		logger.debug("update${moduleName}ByCondition start : model({}) , ${criteriaName}({})",${modelNameLowercase},${criteriaNameLowercase});
		${entityName} ${entityNameLowercase} = BeanUtils.copyProperties(${modelNameLowercase}, ${entityName}.class);
		${exampleName} example = this.createExample(${criteriaNameLowercase});
		${mapperNameLowercase}.updateByExampleSelective(${entityNameLowercase}, example);
		logger.debug("update${moduleName}ByCondition end");
		return ResultResponse.ok();
	}
	
	
	@Override
	public Result<${modelName}> get${moduleName}(Long ${primaryKeyNameLowercase}) {
		logger.debug("get${moduleName} start : ${primaryKeyNameLowercase}({})", ${primaryKeyNameLowercase});
		${modelName} ${modelNameLowercase} = new ${modelName}();
		if(CommonUtils.valueOf(${primaryKeyNameLowercase}) > 0L){
			${entityName} ${entityNameLowercase} = ${mapperNameLowercase}.selectByPrimaryKey(${primaryKeyNameLowercase});
			if (null != ${entityNameLowercase} && ${entityNameLowercase}.getStatus().equals(Status.NORMAL)) {
				${modelNameLowercase} = BeanUtils.copyProperties(${entityNameLowercase}, ${modelName}.class);
			}
		}
		logger.debug("get${moduleName} end");
		return ResultSupport.ok(${modelNameLowercase});
	}

	@Override
	public Result<${modelName}> get${moduleName}Detail(Long ${primaryKeyNameLowercase}) {
		logger.debug("get${moduleName}Detail start:${primaryKeyNameLowercase}({})", ${primaryKeyNameLowercase});
		Result<${modelName}> result = this.get${moduleName}(${primaryKeyNameLowercase});
		if (null != result.getData()) {
			${modelName} ${modelNameLowercase} = result.getData();
			this.build${moduleName}Detail(${modelNameLowercase});
		}
		logger.debug("get${moduleName}Detail end : result{}", result);
		return result;
	}


	@Override
	public ResultPage<${modelName}> find${moduleName}ForPage(${criteriaName} ${criteriaNameLowercase}) {
		logger.debug("find${moduleName}ForPage start : ({})",${criteriaNameLowercase});
		ResultPage<${modelName}> resultPage = new ResultPage<${modelName}>();
		${exampleName} example = this.createExample(${criteriaNameLowercase});
		PageInfo pageInfo = ${criteriaNameLowercase}.toPageInfo();
		List<${entityName}> ${entityNameLowercase}List = this.${mapperNameLowercase}.selectByExampleWithRowbounds(example, pageInfo);
		List<${modelName}> ${modelNameLowercase}List = BeanUtils.copyListProperties(${entityNameLowercase}List, ${modelName}.class);
		resultPage.setPageInfo(pageInfo);
		resultPage.setData(${modelNameLowercase}List);
		logger.debug("find${moduleName}ForPage end : result ({})",resultPage);
		return resultPage;
	}

	@Override
	public Result<List<${modelName}>> find${moduleName}List(${criteriaName} ${criteriaNameLowercase}) {
		logger.debug("find${moduleName}List start : ({})",${criteriaNameLowercase});
		Result<List<${modelName}>> result = new Result<List<${modelName}>>();
		${exampleName} example = this.createExample(${criteriaNameLowercase});
		List<${entityName}> ${entityNameLowercase}List = ${mapperNameLowercase}.selectByExample(example);
		List<${modelName}> ${modelNameLowercase}List = BeanUtils.copyListProperties(${entityNameLowercase}List, ${modelName}.class);
		result.setData(${modelNameLowercase}List);
		logger.debug("find${moduleName}List end result : ({})",result);
		return result;
	}

	@Override
	public ResultPage<${modelName}> find${moduleName}DetailForPage(${criteriaName} ${criteriaNameLowercase}) {
		logger.debug("find${moduleName}DetailForPage start : ({})",${criteriaNameLowercase});
		ResultPage<${modelName}> resultPage = this.find${moduleName}ForPage(${criteriaNameLowercase});
		for (${modelName} ${modelNameLowercase} : resultPage.listData()) {
			this.build${moduleName}Detail(${modelNameLowercase});
		}
		logger.debug("find${moduleName}DetailForPage end result : ({})",resultPage);
		return resultPage;
	}

	@Override
	public Result<List<${modelName}>> find${moduleName}DetailList(${criteriaName} ${criteriaNameLowercase}) {
		logger.debug("find${moduleName}DetailList start : ({})",${criteriaNameLowercase});
		Result<List<${modelName}>> result = this.find${moduleName}List(${criteriaNameLowercase});
		for (${modelName} ${modelNameLowercase} : result.getData()) {
			this.build${moduleName}Detail(${modelNameLowercase});
		}
		logger.debug("find${moduleName}DetailList end result : ({})",result);
		return result;
	}

	@Override
	public Result<Long> count${moduleName}ByCondition(${criteriaName} ${criteriaNameLowercase}) {
		logger.debug("count${moduleName}ByCondition start : ({})",${criteriaNameLowercase});
		Result<Long> result = new Result<Long>();
		${exampleName} example = this.createExample(${criteriaNameLowercase});
		long count = ${mapperNameLowercase}.countByExample(example);
		result.setData(count);
		logger.debug("count${moduleName}ByCondition end result : ({})",result);
		return result;
	}

	/**
	 * 检查非空属性
	 * 
	 * @param ${modelNameLowercase}
	 */
	private Boolean checkNeccesaryAttribute(${modelName} ${modelNameLowercase}) {
		if (null == ${modelNameLowercase}) {
			return false;
		}
		//TODO:添加验证方法
		return true;
	}
	
	/**
	 * 查询条件
	 * @param ${criteriaNameLowercase}
	 * @return
	 */
	private ${exampleName} createExample(${criteriaName} ${criteriaNameLowercase}){
		${exampleName} example = new ${exampleName}();
		//TODO:添加创建条件方法
		return example;
	}
	
	/**
	 * 根据传入的${modelNameLowercase},添加其他关联信息
	 * @param ${modelNameLowercase}
	 * @return
	 */
	private ${modelName} build${moduleName}Detail (${modelName} ${modelNameLowercase}) {
		//TODO:添加其他需要的信息
		return ${modelNameLowercase};
	};
}
