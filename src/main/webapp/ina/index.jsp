<%@ page import="ina.helper.LoginHelper" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>INA Prüfung SS22</title>
</head>
<%
    LoginHelper loginHelper = (LoginHelper) request.getSession().getAttribute("loginHelper");

    if(loginHelper != null && loginHelper.getUser() != null){
        // User is logged in
        response.sendRedirect("content.jsp");
        return;
    }

    response.sendRedirect("login.jsp");
%>
<body>
</body>
</html>