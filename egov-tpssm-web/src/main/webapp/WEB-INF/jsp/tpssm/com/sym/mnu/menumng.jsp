<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comSymMnuMpm.menu.title"/></c:set>
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
let gridMenu;
let gridMenuDtl;
let $dialog;
let gridMenuRowKey;

/* ********************************************************
 * document.ready 처리 함수
 ******************************************************** */
$(document).ready(function() 
{
	//1.트리메뉴목록
	gridMenu = new tui.Grid({
		el: document.getElementById('gridUpperMenu'), // Container element
		scrollX: false,
		bodyHeight: 200,
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
	
	//2.트리메뉴목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridMenu);
	
	//3.트리메뉴목록의 Click 이벤트
	gridMenu.on('click', function (ev) {
		searchMenuMngList(gridMenu.getValue(ev.rowKey, 'menuNo'),'S');
		setMenuList(gridMenu.getRow(ev.rowKey), 1);
		gridMenuRowKey = ev.rowKey;
	});
	
	//4.하위메뉴목록
	gridMenuDtl = new tui.Grid({
		el: document.getElementById('gridMenuDtl'), // Container element
		scrollX: false,
		rowHeaders: ['rowNum'],
		bodyHeight: 200,
		columns: 
		[
			{header:'<spring:message code="tpssmMnu.menuMng.menuNm" />',        name:'menuNm',       align:'center'},
			{header:'<spring:message code="tpssmMnu.menuMng.progrmFileNm" />',  name:'progrmFileNm', align:'center'},
			{header:'<spring:message code="tpssmMnu.menuMng.menuOrdr" />',      name:'menuOrdr',     align:'center'},
			{header:'<spring:message code="tpssmMnu.menuMng.useAt" />',         name:'useAt',        align:'center'}
		]
	});
	
	//5.하위메뉴목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridMenuDtl);
	
	//6.하위메뉴목록의 Click 이벤트
	gridMenuDtl.on('click', function (ev) {
		setMenuList(gridMenuDtl.getRow(ev.rowKey), 2);
	});
	
	//7.트리메뉴목록의 데이터검색
	searchMenuList();
	
	//8.폼입력 정보의 초기화
	initlMenuList(1);
	
	//9.파일검색의 Click 이벤트
	$('#popupProgrmFileNm').click(function (e) {
		e.preventDefault(); //기본클릭 이벤트 방지
		const options = {
			pagetitle : $(this).attr("title"), width: 550, height: 650,
			pageUrl : "<c:url value='/cmm/programListSearch.do'/>"
		};
		settingDialog(options);
	});
});

/* ********************************************************
 * 트리메뉴목록의 데이터검색 처리 함수
 ******************************************************** */
function searchMenuList() {
	const menuNo = $("#searchCondition option:selected").val();
	$.ajax({
		url : "<c:url value='/cmm/hierarchyMenuList.do'/>",
		method :"POST",
		data : {"menuNo":menuNo},
		dataType : "JSON",
		success : function(result){
			initlMenuList(1);
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

/* ********************************************************
 * 폼입력 정보의 데이터바인딩 처리 함수
 ******************************************************** */
function setMenuList(data, unit) {
	if (data != null) {
		document.menuManageVO.upperMenuId.value=isNullToString(data["upperMenuId"]);
		document.menuManageVO.menuNo.value=isNullToString(data["menuNo"]);
		document.menuManageVO.menuNm.value=isNullToString(data["menuNm"]);
		document.menuManageVO.menuOrdr.value=isNullToString(data["menuOrdr"]);
		document.menuManageVO.progrmFileNm.value=isNullToString(data["progrmFileNm"]);
		document.menuManageVO.menuDc.value=isNullToString(data["menuDc"]);
		document.menuManageVO.useAt.value=isNullToString(data["useAt"]);
		
		switch (unit) {
		case 1: 
			initlMenuList();
			$('.btn_b.new').css('pointer-events','auto');
			$('.btn_b.new').css('background','#4688d2');
			break;
		case 2: 
			$('.btn_b.new').css('pointer-events','none');
			$('.btn_b.new').css('background','#cccccc');
			$('.btn_b.save').css('pointer-events','auto');
			$('.btn_b.save').css('background','#4688d2');
			document.menuManageVO.menuNm.readOnly=false;
			document.menuManageVO.menuOrdr.readOnly=false;
			document.menuManageVO.menuDc.readOnly=false;
			$(".wTable select").css('background','#ffffff');
			$(".wTable select").prop("disabled",false);
			break;
		}
	}
}

/* ********************************************************
 * 폼입력 정보의 초기화 처리 함수
 ******************************************************** */
function initlMenuList(unit) {
	switch (unit) {
	case 1:
		$('.wTable input').val('');
		$('.wTable select').val('Y');
		$('.wTable textarea').val('');
		gridMenu.clear();
		gridMenuDtl.clear();		
	default:
		$(".wTable input").attr("readonly",true);
		$(".wTable textarea").attr("readonly",true);
		$(".wTable select").attr("readonly",true);
		$(".wTable select").prop("disabled",true);
		$('.btn_b.new').css('pointer-events','none');
		$('.btn_b.new').css('background','#cccccc');
		$('.btn_b.save').css('pointer-events','none');
		$('.btn_b.save').css('background','#cccccc');
	}
}

/* ********************************************************
 * 하위메뉴목록의 데이터검색 처리 함수
 ******************************************************** */
function searchMenuMngList(menuNo, mode) {
	$.ajax({
		url : "<c:url value='/cmm/menumngList.do'/>",
		method :"POST",
		data : {"menuNo":menuNo},
		dataType : "JSON",
		success : function(result){
			gridMenuDtl.clear();
			if (result['egovMapList'] != null) {
				gridMenuDtl.resetData(result['egovMapList']);
				if (mode == 'D') { gridMenuDtl.focusAt(gridMenuDtl.getRowCount()-1,1,true); }
			}			
		} 
	});
}

/* ********************************************************
 * 메뉴등록 처리 함수
 ******************************************************** */
function insertMenuList(form) {
	if(confirm("<spring:message code="common.save.msg" />")){
		if(validateMenuManageVO(form)){
			$('.btn_b.save').css('pointer-events','none');
			$.ajax({
				url : "<c:url value='/cmm/menumngInsert.do'/>",
				method :"POST",
				data : $("#menuManageVO").serialize(),
				dataType : "JSON",
				success : function(result) {
					if (result['message'] != null) {
						confirm(result['message']);	
					} else {
						if (result['upperMenuId'] != null) {
							searchMenuMngList(result['upperMenuId'], 'I');
						}
					}
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
}

/* ********************************************************
 * 메뉴삭제 처리 함수
 ******************************************************** */
function deleteMenuList(form) {
	if(confirm("<spring:message code="common.delete.msg" />")){
		$('.btn_b.save').css('pointer-events','none');
		$.ajax({
			url : "<c:url value='/cmm/menumngDelete.do'/>",
			method :"POST",
			data : $("#menuManageVO").serialize(),
			dataType : "JSON",
			success : function(result) {
				if (result['message'] != null) {
					confirm(result['message']);	
				} else {
					if (result['upperMenuId'] != null) {
						searchMenuMngList(result['upperMenuId'],'D');
					}
				}
			},
			error : function(xhr, status) {
				confirm("<spring:message code='fail.common.delete' />");
			},
			complete : function() {
				$('.btn_b.save').css('pointer-events','auto');
			}
		});
	}
}

/* ********************************************************
 * 신규메뉴 처리 함수
 ******************************************************** */
function newMenuList() {
	$.ajax({
		url : "<c:url value='/cmm/menumngCreate.do'/>",
		method :"POST",
		data : $("#menuManageVO").serialize(),
		dataType : "JSON",
		success : function(result) {
			setMenuList(result['menulist'][0], 2);
		},
		error : function(xhr, status) {
			confirm("<spring:message code='fail.common.insert' />");
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
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="tpssmMnu.menuMng.upperMenuNm" /> : </div></li><!-- 상위메뉴명 -->
			<li>
				<select name="searchCondition" id="searchCondition" title="<spring:message code="title.searchCondition" />">
					<c:forEach var="menu" items="${upperMenuList}">
			            <option value="<c:out value="${menu.menuNo}"/>"><c:out value="${menu.menuNm}"/></option>
					</c:forEach>
				</select>
				<span class="btn_b" onclick="searchMenuList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
			</li>
			<li>
				<span class="btn_b new" onclick="newMenuList(document.forms[0]); return false;">
					<a href="#"><spring:message code="title.new" /></a>
				</span>
				<span class="btn_b save" onclick="insertMenuList(document.forms[0]); return false;">
					<a href="#"><spring:message code="button.save" /></a>
				</span>
				<span class="btn_b save" onclick="deleteMenuList(document.forms[0]); return false;">
					<a href="#"><spring:message code="button.delete" /></a>
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
				<a id="popupProgrmFileNm" href="#" target="_blank" title="<spring:message code="comSymMnuMpm.menuList.progrmFileNm" />" style="selector-dummy:expression(this.hideFocus=false);"><img src="<c:url value='/images/egovframework/com/cmm/icon/search2.gif' />"
				alt='' width="15" height="15" />(<spring:message code="comSymMnuMpm.menuList.searchFileNm" />)</a>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuList.menuDc" /></th><!-- 메뉴설명 -->
				<td width="70%" class="left">
				<textarea name="menuDc" class="textarea"  cols="45" rows="8"  style="width:350px;" title="<spring:message code="comSymMnuMpm.menuList.menuDc" />"></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuList.useAt" /></th><!-- 사용여부 -->
				<td width="70%" class="left">
				<select name="useAt" title="<spring:message code="input.input" />" >
					<option value="Y"  label="<spring:message code="input.yes" />"/>
					<option value="N"  label="<spring:message code="input.no" />"/>
				</select>
				</td>
			</tr>
		</table>
	</div>
</body>
</div>
</form:form>
</div>
</html>