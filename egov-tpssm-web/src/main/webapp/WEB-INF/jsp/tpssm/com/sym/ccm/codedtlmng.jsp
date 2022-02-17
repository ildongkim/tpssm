<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comSymCcmCde.cmmnDetailCodeVO.title"/></c:set>
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
    <validator:javascript formName="cmmnDetailCodeVO" staticJavascript="false" xhtml="true" cdata="false"/>
</head>
<script type="text/javascript">
<!--
let gridCode;
let gridCodeDtl;

/* ********************************************************
 * document.ready 처리 함수
 ******************************************************** */
$(document).ready(function() 
{
	//1.코드목록
	gridCode = new tui.Grid({
		el: document.getElementById('gridCode'),
		bodyHeight: 200, scrollX: false,
		rowHeaders: ['rowNum'],
		data: setReadData("<c:url value='/cmm/cmmnCodeList.do'/>"),
		columns: 
		[
			{header:'<spring:message code="comSymCcmCca.cmmnCodeVO.codeId" />',     name:'codeId',   align:'center'},
			{header:'<spring:message code="comSymCcmCca.cmmnCodeVO.codeIdNm" />',   name:'codeIdNm', align:'center'},
		]
	});
	
	//2.코드목록의 이벤트 설정
	setGridEvent(gridCode);
	
	//3.코드목록의 Click 이벤트
	gridCode.on('click', function (ev) {
		setViewCodeClick(); //화면처리
		searchCodeDtlList(gridCode.getValue(ev.rowKey, 'codeId'));
		setCodeList(gridCode.getRow(ev.rowKey));
	});
	
	//4.상세코드목록
	gridCodeDtl = new tui.Grid({
		el: document.getElementById('gridCodeDtl'),
		bodyHeight: 200, scrollX: false,
		rowHeaders: ['rowNum'],
		data: setReadData("<c:url value='/cmm/cmmnCodeDtlList.do'/>"),
		columns: 
		[
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.code" />',          name:'code',          align:'center'},
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeNm" />',        name:'codeNm',        align:'center'},
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.useAt" />',         name:'useAt',         align:'center'},
			{header:'<spring:message code="comSymCcmCde.cmmnDetailCodeVO.lastUpdtPnttm" />', name:'lastUpdtPnttm', align:'center'}
		]
	});

	//5.상세코드목록의 이벤트 설정
	setGridEvent(gridCodeDtl);
	
	//6.상세코드목록의 Click 이벤트
	gridCodeDtl.on('click', function (ev) {
		if (ev.rowKey >= '0') {
			setViewCodeDtlClick(); //화면처리
		}
		setCodeList(gridCodeDtl.getRow(ev.rowKey));
	});
	
	//7.코드목록의 데이터검색
	searchCodeList();
});

/* ********************************************************
 * 코드목록의 데이터검색 처리 함수
 ******************************************************** */
function searchCodeList() {
	//화면처리
	setViewSearch();
	const params = {
		"searchCondition":$("#searchCondition option:selected").val(),
		"searchKeyword":$("#searchKeyword").val()
	};
	gridCode.readData(1, params);
}

/* ********************************************************
 * 코드목록의 데이터검색 처리 함수
 ******************************************************** */
function searchCodeDtlList(codeId) {
	const params = {"codeId":codeId};
	gridCodeDtl.readData(1, params);
}

/* ********************************************************
 * 공통상세코드 등록 처리 함수
 ******************************************************** */
