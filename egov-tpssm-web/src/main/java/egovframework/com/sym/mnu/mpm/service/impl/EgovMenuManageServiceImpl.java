package egovframework.com.sym.mnu.mpm.service.impl;

import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
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
import egovframework.rte.fdl.cmmn.exception.BaseException;
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

	/** 하위 : 개발 시스템 추가 로직 */
	
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
	 * 계층형 메뉴 목록을 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectHierarchyMenuList(MenuManageVO vo) throws Exception {
		return menuManageDAO.selectHierarchyMenuList(vo);
	}
	
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
	 * 신규 메뉴 번호를 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectNextMenuInfo(MenuManageVO vo) throws Exception {
		return menuManageDAO.selectNextMenuInfo(vo);
	}
	
	/** 하위 : 전자정부프레임워크 기본 로직 */
	
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
	 * 메뉴목록 총건수를 조회한다.
	 * @param vo ComDefaultVO
	 * @return int
	 * @exception Exception
	 */
	public int selectMenuManageListTotCnt(ComDefaultVO vo) throws Exception {
		return menuManageDAO.selectMenuManageListTotCnt(vo);
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
	 * 메뉴번호 존재 여부를 조회한다.
	 * @param vo ComDefaultVO
	 * @return int
	 * @exception Exception
	 */
	public int selectMenuNoByPk(MenuManageVO vo) throws Exception {
		return menuManageDAO.selectMenuNoByPk(vo);
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
	 * 메뉴 정보를 수정
	 * @param vo MenuManageVO
	 * @exception Exception
	 */
	public void updateMenuManage(MenuManageVO vo) throws Exception {
		menuManageDAO.updateMenuManage(vo);
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

	/*  메뉴 생성 관리  */

	/**
	 * 메뉴 목록을 조회
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectMenuList() throws Exception {
		return menuManageDAO.selectMenuList();
	}

	/*### 메뉴관련 프로세스 ###*/
	/**
	 * MainMenu Head Menu 조회
	 * @param vo MenuManageVO
	 * @return List
	 * @exception Exception
	 */
	public List<?> selectMainMenuHead(MenuManageVO vo) throws Exception {
		return menuManageDAO.selectMainMenuHead(vo);
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
	 * MainMenu Head MenuURL 조회
	 * @param  iMenuNo  int
	 * @param  sUniqId  String
	 * @return String
	 * @exception Exception
	 */
	public String selectLastMenuURL(int iMenuNo, String sUniqId) throws Exception {
		MenuManageVO vo = new MenuManageVO();
		vo.setMenuNo(selectLastMenuNo(iMenuNo, sUniqId));
		return menuManageDAO.selectLastMenuURL(vo);
	}

	/**
	 * MainMenu Head Menu MenuNo 조회
	 * @param  iMenuNo  int
	 * @param  sUniqId  String
	 * @return String
	 * @exception Exception
	 */
	private int selectLastMenuNo(int iMenuNo, String sUniqId) throws Exception {
		int chkMenuNo = iMenuNo;
		int cntMenuNo = 0;
		for (; chkMenuNo > -1;) {
			chkMenuNo = selectLastMenuNoChk(chkMenuNo, sUniqId);
			if (chkMenuNo > 0) {
				cntMenuNo = chkMenuNo;
			}
		}
		return cntMenuNo;
	}

	/**
	 * MainMenu Head Menu Last MenuNo 조회
	 * @param  iMenuNo  int
	 * @param  sUniqId  String
	 * @return String
	 * @exception Exception
	 */
	private int selectLastMenuNoChk(int iMenuNo, String sUniqId) throws Exception {
		MenuManageVO vo = new MenuManageVO();
		vo.setMenuNo(iMenuNo);
		vo.setTempValue(sUniqId);
		int chkMenuNo = 0;
		int cntMenuNo = 0;
		cntMenuNo = menuManageDAO.selectLastMenuNoCnt(vo);
		if (cntMenuNo > 0) {
			chkMenuNo = menuManageDAO.selectLastMenuNo(vo);
		} else {
			chkMenuNo = -1;
		}
		return chkMenuNo;
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
}