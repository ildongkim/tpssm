package egovframework.com.cop.bbs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.com.cop.bbs.service.BoardMaster;
import egovframework.com.cop.bbs.service.EgovBBSMasterService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("EgovBBSMasterService")
public class EgovBBSMasterServiceImpl extends EgovAbstractServiceImpl implements EgovBBSMasterService {

	@Resource(name = "EgovBBSMasterDAO")
    private EgovBBSMasterDAO egovBBSMasterDao;

    @Resource(name = "egovBBSMstrIdGnrService")
    private EgovIdGnrService idgenService;

	@Override
	public List<?> selectBBSMasterInfs(ComDefaultVO searchVO) {
		List<?> resutl = egovBBSMasterDao.selectBBSMasterInfs(searchVO);
		return resutl;
	}

	@Override
	public void insertBBSMasterInf(BoardMaster boardMaster) throws Exception {
		egovBBSMasterDao.insertBBSMasterInf(boardMaster);
	}
	
	@Override
	public void deleteBBSMasterInf(BoardMaster boardMaster) throws Exception {
		egovBBSMasterDao.deleteBBSMaster(boardMaster);	
	}

}
