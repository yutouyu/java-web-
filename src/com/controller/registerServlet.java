package com.controller;

import bean.*;
import java.sql.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;


@WebServlet("/registerServlet")
public class registerServlet extends HttpServlet {
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        try {//连接数据库
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        }
        catch(Exception e){
            //数据库连接失败
        }
    }

    @Override
    public void doPost(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException{
        String URL = "jdbc:mysql://localhost:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "root";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        Connection con = null;
        try {
            con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        register registerBean=new register();  //创建的Javabean模型
        request.setAttribute("registerBean",registerBean);
        // 临时变量， 保存表单数据
        // 合法性校验后，保存到成员变量
        String loginname=request.getParameter("loginname").trim();
        String password=request.getParameter("password").trim();
        String again_password=request.getParameter("again_password").trim();
        String phone=request.getParameter("phone").trim();
        String address=request.getParameter("address").trim();
        String realname=request.getParameter("realname").trim();
        String mailbox=request.getParameter("mailbox").trim();
        //注册失败有必要设置数据回显
        if(loginname==null||"".equals(loginname.trim())) {
            registerBean.setBackNews("用户名不能为空");
            request.getRequestDispatcher("register.jsp").forward(request,response);
            return;
        }
        if(password==null||"".equals(password.trim())) {
            registerBean.setBackNews("密码不能为空");
            request.getRequestDispatcher("register.jsp").forward(request,response);
            return;
        }
        if(!password.equals(again_password)) {
            registerBean.setBackNews("两次密码不同，注册失败");
            request.getRequestDispatcher("register.jsp").forward(request,response);
            return;
        }
        if(mailbox==null||"".equals(mailbox.trim())) {
            registerBean.setBackNews("邮箱不能为空");
            request.getRequestDispatcher("register.jsp").forward(request,response);
            return;
        }
        //判断字符合法
        boolean isLD=true;
        for(int i=0;i<loginname.length();i++){
            char c=loginname.charAt(i);
            if(!((c<='z'&&c>='a')||(c<='Z'&&c>='A')||(c<='9'&&c>='0')))
                isLD=false;
        }
        String insertCondition="INSERT INTO tb_user VALUES (?,?,?,?,?,?,?)";//最后一个问号用来标识管理员和非管理员
        PreparedStatement sql = null;
        try {
            sql=con.prepareStatement(insertCondition);
            if(isLD) {
                sql.setString(1, loginname);
                sql.setString(2, password);
                sql.setString(3, phone);
                sql.setString(4, address);
                sql.setString(5, realname);
                sql.setInt(6,0);
                sql.setString(7,mailbox);
                int m = sql.executeUpdate();
                if (m != 0) {
                    registerBean.setLoginname(loginname);
                    registerBean.setBackNews("注册成功");
                    registerBean.setPhone(phone);
                    registerBean.setAddress(address);
                    registerBean.setRealname(realname);
                    registerBean.setMailbox(mailbox);
                }
                else{
                    registerBean.setBackNews("信息填写不完整");
                    request.getRequestDispatcher("register.jsp").forward(request,response);
                    return;
                }
            }
            else {
                registerBean.setBackNews("账号中有非法字符");
                request.getRequestDispatcher("register.jsp").forward(request,response);
                return;
            }

        } catch (SQLException ee) {
            registerBean.setBackNews("用户名已被使用，请您更换用户名");
            request.getRequestDispatcher("register.jsp").forward(request,response);
            return;
        }
        request.getRequestDispatcher("register.jsp").forward(request,response);
    }
    public  void  doGet(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException {
        doPost(request,response);
    }

}
