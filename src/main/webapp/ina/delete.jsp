<%@ page import="ina.objects.UsersList" %>
<%@ page import="ina.helper.LoginHelper" %>
<%@ page import="ina.objects.User" %>
<%
    LoginHelper loginHelper = (LoginHelper) request.getSession().getAttribute("loginHelper");

    User userToDelete = null;
    if(loginHelper != null && (userToDelete = loginHelper.getUser()) != null){
        // User has session
    }

    // Delete user
    if(userToDelete != null){
        UsersList.removeUser(userToDelete);
        System.out.println("Deleted user: " + userToDelete.getUsername());
    }

    session.invalidate();
    response.sendRedirect("index.jsp");
%>