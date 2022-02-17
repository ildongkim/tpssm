package egovframework.com.sec.ram.service;

import java.util.List;

import egovframework.com.cmm.ComDefaultVO;

/**
 * 권한관리에 관한 서비스 인터페이스 클래스를 정의한다.
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

public interface EgovAuthorManageService {
	
	/**
	 * 개별사용자에게 할당된 권한리스트 조회
	 * @param authorManageVO AuthorManageVO
	 * @return List<AuthorManageVO>
	 * @exception Exception
	 */
	public List<?> selectAuthorList(ComDefaultVO searchVO) throws Exception;
	
	/**
	 * 사용자의 시스테접근권한를 화면에서 입력하여 입력항목의 정합성을 체크하고 데이터베이스에 저장
	 * @param authorManage AuthorManage
	 * @exception Exception
	 */
	public void insertAuthor(AuthorManage authorManage) throws Exception;
	
	/**
	 * 시스템 사용자중 불필요한 시스템권한정보를 화면에 조회하여 데이터베이스에서 삭제
	 * @param authorManage AuthorManage
	 * @exception Exception
	 */
	public void deleteAuthor(AuthorManage authorManage) throws Exception;
	
}
