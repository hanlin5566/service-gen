package ${basepackage}.service;

import java.util.List;

import com.hanson.base.mybatis.pagination.entity.PageInfo;
import ${entity};

/**
 * Create by hanlin on 2019年1月28日
 **/
public interface ${entityUpper}Service {
	/**
	 * 新增一条数据
	 * @param {@link ${entityUpper}} ${entityLower}
	 * @return
	 */
	public Integer insert(${entityUpper} ${entityLower});
	/**
	 * 删除一条数据
	 * @param id
	 * @return
	 */
	public Integer delete(Integer id);
	/**
	 * 修改一条数据
	 * @param {@link ${entityUpper}} ${entityLower}
	 * @return
	 */
	public Integer update(${entityUpper} ${entityLower});
	/**
	 * 根据主键获取一条未被删除的数据
	 * @param id
	 * @return
	 */
	public ${entityUpper} get(Integer id);
	/**
	 * 根据条件检索数据
	 * @param {@link User}
	 * @param {@link PageInfo}
	 * @return
	 */
	public List<${entityUpper}> search(${entityUpper} ${entityLower},PageInfo page);
}