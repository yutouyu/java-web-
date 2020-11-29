package bean;

public class register{
    String  loginname="" , phone="",
            address="",realname="",backNews="",mailbox="";

    public String getMailbox() {
        return mailbox;
    }

    public void setMailbox(String mailbox) {
        this.mailbox = mailbox;
    }

    public void setLoginname(String loginname){
        this.loginname=loginname;
    }
    public String getLoginname(){
        return loginname;
    }
    public void setPhone(String phone){
        this.phone=phone;
    }
    public String getPhone(){
        return phone;
    }
    public void setAddress(String address){
        this.address=address;
    }
    public String getAddress(){
        return address;
    }
    public void setRealname(String realname){
        this.realname=realname;
    }
    public String getRealname(){
        return realname;
    }
    public void setBackNews(String backNews){
        this.backNews=backNews;
    }
    public String getBackNews(){
        return backNews;
    }
}
