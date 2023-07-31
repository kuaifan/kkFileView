<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>PDF图片预览</title>
    <#include "*/commonHeader.ftl">
    <script src="js/jquery-3.6.1.min.js" type="text/javascript"></script>
    <script src="js/lazyload.js"></script>
    <style>
        body {
            background-color: #F4F5F7;
        }
        .container {
            width: 100%;
            height: 100%;
        }
        .img-area {
            text-align: center;
        }
        .my-photo {
            max-width: 100%;
            margin:0 auto;
            border-radius:3px;
            box-shadow:rgba(0,0,0,0.15) 0 0 8px;
            background:#FBFBFB;
        }
        .container {
            padding-right: 0px;
            padding-left: 0px;
        }
    </style>
</head>
<body>
<div class="container">
    <#list imgUrls as img>
        <div class="img-area">
            <img class="my-photo" alt="loading"  data-src="${img}" src="images/grey.gif">
        </div>
    </#list>
</div>
<#if "false" == switchDisabled>
    <img src="images/pdf.svg" width="48" height="48" style="position: fixed; cursor: pointer; top: 40%; right: 48px; z-index: 999;" alt="使用PDF预览" title="使用PDF预览" onclick="changePreviewType('pdf')"/>
</#if>
<script>
    window.onload = function () {
        /*初始化水印*/
        initWaterMark();
        checkImgs();
        /*图片点击事件*/
        if (window.parent) {
            var array = [];
            $(".img-area img").each(function(index, event) {
                array.push($(event).attr("data-src"));
                $(event).click(function() {
                    window.parent.postMessage({
                        source: 'fileView',
                        action: 'picture',
                        params: {
                            index: index,
                            array: array
                        }
                    }, "*");
                });
            });
        }
    };
    window.onscroll = throttle(checkImgs);
    function changePreviewType(previewType) {
        var url = window.location.href;
        if (url.indexOf("officePreviewType=image") !== -1) {
            url = url.replace("officePreviewType=image", "officePreviewType="+previewType);
        } else {
            url = url + "&officePreviewType="+previewType;
        }
        if ('allImages' === previewType) {
            window.open(url)
        } else {
            window.location.href = url;
        }
    }
</script>
</body>
</html>
