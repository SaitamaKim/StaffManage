<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/9/5
  Time: 17:50
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
    String onlineAccount = null;
    String onlinePwd = null;
    String department = null;
    String average = null;
    Cookie nowCookie = null;
    boolean validAccess = false;
    String name = null;
    String account = null;
    String gender = null;
    String phone = null;
    String performance = null;
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
        response.sendRedirect("index.html");
    }else {
        //如果登陆有效
//        sql = "select * from employee where account = '"+onlineAccount+"';";
//        resultSet = statement.executeQuery(sql);
//        resultSet.next();
        name = resultSet.getString("name");
        performance = resultSet.getString("performance");
        department = resultSet.getString("department");

        sql = "select performance from employee";
        resultSet = statement.executeQuery(sql);
        double sum=0;
        int num=0;
        while (resultSet.next()){
            sum+=Double.parseDouble(resultSet.getString("performance"));
            num++;
        }

        DecimalFormat df = new DecimalFormat("0.00");
        average = ""+df.format(sum/num);

        %>
        <!-- 内容框开始 -->
        <div class="content">
            <div class="navTop">
            </div>
            <hr>
            <ul id="infoUl">
                <li><span>您本月绩效为<%=performance%></span></li>
                <li><span>部门平均绩效为<%=average%></span></li>
                <%
                    double performanceInDouble= Double.parseDouble(performance);
                    double averageInDouble= Double.parseDouble(average);
                    if(performanceInDouble>=averageInDouble){
                        %><li><span>您绩效在平均成绩之上！继续保持！</span></li><%
                    }else{
                        %><li><span>您绩效在平均成绩之下。不要灰心，加油！</span></li><%
                    }
                %>
            </ul>
        </div>
        <!-- 内容框结束 -->
        <%
    }
%>
</body>
</html>
