<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-22
  Time: 12:33
  To change this template use File | Settings | File Templates.
--%>
<%--
  管理员查看销售订单
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="controlBean4" class="bean.pagecontrol" scope="session"/>
<jsp:useBean id="emp_loginBean" class="bean.emp_login" scope="session"/>
<jsp:useBean id="emp_allgsBean" class="bean.allgoods" scope="session"/>
<html>
<head>
    <title>销售信息显示</title>
</head>
<body>
<jsp:setProperty name="controlBean4" property="pageSize" param="pageSize"/>
<jsp:setProperty name="controlBean4" property="currentPage" param="currentPage"/>
<!--控制页面的输出-->
<%  //连接数据库
    HashMap<String,order> hashmap=new HashMap<String,order>();
    Connection con = null;
    PreparedStatement sql = null;
    int count_num=0;
    ResultSet result=null;
    //进行数据装载
    try {
    Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
    String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
    String USER_NAME = "yu";      //数据库用户名
    String PASSWORD = "password";     //数据库密码
    con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
    String condition="select count(*) from tb_orderinfo where empId='"+emp_loginBean.getLogname()+"'";
    sql=con.prepareStatement(condition);
    result=sql.executeQuery();
    while (result.next()){
        count_num=result.getInt(1);
//        if(count_num==0){
//            out.print("<table border=2>");
//            out.print("<tr>");
//            out.print("<th>订单号</th>");
//            out.print("<th>买家</th>");
//            out.print("<th>商品号</th>");
//            out.print("<th>商品名</th>");
//            out.print("<th>商品价格</th>");
//            out.print("<th>购买数量</th>");
//        }
//        String orderId =result.getString("orderId");
//        String userName=result.getString("userName");
//        String goodsId=result.getString("goodsId");
//        String goodsName=result.getString("goodsName");
//        Double goodsPrice=result.getDouble("goodsPrice");
//        int goodsNumber=result.getInt("goodsNumber");
//        out.print("<tr>");
//        out.print("<td>" + orderId + "</td>");
//        out.print("<td>" + userName + "</td>");
//        out.print("<td>" + goodsId + "</td>");
//        out.print("<td>" + goodsName + "</td>");
//        out.print("<td>" + goodsPrice + "</td>");
//        out.print("<td>" + goodsNumber + "</td>");
//        out.print("</tr>");
//        count_num+=1;
//    order Sorder=new order();//这里不需要上一级订单
//    Sorder.setOrderId(result.getString("orderId"));
//    Sorder.setOrderSum(result.getDouble("moneySum"));
//    Sorder.setTimestamp(result.getTimestamp("orderTime"));
//    hashmap.put(result.getString("orderId"),Sorder);
        }
//        out.print("</table>");
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
        String condition="select * from tb_orderinfo where empId='"+emp_loginBean.getLogname()+"'";
        sql=con.prepareStatement(condition);
        result=sql.executeQuery();
    }
    catch(Exception e){
        e.printStackTrace();
        //数据库
    }


    int totalRecord=count_num;//需要获取到总的数据

    int pageSize=controlBean4.getPageSize();  //每页显示的记录数
    int totalPages = controlBean4.getTotalPages();//总页数

    if(totalRecord%pageSize==0)
        if(totalRecord==0)
            totalPages = totalRecord/pageSize+1;//总页数
        else
            totalPages = totalRecord/pageSize;//总页数
    else
        totalPages = totalRecord/pageSize+1;

    controlBean4.setPageSize(pageSize);

    controlBean4.setTotalPages(totalPages);
    if(totalPages>=1) {
        if (controlBean4.getCurrentPage() < 1)
            controlBean4.setCurrentPage(controlBean4.getTotalPages());
        if (controlBean4.getCurrentPage() > controlBean4.getTotalPages())
            controlBean4.setCurrentPage(1);
    }

    if(count_num==0) {

    }
    else{
        out.print("<table border=2>");
        out.print("<tr>");
        out.print("<th>订单号</th>");
        out.print("<th>买家</th>");
        out.print("<th>商品号</th>");
        out.print("<th>商品名</th>");
        out.print("<th>商品价格</th>");
        out.print("<th>购买数量</th>");

        int index = (controlBean4.getCurrentPage() - 1) * pageSize + 1;//在总表的位置

        result.absolute(index-1);

        for (int i = 1; i <= pageSize && result.next(); i++) {
            String orderId =result.getString("orderId");
            String userName=result.getString("userName");
            String goodsId=result.getString("goodsId");
            String goodsName=result.getString("goodsName");
            Double goodsPrice=result.getDouble("goodsPrice");
            int goodsNumber=result.getInt("goodsNumber");
            out.print("<tr>");
            out.print("<td>" + orderId + "</td>");
            out.print("<td>" + userName + "</td>");
            out.print("<td>" + goodsId + "</td>");
            out.print("<td>" + goodsName + "</td>");
            out.print("<td>" + goodsPrice + "</td>");
            out.print("<td>" + goodsNumber + "</td>");
            out.print("</tr>");
        }
        out.print("</table");
    }
