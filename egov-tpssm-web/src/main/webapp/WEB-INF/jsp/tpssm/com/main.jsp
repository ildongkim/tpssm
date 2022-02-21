<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
    <title>임시출입자 출입신청심의 시스템</title>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/showModalDialog.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>" ></script>
</head>
<frameset frameborder="0" framespacing="0" rows="75, *, 45">
	<frame name="_top" src="${pageContext.request.contextPath}/cmm/maintop.do" scrolling="no" title="헤더">
		<frameset frameborder="0" framespacing="0" cols="15%,85%">
			<frame name="_left" src="${pageContext.request.contextPath}/cmm/mainleft.do" scrolling="no" title="메뉴페이지">
			<frame name="_content" src="${pageContext.request.contextPath}/cmm/maincontent.do" title="메인페이지">
		</frameset>
	<frame name="_bottom" src="${pageContext.request.contextPath}/cmm/mainbottom.do" scrolling="no" title="푸터">
</frameset>
</html>