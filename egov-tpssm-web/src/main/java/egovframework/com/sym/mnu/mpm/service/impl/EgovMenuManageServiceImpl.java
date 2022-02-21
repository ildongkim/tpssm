package egovframework.com.sym.mnu.mpm.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.sym.mnu.mpm.service.EgovMenuManageService;
import egovframework.com.sym.mnu.mpm.service.MenuManageVO;
import egovframework.com.sym.prm.service.ProgrmManageVO;
import egovframework.com.sym.prm.service.impl.ProgrmManageDAO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.excel.EgovExcelService;

/**
 * 메뉴목록관리, 생성, 사이트맵을 처리하는 비즈니스 구현 클래스를 정의한다.
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
 *   										selectUpperMenuNoByPk() 메서드 추가
 *   2017-02-13  이정은          시큐어코딩(ES) - 시큐어코딩 부적절한 예외 처리[CWE-253, CWE-440, CWE-754]
 *   2019-12-06  신용호          KISA 보안약점 조치 (부적절한 예외처리)
 *
 * </pre>
 */

@Service("meunManageService")
public class EgovMenuManageServiceImpl extends EgovAbstractServiceImpl implements EgovMenuManageService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovMenuManageServiceImpl.class);

	@Resource(name = "menuManageDAO")
	private MenuManageDAO menuManageDAO;
	@Resource(name = "progrmManageDAO")
	private ProgrmManageDAO progrmManageDAO;
	@Resource(name = "excelZipService")
	private EgovExcelService excelZipService;

	@Resource(name = "multipartResolver")
	CommonsMultipartResolver mailmultipartResolver;

	/**
	 * 메뉴관리 목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectMenuManageList(MenuManageVO vo) throws Exception {
		return menuManageDAO.selectMenuManageList(vo);
	}
	
	/**
	 * 하위 메뉴 목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectSubMenuList(MenuManageVO vo) throws Exception {
		return menuManageDAO.selectSubMenuList(vo);
	}
	
	/**
	 * MainMenu Head Left 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectMainMenuLeft(MenuManageVO vo) throws Exception {
		return menuManageDAO.selectMainMenuLeft(vo);
	}
	
	/**
	 * 메뉴트리 목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectMenuTreeList(MenuManageVO vo) throws Exception {
		return menuManageDAO.selectMenuTreeList(vo);
	}
	
	/**
	 * 신규 메뉴 번호를 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectNextMenuInfo(MenuManageVO vo) throws Exception {
		return menuManageDAO.selectNextMenuInfo(vo);
	}
	
	/**
	 * 메뉴 상세정보를 조회
	 * @param vo ComDefaultVO
	 * @return MenuManageVO
	 * @exception Exception
	 */
	public MenuManageVO selectMenuManage(ComDefaultVO vo) throws Exception {
		return menuManageDAO.selectMenuManage(vo);
	}

	/**
	 * 메뉴번호를 상위메뉴로 참조하고 있는 메뉴 존재여부를 조회
	 * @param vo ComDefaultVO
	 * @return int
	 * @exception Exception
	 */
	public int selectUpperMenuNoByPk(MenuManageVO vo) throws Exception {
		return menuManageDAO.selectUpperMenuNoByPk(vo);
	}

	/**
	 * 메뉴 정보를 등록
	 * @param vo MenuManageVO
	 * @exception Exception
	 */
	public void insertMenuManage(MenuManageVO vo) throws Exception {
		menuManageDAO.insertMenuManage(vo);
	}

	/**
	 * 메뉴 정보를 삭제
	 * @param vo MenuManageVO
	 * @exception Exception
	 */
	public void deleteMenuManage(MenuManageVO vo) throws Exception {
		menuManageDAO.deleteMenuManage(vo);
	}

	/**
	 * 화면에 조회된 메뉴 목록 정보를 데이터베이스에서 삭제
	 * @param checkedMenuNoForDel String
	 * @exception Exception
	 */
	public void deleteMenuManageList(String checkedMenuNoForDel) throws Exception {
		MenuManageVO vo = null;

		String[] delMenuNo = checkedMenuNoForDel.split(",");

		if (delMenuNo == null || (delMenuNo.length == 0)) {
			throw new java.lang.Exception("String Split Error!");
		}
		for (int i = 0; i < delMenuNo.length; i++) {
			vo = new MenuManageVO();
			vo.setMenuNo(Integer.parseInt(delMenuNo[i]));
			menuManageDAO.deleteMenuManage(vo);
		}
	}

	/**
	 * 프로그램 정보를 등록
	 * @param  vo ProgrmManageVO
	 * @return boolean
	 * @exception Exception
	 */
	private boolean insertProgrm(ProgrmManageVO vo) throws Exception {
		progrmManageDAO.insertProgrm(vo);
		return true;
	}
	
	/**
	 * 권한에 메뉴정보를 할당하여 데이터베이스에 등록
	 * @param menuCreatList List
	 * @exception Exception
	 */
	public void insertMenuCreat(List<MenuManageVO> menuCreatList) throws Exception{
		menuManageDAO.insertMenuCreat(menuCreatList);
	}
	
	/**
	 * 그룹에 권한정보를 할당하여 데이터베이스에 등록
	 * @param authorGroup AuthorGroup
	 * @exception Exception
	 */
	public void updateMenuCreat(MenuManageVO menuManageVO) throws Exception{
		menuManageDAO.updateMenuCreat(menuManageVO);
	}
}