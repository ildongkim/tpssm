package egovframework.com.cop.bbs.service;

import java.util.List;

import egovframework.com.cmm.ComDefaultVO;

public interface EgovBBSMasterService {

	public List<?> selectBBSMasterInfs(ComDefaultVO searchVO);
	
	public void insertBBSMasterInf(BoardMaster boardMaster) throws Exception;
	
	public void deleteBBSMasterInf(BoardMaster boardMaster) throws Exception;

}
