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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sec.ram.service.AuthorManageVO;
import egovframework.com.sec.ram.service.EgovAuthorManageService;
import egovframework.com.sec.rgm.service.AuthorGroupVO;
import egovframework.com.sec.rgm.service.EgovAuthorGroupService;
import egovframework.com.sym.mnu.mcm.service.EgovMenuCreateManageService;
import egovframework.com.sym.mnu.mcm.service.MenuCreatVO;
import egovframework.com.sym.mnu.mpm.service.EgovMenuManageService;
import egovframework.com.sym.mnu.mpm.service.MenuManageVO;
import egovframework.com.sym.prm.service.EgovProgrmManageService;
import egovframework.com.sym.prm.service.ProgrmManageVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 메뉴관리 서비스를 처리하는 컨트롤러 클래스
 * 메뉴관련 서비스 : 프로그램관리, 권한관리
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

	/** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;
    
    /** EgovMenuManageService */
	@Resource(name = "meunManageService")
    private EgovMenuManageService menuManageService;
    
    /** EgovProgrmManageService */
	@Resource(name = "progrmManageService")
	private EgovProgrmManageService progrmManageService;
	
    /** EgovAuthorManageService */
	@Resource(name = "egovAuthorManageService")
	private EgovAuthorManageService egovAuthorManageService;
	
	/** EgovMenuManageService */
	@Resource(name = "meunCreateManageService")
	private EgovMenuCreateManageService menuCreateManageService;
	
    @Resource(name = "egovAuthorGroupService")
    private EgovAuthorGroupService egovAuthorGroupService;
    
    @Autowired
	private DefaultBeanValidator beanValidator;
    
	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(MenuController.class);

	/**
	 * 메뉴관리 화면이동
	 * @return result - String
	 * @exception Exception
	 */
	@RequestMapping("/cmm/menumng.do")
	public String menuMng(ModelMap model) throws Exception  {

		// 1. 상위메뉴정보
		MenuManageVO menuManageVO = new MenuManageVO();
		menuManageVO.setUpperMenuId(0);
		List<?> menulist = menuManageService.selectSubMenuList(menuManageVO);
		model.addAttribute("upperMenuList", menulist);
		
		return "tpssm/com/sym/mnu/menumng";
	}
	
	/**
	 * 메뉴생성관리 화면이동
	 * @return result - String
	 * @exception Exception
	 */
	@RequestMapping("/cmm/menucreatemng.do")
	public String menuCreateMng(ModelMap model) throws Exception  {
		return "tpssm/com/sym/mnu/menucreatemng";
	}
	
	/**
	 * 프로그램관리 화면이동
	 * @return result - String
	 * @exception Exception
	 */
	@RequestMapping("/cmm/progrmmng.do")
	public String progrmMng(ModelMap model) throws Exception  {
		return "tpssm/com/sym/prm/progrmmng";
	}
	
	/**
	 * 권한관리 화면이동
	 * @return result - String
	 * @exception Exception
	 */
	@RequestMapping("/cmm/authmng.do")
	public String authMng(ModelMap model) throws Exception  {
		return "tpssm/com/sec/authmng";
	}
	
	/**
	 * 권한그룹관리 화면이동
	 * @return result - String
	 * @exception Exception
	 */
	@RequestMapping("/cmm/authgroupmng.do")
	public String authGroupMng(ModelMap model) throws Exception  {
		return "tpssm/com/sec/authgroupmng";
	}
	
	/**
	 * 상위 메뉴 목록을 조회
	 * @return result - List
	 * @exception Exception
	 */
	@PostMapping(value="/cmm/hierarchyMenuList.do")
	public ModelAndView selectHierarchyMenuList(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");

		MenuManageVO menuManageVO = new MenuManageVO();
    	menuManageVO.setMenuNo(Integer.parseInt(EgovStringUtil.isNullToString(commandMap.get("menuNo"))));
    	menuManageVO.setAuthorCode(EgovStringUtil.isNullToString(commandMap.get("authorCode")));
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
	 * @return result - List
	 * @exception Exception
	 */
    @PostMapping(value="/cmm/menumngInsert.do")
    public ModelAndView insertMenuManage (
    		@ModelAttribute("menuManageVO") MenuManageVO menuManageVO,
    		BindingResult bindingResult) throws Exception {
    	
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
	 * @return result - List
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
     * @return result - List
     * @exception Exception
     */
    @RequestMapping(value="/cmm/menumngDelete.do")
    public ModelAndView deleteMenuManage(@ModelAttribute("menuManageVO") MenuManageVO menuManageVO) throws Exception {
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

        return "tpssm/com/sym/mnu/filenmsearch";
    }
    
	/**
	 * 프로그램 목록을 조회
	 * @return result - List
	 * @exception Exception
	 */
	@PostMapping(value="/cmm/progrmmngList.do")
	public ModelAndView progrmManageList(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		ComDefaultVO comdefaultVO = new ComDefaultVO();
		comdefaultVO.setSearchKeyword(EgovStringUtil.isNullToString(commandMap.get("programFileName")));
    	List<?> menulist = progrmManageService.selectProgrmMngList(comdefaultVO);
		modelAndView.addObject(menulist);
		
		return modelAndView;
	}
	
    /**
     * 프로그램정보를 등록한다
     * 프로그램정보 화면으로 이동한다
     * @param progrmManageVO ProgrmManageVO
	 * @return result - List
	 * @exception Exception
	 */
    @PostMapping(value="/cmm/progrmmngInsert.do")
    public ModelAndView insertProgrmManage (
    		@ModelAttribute("progrmManageVO") ProgrmManageVO progrmManageVO,
    		BindingResult bindingResult) throws Exception {
    	
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
    	beanValidator.validate(progrmManageVO, bindingResult); //validation 수행
		if (bindingResult.hasErrors()) { 
			modelAndView.addObject("message", egovMessageSource.getMessage("fail.common.save"));
		} else {
	    	LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	progrmManageVO.setRegisterId((user == null || user.getUniqId() == null) ? "" : user.getUniqId());
	    	progrmManageService.insertProgrm(progrmManageVO);
		}
		
    	return modelAndView;
	}
    
    /**
     * 프로그램 정보를 삭제 한다.
     * @param progrmManageVO ProgrmManageVO
	 * @return result - List
	 * @exception Exception
     */
    @RequestMapping(value="/cmm/progrmmngDelete.do")
    public ModelAndView deleteProgrmList(@ModelAttribute("progrmManageVO") ProgrmManageVO progrmManageVO) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
        progrmManageService.deleteProgrm(progrmManageVO);
    	return modelAndView;
    }
    
	/**
	 * 권한 목록을 조회
	 * @return result - List
	 * @exception Exception
	 */
	@PostMapping(value="/cmm/authmngList.do")
	public ModelAndView authorManageList(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		AuthorManageVO authorManageVO = new AuthorManageVO();
    	List<?> authlist = egovAuthorManageService.selectAuthorList(authorManageVO);
		modelAndView.addObject(authlist);
		
		return modelAndView;
	}
	
    /**
     * 권한정보를 등록한다
     * 권한정보 화면으로 이동한다
     * @param authorManageVO AuthorManageVO
	 * @return result - List
	 * @exception Exception
	 */
    @PostMapping(value="/cmm/authmngInsert.do")
    public ModelAndView insertAuthorManage (
    		@ModelAttribute("authorManageVO") AuthorManageVO authorManageVO,
    		BindingResult bindingResult) throws Exception {
    	
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
    	beanValidator.validate(authorManageVO, bindingResult); //validation 수행
		if (bindingResult.hasErrors()) { 
			modelAndView.addObject("message", egovMessageSource.getMessage("fail.common.save"));
		} else {
	    	LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	authorManageVO.setRegisterId((user == null || user.getUniqId() == null) ? "" : user.getUniqId());
	    	egovAuthorManageService.insertAuthor(authorManageVO);
		}
		
    	return modelAndView;
	}
    
    /**
     * 권한정보를 삭제 한다.
     * @param authorManageVO AuthorManageVO
	 * @return result - List
	 * @exception Exception
     */
    @RequestMapping(value="/cmm/authmngDelete.do")
    public ModelAndView deleteAuthorList(@ModelAttribute("authorManageVO") AuthorManageVO authorManageVO) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		egovAuthorManageService.deleteAuthor(authorManageVO);
    	return modelAndView;
    }
    
	/**
	 * 메뉴생성 정보를 조회
	 * @return result - List
	 * @exception Exception
	 */
	@PostMapping(value="/cmm/menuCreatList.do")
	public ModelAndView selectMenuCreatList(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		MenuCreatVO menuCreatVO = new MenuCreatVO();
		menuCreatVO.setAuthorCode(EgovStringUtil.isNullToString(commandMap.get("authorCode")));
    	List<?> menuCreatList = menuCreateManageService.selectMenuCreatList(menuCreatVO);
		modelAndView.addObject(menuCreatList);
		return modelAndView;
	}
    
    /**
     * 메뉴생성정보를 등록한다
     * 메뉴생성정보 화면으로 이동한다
     * @param menuManageVO    MenuManageVO
	 * @return result - List
	 * @exception Exception
	 */
    @PostMapping(value="/cmm/menucreateInsert.do")
    public ModelAndView insertMenuCreateManage (@RequestParam String data) throws Exception {
    	
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
    	LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	//menuManageVO.setRegisterId((user == null || user.getUniqId() == null) ? "" : user.getUniqId());
    	//menuManageService.insertMenuManage(menuManageVO);
    	//modelAndView.addObject("upperMenuId", menuManageVO.getUpperMenuId());
    	
    	return modelAndView;
	}
    
	/**
	 * 사용자 목록을 조회
	 * @return result - List
	 * @exception Exception
	 */
	@PostMapping(value="/cmm/authMberList.do")
	public ModelAndView selectAuthorMberList(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		AuthorGroupVO authorGroupVO = new AuthorGroupVO();
    	List<?> authlist = egovAuthorGroupService.selectAuthorMberList(authorGroupVO);
		modelAndView.addObject(authlist);
		
		return modelAndView;
	}
	
	/**
	 * 권한그룹 목록을 조회
	 * @return result - List
	 * @exception Exception
	 */
	@PostMapping(value="/cmm/authgrpList.do")
	public ModelAndView selectAuthorGroupList(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		AuthorGroupVO authorGroupVO = new AuthorGroupVO();
		authorGroupVO.setUniqId(EgovStringUtil.isNullToString(commandMap.get("uniqId")));
    	List<?> authlist = egovAuthorGroupService.selectAuthorGroupList(authorGroupVO);
		modelAndView.addObject(authlist);
		
		return modelAndView;
	}
}