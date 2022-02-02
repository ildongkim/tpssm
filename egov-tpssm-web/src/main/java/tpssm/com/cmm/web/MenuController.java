package tpssm.com.cmm.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.mnu.mpm.service.EgovMenuManageService;
import egovframework.com.sym.mnu.mpm.service.MenuManageVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;

/**
 * 메뉴관리 서비스를 처리하는 컨트롤러 클래스
 * @author Harry
 * @since 2022.01.30
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *  수정일                    수정자                수정내용
 *  ----------   --------   ---------------------------
 *  2022.01.30   김일동                최초생성
 *  
 *  </pre>
 */
@Controller
public class MenuController {

	/** EgovMessageSource */
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;

    /** EgovMenuManageService */
	@Resource(name = "meunManageService")
    private EgovMenuManageService menuManageService;
	
	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(MenuController.class);

	@RequestMapping("/cmm/menumng.do")
	public String index(ModelMap model) throws Exception  {

		// 1. 상위메뉴정보
		MenuManageVO menuManageVO = new MenuManageVO();
		menuManageVO.setUpperMenuId(0);
		List<?> menulist = menuManageService.selectSubMenuList(menuManageVO);
		model.addAttribute("upperMenuList", menulist);
		
		return "tpssm/com/sym/menu/menumng";
	}
	
	/**
	 * 상위 메뉴 목록을 조회
	 * @return result - String
	 * @exception Exception
	 */
	@RequestMapping(value="/cmm/hierarchyMenulist.do")
	public ModelAndView selectHierarchyMenuList(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");

		// 1. 메뉴조회
		MenuManageVO menuManageVO = new MenuManageVO();
    	menuManageVO.setMenuNo(Integer.parseInt(EgovStringUtil.isNullToString(commandMap.get("menuNo"))));
    	
    	List<?> menulist = menuManageService.selectHierarchyMenuList(menuManageVO);
		modelAndView.addObject(menulist);
		
		return modelAndView;
	}
	
	/**
	 * 메뉴 목록을 조회
	 * @return result - String
	 * @exception Exception
	 */
	@RequestMapping(value="/cmm/menumanagelist.do")
	public ModelAndView menuManageList(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		// 1. 메뉴조회
		String strMenuNo = EgovStringUtil.isNullToString(commandMap.get("menuNo"));
		if ("".contentEquals(strMenuNo)) { return modelAndView; }
		MenuManageVO menuManageVO = new MenuManageVO();
		menuManageVO.setMenuNo(Integer.parseInt(strMenuNo));
    	
    	List<?> menulist = menuManageService.selectMenuManageList(menuManageVO);
		modelAndView.addObject(menulist);
		
		return modelAndView;
	}
}