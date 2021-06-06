<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2021-06-04
  Time: 15:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
  <title>新添加销售人员</title>
</head>
<body>
<form action="addemp.jsp" method="post">
  销售人员Id:<Input type=text name="empId" placeholder="请授予销售人员Id"><br><br>
  销售员真实姓名:<Input type=text name="empName" placeholder="请输入销售员真实姓名"><br><br>
  账号密码:<Input type="password" name="empPwd" placeholder="请输入账号密码"><br><br>
  联系电话:<Input type=text name="empTel" placeholder="请输入销售人员联系电话"><br><br>
  <Input type=submit name="submit" value="提交">
</form>



<%
  Connection con = null;
  PreparedStatement sql = null;
  String empId= request.getParameter("empId");
  String empName= request.getParameter("empName");
  String empPwd= request.getParameter("empPwd");
  String empTel= request.getParameter("empTel");
  //全部信息必须完整,不为空使!flag==true,否则为false
  boolean flag1= empId==null||empId.equals("");
  boolean flag2= empName==null||empName.equals("");
  boolean flag3= empPwd==null||empPwd.equals("");
  boolean flag4= empTel==null||empTel.equals("");
  //连接数据库进行数据装载
  if((!flag1)&&(!flag2)&&(!flag3)&&(!flag4)){
    try {
      Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
      String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
      String USER_NAME = "yu";      //数据库用户名
      String PASSWORD = "password";     //数据库密码
      con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
      //模糊查询
      String condition="INSERT INTO sale_employee VALUES (?,?,?,?)";
      sql=con.prepareStatement(condition);
      sql.setString(1,empId);
      sql.setString(2,empName);
      sql.setString(3,empPwd);
      sql.setString(4,empTel);
      int m=sql.executeUpdate();
      if(m!=0) {
        out.print("添加成功！");
      }
      else
      {
        out.print("添加失败，请重新修改或完善商品信息");
      }

    }
    catch(Exception e){
      e.printStackTrace();
    }
  }
  else
  {
    out.print("请完整填写信息");
    out.print("<br>");
  }
%>
<br>
<input type="button" value="返回" onclick="window.location.href='admin.jsp'">
</body>
</html>
