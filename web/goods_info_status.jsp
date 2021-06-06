<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2021-06-04
  Time: 15:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="controlBean2" class="bean.pagecontrol" scope="session"/>
<html>
<head>
    <title>查看销售商品的信息和状态(在售或不在售)</title>
</head>
<body>
<form action="goods_info_status.jsp" method="post">
    商品Id:<Input type=text name="goodsId" placeholder="请输入商品Id"><br><br>
    <Input type=submit name="submit" value="提交">
</form>
<%  //上面放置查询商品Id框
    //连接数据库，先查询tb_goods 返回库存和销售状态
    //再查询tb_orderinfo查询所有的订单信息
    //统计销售信息--也可用来核对另一张表的销售信息
    Connection con = null;
    PreparedStatement sql = null;
    ResultSet result=null;
    String goodsId=request.getParameter("goodsId");
    int count_num=0;//得到记录条数
    try {
        Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "yu";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        //模糊查询
        String condition="select * from tb_goods where goodsId='"+goodsId+"'";
        //商品为主键且唯一，查询结果要么为空要么是一条
        sql=con.prepareStatement(condition);
        result=sql.executeQuery();
        if (result.next()){
            int goodsNumber=result.getInt("goodsNumber");
            if(goodsNumber>0){
                out.print("商品正在销售，目前库存为:"+goodsNumber);
            }
            else{
                out.print("商品目前缺货中...");
            }
        }
    }
    catch(Exception e){
        e.printStackTrace();
        //数据库
    }


%>
<br>
<jsp:setProperty name="controlBean2" property="pageSize" param="pageSize"/>
<jsp:setProperty name="controlBean2" property="currentPage" param="currentPage"/>
<%
    //上面已经有count_num记录总条数,可以很好的分页
    //获取结果集
    result=null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "yu";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        String condition="select count(*) from tb_orderinfo where goodsId='"+goodsId+"'";
        sql=con.prepareStatement(condition);
        result=sql.executeQuery();
        while(result.next()){
            count_num=result.getInt(1);
        }
    }
    catch(Exception e){
        e.printStackTrace();
        //数据库
    }

    result=null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "yu";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        String condition="select * from tb_orderinfo where goodsId='"+goodsId+"'";
        sql=con.prepareStatement(condition);
        result=sql.executeQuery();
    }
    catch(Exception e){
        e.printStackTrace();
        //数据库
    }

    int totalRecord=count_num;

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

    if(count_num==0) {

    }
    else{
        out.print("<table border=2>");
        out.print("<tr>");
        out.print("<th>订单Id</th>");
        out.print("<th>购买人</th>");
        out.print("<th>商品Id</th>");
        out.print("<th>商品名称</th>");
        out.print("<th>商品价格</th>");
        out.print("<th>购买数量</th>");
        out.print("<th>销售人员</th>");

        int index = (controlBean2.getCurrentPage() - 1) * pageSize + 1;//在总表的位置

        result.absolute(index-1);


        for (int i = 1; i <= pageSize && result.next(); i++) {
            String orderId = result.getString("orderId");
            String userName = result.getString("userName");
            int goodsNumber = result.getInt("goodsNumber");
            String goodsName = result.getString("goodsName");
            Double goodsPrice = result.getDouble("goodsPrice");
            String empId = result.getString("empId");

            out.print("<tr>");
            out.print("<td>" + orderId + "</td>");
            out.print("<td>" + userName+ "</td>");
            out.print("<td>" + goodsId+ "</td>");
            out.print("<td>" + goodsName + "</td>");
            out.print("<td>" +  goodsPrice+ "</td>");
            out.print("<td>" + goodsNumber + "</td>");
            out.print("<td>" + empId + "</td>");
            out.print("</tr>");

        }
        out.print("</table");
    }

%>
<br>


<Table>
    <tr>
        <td>
            <form action="goods_info_status.jsp" method=post style="margin: auto">
                <Input type=hidden name="goodsId" value="<%=request.getParameter("goodsId")%>">
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
            <form action="goods_info_status.jsp" method=post style="margin: auto">
                <Input type=hidden name="goodsId" value="<%=request.getParameter("goodsId")%>">
                <Input type=hidden name="currentPage" value="<%=controlBean2.getCurrentPage()+1 %>">
                <Input type=submit name="next" value="下一页">

            </form>
        </td>
    </tr>
    <tr>
        <td>
            <form action="goods_info_status.jsp" method=post >
                <Input type=hidden name="goodsId" value="<%=request.getParameter("goodsId")%>">
                每页显示<Input type=text name="pageSize" size=3>
                条记录<Input type=submit name="confirm" value="确定">
            </form>
        </td>
        <td>
            <form action="goods_info_status.jsp" method=post>
                <Input type=hidden name="goodsId" value="<%=request.getParameter("goodsId")%>">
                输入页码：<Input type=text name="currentPage" size=2 >
                <Input type=submit name="jump" value="跳转">
            </form>
        </td>
    </tr>
</Table>
<input type ='button'  value='返回' onclick="window.location.href='admin.jsp'">

</body>
</html>
