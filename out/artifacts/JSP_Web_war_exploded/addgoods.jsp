<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-11-22
  Time: 12:31
  To change this template use File | Settings | File Templates.
--%>
<%--
  以前是管理员对商品进行修改的页面，现在需要交给销售员**
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="emp_loginBean" class="bean.emp_login" scope="session"/>
<jsp:useBean id="emp_allgsBean" class="bean.allgoods" scope="session"/>
<html>
<head>
    <title>增加商品</title>
</head>
<body>
<form action="addgoods.jsp" method="post">
    商品标号:<Input type=text name="goodsId" placeholder="请输入商品标号"><br><br>
    商品名称:<Input type=text name="goodsName" placeholder="请输入商品名称"><br><br>
    商品价格:<Input type=text name="goodsPrice" placeholder="请输入商品价格"><br><br>
    商品品牌:<Input type=text name="goodsBrand" placeholder="请输入商品品牌"><br><br>
    商品描述:<Input type=text name="goodsDes" placeholder="请输入商品描述"><br><br>
    商品库存:<Input type=text name="goodsNumber" placeholder="请输入商品库存"><br><br>
    <Input type=submit name="submit" value="提交">
</form>



<%
    Connection con = null;
    PreparedStatement sql = null;
    String goodsId= request.getParameter("goodsId");
    String goodsName= request.getParameter("goodsName");
    Double goodsPrice= 0.0;
    String empId=emp_loginBean.getLogname();
    if(request.getParameter("goodsPrice")==null||request.getParameter("goodsNumber").equals("")){
        goodsPrice= 0.0;
    }
    else{
        goodsPrice= Double.parseDouble(request.getParameter("goodsPrice"));
    }
    String goodsBrand= request.getParameter("goodsBrand");
    String goodsDes= request.getParameter("goodsDes");
    int goodsNumber=0;
    if(request.getParameter("goodsNumber")==null||request.getParameter("goodsNumber").equals("")){
        goodsNumber=0;
    }
    else{
        goodsNumber=Integer.parseInt(request.getParameter("goodsNumber"));
    }
    boolean flag1= goodsId==null||goodsId.equals("");//0则不为空
    boolean flag2= goodsName==null||goodsName.equals("");
    boolean flag3= goodsBrand==null||goodsBrand.equals("");
    //连接数据库进行数据装载
    if(!flag1&&!flag2&&goodsPrice!=0.0&&!flag3&&goodsNumber!=0){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
            String USER_NAME = "yu";      //数据库用户名
            String PASSWORD = "password";     //数据库密码
            con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
            //模糊查询
            String condition="INSERT INTO tb_goods VALUES (?,?,?,?,?,?,?)";
            sql=con.prepareStatement(condition);
            sql.setString(1,goodsId);
            sql.setString(2,goodsName);
            sql.setDouble(3,goodsPrice);
            sql.setString(4,goodsBrand);
            sql.setString(5,goodsDes);
            sql.setInt(6,goodsNumber);
            sql.setString(7,empId);
            int m=sql.executeUpdate();
            if(m!=0)
            {
                condition="INSERT INTO emp_sale_goods VALUES (?,?,?,?,?)";
                sql=con.prepareStatement(condition);
                sql.setString(1,empId);
                sql.setString(2,goodsId);
                sql.setString(3,goodsName);
                sql.setInt(4,0);
                sql.setDouble(5,goodsPrice);
                m=sql.executeUpdate();
                if(m!=0)
                {
                    out.print("添加成功！");
                }
                else
                {
                    out.print("添加失败，请重新修改或完善商品信息");
                }
            }
            else
            {
                out.print("添加失败，请重新修改或完善商品信息");
            }

        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    else
    {
        out.print("请完整填写信息");
        out.print("<br>");
    }
%>
<br>
<input type="button" value="返回" onclick="window.location.href='sale_emp.jsp'">
</body>
</html>
