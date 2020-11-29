<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-18
  Time: 09:37
  To change this template use File | Settings | File Templates.
  注册功能
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<jsp:useBean id="registerBean" class="bean.register" scope="request"/>
<html>
<head>
    <title>注册页面</title>
</head>
<body>
<form action="registerServlet" method="post" id=registerform style="font-size: 26px;text-align: center;">
    *用户名称:<Input type="text" name="loginname" style="height: 26px;"><br>
    *用户密码:<Input type="password" name="password" style="height: 30px;"><br>
    *重复密码:<Input type="password" name="again_password" style="height: 30px;"><br>
    *联系电话:<Input type="text" name="phone" style="height: 30px;"><br>
    *邮寄地址:<Input type="text" name="address" style="height: 30px;"><br>
    *真实姓名:<Input type="text" name="realname" style="height: 30px;"><br>
    *有效邮箱:<Input type="text" name="mailbox" style="height: 30px;"><br>
    <button type="submit" id="registerbtn" style="height:30px;width: 80px;">注册</button>
    <input type="button" value="返回登录" onclick="window.location.href='login.jsp'" style="height:30px;width: 80px;"><br>
    <span>
        <%--返回信息--%>
        <jsp:getProperty name="registerBean"  property="backNews" />
    </span>
</form>

</body>
</html>
