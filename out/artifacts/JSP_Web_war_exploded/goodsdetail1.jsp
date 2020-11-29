<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-22
  Time: 10:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="bean.goods" %>
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
        String searchMess= request.getParameter("searchMess");
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


    %>
</table>
<br>
<%
    String button="<form  action='goodsToCarServlet' method = 'post' style=\"margin: auto\">"+
            "<input type ='hidden' name='add4' value= "+Id+">"+
            "<input type ='hidden' name='searchMess' value= "+searchMess+">"+
            "<input type ='submit'  value='加入购物车' ></form>";
    out.print(button);
    out.print("<br>");
    String button1="<input type ='button'  value='返回' onclick=\"window.location.href='showresult.jsp?searchMess="
            +searchMess+"'\">";

    out.print(button1);
%>


</body>
</html>
