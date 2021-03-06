<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comCopSecRgm.authorGroupVO.title"/></c:set>
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
    <validator:javascript formName="authorGroupVO" staticJavascript="false" xhtml="true" cdata="false"/>
</head>
<script type="text/javascript">
<!--
let gridUser;

/* ********************************************************
 * document.ready ?????? ??????
 ******************************************************** */
$(document).ready(function() 
{
	//1.???????????????
	gridAuthMber = new tui.Grid({
		el: document.getElementById('gridAuthMber'),
		bodyHeight: 450, scrollX: false,
		rowHeaders: ['rowNum'],
		data: setReadData("<c:url value='/cmm/authMberList.do'/>"),
		columns: 
		[
			{header:'<spring:message code="comCopSecRgm.authorGroupVO.userId" />',     name:'userId',    align:'center'},
			{header:'<spring:message code="comCopSecRgm.authorGroupVO.userNm" />',     name:'userNm',    align:'center'},
			{header:'<spring:message code="comCopSecRgm.authorGroupVO.mberTyNm" />',   name:'mberTyNm',  align:'center'}
		]
	});
	
	//2.??????????????? ?????? Row ????????? ?????? ????????? ??????
	setGridEvent(gridAuthMber);
	
	//3.??????????????? Click ?????????
	gridAuthMber.on('click', function (ev) {
		setAuthMberList(gridAuthMber.getRow(ev.rowKey));
	});
	
	//4.????????????
	gridAuth = new tui.Grid({
		el: document.getElementById('gridAuth'), // Container element
		bodyHeight: 450, scrollX: false,
		rowHeaders: ['checkbox'],
		data: setReadData("<c:url value='/cmm/authgrpList.do'/>"),
		columns: 
		[
			{header:'<spring:message code="comCopSecRam.authorManageVO.authorCode" />',     name:'authorNm',    align:'center'},
			{header:'<spring:message code="comCopSecRam.authorManageVO.authorNm" />',       name:'authorCode',  align:'center'}
		]
	});
	
	//5.????????? ????????? ???????????????
	searchAuthMberList();
});

/* ********************************************************
 * ????????? ????????? ??????????????? ?????? ??????
 ******************************************************** */
function searchAuthMberList() {
	//????????????
	setViewSearch();
	const params = {"searchKeyword":$("#searchKeyword").val()};
	gridAuthMber.readData(1, params);
}

/* ********************************************************
 * ???????????? ?????? ?????? ??????
 ******************************************************** */
function insertAuthGrpList() {
	if(gridAuthMber.getFocusedCell()['rowKey']==null) { return; }
	if(confirm("<spring:message code="common.save.msg" />")){
		//???????????????
		gridAuth.getData().forEach(function(data, idx) {
			gridAuth.setValue(idx, "regYn", 
				data["_attributes"]["checked"] == "true" || 
				data["_attributes"]["checked"] == true ? "Y" : "N"
			);
		});
		$.ajax({
			url : "<c:url value='/cmm/authgroupInsert.do'/>",
			method : "POST",
			data : JSON.stringify(gridAuth.getData()),
			dataType : "JSON",
			contentType : "application/json",
			success : function(result) {
				confirm("<spring:message code='success.common.save' />");
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

/* ********************************************************
 * ??????????????? ??????????????? ?????? ??????
 ******************************************************** */
function setAuthMberList(data) {
	if (data == null) { return; }
	const params = {uniqId:data["uniqId"],mberTyCode:data["mberTyCode"]};
	gridAuth.readData(1, params);
}

/* ********************************************************
 * ?????? ??? ????????????
 ******************************************************** */
function setViewSearch() {
	
	//????????????????????????
	gridAuth.clear();
}
-->
</script>
<div id="border" style="width:730px">

<form:form commandName="authorGroupVO" name="authorGroupVO" method="post">

<div class="board">
	<h1 style="background-position:left 3px"><spring:message code="comCopSecRgm.authorGroupVO.pageTop.title" /></h1>
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />">
		<ul>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="comCopSecRgm.authorGroupVO.userId" /> : </div></li>
			<li>
				<input class="s_input" name="searchKeyword" id="searchKeyword" type="text" size="35" 
					title="<spring:message code="title.search" /> <spring:message code="input.input" />" 
					value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<span class="btn_b" onclick="searchAuthMberList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
			</li>
			<li>
				<span class="btn_b save" onclick="insertAuthGrpList(); return false;">
					<a href="#"><spring:message code="button.save" /></a>
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
			<div id="gridAuthMber"></div>
		</td>
		<td style="vertical-align:top">
			<div id="gridAuth"></div>
		</td>
	</tr>
	</table>
</body>
</div>
</form:form>
</div>
</html>