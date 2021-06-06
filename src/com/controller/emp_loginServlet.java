//销售人员登陆
package com.controller;
import bean.*;
import java.sql.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/emp_loginServlet")
public class emp_loginServlet extends HttpServlet{
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
        emp_login loginBean=new emp_login();
        //创建的Javabean模型

        HttpSession session=request.getSession(true);

        //将javaBean加入session

        String uname = request.getParameter("uname");
        String upwd = request.getParameter("upwd");

        if(uname==null||"".equals(uname.trim())){
            loginBean.setBackNews("用户姓名不能为空");
            request.getRequestDispatcher("sale_emp_login.jsp").forward(request,response);
            return;
        }
        if(upwd==null||"".equals(upwd.trim())){
            loginBean.setBackNews("用户密码不能为空");
            request.getRequestDispatcher("sale_emp_login.jsp").forward(request,response);
            return;
        }
        //空情况排除后开始数据库校验

        try {
            String condition="select * from sale_employee where empId = '"+uname+
                    "' and empPwd ='"+upwd+"'";
            sql=con.prepareStatement(condition);
            ResultSet result=sql.executeQuery();
            if(result.next()){
                try{//登录成功可以添加处理事务的JavaBean
                    allgoods allgsBean=new allgoods(uname);//商品预加载需要重写初始化方法，通过销售Id
                    loginBean.setLogname(uname);
                    loginBean.setPhone(result.getString(4));
                    loginBean.setRealname(result.getString(2));
                    loginBean.setBackNews("成功登陆");
                    loginBean.setIpAddr(request);
                    Timestamp loginTime = new Timestamp(System.currentTimeMillis());
                    session.setAttribute("loginTime",loginTime);
//                    需要重写重构方法
//                    userorders orderBean=new userorders();
//                    orderBean.load(uname);
//                    session.setAttribute("orderBean",orderBean);
                    session.setAttribute("emp_loginBean",loginBean);
                    session.setAttribute("emp_allgsBean",allgsBean);
                }
                catch(Exception ee){
                    loginBean=new emp_login();
                    allgoods allgsBean=new allgoods(uname);
                    loginBean.setLogname(uname);
                    loginBean.setPhone(result.getString(4));
                    loginBean.setRealname(result.getString(2));
                    loginBean.setBackNews("成功登陆");
                    loginBean.setIpAddr(request);
                    Timestamp loginTime = new Timestamp(System.currentTimeMillis());
                    session.setAttribute("loginTime",loginTime);
//                    userorders orderBean=new userorders();
//                    orderBean.load(uname);
//                    session.setAttribute("orderBean",orderBean);
                    session.setAttribute("emp_loginBean",loginBean);
                    session.setAttribute("emp_allgsBean",allgsBean);
                }

                    request.getRequestDispatcher("sale_emp.jsp").forward(request,response);

            }
            else{
                loginBean.setBackNews("您输入的用户名不存在或密码错误");
                request.getRequestDispatcher("sale_emp_login.jsp").forward(request,response);
                return;

            }
        }
        catch (SQLException e) {

            request.getRequestDispatcher("sale_emp_login.jsp").forward(request,response);
        }
    }
    public  void  doGet(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException {
        doPost(request,response);
    }
}
