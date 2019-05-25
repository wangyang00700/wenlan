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
        <legend>客户列表</legend>
        <button class="layui-btn" onclick="getData()">购买选中客户资料</button>
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
    var datatype = "<c:out value='${sessionScope.user.dtype}' />";
    var uid = "<c:out value='${sessionScope.user.uid}' />";
    function getData() {
        var urlpath;
        if (datatype == 0)
            urlpath = "client/setClientByuid";
        else urlpath = "tdata/setTdataByuid";
        var checkStatus = table.checkStatus('testTable')
            , datas = checkStatus.data;
        if (datas.length == 0) {
            layer.msg("未选取客户", {icon: 2});
            return;
        }
        var cids = "";
        for (var i = 0; i < datas.length; i++) {
            cids += "," + datas[i].cid;
        }
        index = layer.load(2);
        $.post(urlpath, {"uid": uid, "cids": cids}, function (json) {
            layer.close(index);
            if (json.code == 1) {
                layer.msg(json.msg, {icon: 1});
                window.parent.getUser();
                tableIns.reload();
            }
            else if (json.code == 2) {
                layer.alert(json.msg, {icon: 1});
            }
            else {
                layer.msg(json.msg, {icon: 2});
            }
        });
    }
</script>
<script>
    var table;
    var tableIns;
    layui.use(['table'], function () {
        table = layui.table;
        var urlpath = "";
        if (datatype == 0)
            urlpath = "client/getAllByUser";
        else urlpath = "tdata/getUserdata";
        tableIns = table.render({
            elem: '#test'
            , url: urlpath
            , where: {uid: uid}
            , id: 'testTable'
            , title: '资源表'
            , cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            , page: true  //开启分页
            , limits: [100, 200, 300, 400, 500, 1000]  //每页条数的选择项，默认：[10,20,30,40,50,60,70,80,90]。
            , limit: 100 //每页默认显示的数量
            , method: 'post'  //提交方式
            , cols: [[ //表头
                {type: 'checkbox'}
                , {field: 'index', title: '序号', templet: "#index", align: "center"}
                , {field: 'name', title: '姓名', align: "center"}
                , {field: 'tel', title: '电话', align: "center"}
                , {field: 'date', title: '日期', align: "center"}
            ]]
            , done: function (res, curr, count) {
                //如果是异步请求数据方式，res即为你接口返回的信息。
                //如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、count为数据总长度
                var limit = res.limit;
                layui.each($('.tdspan'), function (index, item) {
                    $(item).text((curr - 1) * limit + index + 1);
                });
            }
        })
        ;
    })
    ;
</script>
<%--<script>--%>
<%--function JSONToExcelConvertor(JSONData, FileName) {--%>
<%--//先转化json--%>
<%--var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;--%>
<%--var excel = '<table>';--%>
<%--var row = "<tr>";--%>
<%--//设置表头--%>
<%--var keys = Object.keys(JSONData[0]);--%>
<%--keys.forEach(function (item) {--%>
<%--switch (item) {--%>
<%--case'name':--%>
<%--item = '姓名';--%>
<%--break;--%>
<%--case'tel':--%>
<%--item = '电话';--%>
<%--break;--%>
<%--case'date':--%>
<%--item = '日期';--%>
<%--break;--%>
<%--}--%>
<%--row += "<td>" + item + '</td>';--%>
<%--});--%>
<%--//换行--%>
<%--excel += row + "</tr>";--%>
<%--//设置数据--%>
<%--for (var i = 0; i < arrData.length; i++) {--%>
<%--var row = "<tr>";--%>
<%--for (var index in arrData[i]) {--%>
<%--//var value = arrData[i][index] === "." ? "" : arrData[i][index];--%>
<%--row += '<td>' + arrData[i][index] + '</td>';--%>
<%--}--%>
<%--excel += row + "</tr>";--%>
<%--}--%>

<%--excel += "</table>";--%>

<%--var excelFile = "<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:x='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'>";--%>
<%--excelFile += '<meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';--%>
<%--excelFile += '<meta http-equiv="content-type" content="application/vnd.ms-excel';--%>
<%--excelFile += '; charset=UTF-8">';--%>
<%--excelFile += "<head>";--%>
<%--excelFile += "<!--[if gte mso 9]>";--%>
<%--excelFile += "<xml>";--%>
<%--excelFile += "<x:ExcelWorkbook>";--%>
<%--excelFile += "<x:ExcelWorksheets>";--%>
<%--excelFile += "<x:ExcelWorksheet>";--%>
<%--excelFile += "<x:Name>";--%>
<%--excelFile += "{worksheet}";--%>
<%--excelFile += "</x:Name>";--%>
<%--excelFile += "<x:WorksheetOptions>";--%>
<%--excelFile += "<x:DisplayGridlines/>";--%>
<%--excelFile += "</x:WorksheetOptions>";--%>
<%--excelFile += "</x:ExcelWorksheet>";--%>
<%--excelFile += "</x:ExcelWorksheets>";--%>
<%--excelFile += "</x:ExcelWorkbook>";--%>
<%--excelFile += "</xml>";--%>
<%--excelFile += "<![endif]-->";--%>
<%--excelFile += "</head>";--%>
<%--excelFile += "<body>";--%>
<%--excelFile += excel;--%>
<%--excelFile += "</body>";--%>
<%--excelFile += "</html>";--%>

<%--var uri = 'data:application/vnd.ms-excel;charset=utf-8,' + encodeURIComponent(excelFile);--%>

<%--var link = document.createElement("a");--%>
<%--link.href = uri;--%>

<%--link.style = "visibility:hidden";--%>
<%--link.download = FileName + ".xls";--%>

<%--document.body.appendChild(link);--%>
<%--link.click();--%>
<%--document.body.removeChild(link);--%>
<%--}--%>
<%--</script>--%>
</body>
</html>
