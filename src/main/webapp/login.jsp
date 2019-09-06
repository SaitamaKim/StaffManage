<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: 金虎
  Date: 2019/9/3
  Time: 14:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>管理系统</title>
</head>
<body>
<%!Connection conn = null;
    Statement statement = null;
    ResultSet resultSet = null;
    String sql = null;
%>

<%!public void jspInit(){
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3308/staff?useSSL=false&serverTimezone=UTC","root","123456");
        statement = conn.createStatement();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
    public void jspDestroy(){
        try {
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<%
String account = null;
String password = null;
String name = null;
String identity = null;
String logout = null;

logout = request.getParameter("logout");

if(logout!= null && logout.equals("yes")) {
    //如果获取的是注销消息
    /**
     * 注销有bug(貌似解决了？？)
     */
    System.out.println("用户注销了！");
    Cookie cookie = new Cookie("onlineAccount",null);
    Cookie cookie1 = new Cookie("onlinePwd",null);
    cookie.setMaxAge(0);
    cookie1.setMaxAge(0);
    cookie.setPath("/");
    cookie1.setPath("/");
    response.setHeader("P3P","CP=CAO PSA OUR");
    response.addCookie(cookie);//重新响应
    response.addCookie(cookie1);
    response.sendRedirect("index.html");
}//否则如果是登陆信息
else{
    account = request.getParameter("account");
    password = request.getParameter("password");
    if(account.startsWith("1")){identity="admin";}
    else if(account.startsWith("2")){identity="chief";}
    else{identity="employee";}
    //查账密是否正确
    sql = "select name from "+ identity +" where account ='"+account+"' and password ='"+password+"';";
    resultSet = statement.executeQuery(sql);

    if(resultSet.next()== false){//账密错误
    %>
    <script>
        var check = confirm("输入错误！重试？");
        if(check){window.history.back()}
        else{window.open('','_self','');
            window.close();}
    </script><%
    } else{//账密正确
        name = resultSet.getString("name");
        //设置cookie
        Cookie cookie = new Cookie("onlineAccount",account);
        Cookie cookie1 = new Cookie("onlinePwd",password);
        cookie.setMaxAge(2000);//2000秒后过期
        cookie1.setMaxAge(2000);
        cookie.setPath("/");
        cookie1.setPath("/");
        response.setHeader("P3P","CP=CAO PSA OUR");
        response.addCookie(cookie);
        response.addCookie(cookie1);
        //输出在线用户信息
        System.out.println("在线账号"+account);

        //根据身份跳转页面
        switch (identity) {
            case "admin": response.sendRedirect("admin.jsp");break;
            case "chief": response.sendRedirect("chief.jsp");break;
            case "employee": response.sendRedirect("emp.jsp");break;
            default:break;
        }
    }
}
%>



</body>
</html>

