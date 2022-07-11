package ina.servlets;

import ina.helper.LoginHelper;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "LoginServlet", value = "/ina/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        LoginHelper loginHelper;
        if (request.getSession().getAttribute("loginHelper") == null){
            loginHelper = new LoginHelper(request, response);
        }
        else {
            loginHelper = (LoginHelper) request.getSession().getAttribute("loginHelper");
        }

        loginHelper.doGet(request, response);

        response.setStatus(303);
        response.setHeader("Location", "index.jsp");
        response.setHeader("Connection", "close");
    }
}
