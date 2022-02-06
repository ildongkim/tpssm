package tpssm.com.cmm.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.mnu.mpm.service.EgovMenuManageService;
import egovframework.com.sym.mnu.mpm.service.MenuManageVO;
import egovframework.com.sym.prm.service.EgovProgrmManageService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

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
	
	/** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;
    
    /** EgovMenuManageService */
	@Resource(name = "progrmManageService")
	private EgovProgrmManageService progrmManageService;
	
    @Autowired
	private DefaultBeanValidator beanValidator;
    
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
	 * @return result - List
	 * @exception Exception
	 */
	@PostMapping(value="/cmm/hierarchyMenulist.do")
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
	 * @return result - List
	 * @exception Exception
	 */
	@PostMapping(value="/cmm/menumngList.do")
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
	
    /**
     * 메뉴정보를 등록한다
     * 메뉴정보 화면으로 이동한다
     * @param menuManageVO    MenuManageVO
	 * @return result - String
	 * @exception Exception
	 */
    @PostMapping(value="/cmm/menumngInsert.do")
    public ModelAndView insertMenuManage (
    		@ModelAttribute("menuManageVO") MenuManageVO menuManageVO,
    		BindingResult bindingResult,
    		ModelMap model) throws Exception {
    	
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
    	beanValidator.validate(menuManageVO, bindingResult); //validation 수행
		if (bindingResult.hasErrors()) { 
			modelAndView.addObject("message", egovMessageSource.getMessage("fail.common.save"));
		} else {
	    	LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	menuManageVO.setRegisterId((user == null || user.getUniqId() == null) ? "" : user.getUniqId());
	    	menuManageService.insertMenuManage(menuManageVO);
	    	modelAndView.addObject("upperMenuId", menuManageVO.getUpperMenuId());
		}
		
    	return modelAndView;
	}
    
    /**
     * 메뉴정보를 등록한다
     * 메뉴정보 화면으로 이동한다
     * @param menuManageVO    MenuManageVO
	 * @return result - String
	 * @exception Exception
	 */
    @PostMapping(value="/cmm/menumngCreate.do")
    public ModelAndView createMenuManage (
    		@ModelAttribute("menuManageVO") MenuManageVO menuManageVO,
    		ModelMap model) throws Exception {
    	
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		List<?> menulist = menuManageService.selectNextMenuInfo(menuManageVO);
		modelAndView.addObject("menulist", menulist);
		
    	return modelAndView;
	}
    
    /**
     * 메뉴정보를 삭제 한다.
     * @param menuManageVO MenuManageVO
     * @return 출력페이지정보 "forward:/cmm/menumanagedelete.do"
     * @exception Exception
     */
    @RequestMapping(value="/cmm/menumngDelete.do")
    public ModelAndView deleteMenuManage(
    		@ModelAttribute("menuManageVO") MenuManageVO menuManageVO,
    		ModelMap model)
            throws Exception {
    	
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
    	if (menuManageService.selectUpperMenuNoByPk(menuManageVO) != 0){
    		modelAndView.addObject("message", egovMessageSource.getMessage("fail.common.delete.upperMenuExist"));
		} else {
			menuManageService.deleteMenuManage(menuManageVO);
			modelAndView.addObject("upperMenuId", menuManageVO.getUpperMenuId());
		}
		
    	return modelAndView;
    }
    
    /**
     * 프로그램파일명을 조회한다.
     * @param searchVO ComDefaultVO
     * @return 출력페이지정보 "/cmm/programListSearch"
     * @exception Exception
     */
    @RequestMapping(value="/cmm/programListSearch.do")
    public String selectProgrmListSearch(
    		@ModelAttribute("searchVO") ComDefaultVO searchVO,
    		ModelMap model)
            throws Exception {
    	
    	// 내역 조회
    	searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
    	searchVO.setPageSize(propertiesService.getInt("pageSize"));

    	/** pageing */
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

        List<?> list_progrmmanage = progrmManageService.selectProgrmList(searchVO);
        model.addAttribute("list_progrmmanage", list_progrmmanage);

        int totCnt = progrmManageService.selectProgrmListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);

        return "tpssm/com/sym/menu/filenmsearch";
    }
}