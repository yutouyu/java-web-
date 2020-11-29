<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-17
  Time: 16:13
  To change this template use File | Settings | File Templates.
  登录界面，可跳转到注册界面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="loginBean" class="bean.login" scope="session"/>
<html>
  <head>
    <title>登录/注册页面</title>
  </head>
  <body>
  <%--可分为管理员和普通用户登录，管理员由后台创建--%>
  <form action="loginServlet" method="post" id="loginform" style="font-size: 30px;text-align: center;">
      名称:<input type="text" name="uname" id="uname" style="height: 30px;"><br>

      密码:<input type="password" name="upwd" id="upwd" style="height: 30px;"><br>
      <%--登录按钮，表单经前端简单验证再提交给后台验证--%>
      <button type="button" id="logbtn" style="height:30px;width: 80px;">登录</button>
      <%--页面重定向到注册页面--%>
      <button type="button" onclick="window.location='register.jsp'" style="height:30px;width: 80px;">注册</button><br>
      <span style="font-size: 26px;" id="msg">${loginBean.getBackNews()}</span>

  </form>
  </body>
<script type="text/javascript" src="js/jquery-3.5.1.min.js"></script>
<script type="text/javascript">
    $("#logbtn").click(function () {
        var uname= $("#uname").val();
        var upwd=$("#upwd").val();
        if(isEmpty(uname)){
            $("#msg").html("用户名不能为空！");
            return;
        }
        if(isEmpty(upwd)){
            $("#msg").html("用户密码不能为空！");
            return;
        }
        $("#loginform").submit();
    })

    function isEmpty(str) {
        if(str==null||str.trim()==""){
            return true;
        }
        else return false;
    }
</script>
</html>
