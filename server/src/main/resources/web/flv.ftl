<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0">
    <title>多媒体文件预览</title>
    <script src="js/flv.min.js" type="text/javascript"></script>
    <#include "*/commonHeader.ftl">
</head>
<style>
    body {
        background-color: #F4F5F7;
    }
    .m {
        width: 1024px;
        max-width: 100%;
        margin: 0 auto;
    }
</style>
<body>
<div class="m">
    <video width="1024" id="videoElement"></video>
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