//    if(hashmap.size()==0) {//提交订单时也会判断
//        out.print("商城没有用户订单信息");
//
//    }
//    else{
//        out.print("<table border=2>");
//        out.print("<tr>");
//        out.print("<th>订单号</th>");
//        out.print("<th>下单时间</th>");
//        out.print("<th>交易金额</th>");
//        out.print("<th>查看详情</th>");
//
//        int index = (controlBean4.getCurrentPage() - 1) * pageSize + 1;//在总表的位置
//        Iterator<Map.Entry<String, order>> iterator = hashmap.entrySet().iterator();
//
//        for (int i = 1; i < index && iterator.hasNext(); i++) {//定位到前一个
//            iterator.next();
//        }
//
//        for (int i = 1; i <= pageSize && iterator.hasNext(); i++) {
//            Map.Entry<String, order> entry = iterator.next();//与前面定位配合获取到指定位置
//            String orderId = entry.getValue().getOrderId();//订单号
//            Timestamp Time = entry.getValue().getTimestamp();//下单时间
//            Double moneySum = entry.getValue().getOrderSum();//交易金额
//            salesum+=moneySum;
//            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
//            String time=sdf.format(Time);
//            String detail="<form  action='orderdetail1.jsp' method = 'post' style=\"margin: auto\">"+
//                    "<input type ='hidden' name='orderdetail' value= "+orderId+">"+
//                    "<input type ='submit'  value='查看订单详情' ></form>";
//
//            out.print("<tr>");
//            out.print("<td>" + orderId + "</td>");
//            out.print("<td>" + time + "</td>");
//            out.print("<td>" + moneySum + "</td>");
//            out.print("<td>" + detail + "</td>");
//            out.print("</tr>");
//
//        }
//        out.print("</table>");
//        out.print("<br>");
//        out.print("销售总金额"+salesum);
//        out.print("<br>");
//    }


%>
<br>


<Table>
    <tr>
        <td>
            <form action="saleinfo.jsp" method=post style="margin: auto">
                <Input type=hidden name="currentPage" value="<%=controlBean4.getCurrentPage()-1 %>">
                <Input type=submit name="previous" value="上一页">
            </form>
        </td>
        <td>
            <jsp:getProperty name="controlBean4" property="currentPage"/>
            /
            <jsp:getProperty name="controlBean4" property="totalPages"/>
            页
        </td>
        <td>
            <form action="saleinfo.jsp" method=post style="margin: auto">
                <Input type=hidden name="currentPage" value="<%=controlBean4.getCurrentPage()+1 %>">
                <Input type=submit name="next" value="下一页">
            </form>
        </td>
    </tr>
    <tr>
        <td>
            <form action="saleinfo.jsp" method=post>
                每页显示<Input type=text name="pageSize" size=3>
                条记录<Input type=submit name="confirm" value="确定">
            </form>
        </td>
        <td>
            <form action="saleinfo.jsp" method=post>
                输入页码：<Input type=text name="currentPage" size=2 >
                <Input type=submit name="jump" value="跳转">
            </form>
        </td>
    </tr>
</Table>
<input type ='button'  value='返回' onclick="window.location.href='sale_emp.jsp'">
</body>
</html>
