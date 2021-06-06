//购物车删除商品操作
package com.controller;
import bean.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
@WebServlet("/goodsDeletecarServlet")
public class goodsDeletecarServlet extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        String deleteId=request.getParameter("delete");//从购物车里减少的商品Id
        if(deleteId!=null)
        {
            HttpSession session = request.getSession(true);
            login loginBean = (login) session.getAttribute("loginBean");
            loginBean.deleteCarbyId(deleteId);
            session.setAttribute("loginBean", loginBean);
            request.getRequestDispatcher("browsecar.jsp").forward(request, response);
            //网页名需要修改
        }
        else{
            response.getWriter().println("数据传输出错");
            request.getRequestDispatcher("browsecar.jsp").forward(request, response);
            //网页名需要修改
        }
    }
}
