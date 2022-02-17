package egovframework.com.cop.bbs.service;

import java.io.Serializable;

import org.apache.commons.lang3.builder.ToStringBuilder;

/**
 * 게시판 속성 정보를 관리하기 위한 VO  클래스
 * @author 공통서비스개발팀 이삼섭
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.3.12  이삼섭          최초 생성
 *
 * </pre>
 */
@SuppressWarnings("serial")
public class BoardMasterVO extends BoardMaster implements Serializable {
    
    /** 검색시작일 */
    private String searchBgnDe = "";
    
    /** 검색조건 */
    private String searchCnd = "";
    
    /** 검색종료일 */
    private String searchEndDe = "";
    
    /** 검색단어 */
    private String searchWrd = "";
    
    /** 정렬순서(DESC,ASC) */
    private String sortOrdr = "";
    
    /** 검색사용여부 */
    private String searchUseYn = "";

    /** rowNo */
    private int rowNo = 0;

    /** 최초 등록자명 */
    private String frstRegisterNm = "";

    /** 게시판유형 코드명 */
    private String bbsTyCodeNm = "";

    /** 템플릿 명 */
    private String tmplatNm = "";

    /** 최종 수정자명 */
    private String lastUpdusrNm = "";

    /** 권한지정 여부 */
    private String authFlag = "";

    /** 템플릿경로 */
    private String tmplatCours = "";

    /**
     * searchBgnDe attribute를 리턴한다.
     * 
     * @return the searchBgnDe
     */
    public String getSearchBgnDe() {
	return searchBgnDe;
    }

    /**
     * searchBgnDe attribute 값을 설정한다.
     * 
     * @param searchBgnDe
     *            the searchBgnDe to set
     */
    public void setSearchBgnDe(String searchBgnDe) {
	this.searchBgnDe = searchBgnDe;
    }

    /**
     * searchCnd attribute를 리턴한다.
     * 
     * @return the searchCnd
     */
    public String getSearchCnd() {
	return searchCnd;
    }

    /**
     * searchCnd attribute 값을 설정한다.
     * 
     * @param searchCnd
     *            the searchCnd to set
     */
    public void setSearchCnd(String searchCnd) {
	this.searchCnd = searchCnd;
    }

    /**
     * searchEndDe attribute를 리턴한다.
     * 
     * @return the searchEndDe
     */
    public String getSearchEndDe() {
	return searchEndDe;
    }

    /**
     * searchEndDe attribute 값을 설정한다.
     * 
     * @param searchEndDe
     *            the searchEndDe to set
     */
    public void setSearchEndDe(String searchEndDe) {
	this.searchEndDe = searchEndDe;
    }

    /**
     * searchWrd attribute를 리턴한다.
     * 
     * @return the searchWrd
     */
    public String getSearchWrd() {
	return searchWrd;
    }

    /**
     * searchWrd attribute 값을 설정한다.
     * 
     * @param searchWrd
     *            the searchWrd to set
     */
    public void setSearchWrd(String searchWrd) {
	this.searchWrd = searchWrd;
    }

    /**
     * sortOrdr attribute를 리턴한다.
     * 
     * @return the sortOrdr
     */
    public String getSortOrdr() {
	return sortOrdr;
    }

    /**
     * sortOrdr attribute 값을 설정한다.
     * 
     * @param sortOrdr
     *            the sortOrdr to set
     */
    public void setSortOrdr(String sortOrdr) {
	this.sortOrdr = sortOrdr;
    }

    /**
     * searchUseYn attribute를 리턴한다.
     * 
     * @return the searchUseYn
     */
    public String getSearchUseYn() {
	return searchUseYn;
    }

    /**
     * searchUseYn attribute 값을 설정한다.
     * 
     * @param searchUseYn
     *            the searchUseYn to set
     */
    public void setSearchUseYn(String searchUseYn) {
	this.searchUseYn = searchUseYn;
    }

    /**
     * rowNo attribute를 리턴한다.
     * 
     * @return the rowNo
     */
    public int getRowNo() {
	return rowNo;
    }

    /**
     * rowNo attribute 값을 설정한다.
     * 
     * @param rowNo
     *            the rowNo to set
     */
    public void setRowNo(int rowNo) {
	this.rowNo = rowNo;
    }

    /**
     * frstRegisterNm attribute를 리턴한다.
     * 
     * @return the frstRegisterNm
     */
    public String getFrstRegisterNm() {
	return frstRegisterNm;
    }

    /**
     * frstRegisterNm attribute 값을 설정한다.
     * 
     * @param frstRegisterNm
     *            the frstRegisterNm to set
     */
    public void setFrstRegisterNm(String frstRegisterNm) {
	this.frstRegisterNm = frstRegisterNm;
    }

    /**
     * bbsTyCodeNm attribute를 리턴한다.
     * 
     * @return the bbsTyCodeNm
     */
    public String getBbsTyCodeNm() {
	return bbsTyCodeNm;
    }

    /**
     * bbsTyCodeNm attribute 값을 설정한다.
     * 
     * @param bbsTyCodeNm
     *            the bbsTyCodeNm to set
     */
    public void setBbsTyCodeNm(String bbsTyCodeNm) {
	this.bbsTyCodeNm = bbsTyCodeNm;
    }

    /**
     * tmplatNm attribute를 리턴한다.
     * 
     * @return the tmplatNm
     */
    public String getTmplatNm() {
	return tmplatNm;
    }

    /**
     * tmplatNm attribute 값을 설정한다.
     * 
     * @param tmplatNm
     *            the tmplatNm to set
     */
    public void setTmplatNm(String tmplatNm) {
	this.tmplatNm = tmplatNm;
    }

    /**
     * lastUpdusrNm attribute를 리턴한다.
     * 
     * @return the lastUpdusrNm
     */
    public String getLastUpdusrNm() {
	return lastUpdusrNm;
    }

    /**
     * lastUpdusrNm attribute 값을 설정한다.
     * 
     * @param lastUpdusrNm
     *            the lastUpdusrNm to set
     */
    public void setLastUpdusrNm(String lastUpdusrNm) {
	this.lastUpdusrNm = lastUpdusrNm;
    }

    /**
     * authFlag attribute를 리턴한다.
     * 
     * @return the authFlag
     */
    public String getAuthFlag() {
	return authFlag;
    }

    /**
     * authFlag attribute 값을 설정한다.
     * 
     * @param authFlag
     *            the authFlag to set
     */
    public void setAuthFlag(String authFlag) {
	this.authFlag = authFlag;
    }

    /**
     * tmplatCours attribute를 리턴한다.
     * 
     * @return the tmplatCours
     */
    public String getTmplatCours() {
	return tmplatCours;
    }

    /**
     * tmplatCours attribute 값을 설정한다.
     * 
     * @param tmplatCours
     *            the tmplatCours to set
     */
    public void setTmplatCours(String tmplatCours) {
	this.tmplatCours = tmplatCours;
    }

    /**
     * toString 메소드를 대치한다.
     */
    public String toString() {
	return ToStringBuilder.reflectionToString(this);
    }
}
