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
    <validator:javascript formName="cmmnCodeVO" staticJavascript="false" xhtml="true" cdata="false"/>
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
			{header:'<spring:message code="comSymCcmCca.cmmnCodeVO.codeId" />',   name:'codeId', align:'center'},
			{header:'<spring:message code="comSymCcmCca.cmmnCodeVO.codeIdNm" />',   name:'codeIdNm', align:'center'},
			{header:'<spring:message code="comSymCcmCca.cmmnCodeVO.useAt" />',   name:'useAt', align:'center'},
			{header:'<spring:message code="comSymCcmCca.cmmnCodeVO.lastUpdtPnttm" />',   name:'lastUpdtPnttm', align:'center'}
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
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.useAt" />', name: 'useAt', align:'center'}
		]
	});

	//5.코드목록의 데이터검색
	searchCodeList();
});

/* ********************************************************
 * 코드목록의 데이터검색 처리 함수
 ******************************************************** */
function searchCodeList() {
	$.ajax({
		url : "<c:url value='/cmm/cmmnCodeList.do'/>",
		method :"POST",
		data : {
				"searchCondition":$("#searchCondition option:selected").val(),
				"searchKeyword":$("#searchKeyword").val(),
			},
		dataType : "JSON",
		success : function(result){
			initlCodeList(2);
			if (result['egovMapList'] != null) {
				gridCode.resetData(result['egovMapList']);
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
			gridCodeDtl.clear();
			if (result['egovMapList'] != null) {
				gridCodeDtl.resetData(result['egovMapList']);
			}
		} 
	});
}

/* ********************************************************
 * 메뉴삭제 처리 함수
 ******************************************************** */
function deleteCodeList(form) {
	if(confirm("<spring:message code="common.delete.msg" />")){
		$('.btn_b.save').css('pointer-events','none');
		$.ajax({
			url : "<c:url value='/cmm/codemngDelete.do'/>",
			method :"POST",
			data : $("#cmmnCodeVO").serialize(),
			dataType : "JSON",
			success : function(result) {
				if (result['message'] != null) {
					confirm(result['message']);	
				} else {
					searchCodeList();
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
 * 폼입력 정보의 초기화 처리 함수
 ******************************************************** */
function initlCodeList(unit) {
	$("#codeId").attr("readonly",true);	
	switch (unit) {
	case 1: //추가
		$("#codeId").attr("readonly",false);
		$('.wTable input').val('');
		$('.wTable select').val('Y');
		$('.wTable textarea').val('');
		break;
	case 2:
		gridCode.clear();
		gridCodeDtl.clear();
		$('.wTable input').val('');
		$('.wTable select').val('Y');
		$('.wTable textarea').val('');
		break;
	}
}

/* ********************************************************
 * 폼입력 정보의 데이터바인딩 처리 함수
 ******************************************************** */
function setCodeList(data, unit) {
	if (data != null) {
		document.cmmnCodeVO.codeId.value=isNullToString(data["codeId"]);
		document.cmmnCodeVO.codeIdNm.value=isNullToString(data["codeIdNm"]);
		document.cmmnCodeVO.codeIdDc.value=isNullToString(data["codeIdDc"]);
		document.cmmnCodeVO.useAt.value=isNullToString(data["useAt"]);
		
		switch (unit) {
		case 1: 
			initlCodeList();
			break;
		case 2: 
			break;
		}
	}
}

/* ********************************************************
 * 공통코드 등록 처리 함수
 ******************************************************** */
function insertCodeList(form) {
	if(confirm("<spring:message code="common.save.msg" />")){
		if(validateCmmnCodeVO(form)){
			$('.btn_b.save').css('pointer-events','none');
			$.ajax({
				url : "<c:url value='/cmm/codemngInsert.do'/>",
				method :"POST",
				data : $("#cmmnCodeVO").serialize(),
				dataType : "JSON",
				success : function(result) {
					if (result['message'] != null) {
						confirm(result['message']);	
					} else {
						searchCodeList();
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
 * 신규코드 처리 함수
 ******************************************************** */
function newCodeList() {
	initlCodeList(1);
}
</script>
<div id="border" style="width:730px">

<form:form commandName="cmmnCodeVO" name="cmmnCodeVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comSymCcmCca.cmmnCodeVO.pageTop.title" /></h1><!-- 공통코드 -->
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />"><!-- 이 레이아웃은 하단 정보를 대한 검색 정보로 구성되어 있습니다. -->
		<ul>
			<li>
				<select name="searchCondition" id="searchCondition" title="<spring:message code="title.searchCondition" />">
					<option value="1"  <c:if test="${searchVO.searchCondition == '1'}">selected="selected"</c:if> ><spring:message code="comSymCcmCca.cmmnCodeVO.codeId" /></option><!-- 코드ID -->
					<option value="2"  <c:if test="${searchVO.searchCondition == '2'}">selected="selected"</c:if> ><spring:message code="comSymCcmCca.cmmnCodeVO.codeIdNm" /></option><!-- 코드ID명 -->
				</select>
				<input class="s_input" name="searchKeyword" id="searchKeyword" type="text"  size="35" title="<spring:message code="title.search" /> <spring:message code="input.input" />" value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
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
		<col style="" />
		<col style="width:310px" />
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
				<th><spring:message code="comSymCcmCca.cmmnCodeVO.codeId" /> <span class="pilsu">*</span></th><!-- 코드ID -->
				<td class="left">
				<input name="codeId" id="codeId" type="text" value=""  maxlength="10" title="<spring:message code="comSymCcmCca.cmmnCodeVO.codeId" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCca.cmmnCodeVO.codeIdNm" /> <span class="pilsu">*</span></th><!-- 코드ID명 -->
				<td class="left">
				<input name="codeIdNm" type="text" value=""  maxlength="10" title="<spring:message code="comSymCcmCca.cmmnCodeVO.codeIdNm" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCca.cmmnCodeVO.codeIdDc" /></th><!-- 코드ID설명 -->
				<td width="70%" class="left">
				<textarea name="codeIdDc" class="textarea"  cols="45" rows="8"  style="width:350px;" title="<spring:message code="comSymCcmCca.cmmnCodeVO.codeIdDc" />"></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCca.cmmnCodeVO.useAt" /></th><!-- 사용여부 -->
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