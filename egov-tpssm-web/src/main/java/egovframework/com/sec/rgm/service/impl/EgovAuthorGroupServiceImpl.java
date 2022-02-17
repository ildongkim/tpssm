package egovframework.com.sec.rgm.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.sec.rgm.service.AuthorGroupVO;
import egovframework.com.sec.rgm.service.EgovAuthorGroupService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 권한그룹에 관한 ServiceImpl 클래스를 정의한다.
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
 *   2009.03.11  이문준          최초 생성
 *
 * </pre>
 */

@Service("egovAuthorGroupService")
public class EgovAuthorGroupServiceImpl  extends EgovAbstractServiceImpl implements EgovAuthorGroupService {
	
	@Resource(name="authorGroupDAO")
    private AuthorGroupDAO authorGroupDAO;

	/**
	 * 사용자 목록 조회
	 * @param authorGroupVO AuthorGroupVO
	 * @return List<AuthorGroupVO>
	 * @exception Exception
	 */
	public List<?> selectAuthorMberList(ComDefaultVO searchVO) throws Exception{
		return authorGroupDAO.selectAuthorMberList(searchVO);
	}
	
	/**
	 * 그룹별 할당된 권한 목록 조회
	 * @param authorGroupVO AuthorGroupVO
	 * @return List<AuthorGroupVO>
	 * @exception Exception
	 */
	public List<?> selectAuthorGroupList(AuthorGroupVO authorGroupVO) throws Exception{
		return authorGroupDAO.selectAuthorGroupList(authorGroupVO);
	}
	
}