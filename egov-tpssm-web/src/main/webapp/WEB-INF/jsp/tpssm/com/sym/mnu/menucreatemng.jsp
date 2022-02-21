<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comSymMnuMcm.menuManageVO.title"/></c:set>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
    <title>${pageTitle}<spring:message code="title.list" /></title>
    <link href="<c:url value="/css/egovframework/com/cmm/jqueryui.css"/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/modules/tui-grid/dist/tui-grid.min.css' />" rel="stylesheet" type="text/css">
    <link href="<c:url value="/css/egovframework/com/com.css"/>" rel="stylesheet" type="text/css">
    <link href="<c:url value="/css/egovframework/com/button.css"/>" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jqueryui.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/modules/tui-grid/dist/tui-grid.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/js/tpssm/com/com.js'/>" ></script>
    <script type="text/javascript" src="<c:url value="/cmm/init/validator.do"/>"></script>
    <validator:javascript formName="menuManageVO" staticJavascript="false" xhtml="true" cdata="false"/>
</head>
<script type="text/javascript">
<!--
let gridAuth;
let gridMenu;

/* ********************************************************
 * document.ready 처리 함수
 ******************************************************** */
$(document).ready(function() 
{
	//1.권한목록
	gridAuth = new tui.Grid({
		el: document.getElementById('gridAuth'),
		bodyHeight: 450, scrollX: false,
		rowHeaders: ['rowNum'],
		data: setReadData("<c:url value='/cmm/authmngList.do'/>"),
		columns: 
		[
			{header:'<spring:message code="comCopSecRam.authorManageVO.authorCode" />', name:'authorCode', align:'center'},
			{header:'<spring:message code="comCopSecRam.authorManageVO.authorNm" />',   name:'authorNm',   align:'center'},
			{header:'<spring:message code="comCopSecRam.authorManageVO.authorDc" />',   name:'authorDc',   align:'center'}
		]
	});
	
	//2.권한목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridAuth);
	
	//3.권한목록의 Click 이벤트
	gridAuth.on('click', function (ev) {
		setMenuCreatList(gridAuth.getRow(ev.rowKey));
	});
	
	//4.트리메뉴목록
	gridMenu = new tui.Grid({
		el: document.getElementById('gridUpperMenu'),
		bodyHeight: 450, scrollX: false,
		rowHeaders: ['checkbox'],
		treeColumnOptions: {
			name: 'menuNm',
			useIcon: true,
			useCascadingCheckbox: true
		},
		columns: 
		[
			{header:'<spring:message code="comSymMnuMcm.menuManageVO.menuNm" />', name:'menuNm'}
		]
	});
	
	//5.권한목록의 데이터검색
	searchAuthList();
});

/* ********************************************************
 * 권한목록의 데이터검색 처리 함수
 ******************************************************** */
function searchAuthList() {
	const params = {"searchKeyword":$("#searchKeyword").val()};
	gridAuth.readData(1, params);
	gridAuth.on('beforeRequest', function(ev) {
		gridMenu.clear();
	});
}

/* ********************************************************
 * 메뉴생성 목록의 체크 처리 함수
 ******************************************************** */
function setMenuCreatList(data) {
	if (data == null) { return; }
	$.ajax({
		url : "<c:url value='/cmm/selectMenuTreeList.do'/>",
		method :"POST",
		data : {menuNo:0, authorCode:isNullToString(data["authorCode"])},
		dataType : "JSON",
		success : function(result){
			if (result['menuManageVOList'] != null) {
				getHierarchyMenuList(result['menuManageVOList'][0]);
				gridMenu.resetData(result['menuManageVOList']);
				gridMenu.expandAll();
			}
		} 
	});
}

/* ********************************************************
 * 메뉴생성등록 처리 함수
 ******************************************************** */
function insertMenuCreatList() {
	if(gridAuth.getFocusedCell()['rowKey']==null) { return; }
	
	var sendDate = "";
	var sendUrl = "";
	if (gridMenu.getCheckedRows()[0] == null) {
		sendData = JSON.stringify({ "authorCode" : gridAuth.getRow(gridAuth.getFocusedCell()['rowKey'])['authorCode'] });
		sendUrl = "<c:url value='/cmm/menucreateUpdate.do'/>";
	} else {
		sendData = JSON.stringify(gridMenu.getCheckedRows());
		sendUrl = "<c:url value='/cmm/menucreateInsert.do'/>";
	}
	
	if(confirm("<spring:message code="common.save.msg" />")){
		$.ajax({
			url : sendUrl,
			method :"POST",
			data : sendData,
			dataType : "JSON",
			contentType : "application/json",
			success : function(result) {
				confirm("<spring:message code='success.common.save' />");
			},
			error : function(xhr, status) {
				confirm("<spring:message code='fail.common.save' />");
			},
			complete : function() {
				$('.btn_b.save').css('pointer-events','auto');
			}
		});
	}
}
-->
</script>
<div id="border" style="width:730px">

<form:form commandName="menuManageVO" name="menuManageVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comSymMnuMcm.menuManageVO.pageTop.title" /></h1>
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />">
		<ul>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="comCopSecRam.authorManageVO.authorNm" /> : </div></li>
			<li>
				<input class="s_input" name="searchKeyword" id="searchKeyword" type="text" size="35" 
					title="<spring:message code="title.search" /> <spring:message code="input.input" />" 
					value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<span class="btn_b" onclick="searchAuthList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
				<span class="btn_b save" onclick="insertMenuCreatList();">
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
		<col style="width:318px" />
	</colgroup>
	<tr>
		<td style="vertical-align:top">
			<div id="gridAuth"></div>
		</td>
		<td style="vertical-align:top">
			<div id="gridUpperMenu"></div>
		</td>
	</tr>
	</table>
</body>
</div>
</form:form>
</div>
</html>