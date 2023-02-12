<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>多媒体文件预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/flv.min.js" type="text/javascript"></script>
</head>
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
</style>
<body>
<div class="m">
    <video id="videoElement"></video>
</div>
<script>
    if (flvjs.isSupported()) {
        var videoElement = document.getElementById('videoElement');
        var flvPlayer = flvjs.createPlayer({
            type: 'flv',
            url: '${mediaUrl}'
        });
        flvPlayer.attachMediaElement(videoElement);
        flvPlayer.load();
        flvPlayer.play();
    }
    /*初始化水印*/
    window.onload = function() {
      initWaterMark();
    }
</script>
</body>

</html>
