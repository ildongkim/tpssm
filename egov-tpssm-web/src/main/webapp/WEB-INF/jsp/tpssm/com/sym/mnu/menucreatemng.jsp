<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comSymMnuMcm.menu.title"/></c:set>
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
    <script type="text/javascript" src="<c:url value='/modules/tui-grid/dist/tui-grid.min.js'/>" ></script>
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
		el: document.getElementById('gridAuth'), // Container element
		scrollX: false,
		bodyHeight: 500,
		rowHeaders: ['rowNum'],
		columns: 
		[
			{header:'<spring:message code="comCopSecRam.regist.authorCode" />',     name:'authorCode',    align:'center'},
			{header:'<spring:message code="comCopSecRam.regist.authorNm" />',       name:'authorNm',      align:'center'},
			{header:'<spring:message code="comCopSecRam.regist.authorDc" />',       name:'authorDc',      align:'center'}
		]
	});
	
	//2.권한목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridAuth);
	
	//3.권한목록의 Click 이벤트
	gridAuth.on('click', function (ev) {
		setAuthList(gridAuth.getRow(ev.rowKey), 1);
	});
	
	//4.트리메뉴목록
	gridMenu = new tui.Grid({
		el: document.getElementById('gridUpperMenu'), // Container element
		scrollX: false,
		bodyHeight: 500,
		rowHeaders: ['checkbox'],
		treeColumnOptions: {
			name: 'menuNm',
			useIcon: true,
			useCascadingCheckbox: true
		},
		columns: 
		[
			{header:'<spring:message code="tpssmMnu.menuMng.menuNm" />', name:'menuNm'}
		]
	});
	
	//5.트리메뉴목록의 데이터검색
	searchMenuList();
});

/* ********************************************************
 * 트리메뉴목록의 데이터검색 처리 함수
 ******************************************************** */
function searchMenuList() {
	const menuNo = $("#upperMenu option:selected").val();
	$.ajax({
		url : "<c:url value='/cmm/hierarchyMenuList.do'/>",
		method :"POST",
		data : {"menuNo":menuNo},
		dataType : "JSON",
		success : function(result){
			if (result['menuManageVOList'] != null) {
				const data = result['menuManageVOList'][0];
				let childdata;
				for (key in data) {
					if (key == '_children') {
						for (idx in data[key]) {
							childdata = data[key][idx];
							if (childdata['_children'].length == 0) {
								delete childdata['_children'];
							}
						}
					}
				}
				gridMenu.resetData(result['menuManageVOList']);
				gridMenu.expandAll();
			}
		} 
	});
}
-->
</script>
<div id="border" style="width:730px">

<form:form commandName="menuManageVO" name="menuManageVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comSymMnuMpm.menuList.pageTop.title" /></h1><!-- 메뉴 목록 -->
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />"><!-- 이 레이아웃은 하단 정보를 대한 검색 정보로 구성되어 있습니다. -->
		<ul>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="comCopSecRam.list.searchKeywordText" /> : </div></li>
			<li>
				<input class="s_input" name="searchKeyword" type="text"  size="35" title="<spring:message code="title.search" /> <spring:message code="input.input" />" value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<span class="btn_b" onclick="searchAuthList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
			</li>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="comSymMnuMpm.menuManage.validate.menuNm" /> : </div></li>
			<li>
				<select name="upperMenu" id="upperMenu" title="<spring:message code="title.searchCondition" />">
					<c:forEach var="menu" items="${upperMenuList}">
			            <option value="<c:out value="${menu.menuNo}"/>"><c:out value="${menu.menuNm}"/></option>
					</c:forEach>
				</select>
				<span class="btn_b" onclick="searchMenuList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>
			</li>				
			<li>
				<span class="btn_b save" onclick="insertMenuList(document.forms[0]); return false;">
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