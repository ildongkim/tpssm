<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comSecRgm.authgroup.title"/></c:set>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
    <title>${pageTitle}<spring:message code="title.list" /></title>
    <link href="<c:url value='/modules/tui-grid/dist/tui-grid.min.css' />" rel="stylesheet" type="text/css">
    <link href="<c:url value="/css/egovframework/com/com.css"/>" rel="stylesheet" type="text/css">
    <link href="<c:url value="/css/egovframework/com/button.css"/>" rel="stylesheet" type="text/css">
    <link href="<c:url value="/css/egovframework/com/cmm/jqueryui.css"/>" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jqueryui.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/modules/tui-grid/dist/tui-grid.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/js/tpssm/com/com.js'/>" ></script>
    <script type="text/javascript" src="<c:url value="/cmm/init/validator.do"/>"></script>
    <validator:javascript formName="authorGroupVO" staticJavascript="false" xhtml="true" cdata="false"/>
</head>
<script type="text/javascript">
<!--
let gridUser;

/* ********************************************************
 * document.ready 처리 함수
 ******************************************************** */
$(document).ready(function() 
{
	//1.사용자목록
	gridAuthMber = new tui.Grid({
		el: document.getElementById('gridAuthMber'), // Container element
		scrollX: false,
		bodyHeight: 450,
		rowHeaders: ['rowNum'],
		columns: 
		[
			{header:'<spring:message code="comCopSecRgm.list.userId" />',     name:'userId',    align:'center'},
			{header:'<spring:message code="comCopSecRgm.list.userNm" />',     name:'userNm',    align:'center'},
			{header:'<spring:message code="comCopSecRgm.list.mberTyNm" />',   name:'mberTyNm',  align:'center'}
		]
	});
	
	//2.권한목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridAuthMber);
	
	//3.권한목록의 Click 이벤트
	gridAuthMber.on('click', function (ev) {
		setAuthMberList(gridAuthMber.getRow(ev.rowKey));
	});
	
	//4.권한목록
	gridAuth = new tui.Grid({
		el: document.getElementById('gridAuth'), // Container element
		scrollX: false,
		bodyHeight: 450,
		rowHeaders: ['checkbox'],
		columns: 
		[
			{header:'<spring:message code="comCopSecRgm.list.authorNm" />',     name:'authorNm',    align:'center'},
			{header:'<spring:message code="comCopSecRgm.list.authorCode" />',   name:'authorCode',  align:'center'}
		]
	});
	
	//5.사용자 목록의 데이터검색
	searchAuthMberList();
});

/* ********************************************************
 * 사용자 목록의 데이터검색 처리 함수
 ******************************************************** */
function searchAuthMberList() {
	const searchKeyword = "";
	$.ajax({
		url : "<c:url value='/cmm/authMberList.do'/>",
		method :"POST",
		data : {"searchKeyword":searchKeyword},
		dataType : "JSON",
		success : function(result){
			if (result['egovMapList'] != null) {
				gridAuthMber.resetData(result['egovMapList']);
				gridAuth.clear();
			}
		} 
	});
}

/* ********************************************************
 * 권한목록의 데이터검색 처리 함수
 ******************************************************** */
function setAuthMberList(data) {
	if (data == null) { return; }
	$.ajax({
		url : "<c:url value='/cmm/authgrpList.do'/>",
		method :"POST",
		data : {uniqId:isNullToString(data["esntlId"])},
		dataType : "JSON",
		success : function(result){
			if (result['hashMapList'] != null) {
				gridAuth.resetData(result['hashMapList']);
			}
		} 
	});
}

-->
</script>
<div id="border" style="width:730px">

<form:form commandName="authorGroupVO" name="authorGroupVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comCopSecRgm.title" /></h1>
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />"><!-- 이 레이아웃은 하단 정보를 대한 검색 정보로 구성되어 있습니다. -->
		<ul>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="comCopSecRam.list.searchKeywordText" /> : </div></li>
			<li>
				<input class="s_input" name="searchKeyword" type="text"  size="35" title="<spring:message code="title.search" /> <spring:message code="input.input" />" value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<span class="btn_b" onclick="searchAuthMberList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
			</li>
			<li>
				<span class="btn_b save" onclick="insertAuthList(document.forms[0]); return false;">
					<a href="#"><spring:message code="button.save" /></a>
				</span>
			</li>
		</ul>
	</div>
</div>

<div id="main" style="display:">

<body>
    <!-- Page content-->
	<table>
	<colgroup>
		<col style="" />
		<col style="width:310px" />
	</colgroup>
	<tr>
		<td style="vertical-align:top">
			<div id="gridAuthMber"></div>
		</td>
		<td style="vertical-align:top">
			<div id="gridAuth"></div>
		</td>
	</tr>
	</table>
</body>
</div>
</form:form>
</div>
</html>