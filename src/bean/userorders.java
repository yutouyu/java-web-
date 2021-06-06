//用户订单信息的装载
package bean;
import java.sql.*;
import java.util.*;

public class userorders {
    HashMap<String,order> hashmap=new HashMap<String,order>();

    public void load(String userName){
        Connection con = null;
        PreparedStatement sql = null;
        //连接数据库进行数据装载
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            String URL = "jdbc:mysql://47.115.63.32:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
            String USER_NAME = "yu";      //数据库用户名
            String PASSWORD = "password";     //数据库密码
            con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
            String condition="select * from tb_order where userName='"+userName+"'";
            sql=con.prepareStatement(condition);
            ResultSet result=sql.executeQuery();
            while (result.next()){
                order Sorder=new order();
                Sorder.setOrderId(result.getString("orderId"));
                Sorder.setOrderSum(result.getDouble("moneySum"));
                Sorder.setTimestamp(result.getTimestamp("orderTime"));
                hashmap.put(result.getString("orderId"),Sorder);
            }
        }
        catch(Exception e){
            e.printStackTrace();
            //数据库
        }
    }

    public userorders(){

    }

    public HashMap<String, order> getHashmap() {
        return hashmap;
    }

    public void setHashmap(HashMap<String, order> hashmap) {
        this.hashmap = hashmap;
    }
}
