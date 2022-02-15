<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comSymPrm.progrm.title"/></c:set>
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
    <validator:javascript formName="progrmManageVO" staticJavascript="false" xhtml="true" cdata="false"/>
</head>
<script type="text/javascript">
<!--
let gridProgrm;

/* ********************************************************
 * document.ready 처리 함수
 ******************************************************** */
$(document).ready(function() 
{
	//1.프로그램목록
	gridProgrm = new tui.Grid({
		el: document.getElementById('gridProgrm'), // Container element
		scrollX: false,
		bodyHeight: 200,
		rowHeaders: ['rowNum'],
		columns: 
		[
			{header:'<spring:message code="comSymPrm.programListManage.programFileName" />',    name:'progrmFileNm',    align:'center'},
			{header:'<spring:message code="comSymPrm.programListManage.programName" />',        name:'progrmKoreanNm',  align:'center'},
			{header:'<spring:message code="comSymPrm.programListManage.ProgramDescription" />', name:'progrmDc',        align:'center'},
			{header:'<spring:message code="comSymPrm.programListManage.url" />',                name:'url',             align:'center'},
			{header:'<spring:message code="comSymPrm.programListManage.useAt" />',              name:'useAt',           align:'center'}
		]
	});
	
	//2.프로그램목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridProgrm);
	
	//3.프로그램목록의 Click 이벤트
	gridProgrm.on('click', function (ev) {
		setViewProgrmClick(); //화면처리
		setProgrmList(gridProgrm.getRow(ev.rowKey));
	});
	
	//4.프로그램목록의 데이터검색
	searchProgrmList();
});

/* ********************************************************
 * 프로그램목록의 데이터검색 처리 함수
 ******************************************************** */
function searchProgrmList() {
	//화면처리
	setViewSearch();
	
	const programFileName = document.progrmManageVO.searchKeyword.value;
	$.ajax({
		url : "<c:url value='/cmm/progrmmngList.do'/>",
		method :"POST",
		data : {"programFileName":programFileName},
		dataType : "JSON",
		success : function(result){
			if (result['egovMapList'] != null) {
				gridProgrm.resetData(result['egovMapList']);
			}
		} 
	});
}

/* ********************************************************
 * 프로그램등록 처리 함수
 ******************************************************** */
function insertProgrmList(form) {
	if(confirm("<spring:message code="common.save.msg" />")){
		if(validateProgrmManageVO(form)){
			$('.btn_b.save').css('pointer-events','none');
			$.ajax({
				url : "<c:url value='/cmm/progrmmngInsert.do'/>",
				method :"POST",
				data : $("#progrmManageVO").serialize(),
				dataType : "JSON",
				success : function(result) {
					if (result['message'] != null) {
						confirm(result['message']);	
					} else {
						searchProgrmList();
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
 * 프로그램 삭제 처리 함수
 ******************************************************** */
function deleteProgrmList(form) {
	if(confirm("<spring:message code="common.delete.msg" />")){
		$('.btn_b.save').css('pointer-events','none');
		$.ajax({
			url : "<c:url value='/cmm/progrmmngDelete.do'/>",
			method :"POST",
			data : $("#progrmManageVO").serialize(),
			dataType : "JSON",
			success : function(result) {
				if (result['message'] != null) {
					confirm(result['message']);	
				} else {
					searchProgrmList();
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
function setProgrmList(data) {
	if (data != null) {
		document.progrmManageVO.progrmFileNm.value=isNullToString(data["progrmFileNm"]);
		document.progrmManageVO.progrmKoreanNm.value=isNullToString(data["progrmKoreanNm"]);
		document.progrmManageVO.progrmDc.value=isNullToString(data["progrmDc"]);
		document.progrmManageVO.URL.value=isNullToString(data["url"]);
		document.progrmManageVO.useAt.value=isNullToString(data["useAt"]);
		$("#progrmFileNm").attr("readonly",true);
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
	
	//입력항목처리
	$("#progrmFileNm").attr("readonly",false);
	
	//그리드초기화처리
	gridProgrm.clear();
}

/* ********************************************************
 * 프로그램목록 클릭 후 화면처리
 ******************************************************** */
function setViewProgrmClick() {
	
	//입력항목비활성처리
	$("#progrmFileNm").attr("readonly",true);
}

/* ********************************************************
 * 신규버튼클릭 후 화면처리
 ******************************************************** */
function setViewNewClick()  {
	
	//입력값공백처리
	$('.wTable input').val('');
	$('.wTable select').val('Y');
	$('.wTable textarea').val('');
	
	//입력항목비활성처리
	$("#progrmFileNm").attr("readonly",false);
}
-->
</script>
<div id="border" style="width:730px">

<form:form commandName="progrmManageVO" name="progrmManageVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comSymPrm.programListManage.pageTop.title" /></h1><!-- 프로그램목록 -->
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />"><!-- 이 레이아웃은 하단 정보를 대한 검색 정보로 구성되어 있습니다. -->
		<ul>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="comSymPrm.programListManage.programName" /> : </div></li><!-- 프로그램명 -->
			<li>
				<input class="s_input" name="searchKeyword" type="text"  size="35" title="<spring:message code="title.search" /> <spring:message code="input.input" />" value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<span class="btn_b" onclick="searchProgrmList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
			</li>
			<li>
				<span class="btn_b new" onclick="setViewNewClick();">
					<a href="#"><spring:message code="title.new" /></a>
				</span>
				<span class="btn_b save" onclick="insertProgrmList(document.forms[0]); return false;">
					<a href="#"><spring:message code="button.save" /></a>
				</span>
				<span class="btn_b save" onclick="deleteProgrmList(document.forms[0]); return false;">
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
			<div id="gridProgrm"></div>
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
				<th><spring:message code="comSymPrm.programListManage.programFileName" /> <span class="pilsu">*</span></th><!-- 프로그램파일명 -->
				<td class="left">
				<input name="progrmFileNm" id="progrmFileNm" type="text" value=""  maxlength="50" title="<spring:message code="comSymPrm.programListManage.programFileName" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymPrm.programListManage.programName" /> <span class="pilsu">*</span></th><!-- 프로그램명 -->
				<td class="left">
				<input name="progrmKoreanNm" type="text" value=""  maxlength="50" title="<spring:message code="comSymPrm.programListManage.programName" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymPrm.programListManage.url" /></th><!-- URL -->
				<td width="70%" class="left">
				<input name="URL" type="text" value=""  maxlength="100" title="<spring:message code="comSymPrm.programListManage.url" />" style="width:190px"/>
				</td>
			</tr>			
			<tr>
				<th><spring:message code="comSymPrm.programListManage.ProgramDescription" /></th><!-- 프로그램설명 -->
				<td width="70%" class="left">
				<textarea name="progrmDc" class="textarea"  cols="45" rows="8"  style="width:350px;" title="<spring:message code="comSymPrm.programListManage.ProgramDescription" />"></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comSymPrm.programListManage.useAt" /></th><!-- 사용여부 -->
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