<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/9/3
  Time: 15:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="css/RightContentPanel.css">
    <script src="js/jquery-3.4.1.min.js"></script>
</head>
<body>
<%--   嵌入jsp开始   --%>
<%!Connection conn = null;
    Statement statement = null;
    ResultSet resultSet = null;
    String sql = null;%>
<%!public void jspInit(){
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/staff?useSSL=false&serverTimezone=UTC","root","123456");
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
    String onlineAccount = null;
    String onlinePwd = null;
    Cookie nowCookie = null;
    boolean validAccess = false;
    String name = null;
    String account = null;
    String gender = null;
    String phone = null;
    /**
     * 检查cookie是否可以登录该页面
     */
    Cookie cookies[] = request.getCookies();
    for (Cookie cookie : cookies) {
        if (cookie.getName().equals("onlineAccount")) {
            nowCookie = cookie;
            //获得登陆的账号
            onlineAccount = nowCookie.getValue();
            if(onlineAccount!=null&&onlinePwd!=null){break;}
        } else if (cookie.getName().equals("onlinePwd")) {
            nowCookie = cookie;
            //获得登陆的密码
            onlinePwd = nowCookie.getValue();
            if(onlineAccount!=null&&onlinePwd!=null){break;}
        }
    }
    sql = "select * from admin where account = '"+onlineAccount+"' and password = '"
            + onlinePwd + "';";
    resultSet = statement.executeQuery(sql);
    //如果登陆无效
    if(resultSet.isClosed() || resultSet.next()== false){
        %><script>parent.location.href = "index.html";</script><%
    }else {
        //如果登陆有效
//        sql = "select * from admin where account = '"+onlineAccount+"';";
//        resultSet = statement.executeQuery(sql);
//        resultSet.next();
        name = resultSet.getString("name");
        gender = resultSet.getString("gender");
        phone = resultSet.getString("phone");



%>
    <!-- 内容框开始 -->
    <div class="content">
        <div class="navTop">
        </div>
        <hr>
        <ul id="infoUl">
            <li><span>身份:管理员</span></li>
            <li><span>账号:<%=onlineAccount%></span></li>
            <li><span>姓名:<%=name%></span></li>
            <li><span>性别:<%=gender%></span></li>
            <li><span>电话:<%=phone%></span></li>
        </ul>
    </div>
    <!-- 内容框结束 -->
<%
    }
%>
</body>
</html>