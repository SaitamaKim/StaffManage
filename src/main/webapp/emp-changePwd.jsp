<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: 金虎
  Date: 2019/9/5
  Time: 17:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="css/RightContentPanel.css">
    <script src="js/jquery-3.4.1.min.js"></script>
    <script src="js/xlsx.core.min.js"></script>
</head>
<body>


<%!
    boolean validAccess =false;
    Connection conn = null;
    String success = "no";
    Statement statement = null;
    ResultSet resultSet = null;
    String sql = null;
%>

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
    String originPwd = null;
    String newPwd = null;
    String repeatPwd = null;
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
    sql = "select * from employee where account = '"+onlineAccount+"' and password = '"
            + onlinePwd + "';";
    resultSet = statement.executeQuery(sql);
    //如果登陆无效
    if(resultSet.isClosed() || resultSet.next()== false){
        %><script>parent.location.href = "index.html";</script><%
    }else{
        //如果登陆有效。啥也不做，继续下面的
    }
%>

<%
    originPwd = request.getParameter("originPwd");
    newPwd = request.getParameter("newPwd");
    repeatPwd = request.getParameter("repeatPwd");
    if(originPwd == null){
        //如果没有收到密码参数，也就是说本次请求不是重置密码，而是访问页面
        %><!-- 内容框开始 -->
        <div class="content">
            <div class="navTop">
            </div>
            <hr>
            <!--更改密码表单开始-->
            <form action="emp-changePwd.jsp" onsubmit="return check()" method="post" class="pwdForm">
                <span>原密码:</span><input type="password" name="originPwd" required><br>
                <span>新密码(至少8位):</span><input type="password" name="newPwd" id="newPwd" required><br>
                <span>重复新密码:</span><input type="password" name="repeatPwd" id="repeatPwd" required><br>
                <input class="submit" type="submit" name="submit" value="立即修改"/>
            </form>

            <!--更改密码表单结束-->
        </div>
        <!-- 内容框结束 -->
    <%}else{
        //否则就是重置密码
        //先检查输入原密码正确性
        sql = "select name from employee where account = '"+onlineAccount+
                "' and password = '"+originPwd+"';";
        resultSet = statement.executeQuery(sql);
        if(resultSet.next()== false){
            %><script>
                window.location.href = document.referrer;
                alert("原密码输入错误!");
            </script><%
        }else{
            sql = "update employee set password = '"+newPwd+"'"+" where account = '"+
                    onlineAccount+"';";
            statement.execute(sql);
            Cookie cookie = new Cookie("onlineAccount",onlineAccount);
            Cookie cookie1 = new Cookie("onlinePwd",newPwd);
            cookie.setMaxAge(2000);//2000秒后过期
            cookie1.setMaxAge(2000);
            cookie.setPath("/");
            cookie1.setPath("/");
            response.setHeader("P3P","CP=CAO PSA OUR");
            response.addCookie(cookie);
            response.addCookie(cookie1);
            %><script>
                window.parent.location.href = "index.html";
                alert("修改成功!请重新登录");
            </script><%
        }
    }
%>
<script>
   function check() {
       if($('#newPwd').val()!==$('#repeatPwd').val()){
           alert("两次密码不匹配！");
           return false;
       }else if($('#newPwd').val().length<8){
           alert("新密码格式不正确！")
           return false;
       }
   }
</script>

</body>
</html>
