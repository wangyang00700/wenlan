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
    <title>查看实时资源</title>
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
    <table class="layui-hide" id="test" lay-filter="test"></table>
    <script type="text/html" id="toolbarDemo">
        <div class="layui-btn-container">
            <button class="layui-btn layui-btn-sm" lay-event="delete_ok_data">清空已提取数据</button>
            <button class="layui-btn layui-btn-sm" lay-event="delete_all_data">清空全部数据</button>
            <lable class="layui-btn-sm" id="okcount"></lable>
            <%--<button class="layui-btn layui-btn-sm" lay-event="outline">全部禁用</button>--%>
            <%--<button class="layui-btn layui-btn-sm" lay-event="savenow">保存当前页更改</button>--%>
        </div>
    </script>
    <script type="text/html" id="index">
        <span class="tdspan"></span>
    </script>
</div>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="layui/layui.all.js"></script>
<script>
    layui.use('table', function () {
        var table = layui.table;
        var index;
        var tableIns = table.render({
            elem: '#test'
            , url: 'client/getdata'
            , id: 'testTable'
            , cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            , toolbar: '#toolbarDemo'
            , defaultToolbar: ['exports']
            , page: true  //开启分页
            , limits: [100, 500, 1000]  //每页条数的选择项，默认：[10,20,30,40,50,60,70,80,90]。
            , limit: 100 //每页默认显示的数量
            , method: 'post'  //提交方式
            , cols: [[ //表头
                {field: 'index', title: '序号', templet: "#index"}
                , {field: 'name', title: '姓名'}
                , {field: 'tel', title: '电话'}
                , {field: 'date', title: '日期'}
//                , {field: 'status', title: '状态(0禁用1启用)', sort: true, edit: 'text'}
//                , {fixed: 'right', title: '操作', toolbar: '#barDemo', width: 150, align: 'center'}
            ]]
            , done: function (res, curr, count) {
                var limit = res.limit;
                layui.each($('.tdspan'), function (index, item) {
                    $(item).text((curr - 1) * limit + index + 1);
                });
                //如果是异步请求数据方式，res即为你接口返回的信息。
                //如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、count为数据总长度
                $("#okcount").text("已提取" + res.okcount + "条数据");

            }
        });

        //头工具栏事件
        table.on('toolbar(test)', function (obj) {
            switch (obj.event) {
                case 'delete_ok_data':
                    index = layer.load(2);
                    $.post('client/delete?type=1', function (json) {
                        if (json.code == 1) {
                            tableIns.reload();
                            layer.close(index);
                            layer.msg("已提取资源删除成功", {icon: 1});
                        }

                    });
                    break;
                case 'delete_all_data':
                    layer.confirm('确定删除全部资源？', {
                        btn: ['确定', '取消'] //按钮
                    }, function () {
                        index = layer.load(2);
                        $.post('client/delete?type=0', function (json) {
                            if (json.code == 1) {
                                tableIns.reload();
                                layer.close(index);
                                layer.msg("全部资源删除成功", {icon: 1});
                            }

                        });
                    }, function () {
                        layer.close(index);
                    });

                    break;
            }
        });

    });
</script>

</body>
</html>
