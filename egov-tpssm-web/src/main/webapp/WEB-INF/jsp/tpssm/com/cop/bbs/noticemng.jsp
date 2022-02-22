<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<c:set var="pageTitle"><spring:message code="comCopBbs.boardVO.Notice.title"/></c:set>
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
    <link href="<c:url value='/modules/smarteditor2.10/dist/css/ko_KR/smart_editor2.css' />" rel="stylesheet" type="text/css">
    <link href="<c:url value='/modules/tui-file-uploader/dist/tui-file-uploader.css' />" rel="stylesheet" type="text/css">
    <link href="<c:url value='/modules/tui-pagination/dist/tui-pagination.min.css' />" rel="stylesheet" type="text/css">
    <link href="<c:url value='/modules/tui-grid/dist/tui-grid.min.css' />" rel="stylesheet" type="text/css">
    <link href="<c:url value="/css/egovframework/com/com.css"/>" rel="stylesheet" type="text/css">
    <link href="<c:url value="/css/egovframework/com/button.css"/>" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jqueryui.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/modules/smarteditor2.10/dist/js/service/HuskyEZCreator.js'/>" charset="utf-8"></script>
    <script type="text/javascript" src="<c:url value='/modules/tui-file-uploader/dist/tui-code-snippet.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/modules/tui-file-uploader/dist/tui-file-uploader.min.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/modules/tui-pagination/dist/tui-pagination.min.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/modules/tui-grid/dist/tui-grid.min.js'/>" ></script>
	<script type="text/javascript" src="<c:url value='/js/tpssm/com/com.js'/>" ></script>
    <script type="text/javascript" src="<c:url value="/cmm/init/validator.do"/>"></script>
    <validator:javascript formName="boardVO" staticJavascript="false" xhtml="true" cdata="false"/>
</head>
<script type="text/javascript">
<!--
let gridNotice;

/* ********************************************************
 * document.ready 처리 함수
 ******************************************************** */
$(document).ready(function() 
{
	//1.공지사항 그리드설정
	gridNotice = new tui.Grid({
		el: document.getElementById('gridNotice'),
		bodyHeight: 200, scrollX: false, scrollY: false,
		rowHeaders: ['rowNum'],
		data: setReadData("<c:url value='/cmm/noticeinfs.do'/>"),
		pageOptions: {
			perPage: 5
		},
		columns: 
		[
			{header:'<spring:message code="comCopBbs.boardVO.Notice.nttSj" />',             name:'nttSj',             align:'center'},
			{header:'<spring:message code="comCopBbs.boardVO.Notice.frstRegistPnttm" />',   name:'frstRegistPnttm',   align:'center'},
			{header:'<spring:message code="comCopBbs.boardVO.Notice.inqireCo" />',          name:'inqireCo',          align:'center'}
		]
	});
	
	//2.공지사항목록의 이벤트 설정
	setGridEvent(gridNotice);
	
	//3.게시판목록의 Click 이벤트
	gridNotice.on('click', function (ev) {
		setBBSList(gridNotice.getRow(ev.rowKey));
	});
	
	//4.게시판목록의 데이터검색
	searchNoticeList();
	
	//5.파일업로더
	setFileUploader();
});

/* ********************************************************
 * 게시판목록의 데이터검색 처리 함수
 ******************************************************** */
function searchNoticeList() {
	//화면처리
	setViewSearch();
	const params = {"bbsId":"BBS_NOTICE", "searchKeyword":$("#searchKeyword").val()};
	gridNotice.readData(1, params);
}

/* ********************************************************
 * 폼입력 정보의 데이터바인딩 처리 함수
 ******************************************************** */
function setBBSList(data) {
	if (data != null) {
		document.getElementById('nttSj').value=isNullToString(data["nttSj"]);
		document.getElementById('frstRegistPnttm').value=isNullToString(data["frstRegistPnttm"]);
		document.getElementById('frstRegisterNm').value=isNullToString(data["frstRegisterNm"]);
		document.getElementById('nttCn').value=isNullToString(data["nttCn"]);
		$(".wTable input").attr("readonly",true);
		oEditors.getById["nttCn"].exec("SET_IR", [""]);
		oEditors.getById["nttCn"].exec("PASTE_HTML", [data["nttCn"]]);
	}
}

/* ********************************************************
 * 공지사항 등록 처리 함수
 ******************************************************** */
function insertContents(form) {
	oEditors.getById["nttCn"].exec("UPDATE_CONTENTS_FIELD", []);
	
	if(confirm("<spring:message code="common.save.msg" />"))
	{
		$('#tui-uploader-form').submit();
	}
}

/* ********************************************************
 * 조회 후 화면처리
 ******************************************************** */
