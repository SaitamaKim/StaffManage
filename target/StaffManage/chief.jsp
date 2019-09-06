<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: 金虎
  Date: 2019/9/4
  Time: 13:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>主管</title>
    <link href="css/jquery-accordion-menu.css" rel="stylesheet" type="text/css" />
    <link href="css/font-awesome.css" rel="stylesheet" type="text/css" />
</head>
<body>

<%--检查是否非法登陆的--%>
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
    Cookie nowCookie = null;
    String name = null;
    String account = null;
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
    sql = "select * from chief where account = '"+onlineAccount+"' and password = '"
            + onlinePwd + "';";
    resultSet = statement.executeQuery(sql);
    //如果登陆无效
    if(resultSet.isClosed() || resultSet.next()== false){
        response.sendRedirect("index.html");
    }else{
        //如果登陆有效。啥也不做，自己加载下面的
        name  = resultSet.getString("name");
    }
%>




<!-- 导航边栏开始 注意我写的导航边栏叫content... -->
<div class="content">
    <div id="jquery-accordion-menu" class="jquery-accordion-menu red">
        <div class="jquery-accordion-menu-header" id="form">
            <img src="img/icon.jpg" alt="" class="round_icon">
            <div class="briefInfo">
                <span class="briefInfo__name"><%=name%></span>
                <span class="briefInfo__account"><%=onlineAccount%></span>
            </div>
        </div>
        <ul id="demo-list">
            <li><a href="index.html"><i class="fa fa-home"></i>主页</a></li>
            <li class="active"><a href="#" onclick="document.getElementById('contentFrame').src='chief-info.jsp';return false;"><i class="fa fa-user"></i>查看个人信息</a></li>
            <li><a href="#" onclick="document.getElementById('contentFrame').src='chief-impEmp.jsp';return false;"><i class="fa fa-pencil"></i>录入员工绩效</a></li>
            <li><a href="#" onclick="document.getElementById('contentFrame').src='chief-exportEmpDataToExcel.jsp';return false;"><i class="fa fa-print"></i>导出员工绩效</a></li>
            <li><a href="#" onclick="logout(event)"><i class="fa fa-sign-out"></i>退出账号</a></li>
        </ul>
        <div class="jquery-accordion-menu-footer">
        </div>
    </div>
</div>
<!-- 导航边栏结束 -->
<!--  嵌入内容框开始-->
<iframe src="admin-info.jsp" id="contentFrame"></iframe>
<!-- 嵌入内容框结束-->

<%--默认定向--%>
<script>document.getElementById('contentFrame').src='chief-info.jsp';</script>

<%--侧边栏效果--%>
<script src="js/jquery-3.4.1.min.js"></script>
<script src="js/jquery-accordion-menu.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function(){
        //顶部导航切换
        $("#demo-list li").click(function(){
            $("#demo-list li.active").removeClass("active")
            $(this).addClass("active");
        })
    })
</script>
<script type="text/javascript">
    jQuery("#jquery-accordion-menu").jqueryAccordionMenu();
</script>
<%--注销按钮事件引入--%>
<script src="js/logout.js"></script>

</body>
</html>