package tpssm.com.cmm.web;

import java.util.HashMap;
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

import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovCmmUseService;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.cop.bbs.service.BoardMaster;
import egovframework.com.cop.bbs.service.BoardMasterVO;
import egovframework.com.cop.bbs.service.BoardVO;
import egovframework.com.cop.bbs.service.EgovArticleService;
import egovframework.com.cop.bbs.service.EgovBBSMasterService;
import egovframework.com.utl.fcc.service.EgovNumberUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;

/**
 * 게시판 서비스를 처리하는 컨트롤러 클래스
 * @author Harry
 * @since 2022.02.10
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *  수정일                    수정자                수정내용
 *  ----------   --------   ---------------------------
 *  2022.02.10   김일동                최초생성
 *  
 *  </pre>
 */
@Controller
public class BBSController {

	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(BBSController.class);

    @Resource(name = "EgovCmmUseService")
    private EgovCmmUseService cmmUseService;
    
	/** EgovMessageSource */
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;
	
    @Resource(name = "EgovBBSMasterService")
    private EgovBBSMasterService egovBBSMasterService;
    
	@Resource(name = "EgovArticleService")
	private EgovArticleService egovArticleService;
	
    @Autowired
	private DefaultBeanValidator beanValidator;
    
	@RequestMapping("/cmm/bbsmstmng.do")
	public String codeMng(ModelMap model) throws Exception  {
		
		//공통코드(게시판유형)
		ComDefaultCodeVO vo = new ComDefaultCodeVO();
		vo.setCodeId("COM101");
		List<?> codeResult = cmmUseService.selectCmmCodeDetail(vo);
		model.addAttribute("bbsTyCode", codeResult);
		
		return "tpssm/com/cop/bbs/bbsmstmng";
	}
	
	@RequestMapping("/cmm/noticemng.do")
	public String noticeMng(ModelMap model) throws Exception  {
		return "tpssm/com/cop/bbs/noticemng";
	}
	
    /**
     * 게시판 마스터 목록을 조회한다.
     * 
     * @param Map<String, Object>
     * @return
     * @throws Exception
     */
    @PostMapping("/cmm/bbsmstinfs.do")
    public ModelAndView selectBBSMasterInfs(@RequestParam Map<String, Object> commandMap) throws Exception {
    	ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		BoardMasterVO boardMasterVO = new BoardMasterVO();
		boardMasterVO.setBbsId(EgovStringUtil.isNullToString(commandMap.get("bbsId")));
		List<?> bbsMstList = egovBBSMasterService.selectBBSMasterInfs(boardMasterVO);
		modelAndView.addObject(bbsMstList);
		
		return modelAndView;
    }
    
    /**
     * 게시판 정보를 저장한다.
     * 
     * @param boardMasterVO
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @PostMapping("/cmm/bbsmstInsert.do")
    public ModelAndView insertBBSMaster(
    		@ModelAttribute("boardMaster") BoardMaster boardMaster,
    		BindingResult bindingResult) throws Exception {
    	ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
    	beanValidator.validate(boardMaster, bindingResult); //validation 수행
		if (bindingResult.hasErrors()) { 
			modelAndView.addObject("message", egovMessageSource.getMessage("fail.common.save"));
		} else {
	    	LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	boardMaster.setFrstRegisterId((user == null || user.getUniqId() == null) ? "" : user.getUniqId());
	    	egovBBSMasterService.insertBBSMasterInf(boardMaster);
		}
		
		return modelAndView;
    }
    
    /**
     * 게시판 정보를 삭제 한다.
     * @param boardMasterVO BoardMaster
	 * @return result - List
	 * @exception Exception
     */
    @RequestMapping(value="/cmm/bbsmstDelete.do")
    public ModelAndView deleteBBSMaster(@ModelAttribute("boardMaster") BoardMaster boardMaster) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		egovBBSMasterService.deleteBBSMasterInf(boardMaster);
    	return modelAndView;
    }
    
    /**
     * 공지사항 목록을 조회한다.
     * 
     * @param Map<String, Object>
     * @return
     * @throws Exception
     */
    @PostMapping("/cmm/noticeinfs.do")
    public ModelAndView selectNoticeInfs(@RequestParam Map<String, Object> commandMap) throws Exception {
    	ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		if ("BBS_NOTICE".equals(EgovStringUtil.isNullToString(commandMap.get("bbsId")))) {
			BoardVO boardVO = new BoardVO();
			boardVO.setBbsId(EgovStringUtil.isNullToString(commandMap.get("bbsId")));
			boardVO.setPage(EgovNumberUtil.isNullToZero(commandMap.get("page")));
			boardVO.setPerPage(EgovNumberUtil.isNullToZero(commandMap.get("perPage")));
			modelAndView.addObject("result", true);
			modelAndView.addObject("data", egovArticleService.selectNoticeArticleList(boardVO));
		} else {
			modelAndView.addObject("result", false);
			modelAndView.addObject("message", egovMessageSource.getMessage("fail.common.select"));
		}
		
		return modelAndView;
    }
}