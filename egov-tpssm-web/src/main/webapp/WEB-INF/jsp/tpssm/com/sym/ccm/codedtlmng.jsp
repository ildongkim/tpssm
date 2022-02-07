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
    <link href="<c:url value="/css/egovframework/com/button.css"/>" rel="stylesheet" type="text/css">
    <link href="<c:url value="/css/egovframework/com/cmm/jqueryui.css"/>" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jqueryui.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/modules/tui-grid/dist/tui-grid.min.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/js/tpssm/com/com.js'/>" ></script>
    <script type="text/javascript" src="<c:url value="/cmm/init/validator.do"/>"></script>
    <validator:javascript formName="cmmnDetailCodeVO" staticJavascript="false" xhtml="true" cdata="false"/>
</head>
<script type="text/javascript">

let gridCode;
let gridCodeDtl;

/* ********************************************************
 * document.ready 처리 함수
 ******************************************************** */
$(document).ready(function() 
{
	//1.코드목록
	gridCode = new tui.Grid({
		el: document.getElementById('gridCode'), // Container element
		scrollX: false,
		rowHeaders: ['rowNum'],
		bodyHeight: 200,
		columns: 
		[
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeId" />',   name:'codeId', align:'center'},
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeIdNm" />',   name:'codeIdNm', align:'center'},
		]
	});
	
	//2.코드목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridCode);
	
	//3.코드목록의 Click 이벤트
	gridCode.on('click', function (ev) {
		searchCodeDtlList(gridCode.getValue(ev.rowKey, 'codeId'));
		setCodeList(gridCode.getRow(ev.rowKey), 1);
	});
	
	//4.상세코드목록
	gridCodeDtl = new tui.Grid({
		el: document.getElementById('gridCodeDtl'), // Container element
		scrollX: false,
		rowHeaders: ['rowNum'],
		bodyHeight: 200,
		columns: 
		[
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.code" />',   name:'code', align:'center'},
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeNm" />', name: 'codeNm', align:'center'},
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.useAt" />', name: 'useAt', align:'center'},
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.lastUpdtPnttm" />',   name:'lastUpdtPnttm', align:'center'}
		]
	});

	//5.상세코드목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridCodeDtl);
	
	//6.상세코드목록의 Click 이벤트
	gridCodeDtl.on('click', function (ev) {
		setCodeList(gridCodeDtl.getRow(ev.rowKey), 1);
	});
	
});

/* ********************************************************
 * 코드목록의 데이터검색 처리 함수
 ******************************************************** */
function searchCodeList() {
	let codeId = "";
	$.ajax({
		url : "<c:url value='/cmm/cmmnCodeList.do'/>",
		method :"POST",
		data : {"codeId":codeId},
		dataType : "JSON",
		success : function(result){
			initlCodeList(1);
			if (result['cmmnCodeVOList'] != null) {
				gridCode.resetData(result['cmmnCodeVOList']);
			}
		} 
	});
}

/* ********************************************************
 * 코드목록의 데이터검색 처리 함수
 ******************************************************** */
function searchCodeDtlList(codeId) {
	$.ajax({
		url : "<c:url value='/cmm/cmmnCodeDtlList.do'/>",
		method :"POST",
		data : {"codeId":codeId},
		dataType : "JSON",
		success : function(result){
			if (result['cmmnDetailCodeVOList'] != null) {
				gridCodeDtl.resetData(result['cmmnDetailCodeVOList']);
			}
		} 
	});
}

/* ********************************************************
 * 폼입력 정보의 초기화 처리 함수
 ******************************************************** */
