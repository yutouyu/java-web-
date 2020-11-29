<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-19
  Time: 09:04
  To change this template use File | Settings | File Templates.
  登录账号后的商城，可以添加购物车，浏览商品属性
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<jsp:useBean id="loginBean" class="bean.login" scope="session"/>
<jsp:useBean id="allgsBean" class="bean.allgoods" scope="session"/>
<jsp:useBean id="controlBean" class="bean.pagecontrol" scope="session"/>
<html>
<head>

    <title>用户商城界面</title>
</head>
<body>
<!--该页面可以直接浏览商品-->
<td><a href="showresult.jsp" style="text-decoration: none;font-size: 22px;">查询商品</a></td>
<td><a href="browsecar.jsp" style="text-decoration: none;font-size: 22px;">查看购物车</a></td>
<td><a href="vieworder.jsp" style="text-decoration: none;font-size: 22px;">查看订单</a></td>
<td><a href="logoutServlet" style="text-decoration: none;font-size: 22px;">注销</a></td>
<br>
<table border=1px rules="rows" style="text-align: center;vertical-align: center;">
    <tr>
        <th>商品名称</th>
        <th>商品品牌</th>
      <!--  <th>化妆品制造商</th> 可以考虑加入goods属性-->
        <th>商品价格</th>
        <th></th>
        <th></th>
    </tr>
<jsp:setProperty name="controlBean" property="pageSize" param="pageSize"/>
<jsp:setProperty name="controlBean" property="currentPage" param="currentPage"/>
    <!--控制页面的输出-->
<%
    int totalRecord=allgsBean.getHashmap().size();

    int pageSize=controlBean.getPageSize();  //每页显示的记录数
    int totalPages = controlBean.getTotalPages();//总页数

    if(totalRecord%pageSize==0)
        if(totalRecord==0)
            totalPages = totalRecord/pageSize+1;//总页数
        else
            totalPages = totalRecord/pageSize;//总页数
    else
        totalPages = totalRecord/pageSize+1;

    controlBean.setPageSize(pageSize);

    controlBean.setTotalPages(totalPages);
    if(totalPages>=1) {
        if (controlBean.getCurrentPage() < 1)
            controlBean.setCurrentPage(controlBean.getTotalPages());
        if (controlBean.getCurrentPage() > controlBean.getTotalPages())
            controlBean.setCurrentPage(1);
    }

    if(allgsBean.getHashmap().size()==0) {
        out.print("商店没有售卖商品！");
    }

    else{
    out.println("全部记录数"+totalRecord); //全部记录数可有可无


        int index=(controlBean.getCurrentPage()-1)*pageSize+1;//在总表的位置
        Iterator<Map.Entry<String, goods>>  iterator=allgsBean.getHashmap().entrySet().iterator();

        for(int i=1;i<index&&iterator.hasNext();i++) {//定位到前一个
            iterator.next();
        }

        for(int i=1;i<=pageSize&&iterator.hasNext();i++) {
            Map.Entry<String, goods> entry = iterator.next();//与前面定位配合获取到指定位置
            String Id=entry.getValue().getGoodsId();//商品标号
            String Name=entry.getValue().getGoodsName();//商品名称
            String Brand=entry.getValue().getGoodsBrand();//商品品牌
            Double Price=entry.getValue().getGoodPrice();//商品价格
            //该页面仅展示此部分内容，点击查看更多可以看到更多商品信息
            String button="<form  action='goodsToCarServlet' method = 'post'  style=\"margin: auto\">"+
                    "<input type ='hidden' name='add1' value= "+Id+">"+
                    "<input type ='submit'  value='加入购物车' ></form>";
            //提交放入购物车按钮，放入商品标号信息，后台执行login里对car操作的内置函数进行添加
            String detail="<form  action='goodsdetail.jsp' method = 'post'  style=\"margin: auto\">"+
                    "<input type ='hidden' name='detail' value= "+Id+">"+
                    "<input type ='submit'  value='查看细节' ></form>";
            out.print("<tr>");
            out.print("<td>"+Name+"</td>");
            out.print("<td>"+Brand+"</td>");
            out.print("<td>"+Price+"</td>");
            out.print("<td>"+detail+"</td>");
            out.print("<td>"+button+"</td>");
            out.print("</tr>");
        }
    }
%>
</table>
<br>

<Table>
    <tr>
        <td>
            <form action="shoppingpage.jsp" method=post style="margin: auto">
            <Input type=hidden name="currentPage" value="<%=controlBean.getCurrentPage()-1 %>">
            <Input type=submit name="previous" value="上一页">
            </form>
        </td>
        <td>
        <jsp:getProperty name="controlBean" property="currentPage"/>
        /
        <jsp:getProperty name="controlBean" property="totalPages"/>
        页
        </td>
        <td>
            <form action="shoppingpage.jsp" method=post style="margin: auto">
            <Input type=hidden name="currentPage" value="<%=controlBean.getCurrentPage()+1 %>">
            <Input type=submit name="next" value="下一页">
            </form>
        </td>
    </tr>
    <tr>
        <td>
            <form action="shoppingpage.jsp" method=post>
        每页显示<Input type=text name="pageSize" size=3>
        条记录<Input type=submit name="confirm" value="确定">
            </form>
        </td>
        <td>
            <form action="shoppingpage.jsp" method=post>
            输入页码：<Input type=text name="currentPage" size=2 >
            <Input type=submit name="jump" value="跳转">
            </form>
        </td>
    </tr>
</Table>
</body>
</html>
