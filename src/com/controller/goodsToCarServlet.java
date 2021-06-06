//处理不同页面上的“商品加入购物车”操作，方便网页跳转到正确页面
package com.controller;
import bean.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
@WebServlet("/goodsToCarServlet")
public class goodsToCarServlet extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
       String Id1=request.getParameter("add1");
       String Id2=request.getParameter("add2");
       String Id3=request.getParameter("add3");
        String Id4=request.getParameter("add4");
       //获取Id,每个商品页面都有add按钮，但只有购物车页面才有delete按钮
        //add1对应shoppingpage.jsp，add2对应goodsdetail.jsp，add3对应购物车页面

        if(Id1!=null||Id2!=null||Id3!=null||Id4!=null) {
            if (Id1 != null) {//从商城页面加入购物车
                HttpSession session = request.getSession(true);
                allgoods allgsBean = (allgoods) session.getAttribute("allgsBean");
                login loginBean = (login) session.getAttribute("loginBean");
                loginBean.addCarbyId(allgsBean.getHashmap(), Id1);
                session.setAttribute("loginBean", loginBean);
                session.setAttribute("allgsBean", allgsBean);
                request.getRequestDispatcher("shoppingpage.jsp").forward(request, response);
            }

            if (Id2 != null) {//从商城详情页面加入购物车
                HttpSession session = request.getSession(true);
                allgoods allgsBean = (allgoods) session.getAttribute("allgsBean");
                login loginBean = (login) session.getAttribute("loginBean");
                loginBean.addCarbyId(allgsBean.getHashmap(), Id2);
                session.setAttribute("loginBean", loginBean);
                session.setAttribute("allgsBean", allgsBean);
                request.getRequestDispatcher("goodsdetail.jsp?detail="+Id2).forward(request, response);
            }

            if (Id3 != null) {//从购物车页面加入购物车
                HttpSession session = request.getSession(true);
                allgoods allgsBean = (allgoods) session.getAttribute("allgsBean");
                login loginBean = (login) session.getAttribute("loginBean");
                loginBean.addCarbyId(allgsBean.getHashmap(), Id3);
                session.setAttribute("loginBean", loginBean);
                session.setAttribute("allgsBean", allgsBean);
                request.getRequestDispatcher("browsecar.jsp").forward(request, response);
            }
            if (Id4 != null) {//从搜索页
                HttpSession session = request.getSession(true);
                String searchMess= request.getParameter("searchMess");
                allgoods allgsBean = (allgoods) session.getAttribute("allgsBean");
                login loginBean = (login) session.getAttribute("loginBean");
                loginBean.addCarbyId(allgsBean.getHashmap(), Id4);
                session.setAttribute("loginBean", loginBean);
                session.setAttribute("allgsBean", allgsBean);
                request.getRequestDispatcher("showresult.jsp?searchMess="+searchMess).forward(request, response);
                //网页名需要修改
            }
        }
        else{
            response.getWriter().println("数据传输出错");
            request.getRequestDispatcher("shoppingpage.jsp").forward(request, response);
        }

    }
    public  void  doGet(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException {
        doPost(request,response);
    }

}
