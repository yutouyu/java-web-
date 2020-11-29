package com.controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
@WebServlet("/logoutServlet")
public class logoutServlet extends HttpServlet {
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public  void  doPost(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException {
        HttpSession session=request.getSession(true);
        session.invalidate();              //销毁用户的session对象
        response.sendRedirect("login.jsp"); //返回主页

    }
    public  void  doGet(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException {
        doPost(request,response);
    }
}
