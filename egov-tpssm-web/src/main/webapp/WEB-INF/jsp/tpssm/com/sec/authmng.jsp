<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comCopSecRam.authorManageVO.title"/></c:set>
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
    <validator:javascript formName="authorManageVO" staticJavascript="false" xhtml="true" cdata="false"/>
</head>
<script type="text/javascript">
<!--
let gridAuth;

/* ********************************************************
 * document.ready 처리 함수
 ******************************************************** */
$(document).ready(function() 
{
	//1.권한목록
	gridAuth = new tui.Grid({
		el: document.getElementById('gridAuth'),
		bodyHeight: 200, scrollX: false,
		rowHeaders: ['rowNum'],
		data: setReadData("<c:url value='/cmm/authmngList.do'/>"),
		columns: 
		[
			{header:'<spring:message code="comCopSecRam.authorManageVO.authorCode" />',     name:'authorCode',    width:220},
			{header:'<spring:message code="comCopSecRam.authorManageVO.authorNm" />',       name:'authorNm',      width:220},
			{header:'<spring:message code="comCopSecRam.authorManageVO.useAt" />',          name:'useAt',         align:'center'},
			{header:'<spring:message code="comCopSecRam.authorManageVO.authorCreatDe" />',  name:'authorCreatDe', width:120, align:'center'}
		]
	});
	
	//2.권한목록의 이벤트 설정
	setGridEvent(gridAuth);
	
	//3.권한목록의 Click 이벤트
	gridAuth.on('click', function (ev) {
		setViewAuthClick(); //화면처리
		setAuthList(gridAuth.getRow(ev.rowKey));
	});
	
	//5.권한목록의 데이터검색
	searchAuthList();
});

/* ********************************************************
 * 권한목록의 데이터검색 처리 함수
 ******************************************************** */
function searchAuthList() {
	//화면처리
	setViewSearch();
	const params = {"searchKeyword":$("#searchKeyword").val()};
	gridAuth.readData(1, params);
}

/* ********************************************************
 * 권한등록 처리 함수
 ******************************************************** */
function insertAuthList(form) {
	if(confirm("<spring:message code="common.save.msg" />")){
		if(validateAuthorManageVO(form)){
			$('.btn_b.save').css('pointer-events','none');
			$.ajax({
				url : "<c:url value='/cmm/authmngInsert.do'/>",
				method :"POST",
				data : $("#authorManageVO").serialize(),
				dataType : "JSON",
				success : function(result) {
					if (result['message'] != null) {
						confirm(result['message']);	
					} else {
						searchAuthList();
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
 * 권한 삭제 처리 함수
 ******************************************************** */
function deleteAuthList(form) {
	if(confirm("<spring:message code="common.delete.msg" />")){
		$('.btn_b.save').css('pointer-events','none');
		$.ajax({
			url : "<c:url value='/cmm/authmngDelete.do'/>",
			method :"POST",
			data : $("#authorManageVO").serialize(),
			dataType : "JSON",
			success : function(result) {
				if (result['message'] != null) {
					confirm(result['message']);	
				} else {
					searchAuthList();
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
 * 폼입력 정보의 데이터바인딩 처리 함수
 ******************************************************** */
function setAuthList(data) {
	if (data != null) {
		document.authorManageVO.authorCode.value=isNullToString(data["authorCode"]);
		document.authorManageVO.authorNm.value=isNullToString(data["authorNm"]);
		document.authorManageVO.authorDc.value=isNullToString(data["authorDc"]);
		document.authorManageVO.useAt.value=isNullToString(data["useAt"]);
	}
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
	$("#authorCode").attr("readonly",false);
	
	//그리드초기화처리
	gridAuth.clear();
}

/* ********************************************************
 * 권한목록 클릭 후 화면처리
 ******************************************************** */
function setViewAuthClick() {
	
	//입력항목비활성처리
	$("#authorCode").attr("readonly",true);
}

/* ********************************************************
 * 신규버튼클릭 후 화면처리
 ******************************************************** */
function setViewNewClick() {
	
	//입력값공백처리
	$('.wTable input').val('');
	$('.wTable select').val('Y');
	$('.wTable textarea').val('');
	
	//입력항목비활성처리
	$("#authorCode").attr("readonly",false);
}

-->
</script>
<div id="border" style="width:730px">

<form:form commandName="authorManageVO" name="authorManageVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comCopSecRam.authorManageVO.pageTop.title" /></h1>
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />">
		<ul>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="comCopSecRam.authorManageVO.authorNm" /> : </div></li>
			<li>
				<input class="s_input" name="searchKeyword" id="searchKeyword" type="text"  size="35" 
					title="<spring:message code="title.search" /> <spring:message code="input.input" />" 
					value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<span class="btn_b" onclick="searchAuthList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>
			</li>
			<li>
				<span class="btn_b new" onclick="setViewNewClick();">
					<a href="#"><spring:message code="title.new" /></a>
				</span>
				<span class="btn_b save" onclick="insertAuthList(document.forms[0]); return false;">
					<a href="#"><spring:message code="button.save" /></a>
				</span>
				<span class="btn_b save" onclick="deleteAuthList(document.forms[0]); return false;">
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
		<col style="" />
	</colgroup>
	<tr>
		<td style="vertical-align:top">
			<div id="gridAuth"></div>
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
				<th><spring:message code="comCopSecRam.authorManageVO.authorCode" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="authorCode" type="text" maxlength="10" title="<spring:message code="comCopSecRam.authorManageVO.authorCode" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopSecRam.authorManageVO.authorNm" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="authorNm" type="text" maxlength="10" title="<spring:message code="comCopSecRam.authorManageVO.authorNm" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopSecRam.authorManageVO.authorDc" /></th>
				<td width="70%" class="left">
				<textarea name="authorDc" class="textarea" cols="45" rows="8" style="width:350px;" title="<spring:message code="comCopSecRam.authorManageVO.authorDc" />"></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopSecRam.authorManageVO.useAt" /></th>
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