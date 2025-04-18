<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <style type="text/css">
        body {
            margin: 0 auto;
            background-color: #CCB;
            height: 100vh;
            display: grid;
            place-items: center;
            overflow: auto;
        }

        .container {
            width: 90%;
            max-width: 700px;
            padding: 24px;
            box-sizing: border-box;
        }

        img {
            width: auto;
            height: auto;
            max-width: 100%;
            max-height: 100%;
            padding-bottom: 36px;
        }

        span {
            display: block;
            font-size: 20px;
            color: blue;
        }
    </style>
</head>

<body>
<div class="container">
    <img src="images/sorry.jpg"/>
    <span id="msg">
        该(${fileType})文件，系统暂不支持在线预览，具体原因如下：
        <p style="color: red;">${msg}</p>
    </span>
</div>
<script>
    var getQueryParam = function(param) {
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        return urlParams.get(param);
    }
    var button = getQueryParam('button') === 'back' ? true : false;
    if (button) {
        // 添加返回上一页按钮
        document.getElementById('msg').innerHTML += '<button onclick="window.history.back()">返回上一页</button>';
    }
</script>
</body>
</html>
