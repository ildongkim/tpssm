/* Sequence 저장테이블 */
CREATE TABLE COMTECOPSEQ
(
	TABLE_NAME            VARCHAR(60)  NOT NULL ,
	NEXT_ID               NUMERIC(30)  NULL ,
CONSTRAINT  COMTECOPSEQ_PK PRIMARY KEY (TABLE_NAME)
);

/* 접속로그 */
CREATE TABLE COMTNLOGINLOG
(
	LOG_ID                CHAR(20)  NOT NULL ,
	CONECT_ID             VARCHAR(60)  NULL ,
	CONECT_IP             VARCHAR(69)  NULL ,
	CONECT_MTHD           CHAR(4)  NULL ,
	ERROR_OCCRRNC_AT      CHAR(1)  NULL ,
	ERROR_CODE            CHAR(3)  NULL ,
	CREAT_DT              DATETIME  NULL ,
CONSTRAINT  COMTNLOGINLOG_PK PRIMARY KEY (LOG_ID)
);

/* 시스템로그 */
CREATE TABLE COMTNSYSLOG
(
	REQUST_ID             VARCHAR(60)  NOT NULL ,
	JOB_SE_CODE           CHAR(3)  NULL ,
	INSTT_CODE            CHAR(7)  NULL ,
	OCCRRNC_DE            DATETIME  NULL ,
	RQESTER_IP            VARCHAR(69)  NULL ,
	RQESTER_ID            VARCHAR(60)  NULL ,
	TRGET_MENU_NM         VARCHAR(765)  NULL ,
	SVC_NM                VARCHAR(765)  NULL ,
	METHOD_NM             VARCHAR(180)  NULL ,
	PROCESS_SE_CODE       CHAR(3)  NULL ,
	PROCESS_CO            NUMERIC(10)  NULL ,
	PROCESS_TIME          VARCHAR(42)  NULL ,
	RSPNS_CODE            CHAR(3)  NULL ,
	ERROR_SE              CHAR(1)  NULL ,
	ERROR_CO              NUMERIC(10)  NULL ,
	ERROR_CODE            CHAR(3)  NULL ,
CONSTRAINT  COMTNSYSLOG_PK PRIMARY KEY (REQUST_ID)
);

/* 시스템로그요약 */
CREATE TABLE COMTSSYSLOGSUMMARY
(
	OCCRRNC_DE            CHAR(8)  NOT NULL ,
	SVC_NM                VARCHAR(300)  NOT NULL ,
	METHOD_NM             VARCHAR(180)  NOT NULL ,
	CREAT_CO              NUMERIC(10)  NULL ,
	UPDT_CO               NUMERIC(10)  NULL ,
	RDCNT                 NUMERIC(10)  NULL ,
	DELETE_CO             NUMERIC(10)  NULL ,
	OUTPT_CO              NUMERIC(10)  NULL ,
	ERROR_CO              NUMERIC(10)  NULL ,
CONSTRAINT  COMTSSYSLOGSUMMARY_PK PRIMARY KEY (OCCRRNC_DE,SVC_NM,METHOD_NM)
);

/* 개인정보조회 로그 */
CREATE TABLE COMTNPRIVACYLOG
(
    REQUST_ID            VARCHAR(20) NOT NULL,
    INQIRE_DT            DATETIME NOT NULL,
    SRVC_NM              VARCHAR(500) NULL,
    INQIRE_INFO          VARCHAR(100) NULL,
    RQESTER_ID           VARCHAR(20) NULL,
    RQESTER_IP           VARCHAR(23) NULL,
CONSTRAINT  REQUST_ID_PK PRIMARY KEY (REQUST_ID)
)
;

/* 사용자로그 */
CREATE TABLE COMTNUSERLOG
(
	OCCRRNC_DE            CHAR(8)  NOT NULL ,
	RQESTER_ID            VARCHAR(60)  NOT NULL ,
	SVC_NM                VARCHAR(765)  NOT NULL ,
	METHOD_NM             VARCHAR(180)  NOT NULL ,
	CREAT_CO              NUMERIC(10)  NULL ,
	UPDT_CO               NUMERIC(10)  NULL ,
	RDCNT                 NUMERIC(10)  NULL ,
	DELETE_CO             NUMERIC(10)  NULL ,
	OUTPT_CO              NUMERIC(10)  NULL ,
	ERROR_CO              NUMERIC(10)  NULL ,
CONSTRAINT  COMTNUSERLOG_PK PRIMARY KEY (OCCRRNC_DE,RQESTER_ID,SVC_NM,METHOD_NM)
);

/* 웹로그 */
CREATE TABLE COMTNWEBLOG
(
	REQUST_ID             VARCHAR(60)  NOT NULL ,
	OCCRRNC_DE            DATETIME  NULL ,
	URL                   VARCHAR(600)  NULL ,
	RQESTER_ID            VARCHAR(60)  NULL ,
	RQESTER_IP            VARCHAR(69)  NULL ,
CONSTRAINT  COMTNWEBLOG_PK PRIMARY KEY (REQUST_ID)
);

/* 웹로그 요약 */
CREATE TABLE COMTSWEBLOGSUMMARY
(
	OCCRRNC_DE            CHAR(8)  NOT NULL ,
	URL                   VARCHAR(600)  NOT NULL ,
	RDCNT                 NUMERIC(10)  NULL ,
CONSTRAINT  COMTSWEBLOGSUMMARY_PK PRIMARY KEY (OCCRRNC_DE,URL)
);