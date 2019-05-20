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
    <title>查看用户资源</title>
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
        <legend>资源</legend>
        <button class="layui-btn" onclick="getData()">获取资源</button>
        <button class="layui-btn" onclick="exportExcel()">导出成excel</button>
        <table class="layui-hide" id="test" lay-filter="test"></table>
        <script type="text/html" id="index">
            <span class="tdspan"></span>
        </script>
    </fieldset>
</div>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="layui/layui.all.js"></script>
<script>
    var index;
    function getData() {
        index = layer.load(2);
        var uid = "<c:out value='${sessionScope.user.uid}' />";
        $.post('user/getUser?uid=' + uid, function (json) {
            if (json.code == 1) {
                layer.close(index);
                $("#userCount", parent.document).text(json.user.count);
            }

        });
    }
    function exportExcel() {
//        index = layer.load(2);
        var type = "<c:out value='${sessionScope.user.dtype}' />";
        var uid = "<c:out value='${sessionScope.user.uid}' />";
        var urlpath;
        if (type == 0)
            urlpath = "client/getUserdataAll";
        else urlpath = "tdata/getUserdataAll";
        $.post(urlpath, {uid: uid}, function (json) {
            if (json.code == 1) {
                layer.close(index);
                table.exportFile(['','名字', '电话'], json.data, 'xls');
            }

        });
//        alert(JSON.stringify(table.cache.testTable));
//        table.exportFile(['名字', '性别'], data, 'xls');
//        table.exportFile(tableIns.config.id, table.cache.testTable,"xls");
    }
</script>
<script>
    var table;
    var tableIns;
    layui.use(['table'], function () {
        table = layui.table;
        var type = "<c:out value='${sessionScope.user.dtype}' />";
        var uid = "<c:out value='${sessionScope.user.uid}' />";
        var urlpath = "";
        if (type == 0)
            urlpath = "client/getUserdata";
        else urlpath = "tdata/getUserdata";
        tableIns = table.render({
            elem: '#test'
            , url: urlpath
            , where: {uid: uid}
            , id: 'testTable'
            , cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            , page: true  //开启分页
            , limits: [100, 500, 1000]  //每页条数的选择项，默认：[10,20,30,40,50,60,70,80,90]。
            , limit: 100 //每页默认显示的数量
            , method: 'post'  //提交方式
            , cols: [[ //表头
                {field: 'index', title: '序号', templet: "#index"}
                , {field: 'name', title: '姓名'}
                , {field: 'tel', title: '电话'}
                , {field: 'date', title: '日期'}
            ]]
            , done: function (res, curr, count) {
                //如果是异步请求数据方式，res即为你接口返回的信息。
                //如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、count为数据总长度
                var limit = res.limit;
                layui.each($('.tdspan'), function (index, item) {
                    $(item).text((curr - 1) * limit + index + 1);
                });
            }
        });
    });
</script>

</body>
</html>
