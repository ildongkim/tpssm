package egovframework.com.cop.bbs.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.cop.bbs.service.BoardMaster;

@Repository("EgovBBSMasterDAO")
public class EgovBBSMasterDAO extends EgovComAbstractDAO {

	public List<?> selectBBSMasterInfs(ComDefaultVO searchVO) {
		return list("BBSMaster.selectBBSMasterList", searchVO);
	}

	public void insertBBSMasterInf(BoardMaster boardMaster) {
		insert("BBSMaster.insertBBSMaster", boardMaster);
	}

	public void deleteBBSMaster(BoardMaster boardMaster) {
		update("BBSMaster.deleteBBSMaster", boardMaster);
	}
}
