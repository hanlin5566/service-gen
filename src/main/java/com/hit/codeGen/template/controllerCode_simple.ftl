package ${basepackage}.controller;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hanson.base.mybatis.pagination.entity.PageInfo;
import ${basepackage}.dao.gen.entity.${entityUpper};
import ${basepackage}.service.${entityUpper}Service;
import com.hanson.base.exception.ControllerException;
//TODO:需要换成自己的responseCode
import com.hanson.base.response.ResponseCode;
import com.hanson.base.response.ResponseData;

/**
 * Create by hanlin on 2019年1月28日
 **/
@RestController()
@RequestMapping(value = "/${entityLower}s")
public class ${entityUpper}Controller {
	@Autowired
	${entityUpper}Service ${entityLower}Service;
	/**
	 * 根据ID查找用户
	 * @param id
	 * @return
	 */
	@GetMapping("/{id}")
	public ResponseData get(@PathVariable Integer id){
		${entityUpper} ${entityLower} = ${entityLower}Service.get(id);
		if(${entityLower} == null){
			return ResponseData.fail(ResponseCode.RESOURCE_NOT_FOUND);
		}
		return ResponseData.ok(${entityLower});
	}
	/**
	 * 复杂条件查询 查询条件为body中的json
	 * @param ${entityLower}
	 * @return
	 */
	@GetMapping()
	public ResponseData search(${entityUpper} ${entityLower},PageInfo page){
		List<${entityUpper}> list = ${entityLower}Service.search(${entityLower},page);
		if(list == null){
			return ResponseData.fail(ResponseCode.RESOURCE_NOT_FOUND);
		}
		return ResponseData.ok(list).appendPageInfo(page);
	}
	/**
	 * 新增
	 * @param ${entityLower}
	 * @return
	 */
	@PostMapping()
	public ResponseData add(@RequestBody ${entityUpper} ${entityLower}){
		Integer id = ${entityLower}Service.insert(${entityLower});
		return ResponseData.ok(id);
	}
	/**
	 * 修改信息
	 * @param ${entityLower}
	 * @return
	 */
	@PutMapping()
	public ResponseData update(@RequestBody ${entityUpper} ${entityLower}){
		Integer id = ${entityLower}.getId();
		if(id == null || id < 0) {
			throw new ControllerException(ResponseCode.ERROR_PARAM);
		}
		Integer count = ${entityLower}Service.update(${entityLower});
		return ResponseData.ok(count);
	}
	
	/**
	 * 删除信息
	 * @param ${entityLower}
	 * @return
	 */
	@DeleteMapping("/{id}")
	public ResponseData delete(@PathVariable Integer id){
		Integer count = ${entityLower}Service.delete(id);
		return ResponseData.ok(count);
	}
}
