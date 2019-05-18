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
    <title>查看用户</title>
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
        <legend>查看用户</legend>
        <table class="layui-hide" id="test" lay-filter="test"></table>
        <script type="text/html" id="toolbarDemo">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-sm" lay-event="saveCount">保存此页提取量</button>
            </div>
        </script>
        <script type="text/html" id="barDemo">
            <a class="layui-btn layui-btn-xs" lay-event="save">保存</a>
            <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
        </script>
    </fieldset>
</div>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="layui/layui.all.js"></script>
<script>
    layui.use('table', function () {
        var table = layui.table;

        var tableIns = table.render({
            elem: '#test'
            , url: 'user/lookUser'
            , id: 'testTable'
            , toolbar: '#toolbarDemo'
            , defaultToolbar: []
            , cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            , page: true  //开启分页
            , limits: [10, 30, 50]  //每页条数的选择项，默认：[10,20,30,40,50,60,70,80,90]。
            , limit: 10 //每页默认显示的数量
            , method: 'post'  //提交方式
            , cols: [[ //表头
                {field: 'uid', title: 'ID', sort: true}
                , {field: 'username', title: '账号', sort: true, edit: 'text'}
                , {field: 'password', title: '密码', edit: 'text'}
                , {field: 'count', title: '提取量', sort: true, edit: 'number'}
                , {fixed: 'right', title: '操作', toolbar: '#barDemo', align: 'center'}
//                , {field: 'status', title: '状态(0禁用1启用)', sort: true, edit: 'text'}
//                , {fixed: 'right', title: '操作', toolbar: '#barDemo', width: 150, align: 'center'}
            ]]
        });
        //头工具栏事件
        table.on('toolbar(test)', function (obj) {
            switch (obj.event) {
                case 'saveCount':
                    var data = table.cache.testTable;
                    var d = '';
                    for (var i = 0; i < data.length; i++) {
                        d += ',' + data[i].uid + ',' + data[i].count;
                    }
                    $.post('user/update', {"data": d}, function (json) {
                        if (json.code == 1) {
                            layer.msg("保存成功", {icon: 1});
                        }

                    });
                    break;
            }
        });

        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            switch (obj.event) {
                case 'save':
                    var d = ',' + data.uid + ',' + data.count;
                    $.post('user/update', {"data": d}, function (json) {
                        if (json.code == 1)
                            layer.msg("保存成功", {icon: 1});
                    });
                    break;
                case 'delete':
                    $.post('user/delete', {"uid": data.uid}, function (json) {
                        if (json.code == 1) {
                            tableIns.reload();
                            layer.msg("删除成功", {icon: 1});
                        }
                    });
                    break;
            }
        });
    });
</script>
</body>
</html>
