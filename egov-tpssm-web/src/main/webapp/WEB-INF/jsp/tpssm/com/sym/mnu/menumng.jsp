<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comSymMnuMpm.menuManageVO.title"/></c:set>
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
		el: document.getElementById('gridUpperMenu'),
		bodyHeight: 200, scrollX: false,
		treeColumnOptions: {
			name: 'menuNm',
			useIcon: true,
			useCascadingCheckbox: true
		},
		columns: 
		[
			{header:'<spring:message code="comSymMnuMpm.menuManageVO.menuNm" />', name:'menuNm'}
		]
	});
	
	//2.트리메뉴목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridMenu);
	
	//3.트리메뉴목록의 Click 이벤트
	gridMenu.on('click', function (ev) {
		setViewMenuClick(); //화면처리
		searchMenuMngList(gridMenu.getValue(ev.rowKey, 'menuNo'));
		setBindData(gridMenu.getRow(ev.rowKey));
		gridMenuRowKey = ev.rowKey;
	});
	
	//4.하위메뉴목록
	gridMenuDtl = new tui.Grid({
		el: document.getElementById('gridMenuDtl'),
		bodyHeight: 200, scrollX: false,
		rowHeaders: ['rowNum'],
		data: setReadData("<c:url value='/cmm/menumngList.do'/>"),
		columns: 
		[
			{header:'<spring:message code="comSymMnuMpm.menuManageVO.menuNm" />',        name:'menuNm',       align:'center'},
			{header:'<spring:message code="comSymMnuMpm.menuManageVO.progrmFileNm" />',  name:'progrmFileNm', align:'center'},
			{header:'<spring:message code="comSymMnuMpm.menuManageVO.menuOrdr" />',      name:'menuOrdr',     align:'center'},
			{header:'<spring:message code="comSymMnuMpm.menuManageVO.useAt" />',         name:'useAt',        align:'center'}
		]
	});
	
	//5.하위메뉴목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridMenuDtl);
	
	//6.하위메뉴목록의 Click 이벤트
	gridMenuDtl.on('click', function (ev) {
		if (ev.rowKey >= '0') {
			setViewMenuDtlClick(); //화면처리
		}
		setBindData(gridMenuDtl.getRow(ev.rowKey));
	});
	
	//7.트리메뉴목록의 데이터검색
	searchMenuList();
	
	//8.화면초기화처리
	setViewInit();
	
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
	//화면처리
	setViewSearch();
	
	$.ajax({
		url : "<c:url value='/cmm/selectMenuTreeList.do'/>",
		method :"POST",
		data : {upperMenuId:9999999},
		dataType : "JSON",
		success : function(result){
			if (result['menuManageVOList'] != null) {
				getHierarchyMenuList(result['menuManageVOList']);
				gridMenu.resetData(result['menuManageVOList']);
				gridMenu.expandAll();
			}
		} 
	});
}

/* ********************************************************
 * 하위메뉴목록의 데이터검색 처리 함수
 ******************************************************** */
