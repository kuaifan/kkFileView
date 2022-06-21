<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <style type="text/css">
        body{
            margin: 0 auto;
            background-color: #CCB;
        }
        .container{
            width: 700px;
            height: 700px;
            max-width: 90%;
            max-height: 90%;
            margin: 0 auto;
        }
        img{
            width:auto;
            height:auto;
            max-width:100%;
            max-height:100%;
            padding-bottom: 36px;
        }
        span{
            display: block;
            font-size:20px;
            color:blue;
        }
    </style>
</head>
<body>
<div class="container">
    <img src="images/sorry.jpg" />
    <span>
    该文件类型(${fileType})系统暂时不支持在线预览，<b>说明</b>：
        <p style="color: red;">${msg}</p>
    </span>
</div>
</body>

</html>
