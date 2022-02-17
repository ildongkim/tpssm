<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comCopBbs.boardMasterVO.title"/></c:set>
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
    <validator:javascript formName="boardMasterVO" staticJavascript="false" xhtml="true" cdata="false"/>
</head>
<script type="text/javascript">
<!--
let gridBBS;

/* ********************************************************
 * document.ready 처리 함수
 ******************************************************** */
$(document).ready(function() 
{
	//1.게시판목록
	gridBBS = new tui.Grid({
		el: document.getElementById('gridBBS'), // Container element
		bodyHeight: 150, scrollX: false,
		rowHeaders: ['rowNum'],
		data: setReadData("<c:url value='/cmm/bbsmstinfs.do'/>"),
		columns: 
		[
			{header:'<spring:message code="comCopBbs.boardMasterVO.bbsNm" />',        name:'bbsNm',        align:'center'},
			{header:'<spring:message code="comCopBbs.boardMasterVO.bbsTyCode" />',    name:'bbsTyCodeNm',  align:'center'},
			{header:'<spring:message code="comCopBbs.boardMasterVO.useAt" />',        name:'useAt',        align:'center'}
		]
	});
	
	//2.게시판목록의 현재 Row 선택을 위한 이벤트 설정
	setGridEvent(gridBBS);
	
	//3.게시판목록의 Click 이벤트
	gridBBS.on('click', function (ev) {
		setBBSList(gridBBS.getRow(ev.rowKey));
	});
	
	//4.게시판목록의 데이터검색
	searchBBSList();
});

/* ********************************************************
 * 게시판목록의 데이터검색 처리 함수
 ******************************************************** */
function searchBBSList() {
	//화면처리
	setViewSearch();
	const params = {"searchKeyword":$("#searchKeyword").val()};
	gridBBS.readData(1, params);
}

/* ********************************************************
 * 게시판 등록 처리 함수
 ******************************************************** */
