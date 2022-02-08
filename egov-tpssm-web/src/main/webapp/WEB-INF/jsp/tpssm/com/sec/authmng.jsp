<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comSecRam.auth.title"/></c:set>
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
		el: document.getElementById('gridAuth'), // Container element
		scrollX: false,
		bodyHeight: 200,
		rowHeaders: ['rowNum'],
		columns: 
		[
			{header:'<spring:message code="comCopSecRam.regist.authorCode" />',     name:'authorCode',    align:'center'},
			{header:'<spring:message code="comCopSecRam.regist.authorNm" />',       name:'authorNm',      align:'center'},
			{header:'<spring:message code="comCopSecRam.regist.authorDc" />',       name:'authorDc',      align:'center'},
			{header:'<spring:message code="comCopSecRam.regist.useAt" />',          name:'useAt',         align:'center'},
			{header:'<spring:message code="comCopSecRam.regist.authorCreatDe" />',  name:'authorCreatDe', align:'center'}
		]
	});
	
	//2.권한목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridAuth);
	
	//3.권한목록의 Click 이벤트
	gridAuth.on('click', function (ev) {
		setAuthList(gridAuth.getRow(ev.rowKey), 1);
	});
});

/* ********************************************************
 * 권한목록의 데이터검색 처리 함수
 ******************************************************** */
function searchAuthList() {
	const searchKeyword = "";
	$.ajax({
		url : "<c:url value='/cmm/authmngList.do'/>",
		method :"POST",
		data : {"searchKeyword":searchKeyword},
		dataType : "JSON",
		success : function(result){
			initlAuthList(1);
			if (result['authorManageVOList'] != null) {
				gridAuth.resetData(result['authorManageVOList']);
			}
		} 
	});
}

/* ********************************************************
 * 폼입력 정보의 데이터바인딩 처리 함수
 ******************************************************** */
function setAuthList(data, unit) {
	if (data != null) {
		document.authorManageVO.authorCode.value=isNullToString(data["authorCode"]);
		document.authorManageVO.authorNm.value=isNullToString(data["authorNm"]);
		document.authorManageVO.authorDc.value=isNullToString(data["authorDc"]);
		document.authorManageVO.authorCreatDe.value=isNullToString(data["authorCreatDe"]);
		document.authorManageVO.useAt.value=isNullToString(data["useAt"]);
		
		switch (unit) {
		case 1: 
			initlProgrmList();
			$('.btn_b.new').css('pointer-events','auto');
			$('.btn_b.new').css('background','#4688d2');
			break;
		case 2: 
			$('.btn_b.new').css('pointer-events','none');
			$('.btn_b.new').css('background','#cccccc');
			$('.btn_b.save').css('pointer-events','auto');
			$('.btn_b.save').css('background','#4688d2');
			$(".wTable select").css('background','#ffffff');
			$(".wTable select").prop("disabled",false);
			break;
		}
	}
}

/* ********************************************************
 * 폼입력 정보의 초기화 처리 함수
 ******************************************************** */
function initlAuthList(unit) {
	switch (unit) {
	case 1:
		$('.wTable input').val('');
		$('.wTable select').val('Y');
		$('.wTable textarea').val('');
		gridAuth.clear();
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
-->
</script>
<div id="border" style="width:730px">

<form:form commandName="authorManageVO" name="authorManageVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comCopSecRam.title" /></h1>
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />"><!-- 이 레이아웃은 하단 정보를 대한 검색 정보로 구성되어 있습니다. -->
		<ul>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="comCopSecRam.list.searchKeywordText" /> : </div></li><!-- 권한명 -->
			<li>
				<input class="s_input" name="searchKeyword" type="text"  size="35" title="<spring:message code="title.search" /> <spring:message code="input.input" />" value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<span class="btn_b" onclick="searchAuthList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
			</li>
			<li>
				<span class="btn_b new" onclick="newAuthList(document.forms[0]); return false;">
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
				<th><spring:message code="comCopSecRam.regist.authorCode" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="authorCode" type="text" value=""  maxlength="10" title="<spring:message code="comCopSecRam.regist.authorCode" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopSecRam.regist.authorNm" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="authorNm" type="text" value=""  maxlength="10" title="<spring:message code="comCopSecRam.regist.authorNm" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopSecRam.regist.authorDc" /></th>
				<td width="70%" class="left">
				<textarea name="authorDc" class="textarea"  cols="45" rows="8"  style="width:350px;" title="<spring:message code="comCopSecRam.regist.authorDc" />"></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopSecRam.regist.useAt" /></th>
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