function setViewSearch() {
	
	//입력값공백처리
	$('.wTable input[type=text]').val('');
	if (document.getElementById('nttCn').value != "") {
		oEditors.getById["nttCn"].exec("SET_IR", [""]);
	}
	
	//입력항목처리
	$(".wTable input").attr("readonly",true);
	
	//그리드초기화처리
	gridNotice.clear();
}
-->
</script>
<div id="border" style="width:1000px">

<form:form commandName="boardVO" name="boardVO" id="boardVO" method="post">

<div class="board" style="width:1000px">
	<h1 style="background-position:left 3px"><spring:message code="comCopBbs.boardVO.Notice.pageTop.title" /></h1>
	<div class="search_box" title="<spring:message code="common.searchCondition.msg" />">
		<ul>
			<li><div style="line-height:4px;">&nbsp;</div><div><spring:message code="comCopBbs.boardVO.Notice.nttSj" /> : </div></li>
			<li>
				<input class="s_input" name="searchKeyword" id="searchKeyword" type="text" size="35" 
					title="<spring:message code="title.search" /> <spring:message code="input.input" />" 
					value='<c:out value="${searchVO.searchKeyword}"/>'  maxlength="155" >
				<span class="btn_b" onclick="searchNoticeList(); return false;">
					<a href="#"><spring:message code="button.inquire" /></a>
				</span>				
			</li>
			<li>
				<span class="btn_b new" onclick="setViewNewClick();">
					<a href="#"><spring:message code="title.new" /></a>
				</span>
				<span class="btn_b save" onclick="insertContents(document.forms[0]); return false;">
					<a href="#"><spring:message code="button.save" /></a>
				</span>
				<span class="btn_b save" onclick="deleteContents(document.forms[0]); return false;">
					<a href="#"><spring:message code="button.delete" /></a>
				</span>				
			</li>
		</ul>
	</div>
</div>

<div id="uploader" class="tui-file-uploader">

<body>
    <!-- Page content-->
	<table>
	<colgroup>
		<col style="" />
	</colgroup>
	<tr>
		<td style="vertical-align:top">
			<div id="gridNotice"></div>
		</td>
	</tr>
	</table>
	
	<div style="margin-top: 10px">
		<table class="wTable" >
			<colgroup>
				<col style="width:20%" />
				<col style="" />
			</colgroup>
			<tr>
				<th><spring:message code="comCopBbs.boardVO.Notice.nttSj" /> </span></th>
				<td class="left">
				<input name="nttSj" id="nttSj" type="text" maxlength="20" title="<spring:message code="comCopBbs.boardVO.Notice.nttSj" />" style="width:95%"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopBbs.boardVO.Notice.frstRegistPnttm" /> </th>
				<td class="left">
				<input name="frstRegistPnttm" id="frstRegistPnttm" type="text" maxlength="50" title="<spring:message code="comCopBbs.boardVO.Notice.frstRegistPnttm" />" style="width:190px"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopBbs.boardVO.Notice.frstRegisterNm" /> </th>
				<td class="left">
				<input name="frstRegisterNm" id="frstRegisterNm" type="text" maxlength="50" title="<spring:message code="comCopBbs.boardVO.Notice.frstRegisterNm" />" style="width:190px"/>
				</td>
			</tr>			
			<tr>
				<th><spring:message code="comCopBbs.boardVO.Notice.nttCn" /> </th>
				<td width="80%" class="left">
				<textarea name="nttCn" id="nttCn" rows="10" cols="100" style="width:766px; height:412px; display:none;"></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="comCopBbs.boardVO.Notice.atchFile" /> </th>
				<td class="left">
					<div class="tui-file-uploader-header">
						<span class="tui-file-uploader-tit">File Uploader</span>
						<span class="tui-file-upload-msg"><span id="uploadedCount">0</span> files successfully uploaded</span>
						<div class="tui-btn-area">
							<button type="button" class="tui-btn tui-btn-cancel tui-is-disabled" disabled>Remove</button>
							<label class="tui-btn tui-btn-upload">
								<span class="tui-btn-txt">Add files</span>
								<input type="file" name="userfile[]" class="tui-input-file">
							</label>
						</div>
					</div>
					<div class="tui-js-file-uploader-list tui-js-file-uploader-dropzone tui-file-uploader-area tui-has-scroll">
					<div class="tui-dropzone-contents">
						<span class="tui-dropzone-msg">Drop files here.</span>
					</div>
					</div>
					<div class="tui-file-uploader-info">
						<span class="tui-info-txt">Selected <em class="tui-spec"><span id="checkedItemCount">0</span> files</em> (<span id="checkedItemSize">0 KB</span>)</span>
						<span class="tui-info-txt">Total <span id="itemTotalSize">0 KB</span></span>
					</div>
				</td>
			</tr>
		</table>
	</div>	
