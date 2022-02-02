<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
    <title>임시출입자 출입신청심의 시스템</title>
    <link href="<c:url value='/modules/tui-grid/dist/tui-grid.min.css' />" rel="stylesheet" type="text/css">
    <link href="<c:url value="/css/egovframework/com/com.css"/>" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/modules/tui-grid/dist/tui-grid.min.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/js/tpssm/com/com.js'/>" ></script>
</head>
<script>
let gridMenu
let gridMenuDtl

$(document).ready(function() {
	gridLoader();
	searchMenuList();
	initlMenuList();
});

function gridLoader()
{
	gridMenu = new tui.Grid({
		el: document.getElementById('gridUpperMenu'), // Container element
		scrollX: false,
		bodyHeight: 200,
		treeColumnOptions: {
			name: 'menuNm',
			useIcon: true,
			useCascadingCheckbox: false
		},
		columns: 
		[
			{header:'<spring:message code="tpssmMnu.menuDtl.menuNm" />',   name:'menuNm'}
		]
	});
	
	//현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridMenu);
	
	gridMenu.on('click', function (ev) {
		searchMenuMngList(gridMenu.getValue(ev.rowKey, 'menuNo'));
		setMenuList(gridMenu.getRow(ev.rowKey), 1);
	});
	
	gridMenuDtl = new tui.Grid({
		el: document.getElementById('gridMenuDtl'), // Container element
		scrollX: false,
		rowHeaders: ['rowNum'],
		bodyHeight: 200,
		columns: 
		[
			{header:'<spring:message code="tpssmMnu.menuDtl.menuNm" />',   name:'menuNm', align:'center'},
			{header:'<spring:message code="tpssmMnu.menuDtl.progrmNm" />', name: 'progrmNm', align:'center'},
			{header:'<spring:message code="tpssmMnu.menuDtl.menuOrdr" />', name: 'menuOrdr', align:'center'},
			{header:'<spring:message code="tpssmMnu.menuDtl.useAt" />', name: 'useAt', align:'center'},
		]
	});
	
	//현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridMenuDtl);
	
	//입력항목에 데이터 바인딩
	gridMenuDtl.on('click', function (ev) {
		setMenuList(gridMenuDtl.getRow(ev.rowKey), 2);
	});
}

function searchMenuList() {
	const menuNo = $("#searchCondition option:selected").val();
	$.ajax({
		url : "<c:url value='/cmm/hierarchyMenulist.do'/>",
		method :"POST",
		data : {"menuNo":menuNo},
		dataType : "JSON",
		success : function(result){
			gridMenu.clear();
			gridMenuDtl.clear();
			if (result['menuManageVOList'] != null) {
				gridMenu.resetData(result['menuManageVOList']);
				gridMenu.expandAll();
			}
		} 
	});
}

function searchMenuMngList(menuNo) {
	$.ajax({
		url : "<c:url value='/cmm/menumanagelist.do'/>",
		method :"POST",
		data : {"menuNo":menuNo},
		dataType : "JSON",
		success : function(result){
			gridMenuDtl.clear();
			if (result['egovMapList'] != null) {
				gridMenuDtl.resetData(result['egovMapList']);
			}			
		} 
	});
}

function initlMenuList() {
	$('.wTable input').val('');
	$(".wTable input").attr("readonly",true);
	$('.wTable textarea').val('');
	$(".wTable textarea").attr("readonly",true);
}

function setMenuList(data, unit) {
	if (data != null) {
		document.menuManageVO.upperMenuId.value=data["upperMenuId"];
		document.menuManageVO.menuNo.value=data["menuNo"];
		document.menuManageVO.menuNm.value=data["menuNm"];
		document.menuManageVO.menuOrdr.value=data["menuOrdr"];
		document.menuManageVO.menuDc.value=data["menuDc"];
		
		switch (unit) {
		case 1: 
			$(".wTable input").attr("readonly",true);
			document.menuManageVO.progrmFileNm.value='';
			break;
		case 2: 
			document.menuManageVO.menuNm.readOnly=false;
			document.menuManageVO.menuOrdr.readOnly=false;
			document.menuManageVO.menuDc.readOnly=false;
			document.menuManageVO.progrmFileNm.value=data["progrmNm"];
			break;
		default:
			$(".wTable input").attr("readonly",true);
			break;
		}
		
	}
}

</script>
<div id="border" style="width:730px">

