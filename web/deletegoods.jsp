<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-22
  Time: 12:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="loginBean" class="bean.login" scope="session"/>
<jsp:useBean id="allgsBean" class="bean.allgoods" scope="session"/>
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
    String mess=allgsBean.delete(Id);
    out.print(mess);
%>

<br>
<br>
<input type="button" value="返回" onclick="window.location.href='admin.jsp'">

</body>
</html>
