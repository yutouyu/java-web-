<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-20
  Time: 14:47
  To change this template use File | Settings | File Templates.
  具有购物车浏览、增添、结算功能
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<jsp:useBean id="loginBean" class="bean.login" scope="session"/>
<jsp:useBean id="allgsBean" class="bean.allgoods" scope="session"/>
<jsp:useBean id="controlBean1" class="bean.pagecontrol" scope="session"/>

<html>
<head>
    <title>购物车</title>
</head>
<body>
<jsp:setProperty name="controlBean1" property="pageSize" param="pageSize"/>
<jsp:setProperty name="controlBean1" property="currentPage" param="currentPage"/>
<!--控制页面的输出-->
<%
        int totalRecord=loginBean.getCar().size();

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


        if(loginBean.getCar().size()==0) {//提交订单时也会判断
            out.print("购物车还没有添加商品！");

        }//有待测试哦
        else{
        out.print("<table border=2>");
        out.print("<tr>");
        out.print("<th>商品名称</th>");
        out.print("<th>商品品牌</th>");
        out.print("<th>商品价格</th>");
        out.print("<th>添加</th>");
        out.print("<th>商品数目</th>");
        out.print("<th>删除</th>");

        out.println("全部记录数"+totalRecord); //全部记录数可有可无

        int index = (controlBean1.getCurrentPage() - 1) * pageSize + 1;//在总表的位置
        Iterator<Map.Entry<String, goods>> iterator = loginBean.getCar().entrySet().iterator();

        for (int i = 1; i < index && iterator.hasNext(); i++) {//定位到前一个
            iterator.next();
        }

        for (int i = 1; i <= pageSize && iterator.hasNext(); i++) {
            Map.Entry<String, goods> entry = iterator.next();//与前面定位配合获取到指定位置
            String Id = entry.getValue().getGoodsId();//商品标号
            String Name = entry.getValue().getGoodsName();//商品名称
            String Brand = entry.getValue().getGoodsBrand();//商品品牌
            Double Price = entry.getValue().getGoodPrice();//商品价格
            int number = entry.getValue().getGoodsNumber();//购物车里的数目
            //该页面仅展示此部分内容，点击查看更多可以看到更多商品信息
            String addbutton = "<form  action='goodsToCarServlet' method = 'post' style=\"margin: auto\">" +
                    "<input type ='hidden' name='add3' value= " + Id + ">" +
                    "<input type ='submit'  value='添加' ></form>";
            //提交放入购物车按钮，放入商品标号信息，后台执行login里对car操作的内置函数进行添加
            String deletebutton = "<form  action='goodsDeletecarServlet' method = 'post' style=\"margin: auto\">" +
                    "<input type ='hidden' name='delete' value= " + Id + ">" +
                    "<input type ='submit'  value='删除' ></form>";

            //提交放入购物车按钮，放入商品标号信息，后台执行login里对car操作的内置函数进行添加

            out.print("<tr>");
            out.print("<td>" + Name + "</td>");
            out.print("<td>" + Brand + "</td>");
            out.print("<td>" + Price + "</td>");
            out.print("<td>" + addbutton + "</td>");
            out.print("<td>" + number + "</td>");
            out.print("<td>" + deletebutton + "</td>");
            out.print("</tr>");

        }
        //用于计算现在购物车里的商品总价
        iterator= loginBean.getCar().entrySet().iterator();
        Double sum = 0.0;
        while (iterator.hasNext()) {

            Map.Entry<String, goods> entry = iterator.next();
            sum += entry.getValue().getGoodPrice() * entry.getValue().getGoodsNumber();
        }
        out.print("</table>");
        out.print("所有商品总价为：" + sum + "元");
    }


%>
<br>


<Table>
    <tr>
        <td>
            <form action="browsecar.jsp" method=post style="margin: auto">
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
            <form action="browsecar.jsp" method=post style="margin: auto">
                <Input type=hidden name="currentPage" value="<%=controlBean1.getCurrentPage()+1 %>">
                <Input type=submit name="next" value="下一页">
            </form>
        </td>
    </tr>
    <tr>
        <td>
            <form action="browsecar.jsp" method=post >
                每页显示<Input type=text name="pageSize" size=3>
                条记录<Input type=submit name="confirm" value="确定">
            </form>
        </td>
        <td>
            <form action="browsecar.jsp" method=post>
                输入页码：<Input type=text name="currentPage" size=2 >
                <Input type=submit name="jump" value="跳转">
            </form>
        </td>
    </tr>
</Table>
<input type ='button'  value='返回' onclick="window.location.href='shoppingpage.jsp'">
<input type ='button'  value= "结算" onclick="window.location.href='settlementServlet'">
<input type ='button'  value='查看订单'onclick="window.location.href='vieworder.jsp'">

</body>
</html>