<form name="menuManageVO" action ="<c:url value='/sym/mnu/mpm/EgovMenuListInsert.do' />" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comSymMnuMpm.menuList.pageTop.title" /></h1><!-- 메뉴 목록 -->
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />"><!-- 이 레이아웃은 하단 정보를 대한 검색 정보로 구성되어 있습니다. -->
		<ul>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="tpssmMnu.menuDtl.upperMenuNm" /> : </div></li><!-- 상위메뉴명 -->
			<li>
				<select name="searchCondition" id="searchCondition" title="<spring:message code="title.searchCondition" />">
					<c:forEach var="menu" items="${upperMenuList}">
			            <option value="<c:out value="${menu.menuNo}"/>"><c:out value="${menu.menuNm}"/></option>
					</c:forEach>
				</select>
				<input type="submit" class="s_btn" value="<spring:message code="button.inquire" />" onclick="searchMenuList(); return false;" title="<spring:message code="title.inquire" /> <spring:message code="input.button" />" /><!-- 조회 -->
			</li>
			<li>
				<span class="btn_b"><a href="<c:url value='/sym/mnu/mpm/EgovMenuListSelect.do'/>" onclick="initlMenuList(); return false;" title="<spring:message code="button.init" />"><spring:message code="button.init" /></a></span><!-- 초기화 -->
				<input class="s_btn" type="submit" value='<spring:message code="button.save" />' title='<spring:message code="button.save" />' onclick="insertMenuList(); return false;" />
				<span class="btn_b"><a href="#LINK" onclick="updateMenuList(); return false;" title='<spring:message code="button.update" />'><spring:message code="button.update" /></a></span>
				<span class="btn_b"><a href="#LINK" onclick="deleteMenuList(); return false;" title='<spring:message code="button.delete" />'><spring:message code="button.delete" /></a></span>
			</li>
		</ul>
	</div>
</div>

<div id="main" style="display:">

<body>
    <!-- Page content-->
	<table>
	<colgroup>
		<col style="width:218px" />
		<col style="" />
	</colgroup>
	<tr>
		<td style="vertical-align:top">
			<div id="gridUpperMenu"></div>
		</td>
		<td style="vertical-align:top">
			<div id="gridMenuDtl"></div>
		</td>
	</tr>
	</table>
	
	<div style="margin-top: 10px">
		<table class="wTable" >
			<colgroup>
				<col style="width:30%" />
				<col style="" />
			</colgroup>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuList.upperMenuId" /> <span class="pilsu">*</span></th><!-- 상위메뉴No -->
				<td class="left">
				<input name="upperMenuId" type="text" value=""  maxlength="10" title="<spring:message code="comSymMnuMpm.menuList.upperMenuId" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuList.menuNo" /> <span class="pilsu">*</span></th><!-- 메뉴No -->
				<td class="left">
				<input name="menuNo" type="text" value=""  maxlength="10" title="<spring:message code="comSymMnuMpm.menuList.menuNo" />" style="width:68px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuList.menuNm" /> <span class="pilsu">*</span></th><!-- 메뉴명 -->
				<td class="left">
				<input name="menuNm" type="text" size="30" value=""  maxlength="30" title="<spring:message code="comSymMnuMpm.menuList.menuNm" />">
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuList.menuOrdr" /> <span class="pilsu">*</span></th><!-- 메뉴순서 -->
				<td class="left">
				<input name="menuOrdr" type="text" value=""  maxlength="10" title="<spring:message code="comSymMnuMpm.menuList.menuOrdr" />" style="width:68px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuList.progrmFileNm" /> <span class="pilsu">*</span></th><!-- 파일명 -->
				<td class="left">
				<input name="progrmFileNm" type="text" size="30" value=""  maxlength="60" title="<spring:message code="comSymMnuMpm.menuList.progrmFileNm" />" style="width:190px"/>
				<a id="popupProgrmFileNm" href="/sym/prm/EgovProgramListSearch.do" target="_blank" title="<spring:message code="comSymMnuMpm.menuList.progrmFileNm" />" style="selector-dummy:expression(this.hideFocus=false);"><img src="<c:url value='/images/egovframework/com/cmm/icon/search2.gif' />"
				alt='' width="15" height="15" />(<spring:message code="comSymMnuMpm.menuList.searchFileNm" />)</a>
				</td>
			</tr>
				<tr>
				<th><spring:message code="comSymMnuMpm.menuList.menuDc" /></th><!-- 메뉴설명 -->
				<td width="70%" class="left">
				<textarea name="menuDc" class="textarea"  cols="45" rows="8"  style="width:350px;" title="<spring:message code="comSymMnuMpm.menuList.menuDc" />"></textarea>
				</td>
			</tr>
		</table>
	</div>
</body>
</form>
</div>
</div>
</html>