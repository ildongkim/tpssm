package egovframework.com.sym.mnu.mpm.service.impl;

import java.util.Iterator;
import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.sec.rgm.service.AuthorGroup;
import egovframework.com.sym.mnu.mcm.service.MenuCreatVO;
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

	/** 하위 : 개발 시스템 추가 로직 */
	
	/**
	 * 하위메뉴목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectSubMenuList(MenuManageVO vo) throws Exception{
		return selectList("menuManageDAO.selectSubMenuList", vo);
	}
	
	/**
	 * 계층형메뉴목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectHierarchyMenuList(MenuManageVO vo) throws Exception{
		return selectList("menuManageDAO.selectHierarchyMenuList", vo);
	}
	
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
	
	/** 하위 : 전자정부프레임워크 기본 로직 */
	
    /**
	 * 메뉴목록관리 총건수를 조회한다.
	 * @param vo ComDefaultVO
	 * @return int
	 * @exception Exception
	 */
    public int selectMenuManageListTotCnt(ComDefaultVO vo) {
        return (Integer)selectOne("menuManageDAO.selectMenuManageListTotCnt_S", vo);
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
	 * 메뉴목록 기본정보를 수정
	 * @param vo MenuManageVO
	 * @exception Exception
	 */
	public void updateMenuManage(MenuManageVO vo){
		update("menuManageDAO.updateMenuManage_S", vo);
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
	 * 메뉴 전체목록을 조회
	 * @return list
	 * @exception Exception
	 */
	public List<?> selectMenuList() throws Exception{
		ComDefaultVO vo  = new ComDefaultVO();
		return selectList("menuManageDAO.selectMenuListT_D", vo);
	}


	/**
	 * 메뉴번호 존재여부를 조회
	 * @param vo MenuManageVO
	 * @return int
	 * @exception Exception
	 */
	public int selectMenuNoByPk(MenuManageVO vo) throws Exception{
		return (Integer)selectOne("menuManageDAO.selectMenuNoByPk", vo);
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
	 * 메뉴정보 전체삭제 초기화
	 * @return boolean
	 * @exception Exception
	 */
	public boolean deleteAllMenuList(){
		MenuManageVO vo = new MenuManageVO();
		insert("menuManageDAO.deleteAllMenuList", vo);
		return true;
	}

    /**
	 * 메뉴정보 존재여부 조회한다.
	 * @return int
	 * @exception Exception
	 */
    public int selectMenuListTotCnt() {
    	MenuManageVO vo = new MenuManageVO();
        return (Integer)selectOne("menuManageDAO.selectMenuListTotCnt", vo);
    }


	/*### 메뉴관련 프로세스 ###*/
	/**
	 * MainMenu Head Menu 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectMainMenuHead(MenuManageVO vo) throws Exception{
		return selectList("menuManageDAO.selectMainMenuHead", vo);
	}

	/**
	 * MainMenu Left Menu 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectMainMenuLeft(MenuManageVO vo) throws Exception{
		return selectList("menuManageDAO.selectMainMenuLeft", vo);
	}

	/**
	 * MainMenu Head MenuURL 조회
	 * @param vo MenuManageVO
	 * @return  String
	 * @exception Exception
	 */
	public String selectLastMenuURL(MenuManageVO vo) throws Exception{
		return (String)selectOne("menuManageDAO.selectLastMenuURL", vo);
	}

	/**
	 * MainMenu Left Menu 조회
	 * @param vo MenuManageVO
	 * @return int
	 * @exception Exception
	 */
	public int selectLastMenuNo(MenuManageVO vo) throws Exception{
		return (Integer)selectOne("menuManageDAO.selectLastMenuNo", vo);
	}

	/**
	 * MainMenu Left Menu 조회
	 * @param vo MenuManageVO
	 * @return int
	 * @exception Exception
	 */
	public int selectLastMenuNoCnt(MenuManageVO vo) throws Exception{
		return (Integer)selectOne("menuManageDAO.selectLastMenuNoCnt", vo);
	}
	
	/*
	 * 권한에 메뉴정보를 할당하여 데이터베이스에 등록
	 * @param menuCreatList List
	 * @exception Exception
	 */
	public void insertMenuCreat(List<MenuCreatVO> menuCreatList) throws Exception {
		Iterator<?> iter = menuCreatList.iterator();
		
		MenuCreatVO menuCreatVO = (MenuCreatVO) menuCreatList.get(0);
		update("menuManageDAO.updateMenuCreat", menuCreatVO);
		
		while (iter.hasNext()) {
			insert("menuManageDAO.insertMenuCreat", (MenuCreatVO) iter.next());
		}
	}
	
	/**
	 * 권한에 메뉴정보를 할당하여 데이터베이스에 등록
	 * @param menuCreatVO MenuCreatVO
	 * @exception Exception
	 */
	public void updateMenuCreat(MenuCreatVO menuCreatVO) throws Exception {
		update("menuManageDAO.updateMenuCreat", menuCreatVO);
	}
}