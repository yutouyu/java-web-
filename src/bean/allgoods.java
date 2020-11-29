package bean;
//获取所有商品信息,
//此HashMap对象中key为商品id，value为goods实体
import java.sql.*;
import java.util.*;


public class allgoods {

    HashMap<String,goods> hashmap=new HashMap<String,goods>();

    public allgoods(){
        Connection con = null;
        PreparedStatement sql = null;
        //连接数据库进行数据装载
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            String URL = "jdbc:mysql://localhost:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
            String USER_NAME = "root";      //数据库用户名
            String PASSWORD = "password";     //数据库密码
            con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
            String condition="select * from tb_goods";
            sql=con.prepareStatement(condition);
            ResultSet result=sql.executeQuery();
            while (result.next()){
                goods Sgoods=new goods();
                Sgoods.setGoodsId(result.getString("goodsId"));
                Sgoods.setGoodsName(result.getString("goodsName"));
                Sgoods.setGoodPrice(result.getDouble("goodsPrice"));
                Sgoods.setGoodsBrand(result.getString("goodsBrand"));
                Sgoods.setGoodDes(result.getString("goodsDes"));
                Sgoods.setGoodsNumber(result.getInt("goodsNumber"));
                if(Sgoods.getGoodsNumber()!=0)
                {
                    hashmap.put(result.getString("goodsId"),Sgoods);
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
            //数据库
        }
    }

    public HashMap<String, goods> getHashmap() {
        return hashmap;
    }

    public void setHashmap(HashMap<String, goods> hashmap) {
        this.hashmap = hashmap;
    }

    public goods getbyId(String Id){

        if(hashmap.get(Id)!=null){
            return hashmap.get(Id);
        }
        else{
            return null;
        }
    }
    //创建方法实现对商品的删除，连接数据库
    public String delete(String Id){
        if(Id!=null&&Id.length()!=0){
            Connection con = null;
            PreparedStatement sql = null;
            //连接数据库进行数据装载
            try {
                Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
                String URL = "jdbc:mysql://localhost:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
                String USER_NAME = "root";      //数据库用户名
                String PASSWORD = "password";     //数据库密码
                con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
                String condition="update tb_goods set  goodsNumber=0  where goodsId= '"+Id+"'";
                sql=con.prepareStatement(condition);
                int result=sql.executeUpdate();
                if(result!=0){
                    hashmap.remove(Id);
                    return "成功删除";
                }
                else{
                    return "请输入正确的商品标识";
                }
            }
            catch(Exception e){
                e.printStackTrace();
                //数据库
            }
        }
        else{
            return "请输入正确的商品标识";
        }
        return "";
    }
    public void reset(){//刷新重新导入数据库商品信息，主要是为了刷新库存
        hashmap.clear();//清除数据
        Connection con = null;
        PreparedStatement sql = null;
        //连接数据库进行数据装载
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            String URL = "jdbc:mysql://localhost:3306/jsp_test?characterEncoding=utf-8&serverTimezone=UTC";
            String USER_NAME = "root";      //数据库用户名
            String PASSWORD = "password";     //数据库密码
            con = DriverManager.getConnection(URL,USER_NAME,PASSWORD);
            String condition="select * from tb_goods";
            sql=con.prepareStatement(condition);
            ResultSet result=sql.executeQuery();
            while (result.next()){
                goods Sgoods=new goods();
                Sgoods.setGoodsId(result.getString("goodsId"));
                Sgoods.setGoodsName(result.getString("goodsName"));
                Sgoods.setGoodPrice(result.getDouble("goodsPrice"));
                Sgoods.setGoodsBrand(result.getString("goodsBrand"));
                Sgoods.setGoodDes(result.getString("goodsDes"));
                Sgoods.setGoodsNumber(result.getInt("goodsNumber"));
                if(Sgoods.getGoodsNumber()!=0)
                {
                    hashmap.put(result.getString("goodsId"),Sgoods);
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
            //数据库
        }
    }
}
