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
                    <label id="userType">管理员</label>：${sessionScope.user.username}
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
                        <dd><a href="upload.jsp" target="content_iframe">上传资源</a></dd>
                        <dd><a href="check_now_data.jsp" target="content_iframe">实时资源</a></dd>
                        <%--<dd><a href="check_tonight_data.jsp" target="content_iframe">隔夜资源</a></dd>--%>
                    </dl>
                </li>
                <li class="layui-nav-item ">
                    <a href="javascript:;">用户管理</a>
                    <dl class="layui-nav-child">
                        <dd><a href="creat_user.jsp" target="content_iframe">开户</a></dd>
                        <dd><a href="check_user.jsp" target="content_iframe">查看用户</a></dd>
                    </dl>
                </li>
            </ul>
        </div>
    </div>

    <div class="layui-body">
        <!-- 内容主体区域 -->
        <iframe id="main_iframe" src="upload.jsp" name="content_iframe" frameborder="no" border="0"></iframe>
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
    });
    //JavaScript代码区域
    layui.use('element', function () {
        var element = layui.element;

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
