package egovframework.com.sym.prm.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.sym.prm.service.EgovProgrmManageService;
import egovframework.com.sym.prm.service.ProgrmManageDtlVO;
import egovframework.com.sym.prm.service.ProgrmManageVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

/**
 * 프로그램목록관리 및 프로그램변경관리에 관한 비즈니스 구현 클래스를 정의한다.
 * @author 개발환경 개발팀 이용
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.03.20  이  용          최초 생성
 *
 * </pre>
 */
@Service("progrmManageService")
public class EgovProgrmManageServiceImpl extends EgovAbstractServiceImpl implements EgovProgrmManageService {

	@Resource(name="progrmManageDAO")
    private ProgrmManageDAO progrmManageDAO;

	/**
	 * 프로그램관리 목록을 조회
	 * @param vo ComDefaultVO
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<?> selectProgrmMngList(ComDefaultVO vo) throws Exception {
   		return progrmManageDAO.selectProgrmMngList(vo);
	}
	
	/**
	 * 프로그램 목록을 조회
	 * @param vo ComDefaultVO
	 * @return List
	 * @exception Exception
	 */
	@Override
	public List<?> selectProgrmList(ComDefaultVO vo) throws Exception {
   		return progrmManageDAO.selectProgrmList(vo);
	}
	
	/**
	 * 프로그램목록 총건수를 조회한다.
	 * @param vo  ComDefaultVO
	 * @return Integer
	 * @exception Exception
	 */
    @Override
	public int selectProgrmListTotCnt(ComDefaultVO vo) throws Exception {
        return progrmManageDAO.selectProgrmListTotCnt(vo);
	}
    
	/**
	 * 프로그램 정보를 등록
	 * @param vo ProgrmManageVO
	 * @exception Exception
	 */
	@Override
	public void insertProgrm(ProgrmManageVO vo) throws Exception {
    	progrmManageDAO.insertProgrm(vo);
	}

	/**
	 * 프로그램 정보를 삭제
	 * @param vo ProgrmManageVO
	 * @exception Exception
	 */
	@Override
	public void deleteProgrm(ProgrmManageVO vo) throws Exception {
    	progrmManageDAO.deleteProgrm(vo);
	}

}