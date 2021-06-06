<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-22
  Time: 11:22
  To change this template use File | Settings | File Templates.
--%>
<%--
  管理员的操作界面，现在需要进行功能修改
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>管理员页面</title>
</head>
<body style="font-size: 30px;">
<li><a href="addemp.jsp" style="text-decoration: none">添加销售人员</a></li>
<li><a href="dropemp.jsp" style="text-decoration: none">取消销售人员销售资格(保留销售记录)</a></li>
<li><a href="browsesale.jsp" style="text-decoration: none">查看销售员的销售记录</a></li>
<li><a href="goods_info_status.jsp" style="text-decoration: none">查看销售商品的信息和状态(在售或不在售)</a></li>
<li><a href="logoutServlet" style="text-decoration: none">注销</a></li>
</body>
</html>
