//挂载登录信息和购物功能组件
package bean;
import java.util.*;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

public class login {
    String logname = "";
    String phone = "";
    String address = "";
    String realname = "";
    String backNews = "";
    String mailbox="";
    String ip="";
    HashMap<String, goods> car;
    //用来储存用户买过的商品的ID-num集
    //后面对该map的value降序排序取出最多4个用于推荐，将ID保存到一个list中
    //进入商城首页前将与用户Id绑定的销售信息导入
    HashMap<String,Integer> recom;
    public login() {
        car = new HashMap<String, goods>();
        recom = new HashMap<String,Integer>();
    }

    public HashMap<String, Integer> getRecom() {
        return recom;
    }

    //内置对该map的value降序排序，返回类型为list
    public List<HashMap.Entry<String, Integer>> getDeList(){
        HashMap<String, Integer> list = new HashMap<String,Integer>();
        list=this.recom;
        List<HashMap.Entry<String, Integer>> delist = new ArrayList<HashMap.Entry<String, Integer>>(list.entrySet()); //转换为list
        delist.sort(new Comparator<HashMap.Entry<String, Integer>>() {
            @Override
            public int compare(HashMap.Entry<String, Integer> o1, HashMap.Entry<String, Integer> o2) {
                return o2.getValue().compareTo(o1.getValue());//降序排列
            }
        });
        for(int i=4;i<delist.size();i++){
            //删除i位置后，后续元素会补上原来被删的位置，i++会跳过该位置
            delist.remove(i--);//只取最多4个
        }
        return delist;
    }


    public void setRecom(HashMap<String, Integer> recom) {
        this.recom = recom;
    }

    public void setIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        this.ip=ip;
    }


    public String getIp() {
        return ip;
    }

    public String getMailbox() {
        return mailbox;
    }

    public void setMailbox(String mailbox) {
        this.mailbox = mailbox;
    }



    public void setLogname(String logname) {
        this.logname = logname;
    }

    public String getLogname() {
        return logname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getRealname() {
        return realname;
    }

    public void setRealname(String realname) {
        this.realname = realname;
    }

    public String getBackNews() {
        return backNews;
    }

    public void setBackNews(String backNews) {
        this.backNews = backNews;
    }

    public HashMap<String, goods> getCar() {
        return car;
    }

    public void setCar(HashMap<String, goods> car) {
        this.car = car;
    }

    //allgoodsBean创建后导入数据，此使用其中的HashMap对象获取商品信息（***这个查询应该可以通过直接导入商品信息替代而优化，后续更改）
    public void addCarbyId(HashMap<String,goods> hashmap,String Id){//浏览商品通过导入商品的Id来添加，商品Id不需向用户展示
        //查找hashmap里的信息，提交订单是需要比较库存信息，这里加入购物车不需要，提交订单时逻辑上最好重写allgoods同步库存数据
        //首先查找car里面是否已经有了该商品，有了只需要数量加1就行
            if(car.get(Id)!=null){
                //购物车有该商品了
                int temp=car.get(Id).getGoodsNumber()+1;
                car.get(Id).setGoodsNumber(temp);
                return;
            }
        //没有商品则添加到car中
            if(hashmap.get(Id)!=null){
                goods add=hashmap.get(Id);//获取Id对应的商品信息，这里需要修改库存数作为预购数额
                add.setGoodsNumber(1);
                car.put(Id,add);
                return;
            }
        }

    //查看购物车才能删除（默认删掉一个）,数据为0则直接从car中删除，所以没有找不到的情况
    public void deleteCarbyId(String Id){

        int temp=car.get(Id).getGoodsNumber()-1;
        if(temp>0){
            car.get(Id).setGoodsNumber(temp);
        }
        else{
            car.remove(Id);
        }
    }
    public void destroy(){
        car.clear();
    }

    public void sendmail(String body){

        String smtphost = "smtp.sina.com"; // 发送邮件服务器
        String user = "tw_311@sina.com"; // 邮件服务器登录用户名
        String password = "7df54b6e3c0abd01"; // 邮件服务器登录密码
        String from = "tw_311@sina.com"; // 发送人邮件地址
        String to = mailbox; // 接受人邮件地址
        String subject = "订单已经发送，收件地址为"+address; // 邮件标题
        // 以下为发送程序，用户无需改动
        try {
            //初始化Properties类对象
            Properties prop = new Properties();
            //设置mail.smtp.host属性
            prop.setProperty("mail.host", smtphost);
            prop.setProperty("mail.transport.protocol", "smtp");
            prop.setProperty("mail.smtp.auth","true");
            // 获取非共享的session对象
            Session ssn = Session.getInstance(prop);
            ssn.setDebug(true);
            //创建一个默认的MimeMessage对象。
            MimeMessage message = new MimeMessage(ssn);
            //创建InternetAddress对象
            InternetAddress fromAddress = new InternetAddress(from);
            //设置From: 头部的header字段
            message.setFrom(fromAddress);
            //创建InternetAddress对象
            InternetAddress toAddress = new InternetAddress(to);
            //设置 To: 头部的header字段
            message.addRecipient(Message.RecipientType.TO, toAddress);
            //设置 Subject: header字段
            message.setSubject(subject);
            // 现在设置的实际消息
            message.setContent(body,"text/html;charset=UTF-8");
            //定义发送协议
            Transport transport = ssn.getTransport();
            //建立与服务器的链接
            transport.connect(smtphost, user, password);

            //发送邮件
            transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
            //关闭邮件传输
            transport.close();
        } catch(Exception m) //捕获异常
        {
            m.printStackTrace();
        }
    }
}


