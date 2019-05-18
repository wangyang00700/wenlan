<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2017/8/10
  Time: 14:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="alternate icon" type="image/png" href="img/page_logo.png">
    <link rel="stylesheet" href="layui/css/layui.css">
    <script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
    <script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
    <title>用户资源首页</title>
</head>
<style>

    * {
        font-family: 微软雅黑;
    }

    body {
        background-color: white;
    }

    .layui-container {
        padding: 0;
    }
</style>
<body>
<div class="layui-container">
    <fieldset class="layui-elem-field" style="margin-top: 30px;padding: 10px 20px">
        <legend>查询客户客服绑定</legend>
        <form class="layui-form" action="">
            <div class="layui-form-item">
                <label class="layui-form-label">客户手机</label>
                <div class="layui-input-block">
                    <input type="tel" id="phone" name="phone" lay-verify="required|phone" placeholder="请输入手机号码"
                           autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">客服工号</label>
                <div class="layui-input-block">
                    <input type="text" id="ccname" name="ccname" class="layui-input" disabled="disabled">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="demo1"
                            onclick="return check();">立即查询
                    </button>
                </div>
            </div>
        </form>
    </fieldset>
</div>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="layui/layui.all.js"></script>
<script>
    $(function () {
        check_login();
    });
</script>
<script>
    function check_login() {
        var type = "<c:out value='${sessionScope.type}' />";
        if (type == "") {
            window.location.href = "login.jsp";
        }
    }
</script>
</body>
</html>
