<%@ page import="ina.helper.LoginHelper" %>
<%@ page import="ina.objects.User" %>
<%
    LoginHelper loginHelper = (LoginHelper) request.getSession().getAttribute("loginHelper");

    User userToLogout = loginHelper.getUser();

    System.out.println("Invalidated session for user: " + userToLogout.getUsername());

    session.invalidate();
    response.sendRedirect("index.jsp");
%>