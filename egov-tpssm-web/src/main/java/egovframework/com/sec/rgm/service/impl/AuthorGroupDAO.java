package egovframework.com.sec.rgm.service.impl;

import java.util.Iterator;
import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.sec.rgm.service.AuthorGroup;
import egovframework.com.sec.rgm.service.AuthorGroupVO;

/**
 * 권한그룹에 대한 DAO 클래스를 정의한다.
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

@Repository("authorGroupDAO")
public class AuthorGroupDAO extends EgovComAbstractDAO {

	/**
	 * 사용자 목록 조회
	 * @param authorGroupVO AuthorGroupVO
	 * @return List<AuthorGroupVO>
	 * @exception Exception
	 */
	public List<?> selectAuthorMberList(ComDefaultVO searchVO) throws Exception {
		return list("authorGroupDAO.selectAuthorMberList", searchVO);
	}
	
	/**
	 * 그룹별 할당된 권한 목록 조회
	 * @param authorGroupVO AuthorGroupVO
	 * @return List<AuthorGroupVO>
	 * @exception Exception
	 */
	public List<?> selectAuthorGroupList(AuthorGroupVO authorGroupVO) throws Exception {
		return list("authorGroupDAO.selectAuthorGroupList", authorGroupVO);
	}
	
	/**
	 * 그룹에 권한정보를 할당하여 데이터베이스에 등록
	 * @param authorGroupList List
	 * @exception Exception
	 */
	public void insertAuthorGroup(List<AuthorGroup> authorGroupList) throws Exception {
		Iterator<?> iter = authorGroupList.iterator();
		AuthorGroup authorGroup;
		while (iter.hasNext()) {
			authorGroup = (AuthorGroup) iter.next();
			if ("Y".equals(authorGroup.getRegYn())) {
				insert("authorGroupDAO.insertAuthorGroup", authorGroup);
			} else {
				insert("authorGroupDAO.deleteAuthorGroup", authorGroup);
			}
		}
	}
}