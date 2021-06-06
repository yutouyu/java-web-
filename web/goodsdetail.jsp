<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-20
  Time: 13:09
  To change this template use File | Settings | File Templates.
--%>
<%--
  商品细节查看
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="bean.goods" %>
<%@ page import="java.util.Date" %>
<jsp:useBean id="loginBean" class="bean.login" scope="session"/>
<jsp:useBean id="allgsBean" class="bean.allgoods" scope="session"/>
<jsp:useBean id="controlBean" class="bean.pagecontrol" scope="session"/>
<html>
<head>
    <title>查看商品细节</title>
</head>
<body>
<table border=2 style="text-align: center;vertical-align: center;">
<%

    String Id =request.getParameter("detail");
    allgsBean.reset();
    goods Sgoods=allgsBean.getbyId(Id);
    String Name=Sgoods.getGoodsName();
    String Des=Sgoods.getGoodDes();
    Double Price=Sgoods.getGoodPrice();
    String Brand=Sgoods.getGoodsBrand();
    int Number=Sgoods.getGoodsNumber();


    out.print("<tr>");
    out.print("<td>商品标识号</td>");
    out.print("<td>"+Id+"</td>");
    out.print("</tr>");

    out.print("<tr>");
    out.print("<td>商品名</td>");
    out.print("<td>"+Name+"</td>");
    out.print("</tr>");

    out.print("<tr>");
    out.print("<td>商品品牌</td>");
    out.print("<td>"+Brand+"</td>");
    out.print("</tr>");

    out.print("<tr>");
    out.print("<td>商品价格</td>");
    out.print("<td>"+Price+"</td>");
    out.print("</tr>");

    out.print("<tr>");
    out.print("<td>商品库存数</td>");
    out.print("<td>"+Number+"</td>");
    out.print("</tr>");


    out.print("<tr>");
    out.print("<td>商品描述</td>");
    out.print("<td>"+Des+"</td>");
    out.print("</tr>");
    //此处开始记录
    try {
        Connection con = null;
        PreparedStatement sql = null;
        Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "yu";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        String condition="INSERT INTO view_record VALUES (?,?,?,?)";
        sql=con.prepareStatement(condition);
        sql.setString(1,Id);
        sql.setString(2,Name);
        sql.setString(3,loginBean.getLogname());
        Timestamp viewTime = new Timestamp(System.currentTimeMillis());
        sql.setTimestamp(4,viewTime);
        sql.executeUpdate();
    }
    catch(Exception e){
        e.printStackTrace();
    }

%>
</table>
<br>
<%
    String button="<form  action='goodsToCarServlet' method = 'post' style=\"margin: auto\">"+
            "<input type ='hidden' name='add2' value= "+Id+">"+
            "<input type ='submit'  value='加入购物车' ></form>";
    out.print(button);
%>
<br>
<input type ='button' id="logbtn" value='返回' onclick="window.location.href='shoppingpage.jsp'">