function insertBBSList(form) {
	if(confirm("<spring:message code="common.save.msg" />")){
		if(validateBoardMasterVO(form)){
			$('.btn_b.save').css('pointer-events','none');
			$.ajax({
				url : "<c:url value='/cmm/bbsmstInsert.do'/>",
				method :"POST",
				data : $("#boardMasterVO").serialize(),
				dataType : "JSON",
				success : function(result) {
					if (result['message'] != null) {
						confirm(result['message']);	
					} else {
						searchBBSList();
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
 * 게시판 삭제 처리 함수
 ******************************************************** */
function deleteBBSList(form) {
	if(confirm("<spring:message code="common.delete.msg" />")){
		$('.btn_b.save').css('pointer-events','none');
		$.ajax({
			url : "<c:url value='/cmm/bbsmstDelete.do'/>",
			method :"POST",
			data : $("#boardMasterVO").serialize(),
			dataType : "JSON",
			success : function(result) {
				if (result['message'] != null) {
					confirm(result['message']);	
				} else {
					searchBBSList();
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
function setBBSList(data) {
	if (data != null) {
		document.boardMasterVO.bbsId.value=isNullToString(data["bbsId"]);
		document.boardMasterVO.bbsNm.value=isNullToString(data["bbsNm"]);
		document.boardMasterVO.bbsTyCode.value=isNullToString(data["bbsTyCode"]);
		document.boardMasterVO.bbsIntrcn.value=isNullToString(data["bbsIntrcn"]);
		document.boardMasterVO.fileAtchPosblAt.value=isNullToString(data["fileAtchPosblAt"]);
		document.boardMasterVO.atchPosblFileNumber.value=isNullToString(data["atchPosblFileNumber"]);
		document.boardMasterVO.replyPosblAt.value=isNullToString(data["replyPosblAt"]);
		document.boardMasterVO.useAt.value=isNullToString(data["useAt"]);
		$("#bbsId").attr("readonly",true);
	}
}

/* ********************************************************
 * 조회 후 화면처리
 ******************************************************** */
function setViewSearch() {
	
	//입력값공백처리
	$('.wTable input[type=text]').val('');
	$('.wTable input[type=number]').val(0);
	$('.wTable select').val('Y');
	$('.wTable textarea').val('');
	
	//입력항목처리
	$("#bbsId").attr("readonly",false);
	
	//그리드초기화처리
	gridBBS.clear();
}

/* ********************************************************
 * 신규버튼클릭 후 화면처리
 ******************************************************** */
function setViewNewClick() {
	
	//입력값공백처리
	$('.wTable input[type=text]').val('');
	$('.wTable input[type=number]').val(0);
	$('.wTable select').val('Y');
	$('.wTable textarea').val('');
	
	//입력항목비활성처리
	$("#bbsId").attr("readonly",false);
}
-->
</script>
<div id="border" style="width:730px">

<form:form commandName="boardMasterVO" name="boardMasterVO" id="boardMasterVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comCopBbs.boardMasterVO.pageTop.title" /></h1>
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />"><!-- 이 레이아웃은 하단 정보를 대한 검색 정보로 구성되어 있습니다. -->
		<ul>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="comCopBbs.boardMasterVO.bbsNm" /> : </div></li>
			<li>
				<input class="s_input" name="searchKeyword" id="searchKeyword" type="text" size="35" 
				title="<spring:message code="title.search" /> <spring:message code="input.input" />" 
				value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<span class="btn_b" onclick="searchBBSList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
			</li>
			<li>
				<span class="btn_b new" onclick="setViewNewClick();">
					<a href="#"><spring:message code="title.new" /></a>
				</span>
				<span class="btn_b save" onclick="insertBBSList(document.forms[0]); return false;">
					<a href="#"><spring:message code="button.save" /></a>
				</span>
				<span class="btn_b save" onclick="deleteBBSList(document.forms[0]); return false;">
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
			<div id="gridBBS"></div>
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
				<th><spring:message code="comCopBbs.boardMasterVO.bbsId" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="bbsId" id="bbsId" type="text" maxlength="20" title="<spring:message code="comCopBbs.boardMasterVO.bbsId" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopBbs.boardMasterVO.bbsNm" /> <span class="pilsu">*</span></th>
				<td class="left">
				<input name="bbsNm" type="text" maxlength="50" title="<spring:message code="comCopBbs.boardMasterVO.bbsNm" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopBbs.boardMasterVO.bbsTyCode" /> <span class="pilsu">*</span></th>
				<td width="70%" class="left">
				<select name="bbsTyCode" title="<spring:message code="input.input" />" >
					<c:forEach var="bbsTyCode" items="${bbsTyCode}">
			            <option value="<c:out value="${bbsTyCode.code}"/>"><c:out value="${bbsTyCode.codeNm}"/></option>
					</c:forEach>
				</select>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopBbs.boardMasterVO.bbsIntrcn" /> <span class="pilsu">*</span></th>
				<td class="left">
				<textarea name="bbsIntrcn" class="textarea" cols="45" rows="8" style="width:350px;" title="<spring:message code="comCopBbs.boardMasterVO.bbsIntrcn" />"></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopBbs.boardMasterVO.fileAtchPosblAt" /></th>
				<td width="70%" class="left">
				<select name="fileAtchPosblAt" title="<spring:message code="input.input" />" >
					<option value="Y" label="<spring:message code="input.yes" />"/>
					<option value="N" label="<spring:message code="input.no" />"/>
				</select>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopBbs.boardMasterVO.atchPosblFileNumber" /></th>
				<td width="70%" class="left">
				<input name="atchPosblFileNumber" type="number" min=0 max=5 step=1 maxlength="1" title="<spring:message code="comCopBbs.boardMasterVO.atchPosblFileNumber" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopBbs.boardMasterVO.replyPosblAt" /></th>
				<td width="70%" class="left">
				<select name="replyPosblAt" title="<spring:message code="input.input" />" >
					<option value="Y" label="<spring:message code="input.yes" />"/>
					<option value="N" label="<spring:message code="input.no" />"/>
				</select>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopBbs.boardMasterVO.useAt" /></th><!-- 사용여부 -->
				<td width="70%" class="left">
				<select name="useAt" title="<spring:message code="input.input" />" >
					<option value="Y" label="<spring:message code="input.yes" />"/>
					<option value="N" label="<spring:message code="input.no" />"/>
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