</body>
</div>
</form:form>
</div>
</html>

<script type="text/javascript">
<!--
var oEditors = [];
var sLang = "ko_KR";
var sFont = "나눔고딕";

nhn.husky.EZCreator.createInIFrame({
	oAppRef:oEditors,
	elPlaceHolder:"nttCn",
	sSkinURI:"<c:url value='/modules/smarteditor2.10/dist/SmartEditor2Skin.html'/>",	
	htParams:{bUseVerticalResizer:false, I18N_LOCALE:sLang}, fCreator:"createSEditor2",
	fOnAppLoad:function() {
		oEditors.getById["nttCn"].setDefaultFont(sFont, 12);
	}
});

/*********************************************************
 * TUI.UPLOADER Set
 ******************************************************** */
var $uploadedCount = $('#uploadedCount');
var $itemTotalSize = $('#itemTotalSize');
var $checkedItemCount = $('#checkedItemCount');
var $checkedItemSize = $('#checkedItemSize');
var $removeButton = $('.tui-btn-cancel');

function setFileUploader() {
	var uploader = new tui.FileUploader($('#uploader'), {
		url: { send: "<c:url value='/cmm/noticeInsert.do'/>" },
		isMultiple: true, isBatchTransfer: true,
	    listUI: {
	        type: 'table',
	        columnList: [
	            { header: '{{checkbox}}', body: '{{checkbox}}', width: 32 },
	            { header: 'File Name',  width: 500, 
	                body: '<span class="tui-filename-area"><span class="tui-file-name" style="max-width:480px;">{{filename}}</span></span>'
				},
	            { header: 'File Size', body: '{{filesize}}' }
	        ]
	    }
	});

    uploader.on('check', function(evt) {
    	alert('추가할수없습니다1');
    	return;
    	
        var checkedItems = uploader.getCheckedList();
        var checkedItemSize = uploader.getTotalSize(checkedItems);
        var checkedItemCount = checkedItems.length;
        var removeButtonState = (checkedItemCount === 0);
		
        disableRemoveButton(removeButtonState);
        updateCheckedInfo(checkedItemSize, checkedItemCount);
    });

    uploader.on('checkAll', function(evt) {
    	alert('추가할수없습니다2');
    	return;
    	
        var checkedItems = uploader.getCheckedList();
        var checkedItemSize = uploader.getTotalSize(checkedItems);
        var checkedItemCount = checkedItems.length;
        var removeButtonState = (checkedItemCount === 0);

        disableRemoveButton(removeButtonState);
        updateCheckedInfo(checkedItemSize, checkedItemCount);
    });

    uploader.on('remove', function(evt) {
    	alert('추가할수없습니다3');
    	return;
    	
        var checkedItems = uploader.getCheckedList();
        var removeButtonState = (checkedItems.length === 0);

        disableRemoveButton(removeButtonState);
        setUploadedCountInfo(0);
        resetInfo();
    });

    uploader.on('success', function(evt) {
    	alert('추가할수없습니다4');
    	return;
    	
        var successCount = evt.success;
        var removeButtonState = (successCount > 0);

        $uploadedCount.html(successCount);

        disableRemoveButton(removeButtonState);
        setUploadedCountInfo(successCount);
        resetInfo();
        
        console.log("저장완료!!")
        
        searchNoticeList();
    });

    $removeButton.on('click', function() {
    	alert('추가할수없습니다5');
    	return;
    	
        var checkedItems = uploader.getCheckedList();
        uploader.removeList(checkedItems);
    });
    
	//업로드 파일 체크
    uploader.on('update', function(evt) { // This event is only fired when using batch transfer
    	alert('추가할수없습니다7');
    	return;
    	
        var items = evt.filelist;
        var totalSize = uploader.getTotalSize(items);
        $itemTotalSize.html(totalSize);
    });    
 }
 
 // below service code
function disableRemoveButton(state) {
    var className = 'tui-is-disabled';
    if (state) {
        $removeButton.addClass(className);
    } else {
        $removeButton.removeClass(className);
    }
    $removeButton.prop('disabled', false);
}

function updateCheckedInfo(size, count) {
    $checkedItemSize.html(size);
    $checkedItemCount.html(count);
}

function setUploadedCountInfo(count) {
    $uploadedCount.html(count);
}

function resetInfo() {
    $itemTotalSize.html('0 KB');
    $checkedItemSize.html('0 KB');
    $checkedItemCount.html('0');
}
-->
</script>