//销售人员注销
package com.controller;
import bean.emp_login;

import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
@WebServlet("/emp_logoutServlet")
public class emp_logoutServlet extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public  void  doPost(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException {
        HttpSession session=request.getSession(true);
        //插入登陆和注销记录
        emp_login loginBean = (emp_login) session.getAttribute("emp_loginBean");
        Timestamp loginTime = (Timestamp)session.getAttribute("loginTime");
        Connection con = null;
        PreparedStatement sql = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
            String USER_NAME = "yu";      //数据库用户名
            String PASSWORD = "password";     //数据库密码
            con = DriverManager.getConnection(URL, USER_NAME, PASSWORD);
            //模糊查询
            String condition = "INSERT INTO login_out_emp VALUES (?,?,?,?)";
            sql = con.prepareStatement(condition);
            sql.setTimestamp(1,loginTime);
            sql.setString(2, loginBean.getLogname());
            sql.setString(3, loginBean.getIp());
            Timestamp outTime= new Timestamp(System.currentTimeMillis());
            sql.setTimestamp(4, outTime);
            sql.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
        }

        session.invalidate();              //销毁用户的session对象
        response.sendRedirect("sale_emp_login.jsp"); //返回主页

    }
    public  void  doGet(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException {
        doPost(request,response);
    }
}
