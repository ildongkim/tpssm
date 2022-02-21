<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<head>
<link href="<c:url value='/css/tpssm/com/cmm/mainleft.css' />" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>" ></script>
<script type="text/javascript">
$(function() {
    $(".subtitle:not(:first)").attr('class','subtitle sub_on');
    $(".sub:first").css("display","block");
    $(".sub:not(:first)").css("display","none");
    $(".subtitle").click(function() { 
        if ($(this).next(".sub").css("display") == "none") {
            $(this).attr('class','subtitle');
        } else {
            $(this).attr('class','subtitle sub_on');
        }
        $(this).next(".sub").slideToggle('fast');
    });
});
</script>
</head>

<body>
<div id="wrap">
<div class="lnb">
<h1>전체메뉴</h1>
<c:forEach var="result" items="${list_menulist}" varStatus="status" >
<div class="subtitle"><a href="#">${result.menuNm}</a></div>
<ul class="sub" style="display:none;">
	<c:forEach var="result" items="${result._children}" varStatus="status" >
	<li><a href="${pageContext.request.contextPath}<c:out value="${result.linkUrl}"/>" target="_content" class="link">${result.menuNm}</a></li>
	</c:forEach>
</ul>
</c:forEach>
</div>
</div>
</body>