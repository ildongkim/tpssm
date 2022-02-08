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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.ccm.cca.service.CmmnCode;
import egovframework.com.sym.ccm.cca.service.CmmnCodeVO;
import egovframework.com.sym.ccm.cca.service.EgovCcmCmmnCodeManageService;
import egovframework.com.sym.ccm.cde.service.CmmnDetailCodeVO;
import egovframework.com.sym.ccm.cde.service.EgovCcmCmmnDetailCodeManageService;
import egovframework.com.sym.mnu.mpm.service.MenuManageVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;

/**
 * 코드관리 서비스를 처리하는 컨트롤러 클래스
 * @author Harry
 * @since 2022.02.07
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *  수정일                    수정자                수정내용
 *  ----------   --------   ---------------------------
 *  2022.02.07   김일동                최초생성
 *  
 *  </pre>
 */
@Controller
public class CodeController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(CodeController.class);

	/** EgovMessageSource */
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Resource(name = "CmmnCodeManageService")
    private EgovCcmCmmnCodeManageService cmmnCodeManageService;
	
	@Resource(name = "CmmnDetailCodeManageService")
	private EgovCcmCmmnDetailCodeManageService cmmnDetailCodeManageService;

	@RequestMapping("/cmm/codemng.do")
	public String codeMng(ModelMap model) throws Exception  {
		return "tpssm/com/sym/ccm/codemng";
	}
	
	@RequestMapping("/cmm/codedtlmng.do")
	public String codeDtlMng(ModelMap model) throws Exception  {
		return "tpssm/com/sym/ccm/codedtlmng";
	}
	
    @Autowired
	private DefaultBeanValidator beanValidator;
    
	/**
	 * 코드목록을 조회
	 * @return result - List
	 * @exception Exception
	 */
	@PostMapping(value="/cmm/cmmnCodeList.do")
	public ModelAndView selectCodeList(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");

		CmmnCodeVO searchVO = new CmmnCodeVO();
		searchVO.setSearchCondition(EgovStringUtil.isNullToString(commandMap.get("searchCondition")));
		searchVO.setSearchKeyword(EgovStringUtil.isNullToString(commandMap.get("searchKeyword")));
		List<?> cmmnCodeList = cmmnCodeManageService.selectCmmnCodeList(searchVO);
		modelAndView.addObject(cmmnCodeList);
		
		return modelAndView;
	}
	
	/**
	 * 코드상세목록을 조회
	 * @return result - List
	 * @exception Exception
	 */
	@PostMapping(value="/cmm/cmmnCodeDtlList.do")
	public ModelAndView selectCodeDtlList(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");

		CmmnDetailCodeVO cmmnDtlCodeVO = new CmmnDetailCodeVO();
		cmmnDtlCodeVO.setCodeId(EgovStringUtil.isNullToString(commandMap.get("codeId")));
    	List<?> CmmnDtlCodeList = cmmnDetailCodeManageService.selectCmmnDetailCodeList(cmmnDtlCodeVO);
		modelAndView.addObject(CmmnDtlCodeList);
		
		return modelAndView;
	}
	
    /**
     * 코드정보를 등록한다
     * 코드정보 화면으로 이동한다
     * @param cmmnCodeVO    CmmnCodeVO
	 * @return result - List
	 * @exception Exception
	 */
    @PostMapping(value="/cmm/codemngInsert.do")
    public ModelAndView insertMenuManage (
    		@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO,
    		BindingResult bindingResult) throws Exception {
    	
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
    	beanValidator.validate(cmmnCodeVO, bindingResult); //validation 수행
		if (bindingResult.hasErrors()) { 
			modelAndView.addObject("message", egovMessageSource.getMessage("fail.common.save"));
		} else {
	    	LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	cmmnCodeVO.setFrstRegisterId((user == null || user.getUniqId() == null) ? "" : user.getUniqId());
	    	cmmnCodeVO.setClCode("COM");
	    	cmmnCodeManageService.insertCmmnCode(cmmnCodeVO);
		}
		
    	return modelAndView;
    }
    
    /**
     * 코드정보를 삭제 한다.
     * @param cmmnCodeVO    CmmnCodeVO
     * @return result - List
     * @exception Exception
     */
    @RequestMapping(value="/cmm/codemngDelete.do")
    public ModelAndView deleteMenuManage(@RequestParam Map<String, Object> commandMap) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		CmmnDetailCodeVO cmmnDtlCodeVO = new CmmnDetailCodeVO();
		cmmnDtlCodeVO.setCodeId(EgovStringUtil.isNullToString(commandMap.get("codeId")));
    	List<?> CmmnDtlCodeList = cmmnDetailCodeManageService.selectCmmnDetailCodeList(cmmnDtlCodeVO);
    	
    	if (CmmnDtlCodeList.size() != 0){
    		modelAndView.addObject("message", egovMessageSource.getMessage("fail.common.delete.cmmnDtlCodeExist"));
		} else {
			CmmnCode cmmnCodeVO = new CmmnCode();
			cmmnCodeVO.setCodeId(EgovStringUtil.isNullToString(commandMap.get("codeId")));
			cmmnCodeManageService.deleteCmmnCode(cmmnCodeVO);
		}
		
    	return modelAndView;
    }
}