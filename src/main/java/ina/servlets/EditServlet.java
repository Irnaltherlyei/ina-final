package ina.servlets;

import ina.helper.EditHelper;
import ina.helper.LoginHelper;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "EditServlet", value = "/ina/EditServlet")
public class EditServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EditHelper editHelper;
        if (request.getSession().getAttribute("editHelper") == null){
            editHelper = new EditHelper(request, response);
        }
        else {
            editHelper = (EditHelper) request.getSession().getAttribute("editHelper");
        }

        editHelper.doPost(request, response);

        response.setStatus(303);
        response.setHeader("Location", "index.jsp");
        response.setHeader("Connection", "close");
    }
}
