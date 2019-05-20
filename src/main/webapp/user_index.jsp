<%@ page import="com.wenlan.Model.User" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2017/8/3
  Time: 10:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.*" %>
<%--<%--%>
<%--User dtype = (User) session.getAttribute("user");--%>
<%--String type = "";--%>
<%--if (dtype != null) {--%>
<%--if (dtype.getDtype() == 0)--%>
<%--type = "实时资源";--%>
<%--else type = "隔夜资源";--%>
<%--}--%>

<%--%>--%>
<html>
<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="alternate icon" type="image/png" href="img/page_logo.png">
    <title>资源首页</title>
    <link rel="stylesheet" href="layui/css/layui.css">
    <!-- 让IE8/9支持媒体查询，从而兼容栅格 -->
    <!--[if lt IE 9]>
    <script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
    <script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<style>
    * {
        font-family: 微软雅黑;
    }

    iframe {
        width: 100%;
        height: 100%;
    }
</style>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <div class="layui-logo">资源</div>
        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item">
                <a href="javascript:;">
                    <label id="userType">客户</label>：${sessionScope.user.username}
                </a>
            </li>
            <li class="layui-nav-item">
                <a href="javascript:;">
                    提取量：<label id="userCount">${sessionScope.user.count}</label>
                </a>
            </li>
            <li class="layui-nav-item">
                <a href="javascript:;">
                    提取类型：<label id="datatype"></label>
                </a>
            </li>
        </ul>
    </div>

    <div class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul class="layui-nav layui-nav-tree" lay-filter="test">
                <li class="layui-nav-item layui-nav-itemed">
                    <a class="" href="javascript:;">资源管理</a>
                    <dl class="layui-nav-child">
                        <dd><a href="check_user_data.jsp" target="content_iframe">查看资源</a></dd>
                    </dl>
                </li>
            </ul>
        </div>
    </div>

    <div class="layui-body">
        <!-- 内容主体区域 -->
        <iframe id="main_iframe" src="check_user_data.jsp" name="content_iframe" frameborder="no" border="0"></iframe>
    </div>

    <div class="layui-footer">
        <!-- 底部固定区域 -->
        ㊖ 幸运占一半，另一半要靠人的智能，勤以创业，俭以聚财，诚以待人，逊以自处。
    </div>
</div>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script src="layui/layui.all.js"></script>
<script>
    $(function () {
        check_login();
        getUser();
    });
    //JavaScript代码区域
    layui.use('element', function () {
        var element = layui.element;

    });

</script>
<script>
    function getUser() {
        var uid = "<c:out value='${sessionScope.user.uid}' />";
        $.post('user/getUser?uid=' + uid, function (json) {
            $("#userCount").text(json.user.count);
            if (json.user.dtype == 0)
                $("#datatype").text("实时资源");
            else  $("#datatype").text("隔夜资源");
        });
    }
    function check_login() {
        var type = "<c:out value='${sessionScope.type}' />";
        if (type == "") {
            window.location.href = "login.jsp";
        }
    }
</script>
</body>
</html>
