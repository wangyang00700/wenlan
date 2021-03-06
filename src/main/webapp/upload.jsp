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
    <title>资源上传</title>
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

    .layui-upload-drag {
        width: 100%;
        padding: 0;
        padding-top: 50px;
        padding-bottom: 50px;
    }
</style>
<body>
<div class="layui-container">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;padding: 10px 20px">
        <legend>设置起止时间</legend>
        <div class="layui-inline">
            <div class="layui-inline">
                <label class="layui-form-label">开始日期</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="startDate">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">开始时间</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="startTime">
                </div>
            </div>
        </div>
        <div style="margin-top: 10px">
            <div class="layui-inline">
                <label class="layui-form-label">结束日期</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="endDate">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">结束时间</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="endTime">
                </div>
            </div>
        </div>

    </fieldset>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;padding: 10px 20px">
        <legend>上传实时资源</legend>
        <div class="layui-upload-drag" id="test1">
            <i class="layui-icon">&#xe67c;</i>
            <p>点击上传，或将文件拖拽到此处</p>
        </div>
    </fieldset>

    <%--<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;padding: 10px 20px">--%>
    <%--<legend>上传隔夜资源</legend>--%>
    <%--<div class="layui-upload-drag " id="test2">--%>
    <%--<i class="layui-icon">&#xe67c;</i>--%>
    <%--<p>点击上传，或将文件拖拽到此处</p>--%>
    <%--</div>--%>
    <%--</fieldset>--%>

</div>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="layui/layui.all.js"></script>
<script>
    layui.use('upload', function () {
        var upload = layui.upload;
        var index;
        var datetime = "";
        //执行实例
        var uploadInst = upload.render({
            elem: '#test1' //绑定元素
            , url: 'client/upload/' //上传接口
            , data: {
                startDate: function () {
                    return $("#startDate").val() + " " + $("#startTime").val();
                }
                , endDate: function () {
                    return $("#endDate").val() + " " + $("#endTime").val();
                }
            }
            , field: 'excel'
            , accept: 'file'
            , exts: 'xls|xlsx'
            , before: function () {
                index = layer.load(2);
            }
            , done: function (res) {
                //上传完毕回调
                layer.close(index);
                if (res.code == 1)
                    layer.msg(res.text, {icon: 1});
                else layer.alert(res.text);
            }
            , error: function () {
                //请求异常回调
                layer.close(index);
            }
        });
        //执行实例
        var uploadInst2 = upload.render({
            elem: '#test2' //绑定元素
            , url: 'tdata/upload/' //上传接口
            , field: 'excel'
            , accept: 'file'
            , exts: 'xls|xlsx'
            , before: function () {
                index = layer.load(2);
            }
            , done: function (res) {
                //上传完毕回调
                layer.close(index);
                if (res.code == 1)
                    layer.msg(res.text, {icon: 1});
                else layer.alert(res.text);
            }
            , error: function () {
                //请求异常回调
                layer.close(index);
            }
        });
    });
    layui.use('laydate', function () {
        var laydate = layui.laydate;
        var myDate = new Date();
        var nowdate = myDate.getFullYear() + "/" + (myDate.getMonth() + 1) + "/" + myDate.getDate();
        var nowtime = myDate.getHours() + ":" + myDate.getMinutes() ;
        //执行一个laydate实例
        laydate.render({
            elem: '#startDate' //指定元素
            , type: "date"
            , format: "yyyy/MM/dd"
            , min: -1
            , max: 1
            , value: nowdate
        });
        laydate.render({
            elem: '#startTime' //指定元素
            , type: "time"
            , value: nowtime
            ,format: 'HH:mm'
        });
        laydate.render({
            elem: '#endDate' //指定元素
            , type: "date"
            , format: "yyyy/MM/dd"
            , min: -1
            , max: 1
            , value: nowdate
        });
        laydate.render({
            elem: '#endTime' //指定元素
            , type: "time"
            ,format: 'HH:mm'
            , value: nowtime
        });
    });
</script>

</body>
</html>
