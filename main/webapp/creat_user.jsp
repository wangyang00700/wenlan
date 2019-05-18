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
    <title>开户</title>
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
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;padding: 10px 20px">
        <legend>创建用户</legend>
        <form class="layui-form" action="">
            <div class="layui-form-item">
                <label class="layui-form-label">登录账号</label>
                <div class="layui-input-block">
                    <input type="text" id="username" name="username" lay-verify="required" placeholder="输入登录账号"
                           autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">登录密码</label>
                <div class="layui-input-block">
                    <input type="text" id="password" name="password" lay-verify="required" placeholder="输入登录密码"
                           autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">提取数量</label>
                <div class="layui-input-block">
                    <input type="number" id="count" name="count" lay-verify="required|number" placeholder="输入提取数量"
                           autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-normal" lay-submit lay-filter="*">提交创建
                    </button>
                </div>
            </div>
        </form>
    </fieldset>
</div>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="layui/layui.all.js"></script>
<script>
    layui.use('form', function () {
        var form = layui.form;
        var index;
        form.on('submit(*)', function (data) {
            index = layer.load(2);
            $.post('user/insert', {
                "username": data.field.username,
                "password": data.field.password,
                "count": data.field.count
            }, function (json) {
                layer.close(index);
                if (json.code == 1) {
                    layer.msg("创建成功", {icon: 1});
                }
                else   layer.msg(json.msg);
            });
            return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
        });
    });

</script>
</body>
</html>