function insertCodeList(form) {
	if(confirm("<spring:message code="common.save.msg" />")){
		if(validateCmmnDetailCodeVO(form)){
			$('.btn_b.save').css('pointer-events','none');
			$.ajax({
				url : "<c:url value='/cmm/codedtlmngInsert.do'/>",
				method :"POST",
				data : $("#cmmnDetailCodeVO").serialize(),
				dataType : "JSON",
				success : function(result) {
					if (result['message'] != null) {
						confirm(result['message']);	
					} else {
						if (result['codeId'] != null) {
							searchCodeDtlList(result['codeId']);
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
 * 공통상세코드 삭제 처리 함수
 ******************************************************** */
function deleteCodeList(form) {
	if(confirm("<spring:message code="common.delete.msg" />")){
		$('.btn_b.save').css('pointer-events','none');
		$.ajax({
			url : "<c:url value='/cmm/codedtlmngDelete.do'/>",
			method :"POST",
			data : $("#cmmnDetailCodeVO").serialize(),
			dataType : "JSON",
			success : function(result) {
				if (result['message'] != null) {
					confirm(result['message']);	
				} else {
					if (result['codeId'] != null) {
						searchCodeDtlList(result['codeId']);
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
 * 폼입력 정보의 데이터바인딩 처리 함수
 ******************************************************** */
function setCodeList(data) {
	if (data != null) {
		document.cmmnDetailCodeVO.codeId.value=isNullToString(data["codeId"]);
		document.cmmnDetailCodeVO.codeIdNm.value=isNullToString(data["codeIdNm"]);
		document.cmmnDetailCodeVO.code.value=isNullToString(data["code"]);
		document.cmmnDetailCodeVO.codeNm.value=isNullToString(data["codeNm"]);
		document.cmmnDetailCodeVO.codeDc.value=isNullToString(data["codeDc"]);
		document.cmmnDetailCodeVO.useAt.value=isNullToString(data["useAt"]);
	}
}

/* ********************************************************
 * 조회 후 화면처리
 ******************************************************** */
function setViewSearch() {
	
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
	gridCodeDtl.clear();
}

/* ********************************************************
 * 공통코드클릭 후 화면처리
 ******************************************************** */
function setViewCodeClick() {
	
	//입력항목비활성처리
	$(".wTable input").attr("readonly",true);
	$(".wTable textarea").attr("readonly",true);
	$(".wTable select").attr("readonly",true);
	$(".wTable select").prop("disabled",true);
	
	//버튼비활성처리
	$('.btn_b.new').css('pointer-events','auto');
	$('.btn_b.new').css('background','#4688d2');
	$('.btn_b.save').css('pointer-events','none');
	$('.btn_b.save').css('background','#cccccc');
	
	//그리드초기화처리
	gridCodeDtl.clear();
}

/* ********************************************************
 * 신규버튼클릭 후 화면처리
 ******************************************************** */
function setViewNewClick() {
	
	//입력값공백처리
	document.cmmnDetailCodeVO.code.value="";
	document.cmmnDetailCodeVO.codeNm.value="";
	document.cmmnDetailCodeVO.codeDc.value="";
	$('.wTable select').val('Y');
	
	//입력항목활성처리
	document.cmmnDetailCodeVO.code.readOnly=false;
	document.cmmnDetailCodeVO.codeNm.readOnly=false;
	document.cmmnDetailCodeVO.codeDc.readOnly=false;
	$(".wTable select").css('background','#ffffff');
	$(".wTable select").prop("disabled",false);
	
	//버튼활성처리
	$('.btn_b.save').css('pointer-events','auto');
	$('.btn_b.save').css('background','#4688d2');
}

/* ********************************************************
 * 공통상세코드클릭 후 화면처리
 ******************************************************** */
function setViewCodeDtlClick() {
	
	//입력항목비활성처리
	document.cmmnDetailCodeVO.codeNm.readOnly=false;
	document.cmmnDetailCodeVO.codeDc.readOnly=false;
	$(".wTable select").css('background','#ffffff');
	$(".wTable select").prop("disabled",false);
	
	//버튼비활성처리
	$('.btn_b.save').css('pointer-events','auto');
	$('.btn_b.save').css('background','#4688d2');
}

-->
</script>
<div id="border" style="width:730px">

<form:form commandName="cmmnDetailCodeVO" name="cmmnDetailCodeVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comSymCcmCde.cmmnDetailCodeVO.pageTop.title" /></h1>
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />">
		<ul>
			<li>
				<select name="searchCondition" id="searchCondition" title="<spring:message code="title.searchCondition" />">
					<option value="1" <c:if test="${searchVO.searchCondition == '1'}">selected="selected"</c:if> >
						<spring:message code="comSymCcmCca.cmmnCodeVO.codeId" />
					</option>
					<option value="2" <c:if test="${searchVO.searchCondition == '2'}">selected="selected"</c:if> >
						<spring:message code="comSymCcmCca.cmmnCodeVO.codeIdNm" />
					</option>
				</select>
				<input class="s_input" name="searchKeyword" id="searchKeyword" type="text" size="35" 
					title="<spring:message code="title.search" /> <spring:message code="input.input" />" 
					value='<c:out value="${searchVO.searchKeyword}"/>' maxlength="155" >
				<span class="btn_b" onclick="searchCodeList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
			</li>
			<li>
				<span class="btn_b new" onclick="setViewNewClick();">
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
				<th><spring:message code="comSymCcmCca.cmmnCodeVO.codeId" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="codeId" type="text" maxlength="10" title="<spring:message code="comSymCcmCca.cmmnCodeVO.codeId" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCca.cmmnCodeVO.codeIdNm" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="codeIdNm" type="text" maxlength="10" title="<spring:message code="comSymCcmCca.cmmnCodeVO.codeIdNm" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCde.cmmnDetailCodeVO.code" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="code" type="text" maxlength="10" title="<spring:message code="comSymCcmCde.cmmnDetailCodeVO.code" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeNm" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="codeNm" type="text" maxlength="10" title="<spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeNm" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeDc" /></th>
				<td width="70%" class="left">
				<textarea name="codeDc" class="textarea" cols="45" rows="8" style="width:350px;" title="<spring:message code="comSymCcmCde.cmmnDetailCodeVO.codeDc" />"></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymCcmCde.cmmnDetailCodeVO.useAt" /></th>
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