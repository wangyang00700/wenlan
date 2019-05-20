<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2017/8/3
  Time: 10:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <%--<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">--%>
    <link rel="alternate icon" type="image/png" href="img/page_logo.png">
    <link rel="stylesheet" href="layui/css/layui.css">
    <link href="css/bootstrap/bootstrap.min.css" rel="stylesheet">
    <title>资源登录</title>
</head>

<style>
    * {
        margin: 0;
        padding: 0;
    }

    body {
        font-family: 微软雅黑;
        font-size: 15px;
        background: #657380;
        color: #4F5F6F;
        /*450*515*/
    }

    .center {
        width: 450px;
        height: 450px;
        background: white;
        position: absolute;
        margin: auto;
        left: 0;
        right: 0;
        top: 0;
        bottom: 0;
        border-radius: 5px;
        border-bottom: #4BCF99 5px solid;
    }

    .center-top {
        width: 100%;
        height: 150px;
        text-align: center;
        padding: 50px 0px;
        border-bottom: #4BCF99 1px solid;
    }

    .center-top span {
        display: block;
        font-size: 21px;
        letter-spacing: 5px;
    }

    .center-top p {
        color: #D7DDE4;
        font-size: 11px;
        letter-spacing: 5px;
        margin-top: 8px;
    }

    .center-content {
        width: 100%;
        height: 300px;
        padding: 55px 30px;
    }

    .center-content span {
        display: block;
        font-size: 12px;
        text-align: center;
        color: #657380;
        margin-top: 35px;

    }

    #login_btn {
        width: 100%;
        margin-top: 20px;
        background: #7ACEAC;
        border: none;
        height: 37px;
        color: whitesmoke;
    }

    #login_btn:hover {
        background: #4BCF99;
    }

    .layui-form-label {
        width: auto;
    }

    .layui-input-block {
        margin-left: 70px;
    }
</style>

<body>

<div class="center">
    <div class="center-top">
        <span>客户资源系统</span>
        <p>CUSTOMER RESOURCES SYSTEM</p>
    </div>
    <div class="center-content">
        <form id="login_from">
            <div class="layui-form-item">
                <label class="layui-form-label">账号</label>
                <div class="layui-input-block">
                    <input type="text" name="username" id="username" lay-verify="title" autocomplete="off"
                           placeholder="请输入账号" class="layui-input" value="wangyang">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-block">
                    <input type="password" name="password" id="password" lay-verify="title" autocomplete="off"
                           placeholder="请输入密码" class="layui-input" value="wangyang">
                </div>
            </div>
            <div class="layui-form-item" style="padding: 0 30px">
                <button type="submit" id="login_btn" class="btn btn-default" onclick="return Check()">登录</button>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="layui/layui.all.js"></script>
<script type="text/javascript">
    function Check() {
        var username = $("#username").val();
        var password = $("#password").val();
        if (username != null && username != "" && password != null && password != "") {
            var data = new FormData($('#login_from')[0]);
            var index = layer.load(2);
            $.ajax({
                url: "user/login",
                type: "post",
                data: data,
                processData: false,
                contentType: false,
                success: function (json) {
                    layer.close(index);
                    if (json.code == 1) {
                        if (json.type == 0)
                            window.location.href = "sys_index.jsp";
                        else  window.location.href = "user_index.jsp";
                    }
                    else  layer.msg(json.text);
                },
                error: function (a, b, c) {
                    layer.close(index);
                    layer.msg('服务器异常，请重新登录', {icon: 2});
                }
            });
        }
        else {
            layer.msg('请输入账号或密码！', {icon: 2});
        }
        return false;
    }
</script>
</body>
</html>
