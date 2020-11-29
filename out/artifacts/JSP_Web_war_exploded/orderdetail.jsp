<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-20
  Time: 21:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="loginBean" class="bean.login" scope="session"/>
<jsp:useBean id="allgsBean" class="bean.allgoods" scope="session"/>
<jsp:useBean id="controlBean2" class="bean.pagecontrol" scope="session"/>
<jsp:useBean id="orderBean" class="bean.userorders" scope="session"/>
<html>
<head>
    <title>Title</title>
</head>
<body>
<jsp:setProperty name="controlBean2" property="pageSize" param="pageSize"/>
<jsp:setProperty name="controlBean2" property="currentPage" param="currentPage"/>
<!--控制页面的输出-->


<%
    String orderId=request.getParameter("orderdetail");
    Connection con = null;
    PreparedStatement sql = null;

    //连接数据库进行数据装载
    try {
        Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        String URL = "jdbc:mysql://localhost:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "root";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        String condition="select * from tb_orderinfo where orderId='"+orderId+"'";
        sql=con.prepareStatement(condition);
        ResultSet result=sql.executeQuery();

    result.last();
    int totalRecord=result.getRow();
    result.first();
    int pageSize=controlBean2.getPageSize();  //每页显示的记录数
    int totalPages = controlBean2.getTotalPages();//总页数

    if(totalRecord%pageSize==0)
        if(totalRecord==0)
            totalPages = totalRecord/pageSize+1;//总页数
        else
            totalPages = totalRecord/pageSize;//总页数
    else
        totalPages = totalRecord/pageSize+1;

    controlBean2.setPageSize(pageSize);

    controlBean2.setTotalPages(totalPages);
    if(totalPages>=1) {
        if (controlBean2.getCurrentPage() < 1)
            controlBean2.setCurrentPage(controlBean2.getTotalPages());
        if (controlBean2.getCurrentPage() > controlBean2.getTotalPages())
            controlBean2.setCurrentPage(1);
    }

        out.print("<table border=2 style=\"text-align: center;vertical-align: center;\">");
        out.print("<tr>");
        out.print("<th>订单号</th>");
        out.print("<th>商品标号</th>");
        out.print("<th>商品名</th>");
        out.print("<th>商品价格</th>");
        out.print("<th>购买数量</th>");

        int index = (controlBean2.getCurrentPage() - 1) * pageSize + 1;//在总表的位置

        for (int i = 1; i <= pageSize&&result.absolute(index); i++,index++) {

            String goodsId = result.getString("goodsId");
            String goodsName = result.getString("goodsName");
            Double goodsPrice= result.getDouble("goodsPrice");
            int saleNumber = result.getInt("goodsNumber");
            out.print("<tr>");
            out.print("<td>" + orderId + "</td>");
            out.print("<td>" + goodsId + "</td>");
            out.print("<td>" + goodsName + "</td>");
            out.print("<td>" + goodsPrice + "</td>");
            out.print("<td>" + saleNumber + "</td>");
            out.print("</tr>");

        }
        out.print("</table>");
    }
    catch(Exception e){
        e.printStackTrace();
        //数据库
    }

%>
<br>


<Table>
    <tr>
        <td>
            <form action="orderdetail.jsp?orderdetail=<%=orderId%>" method=post style="margin: auto">
                <Input type=hidden name="currentPage" value="<%=controlBean2.getCurrentPage()-1 %>">
                <Input type=submit name="previous" value="上一页">
            </form>
        </td>
        <td>
        <jsp:getProperty name="controlBean2" property="currentPage"/>
        /
        <jsp:getProperty name="controlBean2" property="totalPages"/>
        页
        </td>
        <td>
            <form action="orderdetail.jsp?orderdetail=<%=orderId%>" method=post style="margin: auto">
                <Input type=hidden name="currentPage" value="<%=controlBean2.getCurrentPage()+1 %>">
                <Input type=submit name="next" value="下一页">
            </form>
        </td>
    </tr>
    <tr>
        <td>
            <form action="orderdetail.jsp?orderdetail=<%=orderId%>" method=post>
                每页显示<Input type=text name="pageSize" size=3>
                条记录<Input type=submit name="confirm" value="确定">
            </form>
        </td>
        <td>
            <form action="orderdetail.jsp?orderdetail=<%=orderId%>" method=post>
                输入页码：<Input type=text name="currentPage" size=2 >
                <Input type=submit name="jump" value="跳转">
            </form>
        </td>
    </tr>
</Table>
<input type ='button'  value='返回' onclick="window.location.href='vieworder.jsp'">
</body>
</html>
