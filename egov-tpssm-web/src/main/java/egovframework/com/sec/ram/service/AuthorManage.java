package egovframework.com.sec.ram.service;

import egovframework.com.cmm.ComDefaultVO;

/**
 * 권한관리에 대한 model 클래스를 정의한다.
 * @author 공통서비스 개발팀 이문준
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.03.20  이문준          최초 생성
 *
 * </pre>
 */

public class AuthorManage extends ComDefaultVO {

	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 권한관리
	 */	
	private AuthorManage authorManage;
	/**
	 * 권한코드
	 */
	private String authorCode;
	/**
	 * 권한등록일자
	 */
	private String authorCreatDe;
	/**
	 * 권한코드설명
	 */
	private String authorDc;
	/**
	 * 권한 명
	 */
	private String authorNm;
	/**
	 * 사용여부
	 */
    private String useAt = "";	
    /**
     * 등록자ID
     */
    private String registerId;
    
	/**
	 * authorManage attribute 를 리턴한다.
	 * @return AuthorManage
	 */
	public AuthorManage getAuthorManage() {
		return authorManage;
	}
	/**
	 * authorManage attribute 값을 설정한다.
	 * @param authorManage AuthorManage 
	 */
	public void setAuthorManage(AuthorManage authorManage) {
		this.authorManage = authorManage;
	}
	/**
	 * authorCode attribute 를 리턴한다.
	 * @return String
	 */
	public String getAuthorCode() {
		return authorCode;
	}
	/**
	 * authorCode attribute 값을 설정한다.
	 * @param authorCode String 
	 */
	public void setAuthorCode(String authorCode) {
		this.authorCode = authorCode;
	}
	/**
	 * authorCreatDe attribute 를 리턴한다.
	 * @return String
	 */
	public String getAuthorCreatDe() {
		return authorCreatDe;
	}
	/**
	 * authorCreatDe attribute 값을 설정한다.
	 * @param authorCreatDe String 
	 */
	public void setAuthorCreatDe(String authorCreatDe) {
		this.authorCreatDe = authorCreatDe;
	}
	/**
	 * authorDc attribute 를 리턴한다.
	 * @return String
	 */
	public String getAuthorDc() {
		return authorDc;
	}
	/**
	 * authorDc attribute 값을 설정한다.
	 * @param authorDc String 
	 */
	public void setAuthorDc(String authorDc) {
		this.authorDc = authorDc;
	}
	/**
	 * authorNm attribute 를 리턴한다.
	 * @return String
	 */
	public String getAuthorNm() {
		return authorNm;
	}
	/**
	 * authorNm attribute 값을 설정한다.
	 * @param authorNm String 
	 */
	public void setAuthorNm(String authorNm) {
		this.authorNm = authorNm;
	}
	/**
	 * useAt attribute 를 리턴한다.
	 * @return String
	 */
	public String getUseAt() {
		return useAt;
	}
	/**
	 * useAt attribute 값을 설정한다.
	 * @param useAt String
	 */
	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}	
	/**
	 * registerId attribute 를 리턴한다.
	 * @return String
	 */
	public String getRegisterId() {
		return registerId;
	}
	/**
	 * registerId attribute 값을 설정한다.
	 * @param registerId String
	 */
	public void setRegisterId(String registerId) {
		this.registerId = registerId;
	}
}
