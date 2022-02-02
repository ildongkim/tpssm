package tpssm.com.cmm.init.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.EgovComponentChecker;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.EgovWebUtil;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.config.EgovLoginConfig;
import egovframework.com.cmm.service.EgovCmmUseService;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.uss.umt.service.EgovEntrprsManageService;
import egovframework.com.uss.umt.service.EgovMberManageService;
import egovframework.com.uss.umt.service.EgovUserManageService;
import egovframework.com.uss.umt.service.EntrprsManageVO;
import egovframework.com.uss.umt.service.MberManageVO;
import egovframework.com.uss.umt.service.UserDefaultVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * 비로그인 서비스를 처리하는 컨트롤러 클래스
 * 로그인, 회원가입, 약관동의, 아이디중복체크, initValidator
 * @author Harry
 * @since 2022.01.27
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *  수정일                    수정자                수정내용
 *  ----------   --------   ---------------------------
 *  2022.01.27   김일동                최초생성
 *  
 *  </pre>
 */
@Controller
public class ComInitController {

	/** EgovLoginService */
	@Resource(name = "loginService")
	private EgovLoginService loginService;

	/** EgovCmmUseService */
	@Resource(name = "EgovCmmUseService")
	private EgovCmmUseService cmmUseService;

	/** EgovMessageSource */
	@Resource(name = "egovMessageSource")
	EgovMessageSource egovMessageSource;

	@Resource(name = "egovLoginConfig")
	EgovLoginConfig egovLoginConfig;

	/** mberManageService */
	@Resource(name = "mberManageService")
	private EgovMberManageService mberManageService;
	
	/** entrprsManageService */
	@Resource(name = "entrprsManageService")
	private EgovEntrprsManageService entrprsManageService;
	
	/** userManageService */
	@Resource(name = "userManageService")
	private EgovUserManageService userManageService;
	
	@Resource(name = "egovPageLinkWhitelist")
    protected List<String> egovWhitelist;

	@Resource(name = "egovNextUrlWhitelist")
    protected List<String> nextUrlWhitelist;
	
	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(ComInitController.class);

	@RequestMapping("/cmm/init/index.do")
	public String index(ModelMap model) {
		return "tpssm/com/init/index";
	}
	
	/**
	 * 로그인 화면으로 들어간다
	 * @param vo - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */
	@IncludedInfo(name = "로그인", listUrl = "/cmm/init/loginUsr.do", order = 10, gid = 10)
	@RequestMapping(value = "/cmm/init/loginUsr.do")
	public String loginUsrView(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
				
		//권한체크시 에러 페이지 이동
		String auth_error =  request.getParameter("auth_error") == null ? "" : (String)request.getParameter("auth_error");
		if(auth_error != null && auth_error.equals("1")){
			return "tpssm/com/init/error/accessDenied";
		}
		
		String message = (String)request.getParameter("loginMessage");
		if (message!=null) model.addAttribute("loginMessage", message);
		
		return "tpssm/com/init/LoginUsr";
	}

