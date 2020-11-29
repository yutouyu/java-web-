package com.controller;


import java.sql.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/searchgdServlet")
public class searchgdServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        //如果传回的值为空直接跳回原页面
        //因为数据库支持模糊查询，直接使用数据库连接吧
        PrintWriter out=response.getWriter();
        Connection con = null;
        PreparedStatement sql = null;
        String searchMess= request.getParameter("searchMess");
        if(searchMess==null||searchMess.length()==0) {
            request.getRequestDispatcher("searchgoods.jsp").forward(request, response);
        }
        //连接数据库进行数据装载
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            String URL = "jdbc:mysql://localhost:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
            String USER_NAME = "root";      //数据库用户名
            String PASSWORD = "password";     //数据库密码
            con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
            //模糊查询
            String condition="select * from tb_goods where goodsName like '%"+searchMess+"%'"+
                    " or goodsBrand like '%"+searchMess+"%'"+" or goodsDes like '%"+searchMess+"%'";
            sql=con.prepareStatement(condition);
            ResultSet result=sql.executeQuery();
            if(result.last())   {
            result.beforeFirst();
            response.setContentType("text/html;charset=UTF-8");
            out.println("<html><body>");
            out.print("<table>");
            out.print("<tr>");
            out.print("<th>商品名称</th>");
            out.print("<th>商品品牌</th>");
            out.print("<th>商品价格</th>");
            out.print("<th></th>");
            out.print("<th></th>");
            out.print("</tr>");
            while (result.next()){
                String goodsId=result.getString("goodsId");
                String goodsName=result.getString("goodsName");
                Double goodsPrice=result.getDouble("goodsPrice");
                String goodsBrand=result.getString("goodsBrand");
                String button="<form  action='goodsToCarServlet' method = 'post'>"+
                       "<input type ='hidden' name='add4' value= "+goodsId+">"+
                       "<input type ='submit'  value='加入购物车' ></form>";
                String detail="<form  action='goodsdetail.jsp' method = 'post'>"+
                    "<input type ='hidden' name='detail' value= "+goodsId+">"+
                    "<input type ='submit'  value='查看细节' ></form>";
                out.print("<tr>");
                out.print("<td>"+goodsName+"</td>");
                out.print("<td>"+goodsBrand+"</td>");
                out.print("<td>"+goodsPrice+"</td>");
                out.print("<td>"+detail+"</td>");
                out.print("<td>"+button+"</td>");
                out.print("</tr>");
                out.println("</body></html>");
                }

            }
            else{
            out.println("真不好意思，查询失败");
            request.getRequestDispatcher("searchgoods.jsp").forward(request, response);
            }
        }
        catch(Exception e){
            e.printStackTrace();
            //数据库
        }
    }
    public void doGet(HttpServletRequest request,
                      HttpServletResponse response)
            throws ServletException,IOException{
        doPost(request,response);
    }
}
