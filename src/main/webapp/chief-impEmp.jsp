<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%--
  Created by IntelliJ IDEA.
  User: 金虎
  Date: 2019/9/4
  Time: 13:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="css/editTable.css">
    <link rel="stylesheet" href="css/RightContentPanel.css">
    <script src="js/jquery-3.4.1.min.js"></script>
</head>
<body>
<!-- 内容框开始 -->
<div class="content">
    <div class="navTop">
        <input type="button" class="navTop__submit" onclick="updateDataBaseForChiefOnEmp()" value="提交"/>
        <input type="button" class="navTop__print" onclick="printTable()" value="打印"/>
    </div>
    <hr>
    <!--输入表格开始-->
    <table class="edittable">
        <thead>
        <tr>
            <th>员工账号</th>
            <th>员工姓名</th>
            <th>员工绩效</th>
        </tr>
        </thead>
        <tbody id="tbody">

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
    String onlineDepartment = null;
    Cookie nowCookie = null;
    String name = null;
    String account = null;
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
    sql = "select * from chief where account = '"+onlineAccount+"' and password = '"
            + onlinePwd + "';";
    resultSet = statement.executeQuery(sql);
    //如果登陆无效
    if(resultSet.isClosed() || resultSet.next()== false){
        %><script>parent.location.href = "index.html";</script><%
    }else{

        onlineDepartment = resultSet.getString("department");
    }
%>

<%
    if(request.getParameter("jsonString") != null) {
        JSONArray jsonArray = JSON.parseArray(URLDecoder.decode(request.getParameter("jsonString"),"utf-8"));
        System.out.println(jsonArray);
        for(int i=0; i<jsonArray.size(); i++){
            account = jsonArray.getJSONObject(i).getString("员工账号");
            name = jsonArray.getJSONObject(i).getString("员工姓名");
            performance = jsonArray.getJSONObject(i).getString("员工绩效");

            /**
             * 录入思路：
             * 1. 表格包括account，name，performance
             * 2. sql语句update一下
             */
            //如果存在则更新
            sql = "update employee set performance = '"+performance+"' "+
                    "where account = '"+account+"';";
            statement.execute(sql);

        }
    }

    //查询所在部门员工的信息
    sql = "select account,name,performance from employee where department='"+
            onlineDepartment+"';";
    resultSet = statement.executeQuery(sql);

    while(resultSet.next()){
        name = resultSet.getString("name");
        account = resultSet.getString("account");
        performance = resultSet.getString("performance");
%>
<tr>
    <td><%=account%></td>
    <td><%=name%></td>
    <td class="editPerformance"><%=performance%></td>
</tr>
<%
    }%>



<%--  嵌入jsp结束  --%>

        </tbody>
    </table>
    <!--输入表格结束-->
</div>
<!-- 内容框结束 -->








<%--把table内容解析成json 传给后台jsp--%>
<script>
    function updateDataBaseForChiefOnEmp(){
        //解析表格数据
        var dataArray = [];
        var trlist  =document.getElementById('tbody').children;
        for(var index = 0 ; index< trlist.length; index++){
            var row = {};
            var tdlist = trlist[index].children;
            row["员工账号"] = tdlist[0].innerHTML;
            row["员工姓名"] = tdlist[1].innerHTML;
            row["员工绩效"] = tdlist[2].innerHTML;
            dataArray.push(row);
        }
        //虚拟表单提交
        var temp = document.createElement("form");
        temp.action = "chief-impEmp.jsp";//提交的地址
        temp.method = "post";//也可指定为get
        temp.style.display = "none";
        var opt = document.createElement("textarea");
        opt.name = "jsonString";
        opt.value = encodeURI(JSON.stringify(dataArray),'utf-8');
        //alert(opt.value);
        temp.appendChild(opt);
        document.body.appendChild(temp);
        temp.submit();
    }
</script>

<%--打印按钮事件--%>
<script>
    function printTable() {
        $('.navTop__submit').hide();
        $('.navTop__print').hide();
        window.print();
        $('.navTop__submit').show();
        $('.navTop__print').show();
    }
</script>



<%--设置edittable动态效果--%>
<script src="js/editTableForChiefOnEmp.js"></script>

</body>
</html>