<%@ page import="java.sql.*" %>
<%@ page import="org.apache.poi.ss.usermodel.Workbook" %>
<%@ page import="org.apache.poi.ss.usermodel.Sheet" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook" %>
<%@ page import="org.apache.poi.openxml4j.exceptions.InvalidFormatException" %>
<%@ page import="org.apache.poi.ss.usermodel.Row" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.io.*" %><%--
  Created by IntelliJ IDEA.
  User: 金虎
  Date: 2019/9/4
  Time: 21:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
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
    String name = null;
    String performance = null;
    Cookie nowCookie =  null;
    String onlineAccount = null;
    String onlinePwd = null;
    String onlineDepartment = null;
    String filename;
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
    //如果登陆有效
    //先查询到所在的部门
    sql = "select department from chief where account='"+onlineAccount+"';";
    resultSet = statement.executeQuery(sql);
    resultSet.next();
    onlineDepartment = resultSet.getString("department");
    //再查询所在部门员工的信息
    sql = "select account,name,performance from employee where department='"+
            onlineDepartment+"';";
    resultSet = statement.executeQuery(sql);


    filename = "" + System.currentTimeMillis();
    String savePath = request.getServletContext().getRealPath("/WEB-INF/tmp");
    File tmpDir = new File(savePath);
    // 判断上传文件的保存目录是否存在
    if (!tmpDir.exists() && !tmpDir.isDirectory())
    {
        // 创建目录
        tmpDir.mkdir();
    }

    String tmpFileName = savePath + "\\" + filename+ ".xlsx";
    //要存放的文件
    File file = new File(tmpFileName);
    //创建wb和sheet
    Workbook wb = new XSSFWorkbook();
    Sheet sheet = wb.createSheet();
    /**
     * 写入操作
     */

    OutputStream outputStream = null;

    try {
//        int rows = sheet.getPhysicalNumberOfRows();
        Row row = sheet.createRow(0);
        //初始化文件标题
        //把员工账号标题记录在第一列上
        row.createCell(0).setCellValue("员工账号");
        //把员工名字标题记录在第二列
        row.createCell(1).setCellValue("员工姓名");
        //把员工绩效标题在第三列上
        row.createCell(2).setCellValue("员工绩效");
        //把员工部门标题记录在第四列上
        row.createCell(3).setCellValue("员工部门");

        //开始逐条录入
        int count = 1;//计数变量
        while(resultSet.next()){
            name = resultSet.getString("name");
            account = resultSet.getString("account");
            performance = resultSet.getString("performance");
            //写入第count条记录
            row = sheet.createRow(count);
            //把员工账号记录在第一列上
            row.createCell(0).setCellValue(account);
            //把员工名字记录在第二列
            row.createCell(1).setCellValue(name);
            //把员工绩效在第三列上
            row.createCell(2).setCellValue(performance);
            //把员工部门记录在第四列上
            row.createCell(3).setCellValue(onlineDepartment);
            //计数变量自增
            count ++;
        }
        //写入文件
        outputStream = new FileOutputStream(file);
        wb.write(outputStream);

    }catch (IOException e) {
        e.printStackTrace();
    }finally {
        if(wb != null) {
            try {
                wb.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }



    /**
     * 下载文件
     */
    //得到要下载的文件
    File downloadfile = new File(tmpFileName);
    //如果文件不存在
    if(!downloadfile.exists()){
        System.out.println("文件不存在!");
        return;
    }

    //设置响应头，控制浏览器下载该文件
    response.setHeader("content-disposition", "attachment;filename=" + URLEncoder.encode(filename+".xlsx", "UTF-8"));
    //读取要下载的文件，保存到文件输入流
    FileInputStream in = new FileInputStream(tmpFileName);
    //创建输出流
    OutputStream output = response.getOutputStream();
    //创建缓冲区
    byte buffer[] = new byte[1024];
    int len = 0;
    //循环将输入流中的内容读取到缓冲区当中
    while((len=in.read(buffer))>0){
        //输出缓冲区的内容到浏览器，实现文件下载
        output.write(buffer, 0, len);
    }
    //关闭文件输入流
    in.close();
    //关闭输出流
    output.close();
    }
%>

</body>
</html>