function initlCodeList(unit) {
	switch (unit) {
	case 1:
		$('.wTable input').val('');
		$('.wTable select').val('Y');
		$('.wTable textarea').val('');
		gridCode.clear();
		gridCodeDtl.clear();		
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
 * 폼입력 정보의 데이터바인딩 처리 함수
 ******************************************************** */
function setCodeList(data, unit) {
	if (data != null) {
		document.cmmnDetailCodeVO.codeId.value=isNullToString(data["codeId"]);
		document.cmmnDetailCodeVO.codeIdNm.value=isNullToString(data["codeIdNm"]);
		document.cmmnDetailCodeVO.code.value=isNullToString(data["code"]);
		document.cmmnDetailCodeVO.codeNm.value=isNullToString(data["codeNm"]);
		document.cmmnDetailCodeVO.codeDc.value=isNullToString(data["codeDc"]);
		document.cmmnDetailCodeVO.useAt.value=isNullToString(data["useAt"]);
		
		switch (unit) {
		case 1: 
			initlCodeList();
			$('.btn_b.new').css('pointer-events','auto');
			$('.btn_b.new').css('background','#4688d2');
			break;
		case 2: 
			$('.btn_b.new').css('pointer-events','none');
			$('.btn_b.new').css('background','#cccccc');
			$('.btn_b.save').css('pointer-events','auto');
			$('.btn_b.save').css('background','#4688d2');
			document.cmmnDetailCodeVO.codeNm.readOnly=false;
			document.cmmnDetailCodeVO.codeDc.readOnly=false;
			$(".wTable select").css('background','#ffffff');
			$(".wTable select").prop("disabled",false);
			break;
		}
	}
}
</script>
<div id="border" style="width:730px">

<form:form commandName="cmmnDetailCodeVO" name="cmmnDetailCodeVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comSymCcmCde.cmmnDetailCodeVO.pageTop.title" /></h1><!-- 공통상세코드 -->
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />"><!-- 이 레이아웃은 하단 정보를 대한 검색 정보로 구성되어 있습니다. -->
		<ul>
			<li>
				<select name="searchCondition1" title="<spring:message code="title.searchCondition" />">
					<option selected value=''><spring:message code="input.select" /></option><!-- 선택하세요 -->
					<option value="1"  <c:if test="${searchVO.searchCondition == '1'}">selected="selected"</c:if> ><spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeId" /></option><!-- 코드ID -->
					<option value="2"  <c:if test="${searchVO.searchCondition == '2'}">selected="selected"</c:if> ><spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeIdNm" /></option><!-- 코드ID명 -->
				</select>
				<input class="s_input" name="searchKeyword1" type="text"  size="35" title="<spring:message code="title.search" /> <spring:message code="input.input" />" value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<select name="searchCondition2" title="<spring:message code="title.searchCondition" />">
					<option selected value=''><spring:message code="input.select" /></option><!-- 선택하세요 -->
					<option value="1"  <c:if test="${searchVO.searchCondition == '1'}">selected="selected"</c:if> ><spring:message code="comSymCcmCde.cmmnDetailCodeVO.code" /></option><!-- 상세코드 -->
					<option value="2"  <c:if test="${searchVO.searchCondition == '2'}">selected="selected"</c:if> ><spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeNm" /></option><!-- 상세코드명 -->
				</select>
				<input class="s_input" name="searchKeyword2" type="text"  size="35" title="<spring:message code="title.search" /> <spring:message code="input.input" />" value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<span class="btn_b" onclick="searchCodeList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
			</li>
			<li>
				<span class="btn_b new" onclick="newCodeList(document.forms[0]); return false;">
					<a href="#"><spring:message code="title.new" /></a>
				</span>
				<span class="btn_b save" onclick="insertCodeList(document.forms[0]); return false;">
					<a href="#"><spring:message code="button.save" /></a>
				</span>
				<span class="btn_b save" onclick="deleteCodeList(document.forms[0]); return false;">
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
			<div id="gridCode"></div>
		</td>
		<td style="vertical-align:top">
			<div id="gridCodeDtl"></div>
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
				<th><spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeId" /> <span class="pilsu">*</span></th><!-- 코드ID -->
				<td class="left">
				<input name="codeId" type="text" value=""  maxlength="10" title="<spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeId" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeIdNm" /> <span class="pilsu">*</span></th><!-- 코드ID명 -->
				<td class="left">
				<input name="codeIdNm" type="text" value=""  maxlength="10" title="<spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeIdNm" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCde.cmmnDetailCodeVO.code" /> <span class="pilsu">*</span></th><!-- 상세코드 -->
				<td class="left">
				<input name="code" type="text" value=""  maxlength="10" title="<spring:message code="comSymCcmCde.cmmnDetailCodeVO.code" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeNm" /> <span class="pilsu">*</span></th><!-- 상세코드 -->
				<td class="left">
				<input name="codeNm" type="text" value=""  maxlength="10" title="<spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeNm" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeDc" /></th><!-- 코드ID설명 -->
				<td width="70%" class="left">
				<textarea name="codeDc" class="textarea"  cols="45" rows="8"  style="width:350px;" title="<spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeDc" />"></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCde.cmmnDetailCodeVO.useAt" /></th><!-- 사용여부 -->
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