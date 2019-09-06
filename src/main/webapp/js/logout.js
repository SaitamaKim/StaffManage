/**
 * 封装注销账号操作
 * 操作如下：
 * 1. 通过退出按钮的监听调用下面的js函数
 * 2. 函数发送虚拟表单给首页
 * 3. 首页接收注销的信息，将其从cookie中删除
 */
function logout(event){
    //虚拟表单提交
    event.preventDefault();
    var temp = document.createElement("form");
    temp.action = "login.jsp";//提交的地址
    temp.method = "post";//也可指定为get
    temp.style.display = "none";
    var opt = document.createElement("textarea");
    opt.name = "logout";
    opt.value = "yes";
    //alert(opt.value);
    temp.appendChild(opt);
    document.body.appendChild(temp);
    temp.submit();
}