<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-22
  Time: 12:32
  To change this template use File | Settings | File Templates.
--%>
<%--
  以前是管理员修改的子页面，需要给销售人员处理**
  在删除时，可以先展现已有的商品库存数不为0的商品，方便查看商品信息**
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="emp_loginBean" class="bean.emp_login" scope="session"/>
<jsp:useBean id="emp_allgsBean" class="bean.allgoods" scope="session"/>
<html>
<head>
    <title>删除商品</title>
</head>
<body>
<form action="deletegoods.jsp" method="post">
    商品标号:<Input type=text name="goodsId" placeholder="请输入商品标号"><br><br>
    <Input type=submit name="submit" value="提交">
</form>
<%
    String Id=request.getParameter("goodsId");
    String mess=emp_allgsBean.delete(Id);
    out.print(mess);
%>

<br>
<br>
<input type="button" value="返回" onclick="window.location.href='sale_emp.jsp'">

</body>
</html>
