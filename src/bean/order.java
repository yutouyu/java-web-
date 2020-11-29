package bean;


import java.sql.*;


//登录后即放入session中方便查看历史订单，订单也可以分页
public class order {
    String orderId="";//订单号
    Double orderSum=0.0;//订单金额
    Timestamp timestamp;//时间戳

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public Double getOrderSum() {
        return orderSum;
    }

    public void setOrderSum(Double orderSum) {
        this.orderSum = orderSum;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }
}
