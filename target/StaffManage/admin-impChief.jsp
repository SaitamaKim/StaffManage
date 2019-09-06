<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %><%--
  Created by IntelliJ IDEA.
  User: 金虎
  Date: 2019/9/3
  Time: 15:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="css/editTable.css">
    <link rel="stylesheet" href="css/RightContentPanel.css">
    <script src="js/jquery-3.4.1.min.js"></script>
    <script src="js/xlsx.core.min.js"></script>
</head>
<body>
<%!Connection conn = null;
    Statement statement = null;
    String sql = null;
    ResultSet resultSet = null;
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
    }%>
<%
    String account = null;
    String name = null;
    String password = null;
    String gender = null;
    String phone = null;
    String department= null;
    Cookie nowCookie = null;
    String onlineAccount = null;
    String onlinePwd = null;
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
        response.sendRedirect("index.html");
    }else{
        //如果登陆有效。啥也不做，自己加载下面的
        name  = resultSet.getString("name");
    }

    /**
     * 导入数据库操作
     */
    if(request.getParameter("jsonString") != null) {
        //如果得到了jsonString信息 说明是导入数据库操作
        JSONArray jsonArray = JSON.parseArray(URLDecoder.decode(request.getParameter("jsonString"),"utf-8"));
        System.out.println(jsonArray);
        for(int i=0; i<jsonArray.size(); i++){
            account = jsonArray.getJSONObject(i).getString("主管账号");
            name = jsonArray.getJSONObject(i).getString("主管姓名");
            password = jsonArray.getJSONObject(i).getString("登陆密码");
            department = jsonArray.getJSONObject(i).getString("管理部门");
            gender = jsonArray.getJSONObject(i).getString("主管性别");
            phone = jsonArray.getJSONObject(i).getString("联系电话");

            /**
             * 导入思路：
             * 1. 表格包括account，name，password,department，gender,phone
             * 2. 检查这些资源对应的数据是否存在。
             * 3. 如果存在，更新除account之外的所有数据
             * 4. 如果不存在，插入
             */
            sql = "select * from chief where account ='"+account+"';";
            resultSet = statement.executeQuery(sql);
            if(resultSet.next()== false){
                //如果不存在这条数据则插入
                sql = "insert into chief(account,name,password,department,gender,phone) values ('"+
                        account+"','"+name+"','"+password+"','"+department+"','"+gender+"','"+phone+"')";
                statement.execute(sql);
            }else{
                //如果存在则更新
                sql = "update chief set name = '"+name+"',password = '"+password+
                        "',department = '"+department+"',gender = '"+gender+
                        "',phone = '"+phone+"' where account = '"+account+"';";
                statement.execute(sql);
            }
        }
    }
%>


<!-- 内容框开始 -->
<div class="content">
    <div class="navTop">
        <div class="navTop__upload-outDiv">
            <input type = "file" class="navTop__upload" id="open-excel" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel"/>
        </div>
        <input type="button" class="navTop__submit" onclick="updateDataBaseForAdminOnChief()" value="提交"/>
    </div>
    <hr>
    <!--输入表格开始-->
    <table class="edittable">
        <thead>
        <tr>
            <th>主管账号</th>
            <th>主管姓名</th>
            <th>登陆密码</th>
            <th>管理部门</th>
            <th>主管性别</th>
            <th>联系电话</th>
            <th class="del-col">操作</th>
        </tr>
        </thead>
        <tbody id="tbody">


        <tr class="append-row">
            <td colspan="7" align="right">
                <input type="button" id="addBtn" value="添 加" />
            </td>
        </tr>
        </tbody>
    </table>
    <!--输入表格结束-->
</div>
<!-- 内容框结束 -->


<%--把table内容解析成json 传给后台jsp--%>
<script>
    function updateDataBaseForAdminOnChief(){
        //解析表格数据
        var dataArray = [];
        var trlist  =document.getElementById('tbody').children;
        for(var index = 0 ; index< trlist.length-1; index++){
            var row = {};
            var tdlist = trlist[index].children;
            row["主管账号"] = tdlist[0].innerHTML;
            row["主管姓名"] = tdlist[1].innerHTML;
            row["登陆密码"] = tdlist[2].innerHTML;
            row["管理部门"] = tdlist[3].innerHTML;
            row["主管性别"] = tdlist[4].innerHTML;
            row["联系电话"] = tdlist[5].innerHTML;
            dataArray.push(row);
        }
        //虚拟表单提交
        var temp = document.createElement("form");
        temp.action = "admin-impChief.jsp";//提交的地址
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
<%--设置edittable动态效果--%>
<script src="js/editTableForAdminOnChief.js"></script>
<%--js处理excel在线显示--%>
<script src="js/showExcelForAdminOnChief.js"></script>


</body>
</html>
