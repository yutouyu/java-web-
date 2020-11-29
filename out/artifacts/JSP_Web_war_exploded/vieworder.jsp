<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-20
  Time: 14:48
  To change this template use File | Settings | File Templates.
  查看订单和历史订单
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="loginBean" class="bean.login" scope="session"/>
<jsp:useBean id="allgsBean" class="bean.allgoods" scope="session"/>
<jsp:useBean id="controlBean3" class="bean.pagecontrol" scope="session"/>
<jsp:useBean id="orderBean" class="bean.userorders" scope="session"/>

<html>
<head>
    <title>Title</title>
</head>
<body>
<jsp:setProperty name="controlBean3" property="pageSize" param="pageSize"/>
<jsp:setProperty name="controlBean3" property="currentPage" param="currentPage"/>
<!--控制页面的输出-->
<%
    int totalRecord=orderBean.getHashmap().size();

    int pageSize=controlBean3.getPageSize();  //每页显示的记录数
    int totalPages = controlBean3.getTotalPages();//总页数

    if(totalRecord%pageSize==0)
        if(totalRecord==0)
            totalPages = totalRecord/pageSize+1;//总页数
        else
            totalPages = totalRecord/pageSize;//总页数
    else
        totalPages = totalRecord/pageSize+1;

    controlBean3.setPageSize(pageSize);

    controlBean3.setTotalPages(totalPages);
    if(totalPages>=1) {
        if (controlBean3.getCurrentPage() < 1)
            controlBean3.setCurrentPage(controlBean3.getTotalPages());
        if (controlBean3.getCurrentPage() > controlBean3.getTotalPages())
            controlBean3.setCurrentPage(1);
    }


    if(orderBean.getHashmap().size()==0) {//提交订单时也会判断
        out.print("您还没有购物信息，订单空空如也！");

    }//有待测试哦
    else{
        out.print("<table border=2>");
        out.print("<tr>");
        out.print("<th>订单号</th>");
        out.print("<th>下单时间</th>");
        out.print("<th>交易金额</th>");
        out.print("<th>查看详情</th>");

        int index = (controlBean3.getCurrentPage() - 1) * pageSize + 1;//在总表的位置
        Iterator<Map.Entry<String, order>> iterator = orderBean.getHashmap().entrySet().iterator();

        for (int i = 1; i < index && iterator.hasNext(); i++) {//定位到前一个
            iterator.next();
        }

        for (int i = 1; i <= pageSize && iterator.hasNext(); i++) {
            Map.Entry<String, order> entry = iterator.next();//与前面定位配合获取到指定位置
            String orderId = entry.getValue().getOrderId();//订单号
            Timestamp Time = entry.getValue().getTimestamp();//下单时间
            Double moneySum = entry.getValue().getOrderSum();//交易金额
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            String time=sdf.format(Time);
            String detail="<form  action='orderdetail.jsp' method = 'post' style=\"margin: auto\">"+
                    "<input type ='hidden' name='orderdetail' value= "+orderId+">"+
                    "<input type ='submit'  value='查看订单详情' ></form>";

            out.print("<tr>");
            out.print("<td>" + orderId + "</td>");
            out.print("<td>" + time + "</td>");
            out.print("<td>" + moneySum + "</td>");
            out.print("<td>" + detail + "</td>");
            out.print("</tr>");

        }
        out.print("</table>");

    }


%>
<br>


<Table>
    <tr>
        <td>
            <form action="vieworder.jsp" method=post style="margin: auto">
                <Input type=hidden name="currentPage" value="<%=controlBean3.getCurrentPage()-1 %>">
                <Input type=submit name="previous" value="上一页">
            </form>
        </td>
        <td>
        <jsp:getProperty name="controlBean3" property="currentPage"/>
        /
        <jsp:getProperty name="controlBean3" property="totalPages"/>
        页
        </td>
        <td>
            <form action="vieworder.jsp" method=post style="margin: auto">
                <Input type=hidden name="currentPage" value="<%=controlBean3.getCurrentPage()+1 %>">
                <Input type=submit name="next" value="下一页">
            </form>
        </td>
    </tr>
    <tr>
        <td>
            <form action="vieworder.jsp" method=post>
                每页显示<Input type=text name="pageSize" size=3>
                条记录<Input type=submit name="confirm" value="确定">
            </form>
        </td>
        <td>
            <form action="vieworder.jsp" method=post>
                输入页码：<Input type=text name="currentPage" size=2 >
                <Input type=submit name="jump" value="跳转">
            </form>
        </td>
    </tr>
</Table>
<input type ='button'  value='返回商城' onclick="window.location.href='shoppingpage.jsp'">
</body>
</html>
