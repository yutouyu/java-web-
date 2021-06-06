<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-22
  Time: 12:31
  To change this template use File | Settings | File Templates.
--%>
<%--
  以前是管理员修改的子页面，需要给销售人员处理**
  优化成先检索需要进行修改的商品的信息**
  暂不支持对商品绑定的销售人员的修改，需要更高的权限
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="emp_loginBean" class="bean.emp_login" scope="session"/>
<jsp:useBean id="emp_allgsBean" class="bean.allgoods" scope="session"/>
<html>
<head>
    <title>修改商品信息</title>
</head>
<body>
<form action="modifygoods.jsp" method="post">
    商品标号:<Input type=text name="goodsId" placeholder="请输入商品标号"><br><br>
    输入修改信息(至少填写一项)<br><br>
    商品名称:<Input type=text name="modify1" placeholder="请输入商品名称"><br><br>
    商品价格:<Input type=text name="modify2" placeholder="请输入商品价格"><br><br>
    商品品牌:<Input type=text name="modify3" placeholder="请输入商品品牌"><br><br>
    商品描述:<Input type=text name="modify4" placeholder="请输入商品描述"><br><br>
    商品库存:<Input type=text name="modify5" placeholder="请输入商品库存"><br><br>
    <Input type=submit name="submit" value="提交">
</form>
<%
    String goodsName=request.getParameter("modify1");
    String goodsPrice=request.getParameter("modify2");
    String goodsBrand=request.getParameter("modify3");
    String goodsDes=request.getParameter("modify4");
    String goodsNumber=request.getParameter("modify5");//goodsId和goodsinfo都不为空才能进行修改
    String goodsId=request.getParameter("goodsId");
    Connection con = null;
    PreparedStatement sql = null;
    if(goodsId!=null&&goodsId.length()!=0) {
        if ((goodsName.length() != 0 || goodsPrice.length() != 0 || goodsBrand.length() != 0 || goodsDes.length() != 0 || goodsNumber.length() != 0)) {
            String updatecondition = "update tb_goods set ";//对tb_goods开始更改

            String updatecondition1 = "update emp_sale_goods set ";//对emp_sale_goods开始更改
            if (goodsName.length() != 0) {
                updatecondition = updatecondition + "goodsName='" + goodsName + "' ,";

                updatecondition1 = updatecondition1 + "goodsName='" + goodsName + "' ,";
            }
            if (goodsPrice.length() != 0) {
                if (goodsPrice.equals("0.0")) {
                    updatecondition = updatecondition + "goodsPrice=0.0 ,";

                    updatecondition1 = updatecondition1 + "goodsPrice=0.0 ,";
                } else {//理论上可以不用Double.parseDouble转换类型
                    updatecondition = updatecondition + "goodsPrice=" + goodsPrice + " ,";

                    updatecondition1 = updatecondition1 + "goodsPrice=" + goodsPrice + " ,";
                }
            }
            if (goodsBrand.length() != 0) {
                updatecondition = updatecondition + "goodsBrand='" + goodsBrand + "' ,";
            }
            if (goodsDes.length() != 0) {
                updatecondition = updatecondition + "goodsDes='" + goodsDes + "' ,";
            }
            if (goodsNumber.length() != 0) {
                if (goodsNumber.equals("0")) {
                    updatecondition = updatecondition + "goodsNumber='0' ,";

                }
                updatecondition = updatecondition + "goodsNumber=" + goodsNumber + " ,";
            }

            updatecondition = updatecondition.substring(0, updatecondition.length() - 1);
            updatecondition1 = updatecondition1.substring(0, updatecondition1.length() - 1);

            updatecondition = updatecondition + "where goodsId='" + goodsId + "'";
            updatecondition1 = updatecondition1 + "where goodsId='" + goodsId + "'";
            try {
                Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
                String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
                String USER_NAME = "yu";      //数据库用户名
                String PASSWORD = "password";     //数据库密码
                con = DriverManager.getConnection(URL, USER_NAME, PASSWORD);
                //模糊查询
                sql = con.prepareStatement(updatecondition);
                int m = sql.executeUpdate();
                if (m != 0) {
                    sql = con.prepareStatement(updatecondition1);
                    m = sql.executeUpdate();
                    if(m!=0){
                        out.print("修改成功");
                    }
                    else{
                        out.print("输入信息类型有误请重新输入");
                    }
                } else {
                    out.print("输入信息类型有误请重新输入");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        else{
            out.print("请填写好信息");
            out.print("<br>");
        }
    }
    else{
        out.print("请填写好信息");
        out.print("<br>");

    }
%>
<br>
<input type="button" value="返回" onclick="window.location.href='sale_emp.jsp'">
</body>
</html>
