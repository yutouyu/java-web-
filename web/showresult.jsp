<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-22
  Time: 09:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="loginBean" class="bean.login" scope="session"/>
<jsp:useBean id="allgsBean" class="bean.allgoods" scope="session"/>
<%@ include file="searchgoods.jsp"%>

<html>
<head>
    <title>返回查询结果</title>
</head>
<body>
<%
    Connection con = null;
    PreparedStatement sql = null;
    String searchMess= request.getParameter("searchMess");
    //连接数据库进行数据装载
    if(searchMess!=null&&searchMess.length()!=0){
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
            out.print("<table style=\"text-align: center;vertical-align: center;\">");
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
                String button="<form  action='goodsToCarServlet' method = 'post' style=\"margin: auto\">"+
                        "<input type ='hidden' name='add4' value= "+goodsId+">"+
                        "<input type ='hidden' name='searchMess' value= "+searchMess+">"+
                        "<input type ='submit'  value='加入购物车' ></form>";
                String detail="<form  action='goodsdetail1.jsp' method = 'post' style=\"margin: auto\">"+
                        "<input type ='hidden' name='detail' value= "+goodsId+">"+
                        "<input type ='hidden' name='searchMess' value= "+searchMess+">"+
                        "<input type ='submit'  value='查看细节' ></form>";
                out.print("<tr>");
                out.print("<td>"+goodsName+"</td>");
                out.print("<td>"+goodsBrand+"</td>");
                out.print("<td>"+goodsPrice+"</td>");
                out.print("<td>"+detail+"</td>");
                out.print("<td>"+button+"</td>");
                out.print("</tr>");

            }

        }
    }
    catch(Exception e){
        e.printStackTrace();
        //数据库
    }
    out.print("</table>");
    }

    out.print("<br>");
    out.print("<input type=\"button\" value='返回商城' onclick=\"window.location.href='shoppingpage.jsp'\">");
%>

</body>
</html>
