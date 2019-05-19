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

    /* 防止下拉框下拉值被遮盖*/
    .layui-table-cell {
        overflow: visible;
    }

    .layui-table-box {
        overflow: visible;
    }

    .layui-table-body {
        overflow: visible;
    }

    /* 调整高度 */
    td .layui-form-select {
        margin-top: -10px;
        margin-left: -15px;
        margin-right: -15px;
    }
</style>
<body>
<div class="layui-container">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;padding: 10px 20px">
        <legend>查看用户</legend>
        <table class="layui-hide" id="test" lay-filter="test"></table>
        <script type="text/html" id="toolbarDemo">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-sm" lay-event="saveCount">批量修改此页</button>
            </div>
        </script>
        <script type="text/html" id="barDemo">
            <a class="layui-btn layui-btn-xs" lay-event="save">保存</a>
            <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
        </script>
        <script type="text/html" id="select">
            <select name="dtype" id="dtype" lay-filter="dtype">
                <option value="0">实时资源</option>
                <option value="1">隔夜资源</option>
            </select>
        </script>
    </fieldset>
</div>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="layui/layui.all.js"></script>
<script>
    layui.use(['table', 'form'], function () {
        var table = layui.table, form = layui.form;

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
                , {field: 'username', title: '账号', sort: true}
                , {field: 'password', title: '密码'}
                , {field: 'dtype', title: '提取类型', templet: "#select"}
                , {field: 'count', title: '提取量', sort: true, edit: 'number'}
                , {fixed: 'right', title: '操作', toolbar: '#barDemo', align: 'center'}
//                , {field: 'status', title: '状态(0禁用1启用)', sort: true, edit: 'text'}
//                , {fixed: 'right', title: '操作', toolbar: '#barDemo', width: 150, align: 'center'}
            ]],
            done: function (res, curr, count) {
                layui.each($('td select'), function (index, item) {
                    var elem = $(item);
                    elem.val(res.data[index].dtype).parents('div.layui-table-cell').css('overflow', 'visible');
                });
                form.render();
            }

        });

        form.on('select(dtype)', function (data) {
            var elem = $(data.elem);
            var trElem = elem.parents('tr');
            var tableData = table.cache.testTable;
            // 更新到表格的缓存数据中，才能在获得选中行等等其他的方法中得到更新之后的值
            tableData[trElem.data('index')][elem.attr('name')] = data.value;
        });


        //头工具栏事件
        table.on('toolbar(test)', function (obj) {
            switch (obj.event) {
                case 'saveCount':
                    var data = table.cache.testTable;
                    var d = '';
                    for (var i = 0; i < data.length; i++) {
                        d += ',' + data[i].uid + ',' + data[i].dtype + ',' + data[i].count;
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
                    var d = ',' + data.uid + ',' + data.dtype + ',' + data.count;
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