function searchMenuMngList(menuNo) {
	if (menuNo == null) { return; }
	const params = {"menuNo":menuNo};
	gridMenuDtl.readData(1, params);
	gridMenuDtl.on('beforeRequest', function(ev) {
		gridMenuDtl.clear();
	});
	gridMenuDtl.on('successResponse', function(ev) {
		//gridMenuDtl.focusAt(gridMenuDtl.getRowCount()-1,1,true);
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
							searchMenuMngList(result['upperMenuId']);
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
						searchMenuMngList(result['upperMenuId']);
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
	//화면처리
	setViewNewClick();
	
	$.ajax({
		url : "<c:url value='/cmm/menumngCreate.do'/>",
		method :"POST",
		data : $("#menuManageVO").serialize(),
		dataType : "JSON",
		success : function(result) {
			setBindData(result['menulist'][0]);
		},
		error : function(xhr, status) {
			confirm("<spring:message code='fail.common.insert' />");
		}
	});
}

/* ********************************************************
 * 화면초기화처리
 ******************************************************** */
function setViewInit() {
	
	//입력값공백처리
	$('.wTable input').val('');
	$('.wTable select').val('Y');
	$('.wTable textarea').val('');
	
	//입력항목비활성처리
	$(".wTable input").attr("readonly",true);
	$(".wTable textarea").attr("readonly",true);
	$(".wTable select").attr("readonly",true);
	$(".wTable select").prop("disabled",true);
	
	//버튼비활성처리
	$('.btn_b.save').css('pointer-events','none');
	$('.btn_b.save').css('background','#cccccc');
	
	//그리드초기화처리
	gridMenu.clear();
	gridMenuDtl.clear();
}

/* ********************************************************
 * 조회 후 화면처리
 ******************************************************** */
function setViewSearch()  {
	
	//입력값공백처리
	$('.wTable input').val('');
	$('.wTable select').val('Y');
	$('.wTable textarea').val('');
	
	//입력항목비활성처리
	$(".wTable input").attr("readonly",true);
	$(".wTable textarea").attr("readonly",true);
	$(".wTable select").attr("readonly",true);
	$(".wTable select").prop("disabled",true);
	
	//버튼처리
	$('.btn_b.new').css('pointer-events','none');
	$('.btn_b.new').css('background','#cccccc');	
	$('.btn_b.save').css('pointer-events','none');
	$('.btn_b.save').css('background','#cccccc');
	
	//그리드초기화처리
	gridMenuDtl.clear();
}

/* ********************************************************
 * 메뉴트리클릭 후 화면처리
 ******************************************************** */
function setViewMenuClick() {
	
	//입력항목비활성처리
	$(".wTable input").attr("readonly",true);
	$(".wTable textarea").attr("readonly",true);
	$(".wTable select").attr("readonly",true);
	$(".wTable select").prop("disabled",true);
	
	//버튼처리
	$('.btn_b.new').css('pointer-events','auto');
	$('.btn_b.new').css('background','#4688d2');
	$('.btn_b.save').css('pointer-events','none');
	$('.btn_b.save').css('background','#cccccc');
}

/* ********************************************************
 * 하위메뉴클릭 후 화면처리
 ******************************************************** */
function setViewMenuDtlClick() {
	
	//입력항목활성처리
	document.menuManageVO.menuNm.readOnly=false;
	document.menuManageVO.menuOrdr.readOnly=false;
	document.menuManageVO.menuDc.readOnly=false;
	$(".wTable select").css('background','#ffffff');
	$(".wTable select").prop("disabled",false);	
	
	//버튼처리
	$('.btn_b.new').css('pointer-events','none');
	$('.btn_b.new').css('background','#cccccc');
	$('.btn_b.save').css('pointer-events','auto');
	$('.btn_b.save').css('background','#4688d2');
}

/* ********************************************************
 * 신규버튼클릭 후 화면처리
 ******************************************************** */
function setViewNewClick()  {
	
	//입력항목활성처리
	document.menuManageVO.menuNm.readOnly=false;
	document.menuManageVO.menuOrdr.readOnly=false;
	document.menuManageVO.menuDc.readOnly=false;
	$(".wTable select").css('background','#ffffff');
	$(".wTable select").prop("disabled",false);	
	
	//버튼처리
	$('.btn_b.new').css('pointer-events','none');
	$('.btn_b.new').css('background','#cccccc');
	$('.btn_b.save').css('pointer-events','auto');
	$('.btn_b.save').css('background','#4688d2');
}
-->
</script>
<div id="border" style="width:730px">

<form:form commandName="menuManageVO" name="menuManageVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comSymMnuMpm.menuManageVO.pageTop.title" /></h1>
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />">
		<ul>
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
				<th><spring:message code="comSymMnuMpm.menuManageVO.upperMenuId" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="upperMenuId" type="text" maxlength="10" title="<spring:message code="comSymMnuMpm.menuManageVO.upperMenuId" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuManageVO.menuNo" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="menuNo" type="text" maxlength="10" title="<spring:message code="comSymMnuMpm.menuManageVO.menuNo" />" style="width:68px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuManageVO.menuNm" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="menuNm" type="text" size="30" maxlength="30" title="<spring:message code="comSymMnuMpm.menuManageVO.menuNm" />">
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuManageVO.menuOrdr" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="menuOrdr" type="text" maxlength="10" title="<spring:message code="comSymMnuMpm.menuManageVO.menuOrdr" />" style="width:68px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuManageVO.progrmFileNm" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="progrmFileNm" type="text" size="30" maxlength="60" title="<spring:message code="comSymMnuMpm.menuManageVO.progrmFileNm" />" style="width:190px"/>
				<a id="popupProgrmFileNm" href="#" target="_blank" 
					title="<spring:message code="comSymMnuMpm.menuManageVO.progrmFileNm" />" 
					style="selector-dummy:expression(this.hideFocus=false);"><img src="<c:url value='/images/egovframework/com/cmm/icon/search2.gif' />"
					alt='' width="15" height="15" />(<spring:message code="comSymMnuMpm.menuManageVO.progrmFileNm" />)</a>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuManageVO.menuDc" /></th>
				<td width="70%" class="left">
				<textarea name="menuDc" class="textarea" cols="45" rows="8" style="width:350px;" title="<spring:message code="comSymMnuMpm.menuManageVO.menuDc" />"></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymMnuMpm.menuManageVO.useAt" /></th>
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