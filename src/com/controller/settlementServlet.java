package com.controller;
import bean.*;
import java.sql.*;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/settlementServlet")
public class settlementServlet extends HttpServlet {
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        try {//数据库驱动
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        }
        catch(Exception e){
            //数据库连接失败
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        //建立数据库连接
        String URL = "jdbc:mysql://localhost:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
        String USER_NAME = "root";      //数据库用户名
        String PASSWORD = "password";     //数据库密码
        Connection con = null;
        try {
            con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        HttpSession session = request.getSession(true);
        allgoods allgsBean = (allgoods) session.getAttribute("allgsBean");
        login loginBean = (login) session.getAttribute("loginBean");
        userorders orderBean=(userorders)session.getAttribute("orderBean");
        if(loginBean.getCar().size()!=0){
            try {
                PreparedStatement sql1 = null,sql2 = null,sql3=null;
                //先更新库存信息导入到allgsBean中
                allgsBean.reset();
                //把购物车里的商品库存信息核对一遍
                Iterator<Map.Entry<String, goods>> iterator = loginBean.getCar().entrySet().iterator();
                for(int i=1;i<=loginBean.getCar().size();i++){
                    Map.Entry<String, goods> entry = iterator.next();
                    if(entry.getValue().getGoodsNumber()>allgsBean.getbyId(entry.getValue().getGoodsId()).getGoodsNumber()){
                        response.getWriter().println(entry.getValue().getGoodsName()+"库存不足");
                        session.setAttribute("uesrBean",orderBean);
                        session.setAttribute("loginBean", loginBean);
                        session.setAttribute("allgsBean", allgsBean);
                        request.getRequestDispatcher("browsecar.jsp").forward(request, response);
                        break;
                    }
                }

                //能运行下来说明能够购买
                String orderId=  System.currentTimeMillis()+"";//获取统一的时间数作为订单号
                String insertCondition="INSERT INTO tb_orderinfo VALUES (?,?,?,?,?,?)";//将购物车信息更新到数据库
                String body = "订单号为"+orderId+"<br/>用户名为"+loginBean.getLogname()+"<br/>";
                iterator = loginBean.getCar().entrySet().iterator();
                while(iterator.hasNext()){
                    Map.Entry<String, goods> entry = iterator.next();
                    sql1=con.prepareStatement(insertCondition);
                    sql1.setString(1, orderId);//订单号
                    sql1.setString(2, loginBean.getLogname());//用户名
                    sql1.setString(3, entry.getValue().getGoodsId());//商品标号

                    sql1.setString(4, entry.getValue().getGoodsName());//商品名
                    body=body+"商品名:"+entry.getValue().getGoodsName()+"    ";
                    sql1.setDouble(5, entry.getValue().getGoodPrice());//商品价格
                    body=body+"商品价格:"+entry.getValue().getGoodPrice()+"    ";
                    sql1.setInt(6,entry.getValue().getGoodsNumber());//购买数量
                    body=body+"购买数量:"+entry.getValue().getGoodsNumber()+"<br/>";
                    sql1.executeUpdate();
                }
                //计算订单金额，也可从页面导入实现
                iterator= loginBean.getCar().entrySet().iterator();
                Double sum = 0.0;
                while (iterator.hasNext()) {
                    Map.Entry<String, goods> entry = iterator.next();
                    sum += entry.getValue().getGoodPrice() * entry.getValue().getGoodsNumber();
                }
                body=body+"<br/>"+"购买总金额:"+sum+"元";
                String insertCondition1="INSERT INTO tb_order(orderId,userName,moneySum) VALUES (?,?,?)";//将购物车信息更新到数据库
                sql3=con.prepareStatement(insertCondition1);
                sql3.setString(1,orderId);
                sql3.setString(2,loginBean.getLogname());
                sql3.setDouble(3,sum);
                sql3.executeUpdate();

                //再次循环更新库存信息
                iterator = loginBean.getCar().entrySet().iterator();
                while(iterator.hasNext()){
                    Map.Entry<String, goods> entry = iterator.next();
                    int s=allgsBean.getbyId(entry.getValue().getGoodsId()).getGoodsNumber()-entry.getValue().getGoodsNumber();
                    String updatecondition="update tb_goods set goodsNumber ='"+s
                    +"' where goodsId='"+entry.getValue().getGoodsId()+"'";
                    sql2=con.prepareStatement(updatecondition);
                    sql2.executeUpdate();
                }
                allgsBean.reset();
                loginBean.destroy();
                orderBean.load(loginBean.getLogname());
                session.setAttribute("uesrBean",orderBean);
                session.setAttribute("loginBean", loginBean);
                session.setAttribute("allgsBean", allgsBean);
                loginBean.sendmail(body);
                request.getRequestDispatcher("browsecar.jsp").forward(request, response);

                    }
            catch(Exception ee){

                }
        }
        else{
                session.setAttribute("uesrBean",orderBean);
                session.setAttribute("loginBean", loginBean);
                session.setAttribute("allgsBean", allgsBean);
                request.getRequestDispatcher("shoppingpage.jsp").forward(request,response);
        }


    }
    public  void  doGet(HttpServletRequest request,HttpServletResponse response)
            throws ServletException,IOException {
        doPost(request,response);
    }
}
