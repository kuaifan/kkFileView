<#setting classic_compatible=true>
<link rel="icon" href="./favicon.ico" type="image/x-icon">
<script src="js/watermark.js" type="text/javascript"></script>

<script>
    /**
     * 初始化水印
     */
    function initWaterMark() {
        let watermarkTxt = '${watermarkTxt}';
        if (watermarkTxt !== '') {
            watermark.init({
                watermark_txt: '${watermarkTxt}',
                watermark_x: 0,
                watermark_y: 0,
                watermark_rows: 0,
                watermark_cols: 0,
                watermark_x_space: ${watermarkXSpace},
                watermark_y_space: ${watermarkYSpace},
                watermark_font: '${watermarkFont}',
                watermark_fontsize: '${watermarkFontsize}',
                watermark_color: '${watermarkColor}',
                watermark_alpha: ${watermarkAlpha},
                watermark_width: ${watermarkWidth},
                watermark_height: ${watermarkHeight},
                watermark_angle: ${watermarkAngle},
            });
        }
        initParentMessage();
    }

    /**
     * 初始化parent消息
     */
    function initParentMessage() {
        if (window.parent) {
            window.parent.postMessage({
                source: 'fileView',
                action: 'ready',
                params: {}
            }, '*');
        }
    }

    /**
     * EEUI 事件
     */
    const eeuiEvents = {
        preview: function (url) {
            if (!url) {
                return;
            }
            window.top.postMessage({
                action: "eeuiAppSendMessage",
                data: [
                    {
                        action: 'setPageData',
                        data: {
                            titleFixed: true,
                            urlFixed: true,
                        }
                    },
                    {
                        action: 'createTarget',
                        url: new URL(url, window.location.href).href,
                    }
                ]
            }, "*")
        }
    }
</script>

<style>
    * {
        margin: 0;
        padding: 0;
    }

    html, body {
        height: 100%;
        width: 100%;
    }
</style>
