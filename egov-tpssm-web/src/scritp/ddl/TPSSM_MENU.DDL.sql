/* 프로그램목록 */
CREATE TABLE COMTNPROGRMLIST
(
	PROGRM_FILE_NM        VARCHAR(180)  NOT NULL ,
	PROGRM_STRE_PATH      VARCHAR(300)  NOT NULL ,
	PROGRM_KOREAN_NM      VARCHAR(180)  NULL ,
	PROGRM_DC             VARCHAR(600)  NULL ,
	URL                   VARCHAR(300)  NOT NULL ,
	USE_AT                CHAR(1)  NULL ,
	FRST_REGIST_PNTTM     DATETIME  NULL ,
	FRST_REGISTER_ID      VARCHAR(60)  NULL ,
	LAST_UPDT_PNTTM       DATETIME  NULL ,
	LAST_UPDUSR_ID        VARCHAR(60)  NULL ,
CONSTRAINT  COMTNPROGRMLIST_PK PRIMARY KEY (PROGRM_FILE_NM)
);

/* 프로그램변경내역 */
CREATE TABLE COMTHPROGRMCHANGEDTLS
(
	PROGRM_FILE_NM        VARCHAR(180)  NOT NULL ,
	REQUST_NO             NUMERIC(10)  NOT NULL ,
	RQESTER_ID            VARCHAR(60)  NOT NULL ,
	CHANGE_REQUST_CN      VARCHAR(3000)  NULL ,
	REQUST_PROCESS_CN     STRING  NULL ,
	OPETR_ID              VARCHAR(60)  NULL ,
	PROCESS_STTUS_CODE    VARCHAR(45)  NOT NULL ,
	PROCESS_DE            CHAR(20)  NULL ,
	RQESTDE               CHAR(20)  NULL ,
	REQUST_SJ             VARCHAR(180)  NOT NULL ,
CONSTRAINT  COMTHPROGRMCHANGEDTLS_PK PRIMARY KEY (PROGRM_FILE_NM,REQUST_NO)
);

/* 메뉴정보 */
CREATE TABLE COMTNMENUINFO
(
	MENU_NM               VARCHAR(180)  NOT NULL ,
	PROGRM_FILE_NM        VARCHAR(180)  NOT NULL ,
	MENU_NO               NUMERIC(20)  NOT NULL ,
	UPPER_MENU_NO         NUMERIC(20)  NULL ,
	MENU_ORDR             NUMERIC(5)  NOT NULL ,
	MENU_DC               VARCHAR(750)  NULL ,
	RELATE_IMAGE_PATH     VARCHAR(300)  NULL ,
	RELATE_IMAGE_NM       VARCHAR(180)  NULL ,
	USE_AT                CHAR(1)  NULL ,
	FRST_REGIST_PNTTM     DATETIME  NULL ,
	FRST_REGISTER_ID      VARCHAR(60)  NULL ,
	LAST_UPDT_PNTTM       DATETIME  NULL ,
	LAST_UPDUSR_ID        VARCHAR(60)  NULL ,
CONSTRAINT  COMTNMENUINFO_PK PRIMARY KEY (MENU_NO)
);

/* 사이트맵 */
CREATE TABLE COMTNSITEMAP
(
	MAPNG_CREAT_ID        VARCHAR(90)  NOT NULL ,
	CREATR_ID             VARCHAR(60)  NOT NULL ,
	MAPNG_FILE_NM         VARCHAR(180)  NOT NULL ,
	MAPNG_FILE_PATH       VARCHAR(300)  NOT NULL ,
CONSTRAINT  COMTNSITEMAP_PK PRIMARY KEY (MAPNG_CREAT_ID)
);

/* 메뉴생성내역 */
CREATE TABLE COMTNMENUCREATDTLS
(
	MENU_NO               NUMERIC(20)  NOT NULL ,
	AUTHOR_CODE           VARCHAR(90)  NOT NULL ,
	MAPNG_CREAT_ID        VARCHAR(90)  NULL ,
CONSTRAINT  COMTNMENUCREATDTLS_PK PRIMARY KEY (MENU_NO,AUTHOR_CODE)
);