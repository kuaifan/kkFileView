<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>多媒体文件预览</title>
    <#include "*/commonHeader.ftl">
    <link rel="stylesheet" href="plyr/plyr.css"/>
    <script type="text/javascript" src="plyr/plyr.js"></script>
    <style>
        body {
            background-color: #F4F5F7;
       }

        .m {
            width: 1024px;
            margin: 0 auto;
            max-width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .plyr,
        .plyr--ready,
        .plyr__video-wrapper {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .plyr--setup {
            height: 100% !important;
            width: 100% !important;
        }
    </style>
</head>
<body>
<div class="m">
    <video>
        <source src="${mediaUrl}"/>
    </video>
</div>
<script>
    plyr.setup();
    window.onload = function () {
        initWaterMark();
    }
</script>
</body>
</html>
