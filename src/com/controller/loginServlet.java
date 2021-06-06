//用户登录信息和基础javabean的装载
package com.controller;
import bean.*;
import java.sql.*;
import java.io.*;
import java.util.Date;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/loginServlet")
public class loginServlet extends HttpServlet {
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        //建立数据库连接
        String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "yu";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        Connection con = null;
        try {
            con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        PreparedStatement sql = null;
        login loginBean=new login();
        //商品预加载
        allgoods allgsBean=new allgoods();

        //创建的Javabean模型

        HttpSession session=request.getSession(true);

        //将javaBean加入session

        String uname = request.getParameter("uname");
        String upwd = request.getParameter("upwd");

        if(uname==null||"".equals(uname.trim())){
            loginBean.setBackNews("用户姓名不能为空");
            request.getRequestDispatcher("login.jsp").forward(request,response);
            return;
        }
        if(upwd==null||"".equals(upwd.trim())){
            loginBean.setBackNews("用户密码不能为空");
            request.getRequestDispatcher("login.jsp").forward(request,response);
            return;
        }
        //空情况排除后开始数据库校验

        try {
            String condition="select * from tb_user where userName = '"+uname+
                    "' and userPwd ='"+upwd+"'";
            sql=con.prepareStatement(condition);
            ResultSet result=sql.executeQuery();
            if(result.next()){
                int symbol=result.getInt(6);
                try{//登录成功可以添加处理事务的JavaBean
                    loginBean.setLogname(uname);
                    loginBean.setPhone(result.getString(3));
                    loginBean.setAddress(result.getString(4));
                    loginBean.setRealname(result.getString(5));
                    loginBean.setMailbox(result.getString(7));
                    loginBean.setIpAddr(request);
                    loginBean.setBackNews("成功登陆");
                    //设置登陆时间戳
                    Timestamp loginTime = new Timestamp(System.currentTimeMillis());
                    session.setAttribute("loginTime",loginTime);
                    userorders orderBean=new userorders();
                    orderBean.load(uname);
                    session.setAttribute("orderBean",orderBean);
                    session.setAttribute("loginBean",loginBean);
                    session.setAttribute("allgsBean",allgsBean);
                }
                catch(Exception ee){
                    symbol=result.getInt(6);
                    loginBean=new login();
                    session.setAttribute("loginBean",loginBean);
                    loginBean.setLogname(uname);
                    loginBean.setPhone(result.getString(3));
                    loginBean.setAddress(result.getString(4));
                    loginBean.setRealname(result.getString(5));
                    loginBean.setMailbox(result.getString(7));
                    loginBean.setIpAddr(request);
                    loginBean.setBackNews("成功登陆");
                    Timestamp loginTime = new Timestamp(System.currentTimeMillis());
                    session.setAttribute("loginTime",loginTime);
                    userorders orderBean=new userorders();
                    orderBean.load(uname);
                    session.setAttribute("orderBean",orderBean);
                    session.setAttribute("loginBean",loginBean);
                    session.setAttribute("allgsBean",allgsBean);
                }
                if(symbol==1)//管理员设置为1
                {   //管理员中的orderBean必然为空，但可以通过特权网页直接访问数据库
                    //allgsBean加载了所有商品
                    request.getRequestDispatcher("admin.jsp").forward(request,response);
                }
                else{
                request.getRequestDispatcher("shoppingpage.jsp").forward(request,response);
                }
            }
            else{
                loginBean.setBackNews("您输入的用户名不存在或密码错误");
                request.getRequestDispatcher("login.jsp").forward(request,response);
                return;

            }
        }
        catch (SQLException e) {

            request.getRequestDispatcher("login.jsp").forward(request,response);
        }
    }
    public  void  doGet(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException {
        doPost(request,response);
    }

    }


