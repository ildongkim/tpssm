package egovframework.com.sym.mnu.mpm.service;

import java.io.InputStream;
import java.util.List;

import egovframework.com.cmm.ComDefaultVO;

/**
 * 메뉴관리에 관한 서비스 인터페이스 클래스를 정의한다.
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

public interface EgovMenuManageService {

	/**
	 * 하위 메뉴 목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	List<?> selectSubMenuList(MenuManageVO vo) throws Exception;
	
	/**
	 * 계층형 메뉴 목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	List<?> selectHierarchyMenuList(MenuManageVO vo) throws Exception;
	
	/**
	 * 메뉴관리 목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	List<?> selectMenuManageList(MenuManageVO vo) throws Exception;
	
	/**
	 * 신규 메뉴 번호를 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	List<?> selectNextMenuInfo(MenuManageVO vo) throws Exception;
	
	/**
	 * 메뉴 상세정보를 조회
	 * @param vo ComDefaultVO
	 * @return MenuManageVO
	 * @exception Exception
	 */
	MenuManageVO selectMenuManage(ComDefaultVO vo) throws Exception;

	/**
	 * 메뉴목록 총건수를 조회한다.
	 * @param vo ComDefaultVO
	 * @return int
	 * @exception Exception
	 */
	int selectMenuManageListTotCnt(ComDefaultVO vo) throws Exception;

	/**
	 * 메뉴번호 존재 여부를 조회한다.
	 * @param vo ComDefaultVO
	 * @return int
	 * @exception Exception
	 */
	int selectMenuNoByPk(MenuManageVO vo) throws Exception;

	int selectUpperMenuNoByPk(MenuManageVO vo) throws Exception;

	/**
	 * 메뉴 정보를 등록
	 * @param vo MenuManageVO
	 * @exception Exception
	 */
	void insertMenuManage(MenuManageVO vo) throws Exception;

	/**
	 * 메뉴 정보를 삭제
	 * @param vo MenuManageVO
	 * @exception Exception
	 */
	void deleteMenuManage(MenuManageVO vo) throws Exception;
	
	/**
	 * 메뉴 목록을 조회
	 * @return List
	 * @exception Exception
	 */
	List<?> selectMenuList() throws Exception;
	
	/**
	 * MainMenu Head Left 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	List<?> selectMainMenuLeft(MenuManageVO vo) throws Exception;
}