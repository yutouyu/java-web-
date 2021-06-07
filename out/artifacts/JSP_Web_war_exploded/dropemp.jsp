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
    <title>取消销售人员资格</title>
</head>
<body>

<%
    //输出所有销售员信息
    Connection con = null;
    PreparedStatement sql = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "yu";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        //模糊查询
        String condition="select * from sale_employee";
        sql=con.prepareStatement(condition);
        ResultSet result=sql.executeQuery();
        if(result.last())   {
            result.beforeFirst();
            out.print("<table style=\"text-align: center;vertical-align: center;\">");
            out.print("<tr>");
            out.print("<th>销售员Id</th>");
            out.print("<th>销售员名字</th>");
            out.print("<th>销售员账号密码</th>");
            out.print("<th>销售员联系电话</th>");
            out.print("</tr>");
            while (result.next()){
                String empId=result.getString("empId");
                String empName=result.getString("empName");
                String empPwd=result.getString("empPwd");
                String empTel=result.getString("empTel");
                out.print("<td>" + empId + "</td>");
                out.print("<td>" + empName + "</td>");
                out.print("<td>" + empPwd + "</td>");
                out.print("<td>" + empTel + "</td>");
                out.print("</tr>");
            }

        }
    }
    catch(Exception e){
        e.printStackTrace();
        //数据库
    }
    out.print("</table>");
%>

<br>
<br>
<form action="dropemp.jsp" method="post">
    删除的销售人员Id:<Input type=text name="empId" placeholder="请输入销售人员Id"><br><br>
    <Input type=submit name="submit" value="提交">
</form>
<%

    String empId= request.getParameter("empId");
    if(empId!=null&&empId.length()!=0){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
            String USER_NAME = "yu";      //数据库用户名
            String PASSWORD = "password";     //数据库密码
            con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
            String condition="delete from sale_employee where empId ='"+empId+"'";
            sql=con.prepareStatement(condition);
            int m =sql.executeUpdate();
            if(m!=0){
                out.print("删除成功");
            }
            else{
                out.print("删除失败");
            }
        }
        catch(Exception e){
            e.printStackTrace();
            //数据库
        }
        out.print("</table>");
    }
%>

<br>
<input type="button" value="返回" onclick="window.location.href='admin.jsp'">

</body>
</html>