	/**
	 * 일반(세션) 로그인을 처리한다
	 * @param vo - 아이디, 비밀번호가 담긴 LoginVO
	 * @param request - 세션처리를 위한 HttpServletRequest
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
	@RequestMapping(value = "/cmm/init/actionLogin.do")
	public String actionLogin(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, ModelMap model) throws Exception {

		// 1. 로그인인증제한 활성화시 
		if( egovLoginConfig.isLock()){
		    Map<?,?> mapLockUserInfo = (EgovMap)loginService.selectLoginIncorrect(loginVO);
		    if(mapLockUserInfo != null){			
				//2.1 로그인인증제한 처리
				String sLoginIncorrectCode = loginService.processLoginIncorrect(loginVO, mapLockUserInfo);
				if(!sLoginIncorrectCode.equals("E")){
					if(sLoginIncorrectCode.equals("L")){
						model.addAttribute("loginMessage", egovMessageSource.getMessageArgs("fail.common.loginIncorrect", new Object[] {egovLoginConfig.getLockCount(),request.getLocale()}));
					}else if(sLoginIncorrectCode.equals("C")){
						model.addAttribute("loginMessage", egovMessageSource.getMessage("fail.common.login",request.getLocale()));
					}
					return "tpssm/com/init/LoginUsr";
				}
		    }else{
		    	model.addAttribute("loginMessage", egovMessageSource.getMessage("fail.common.login",request.getLocale()));
		    	return "tpssm/com/init/LoginUsr";
		    }
		}
		
		// 2. 로그인 처리
		LoginVO resultVO = loginService.actionLogin(loginVO);
		
		// 3. 일반 로그인 처리
		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {

			// 3-1. 로그인 정보를 세션에 저장
			request.getSession().setAttribute("loginVO", resultVO);
			// 2019.10.01 로그인 인증세션 추가
			request.getSession().setAttribute("accessUser", resultVO.getUserSe().concat(resultVO.getId()));

			return "redirect:/cmm/actionMain.do";

		} else {
			model.addAttribute("loginMessage", egovMessageSource.getMessage("fail.common.login",request.getLocale()));
			return "tpssm/com/init/LoginUsr";
		}
	}

	/**
	 * 로그아웃한다.
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/cmm/init/actionLogout.do")
	public String actionLogout(HttpServletRequest request, ModelMap model) throws Exception {

		/*String userIp = EgovClntInfo.getClntIP(request);

		// 1. Security 연동
		return "redirect:/j_spring_security_logout";*/

		request.getSession().setAttribute("loginVO", null);
		// 세션모드인경우 Authority 초기화
		// List<String> authList = (List<String>)EgovUserDetailsHelper.getAuthorities();
		request.getSession().setAttribute("accessUser", null);

