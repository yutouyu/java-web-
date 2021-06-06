<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2021-06-03
  Time: 21:00
  To change this template use File | Settings | File Templates.
--%>
<%--
  提供给销售人员使用的登陆页
  销售人员的信息需通过数据库手动注册
  不能通过注册导入
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="emp_loginBean" class="bean.emp_login" scope="session"/>
<%--
  上面需要改成销售人员的登陆信息
--%>
<html>
<head>
    <title>销售人员登陆页</title>
</head>
<body>
<form action="emp_loginServlet" method="post" id="loginform" style="font-size: 30px;text-align: center;">
    名称:<input type="text" name="uname" id="uname" style="height: 30px;"><br>
    密码:<input type="password" name="upwd" id="upwd" style="height: 30px;"><br>
    <%--登录按钮，表单经前端简单验证再提交给后台验证--%>
    <button type="button" id="logbtn" style="height:30px;width: 80px;">登录</button>
    <span style="font-size: 26px;" id="msg">${emp_loginBean.backNews}</span>
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
