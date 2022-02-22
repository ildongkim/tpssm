package egovframework.com.sym.mnu.mpm.service.impl;

import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.lang.math.NumberUtils;
import org.springframework.stereotype.Repository;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.sym.mnu.mpm.service.MenuManageVO;
/**
 * 메뉴관리, 메뉴생성, 사이트맵 생성에 대한 DAO 클래스를 정의한다.
 * @author 개발환경 개발팀 이용
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.03.20  이  용          최초 생성
 *   2011.07.01  서준식			자기 메뉴 정보를 상위메뉴 정보로 참조하는 메뉴정보가 있는지 조회하는
 *   							selectUpperMenuNoByPk() 메서드 추가
 *
 * </pre>
 */

@Repository("menuManageDAO")
public class MenuManageDAO extends EgovComAbstractDAO{

	/**
	 * 메뉴관리목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectMenuManageList(MenuManageVO vo) throws Exception{
		return selectList("menuManageDAO.selectMenuManageList_D", vo);
	}
	
	/**
	 * 신규 메뉴 번호를 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectNextMenuInfo(MenuManageVO vo) throws Exception{
		return selectList("menuManageDAO.selectNextMenuInfo", vo);
	}
	
	/**
	 * 메뉴목록관리 기본정보를 조회
	 * @param vo ComDefaultVO
	 * @return MenuManageVO
	 * @exception Exception
	 */
	public MenuManageVO selectMenuManage(ComDefaultVO vo)throws Exception{
		return (MenuManageVO)selectOne("menuManageDAO.selectMenuManage_D", vo);
	}

	/**
	 * 메뉴목록 기본정보를 등록
	 * @param vo MenuManageVO
	 * @exception Exception
	 */
	public void insertMenuManage(MenuManageVO vo){
		insert("menuManageDAO.insertMenuManage_S", vo);
	}

	/**
	 * 메뉴목록 기본정보를 삭제
	 * @param vo MenuManageVO
	 * @exception Exception
	 */
	public void deleteMenuManage(MenuManageVO vo){
		delete("menuManageDAO.deleteMenuManage_S", vo);
	}

	/**
	 * 메뉴번호를 상위메뉴로 참조하고 있는 메뉴 존재여부를 조회
	 * @param vo MenuManageVO
	 * @return int
	 * @exception Exception
	 */
	public int selectUpperMenuNoByPk(MenuManageVO vo) throws Exception{
		return (Integer)selectOne("menuManageDAO.selectUpperMenuNoByPk", vo);
	}

	/**
	 * 메뉴트리 목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectMenuTreeList(MenuManageVO vo) throws Exception{
		return selectMenuTree(selectList("menuManageDAO.selectMenuTreeList", vo), vo.getUpperMenuId());
	}
	
    /**
	 * MainMenu Left Menu 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectMainMenuLeft(MenuManageVO vo) throws Exception{
		return selectMenuTree(selectList("menuManageDAO.selectMainMenuLeft", vo), 0);
	}
	
    /**
	 * Menu Tree 조회
	 * @param vo List
	 * @return List
	 * @exception Exception
	 */
	private List<?> selectMenuTree(List<MenuManageVO> list, int uppperMenuId) throws Exception {
		List<MenuManageVO> _chidren = list.stream()
				.filter(s -> s.getUpperMenuId() == uppperMenuId)
				.collect(Collectors.toList());
		for (MenuManageVO _child : _chidren) {
			_child.set_children(selectMenuTree(list, _child.getMenuNo()));
		}
		return _chidren;
	}
	
	/**
	 * 권한에 메뉴정보를 할당하여 데이터베이스에 등록
	 * @param menuCreatList List
	 * @exception Exception
	 */
	public void insertMenuCreat(List<MenuManageVO> menuCreatList) throws Exception {
		Iterator<?> iter = menuCreatList.iterator();
		MenuManageVO menuManageVO;
		while (iter.hasNext()) {
			menuManageVO = (MenuManageVO) iter.next();
			if ("Y".equals(menuManageVO.getUseAt())) {
				insert("menuManageDAO.insertMenuCreat", menuManageVO);
			} else {
				delete("menuManageDAO.deleteMenuCreat", menuManageVO);
			}
		}
	}
}