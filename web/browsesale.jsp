<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2021-06-04
  Time: 15:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="controlBean1" class="bean.pagecontrol" scope="session"/>
<html>
<head>
    <title>查询对应empId的销售情况（简易版）</title>
</head>
<body>

<form action="browsesale.jsp" method="post">
    销售人员Id:<Input type=text name="empId" placeholder="请输入销售人员Id" ><br><br>
    <Input type=submit name="submit" value="提交">
</form>
<%
    //为了分页先在数据库统计条数，后面再控制输出
    Connection con = null;
    PreparedStatement sql = null;
    String empId=request.getParameter("empId");
    int count_num=0;//得到记录条数
    try {
        Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "yu";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        //模糊查询
        String condition="select count(*) from emp_sale_goods where empId='"+empId+"'";
        sql=con.prepareStatement(condition);
        ResultSet result=sql.executeQuery();
        while(result.next()){
            count_num=result.getInt(1);
        }
    }
    catch(Exception e){
        e.printStackTrace();
        //数据库
    }
%>
<jsp:setProperty name="controlBean1" property="pageSize" param="pageSize"/>
<jsp:setProperty name="controlBean1" property="currentPage" param="currentPage"/>
<%
    //上面已经有count_num记录总条数,可以很好的分页
    //获取结果集
    ResultSet result=null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "yu";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        String condition="select * from emp_sale_goods where empId='"+empId+"'";
        sql=con.prepareStatement(condition);
        result=sql.executeQuery();
    }
    catch(Exception e){
        e.printStackTrace();
        //数据库
    }

    int totalRecord=count_num;

    int pageSize=controlBean1.getPageSize();  //每页显示的记录数
    int totalPages = controlBean1.getTotalPages();//总页数

    if(totalRecord%pageSize==0)
        if(totalRecord==0)
            totalPages = totalRecord/pageSize+1;//总页数
        else
            totalPages = totalRecord/pageSize;//总页数
    else
        totalPages = totalRecord/pageSize+1;

    controlBean1.setPageSize(pageSize);

    controlBean1.setTotalPages(totalPages);
    if(totalPages>=1) {
        if (controlBean1.getCurrentPage() < 1)
            controlBean1.setCurrentPage(controlBean1.getTotalPages());
        if (controlBean1.getCurrentPage() > controlBean1.getTotalPages())
            controlBean1.setCurrentPage(1);
    }

    if(count_num==0) {

    }
    else{
        out.print("<table border=2>");
        out.print("<tr>");
        out.print("<th>商品Id</th>");
        out.print("<th>商品名称</th>");
        out.print("<th>销售数量</th>");
        out.print("<th>销售价格</th>");

        int index = (controlBean1.getCurrentPage() - 1) * pageSize + 1;//在总表的位置

        result.absolute(index-1);

        for (int i = 1; i <= pageSize && result.next(); i++) {
            String goodsId = result.getString("goodsId");//商品标号
            String goodsName = result.getString("goodsName");//商品名称
            int sale_number = result.getInt("sale_number");//商品销售数量
            Double goodsPrice = result.getDouble("goodsPrice");//商品价格

            out.print("<tr>");
            out.print("<td>" + goodsId + "</td>");
            out.print("<td>" + goodsName + "</td>");
            out.print("<td>" + sale_number + "</td>");
            out.print("<td>" +  goodsPrice+ "</td>");
            out.print("</tr>");

        }
        out.print("</table");
    }

%>
<br>


<Table>
    <tr>
        <td>
            <form action="browsesale.jsp" method=post style="margin: auto">
                <Input type=hidden name="empId" value="<%=request.getParameter("empId")%>">
                <Input type=hidden name="currentPage" value="<%=controlBean1.getCurrentPage()-1 %>">
                <Input type=submit name="previous" value="上一页">
            </form>
        </td>
        <td>
            <jsp:getProperty name="controlBean1" property="currentPage"/>
            /
            <jsp:getProperty name="controlBean1" property="totalPages"/>
            页
        </td>
        <td>
            <form action="browsesale.jsp" method=post style="margin: auto">
                <Input type=hidden name="empId" value="<%=request.getParameter("empId")%>">
                <Input type=hidden name="currentPage" value="<%=controlBean1.getCurrentPage()+1 %>">
                <Input type=submit name="next" value="下一页">

            </form>
        </td>
    </tr>
    <tr>
        <td>
            <form action="browsesale.jsp" method=post >
                <Input type=hidden name="empId" value="<%=request.getParameter("empId")%>">
                每页显示<Input type=text name="pageSize" size=3>
                条记录<Input type=submit name="confirm" value="确定">
            </form>
        </td>
        <td>
            <form action="browsesale.jsp" method=post>
                <Input type=hidden name="empId" value="<%=request.getParameter("empId")%>">
                输入页码：<Input type=text name="currentPage" size=2 >
                <Input type=submit name="jump" value="跳转">
            </form>
        </td>
    </tr>
</Table>
<input type ='button'  value='返回' onclick="window.location.href='admin.jsp'">

</body>
</html>
