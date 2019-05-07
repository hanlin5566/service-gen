package ${basepackage}.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hanson.base.enums.DataStatus;
import com.hanson.base.mybatis.pagination.entity.PageInfo;
import ${basepackage}.dao.gen.entity.${entityUpper};
import ${basepackage}.dao.gen.entity.${entityUpper}Example;
import ${basepackage}.dao.gen.mapper.${entityUpper}Mapper;
import ${basepackage}.service.${entityUpper}Service;
import com.hanson.base.util.BeanUtils;

/**
 * Create by hanlin on 2019年1月30日
 **/
@Service
public class ${entityUpper}ServiceImpl implements ${entityUpper}Service{
	@Autowired
	${entityUpper}Mapper mapper;
	
	@Override
	public Integer insert(${entityUpper} ${entityLower}) {
		${entityLower}.setDataStatus(DataStatus.NORMAL);
		return mapper.insertSelective(${entityLower});
	}
	@Override
	public Integer delete(Integer id) {
		${entityUpper} ${entityLower} = new ${entityUpper}();
		${entityLower}.setId(id);
		${entityLower}.setDataStatus(DataStatus.DELETED);
		return mapper.updateByPrimaryKeySelective(${entityLower});
	}
	@Override
	public Integer update(${entityUpper} ${entityLower}) {
		return mapper.updateByPrimaryKeySelective(${entityLower});
	}
	
	@Override
	public ${entityUpper} get(Integer id) {
		${entityUpper}Example example = new ${entityUpper}Example();
		example.createCriteria().andDataStatusEqualTo(DataStatus.NORMAL).andIdEqualTo(id);
		List<${entityUpper}> selectByExample = mapper.selectByExample(example);
		return selectByExample.size() > 0 ? selectByExample.get(0) : null;
	}
	
	@Override
	public List<${entityUpper}> search(${entityUpper} ${entityLower}, PageInfo page) {
		${entityLower}.setDataStatus(DataStatus.NORMAL);
		${entityUpper}Example example = BeanUtils.example(${entityLower},${entityUpper}Example.class);
		example.setOrderByClause("id desc");
		List<${entityUpper}> selectByExample = mapper.selectByExampleWithRowbounds(example, page);
		return selectByExample;
	}
}