		//return "redirect:/egovDevIndex.jsp";
		return "redirect:/cmm/init/actionLogin.do";
	}

	/**
	 * 아이디/비밀번호 찾기 화면으로 들어간다
	 * @param
	 * @return 아이디/비밀번호 찾기 페이지
	 * @exception Exception
	 */
	@RequestMapping(value = "/cmm/init/searchIdPassword.do")
	public String idPasswordSearchView(ModelMap model) throws Exception {

		// 1. 비밀번호 힌트 공통코드 조회
		ComDefaultCodeVO vo = new ComDefaultCodeVO();
		vo.setCodeId("COM022");
		List<?> code = cmmUseService.selectCmmCodeDetail(vo);
		model.addAttribute("pwhtCdList", code);

		return "tpssm/com/init/SearchIdPassword";
	}

	/**
	 * 아이디를 찾는다.
	 * @param vo - 이름, 이메일주소, 사용자구분이 담긴 LoginVO
	 * @return result - 아이디
	 * @exception Exception
	 */
	@RequestMapping(value = "/cmm/init/searchId.do")
	public String searchId(@ModelAttribute("loginVO") LoginVO loginVO, ModelMap model) throws Exception {

		if (loginVO == null || loginVO.getName() == null || loginVO.getName().equals("") && loginVO.getEmail() == null || loginVO.getEmail().equals("")
				&& loginVO.getUserSe() == null || loginVO.getUserSe().equals("")) {
			return "tpssm/com/init/error/error";
		}

		// 1. 아이디 찾기
		loginVO.setName(loginVO.getName().replaceAll(" ", ""));
		LoginVO resultVO = loginService.searchId(loginVO);

		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {

			model.addAttribute("resultInfo", "아이디는 " + resultVO.getId() + " 입니다.");
			return "tpssm/com/init/SearchResultIdPassword";
		} else {
			model.addAttribute("resultInfo", egovMessageSource.getMessage("fail.common.idsearch"));
			return "tpssm/com/init/SearchResultIdPassword";
		}
	}

	/**
	 * 비밀번호를 찾는다.
	 * @param vo - 아이디, 이름, 이메일주소, 비밀번호 힌트, 비밀번호 정답, 사용자구분이 담긴 LoginVO
	 * @return result - 임시비밀번호전송결과
	 * @exception Exception
	 */
	@RequestMapping(value = "/cmm/init/searchPassword.do")
	public String searchPassword(@ModelAttribute("loginVO") LoginVO loginVO, ModelMap model) throws Exception {

		//KISA 보안약점 조치 (2018-10-29, 윤창원)
		if (loginVO == null || loginVO.getId() == null || loginVO.getId().equals("") && loginVO.getName() == null || "".equals(loginVO.getName()) && loginVO.getEmail() == null
				|| loginVO.getEmail().equals("") && loginVO.getPasswordHint() == null || "".equals(loginVO.getPasswordHint()) && loginVO.getPasswordCnsr() == null
				|| "".equals(loginVO.getPasswordCnsr()) && loginVO.getUserSe() == null || "".equals(loginVO.getUserSe())) {
			return "tpssm/com/init/error/error";
		}

		// 1. 비밀번호 찾기
		boolean result = loginService.searchPassword(loginVO);

		// 2. 결과 리턴
		if (result) {
			model.addAttribute("resultInfo", "임시 비밀번호를 발송하였습니다.");
			return "tpssm/com/init/SearchResultIdPassword";
		} else {
			model.addAttribute("resultInfo", egovMessageSource.getMessage("fail.common.pwsearch"));
			return "tpssm/com/init/SearchResultIdPassword";
		}
	}

	/**
	 * 일반회원 약관확인
	 * @param model 화면모델
	 * @return EgovStplatCnfirm
	 * @throws Exception
	 */
	@RequestMapping("/cmm/init/EgovStplatCnfirmMber.do")
	public String sbscrbCnfirmMber(ModelMap model) throws Exception {

		//일반회원용 약관 아이디 설정
		String stplatId = "STPLAT_0000000000001";
		//회원가입유형 설정-일반회원
		String sbscrbTy = "USR01";
		//약관정보 조회
		List<?> stplatList = mberManageService.selectStplat(stplatId);
		model.addAttribute("stplatList", stplatList); //약관정보 포함
		model.addAttribute("sbscrbTy", sbscrbTy); //회원가입유형 포함

		return "tpssm/com/init/EgovStplatCnfirm";
	}
	
	/**
	 * 기업회원 약관확인 화면을 조회한다.
	 * @param model 화면모델
	 * @return EgovStplatCnfirm
	 * @throws Exception
	 */
	@RequestMapping("/cmm/init/EgovStplatCnfirmEntrprs.do")
	public String sbscrbEntrprsMber(ModelMap model) throws Exception {

		//기업회원용 약관 아이디 설정
		String stplatId = "STPLAT_0000000000002";
		//회원가입유형 설정-기업회원
		String sbscrbTy = "USR02";
		//약관정보 조회
		List<?> stplatList = entrprsManageService.selectStplat(stplatId);
		model.addAttribute("stplatList", stplatList); //약관정보포함
		model.addAttribute("sbscrbTy", sbscrbTy); //회원가입유형포함

		return "tpssm/com/init/EgovStplatCnfirm";
	}
	
	/**
	 * 실명인증확인화면 호출(주민번호)
	 * @param model 모델
	 * @return EgovStplatCnfirm
	 * @exception Exception
	 */
	@RequestMapping("/cmm/init/EgovRlnmCnfirm.do")
	public String rlnmCnfirm(ModelMap model, @RequestParam Map<String, Object> commandMap) throws Exception {

		model.addAttribute("ihidnum", (String) commandMap.get("ihidnum"));			//주민번호
		model.addAttribute("realname", (String) commandMap.get("realname"));		//사용자이름
		model.addAttribute("sbscrbTy", (String) commandMap.get("sbscrbTy"));		//사용자유형
		model.addAttribute("nextUrlName", (String) commandMap.get("nextUrlName"));	//다음단계버튼명(이동할 URL에 따른)
		String nextUrl = (String) commandMap.get("nextUrl");
		if ( nextUrl == null ) nextUrl = "";
		model.addAttribute("nextUrl", nextUrl);										//다음단계로 이동할 URL
		String result = "";

//		if ("".equals((String) commandMap.get("ihidnum"))) {
//			result = "info.user.rlnmCnfirm";
//			model.addAttribute("result", result); 	//실명확인 결과
//			return "egovframework/com/sec/rnc/EgovRlnmCnfirm";
//		}
//
//		try {
//			result = rlnmManageService.rlnmCnfirm((String) commandMap.get("ihidnum"), (String) commandMap.get("realname"), (String) commandMap.get("sbscrbTy"));
//		} finally {
//			model.addAttribute("result_tmp", result + "__" + result.substring(0, 2));
//			if (result.substring(0, 2).equals("00")) {
//				result = "success.user.rlnmCnfirm";
//			} else if (result.substring(0, 2).equals("01")) {
//				result = "fail.user.rlnmCnfirm";
//			} else {
//				result = "fail.user.connectFail";
//			}
//			model.addAttribute("result", result);		//실명확인 결과
//
//		}
		
		// 화이트 리스트 처리
		// whitelist목록에 있는 경우 결과가 true, 결과가 false인경우 FAIL처리
		if (nextUrlWhitelist.contains(nextUrl) == false) {
			LOGGER.debug("nextUrl WhiteList Error! Please check whitelist!");
			nextUrl="tpssm/com/init/error/error";
		}
		
		// 안전한 경로 문자열로 조치
		nextUrl = EgovWebUtil.filePathBlackList(nextUrl);

		
//		return "egovframework/com/sec/rnc/EgovRlnmCnfirm";
		// 실명인증기능 미탑재로 바로 회원가입 페이지로 이동.
		return "forward:" + nextUrl;
	}
	
	/**
	 * 일반회원가입신청 등록화면으로 이동한다.
	 * @param userSearchVO 검색조건
	 * @param mberManageVO 일반회원가입신청정보
	 * @param commandMap 파라메터전달용 commandMap
	 * @param model 화면모델
	 * @return EgovMberSbscrb
	 * @throws Exception
	 */
	@RequestMapping("/cmm/init/EgovMberSbscrbView.do")
	public String sbscrbMberView(@ModelAttribute("userSearchVO") UserDefaultVO userSearchVO, @ModelAttribute("mberManageVO") MberManageVO mberManageVO,
			@RequestParam Map<String, Object> commandMap, ModelMap model) throws Exception {

		ComDefaultCodeVO vo = new ComDefaultCodeVO();

		//패스워드힌트목록을 코드정보로부터 조회
		vo.setCodeId("COM022");
		List<?> passwordHint_result = cmmUseService.selectCmmCodeDetail(vo);
		//성별구분코드를 코드정보로부터 조회
		vo.setCodeId("COM014");
		List<?> sexdstnCode_result = cmmUseService.selectCmmCodeDetail(vo);

		model.addAttribute("passwordHint_result", passwordHint_result); //패스워트힌트목록
		model.addAttribute("sexdstnCode_result", sexdstnCode_result); //성별구분코드목록
		if (!"".equals(commandMap.get("realname"))) {
			model.addAttribute("mberNm", commandMap.get("realname")); //실명인증된 이름 - 주민번호 인증
			model.addAttribute("ihidnum", commandMap.get("ihidnum")); //실명인증된 주민등록번호 - 주민번호 인증
		}
		if (!"".equals(commandMap.get("realName"))) {
			model.addAttribute("mberNm", commandMap.get("realName")); //실명인증된 이름 - ipin인증
		}

		mberManageVO.setMberSttus("DEFAULT");

		return "tpssm/com/init/EgovMberSbscrb";
	}

	/**
	 * 일반회원가입신청등록처리후로그인화면으로 이동한다.
	 * @param mberManageVO 일반회원가입신청정보
	 * @return loginUsr.do
	 * @throws Exception
	 */
	@RequestMapping("/cmm/init/EgovMberSbscrb.do")
	public String sbscrbMber(@ModelAttribute("mberManageVO") MberManageVO mberManageVO) throws Exception {

		//가입상태 초기화
		mberManageVO.setMberSttus("A");
		//그룹정보 초기화
		//mberManageVO.setGroupId("1");
		//일반회원가입신청 등록시 일반회원등록기능을 사용하여 등록한다.
		mberManageService.insertMber(mberManageVO);
		return "tpssm/com/init/LoginUsr";
	}
	
	/**
	 * 기업회원가입신청 등록화면으로 이동한다.
	 * @param userSearchVO 검색조건정보
	 * @param entrprsManageVO 기업회원초기화정보
	 * @param commandMap 파라메터전송 commandMap
	 * @param model 화면모델
	 * @return EgovEntrprsMberSbscrb
	 * @throws Exception
	 */
	@RequestMapping("/cmm/init/EgovEntrprsMberSbscrbView.do")
	public String sbscrbEntrprsMberView(@ModelAttribute("userSearchVO") UserDefaultVO userSearchVO, @ModelAttribute("entrprsManageVO") EntrprsManageVO entrprsManageVO,
			@RequestParam Map<String, Object> commandMap, ModelMap model) throws Exception {

		ComDefaultCodeVO vo = new ComDefaultCodeVO();

		//패스워드힌트목록을 코드정보로부터 조회
		vo.setCodeId("COM022");
		List<?> passwordHint_result = cmmUseService.selectCmmCodeDetail(vo);
		//성별구분코드를 코드정보로부터 조회
		vo.setCodeId("COM014");
		List<?> sexdstnCode_result = cmmUseService.selectCmmCodeDetail(vo);
		//기업구분코드를 코드정보로부터 조회 - COM026
		vo.setCodeId("COM026");
		List<?> entrprsSeCode_result = cmmUseService.selectCmmCodeDetail(vo);
		//업종코드를 코드정보로부터 조회 - COM027
		vo.setCodeId("COM027");
		List<?> indutyCode_result = cmmUseService.selectCmmCodeDetail(vo);

		model.addAttribute("passwordHint_result", passwordHint_result); //패스워트힌트목록
		model.addAttribute("sexdstnCode_result", sexdstnCode_result); //성별구분코드목록
		model.addAttribute("entrprsSeCode_result", entrprsSeCode_result); //기업구분코드 목록
		model.addAttribute("indutyCode_result", indutyCode_result); //업종코드목록
		if (!"".equals(commandMap.get("realname"))) {
			model.addAttribute("applcntNm", commandMap.get("realname")); //실명인증된 이름 - 주민번호인증
			model.addAttribute("applcntIhidnum", commandMap.get("ihidnum")); //실명인증된 주민등록번호 - 주민번호 인증
		}
		if (!"".equals(commandMap.get("realName"))) {
			model.addAttribute("applcntNm", commandMap.get("realName")); //실명인증된 이름 - ipin인증
		}
		entrprsManageVO.setEntrprsMberSttus("DEFAULT");

		return "tpssm/com/init/EgovEntrprsMberSbscrb";
	}

	/**
	 * 기업회원가입신청 등록처리후 로그인화면으로 이동한다.
	 * @param entrprsManageVO 기업회원가입신청정보
	 * @return forward:/uat/uia/egovLoginUsr.do
	 * @throws Exception
	 */
	@RequestMapping("/cmm/init/EgovEntrprsMberSbscrb.do")
	public String sbscrbEntrprsMber(@ModelAttribute("entrprsManageVO") EntrprsManageVO entrprsManageVO) throws Exception {

		//가입상태 초기화
		entrprsManageVO.setEntrprsMberSttus("A");
		//그룹정보 초기화
		//entrprsManageVO.setGroupId("1");
		//기업회원가입신청 등록시 기업회원등록기능을 사용하여 등록한다.
		entrprsManageService.insertEntrprsmber(entrprsManageVO);
		return "tpssm/com/init/LoginUsr";
	}
	
	/**
	 * 입력한 사용자아이디의 중복확인화면 이동
	 * @param model 화면모델
	 * @return uss/umt/EgovIdDplctCnfirm
	 * @throws Exception
	 */
	@RequestMapping(value = "/cmm/init/EgovIdDplctCnfirmView.do")
	public String checkIdDplct(ModelMap model) throws Exception {

		// 미인증 사용자에 대한 보안처리
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if (!isAuthenticated) {
			return "tpssm/com/init/index";
		}

		model.addAttribute("checkId", "");
		model.addAttribute("usedCnt", "-1");
		return "tpssm/com/init/EgovIdDplctCnfirm";
	}
	
	/**
	 * 입력한 사용자아이디의 중복여부를 체크하여 사용가능여부를 확인
	 * @param commandMap 파라메터전달용 commandMap
	 * @param model 화면모델
	 * @return uss/umt/EgovIdDplctCnfirm
	 * @throws Exception
	 */
	@RequestMapping(value = "/cmm/init/EgovIdDplctCnfirmAjax.do")
	public ModelAndView checkIdDplctAjax(@RequestParam Map<String, Object> commandMap) throws Exception {

    	ModelAndView modelAndView = new ModelAndView();
    	modelAndView.setViewName("jsonView");

		String checkId = (String) commandMap.get("checkId");
		//checkId = new String(checkId.getBytes("ISO-8859-1"), "UTF-8");

		int usedCnt = userManageService.checkIdDplct(checkId);
		modelAndView.addObject("usedCnt", usedCnt);
		modelAndView.addObject("checkId", checkId);

		return modelAndView;
	}
	
    /**
	 * 권한제한 화면 이동
	 * @return String
	 * @exception Exception
	 */
    @RequestMapping("/cmm/init/accessDenied.do")
    public String accessDenied()
            throws Exception {
        return "tpssm/com/init/error/accessDenied";
    }
    
    /**
	 * 모달조회
	 * @return String
	 * @exception Exception
	 */
    @RequestMapping(value="/cmm/init/EgovModal.do")
    public String selectUtlJsonInquire()  throws Exception {
        return "tpssm/com/init/EgovModal";
    }
    
    /**
	 * validato rule dynamic Javascript
	 */
	@RequestMapping("/cmm/init/validator.do")
	public String validate(){
		return "tpssm/com/init/validator";
	}
	
    /**
	 * JSP 호출작업만 처리하는 공통 함수
	 */
	@RequestMapping(value="/cmm/init/EgovPageLink.do")
	public String moveToPage(@RequestParam("link") String linkPage){
		String link = linkPage;
		link = link.replace(";", "");
		link = link.replace(".", "");
		
		// service 사용하여 리턴할 결과값 처리하는 부분은 생략하고 단순 페이지 링크만 처리함
		if (linkPage==null || linkPage.equals("")){
			link="tpssm/com/init/error/error";
		}
		
		// 화이트 리스트 처리
		// whitelist목록에 있는 경우 결과가 true, 결과가 false인경우 FAIL처리
		if (egovWhitelist.contains(linkPage) == false) {
			LOGGER.debug("Page Link WhiteList Error! Please check whitelist!");
			link="tpssm/com/init/error/erro";
		}
		
		// 안전한 경로 문자열로 조치
		link = EgovWebUtil.filePathBlackList(link);
		
		return link;
	}
}