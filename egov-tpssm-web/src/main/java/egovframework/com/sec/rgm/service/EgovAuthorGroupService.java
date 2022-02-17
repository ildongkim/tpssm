package egovframework.com.sec.rgm.service;

import java.util.List;

import egovframework.com.cmm.ComDefaultVO;


/**
 * 권한그룹에 관한 서비스 인터페이스 클래스를 정의한다.
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

public interface EgovAuthorGroupService {

	/**
	 * 사용자 목록 조회
	 * @param authorGroupVO AuthorGroupVO
	 * @return List<AuthorGroupVO>
	 * @exception Exception
	 */
	public List<?> selectAuthorMberList(ComDefaultVO searchVO) throws Exception;
	
	/**
	 * 그룹별 할당된 권한 목록 조회
	 * @param authorGroupVO AuthorGroupVO
	 * @return List<AuthorGroupVO>
	 * @exception Exception
	 */
	public List<?> selectAuthorGroupList(AuthorGroupVO authorGroupVO) throws Exception;	

}