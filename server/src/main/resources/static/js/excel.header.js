/**创建一个div并固定在底部，将center中的所有a标签放在改div中**/
$("body").append($("<div>").css({
    "width": "100%",
    "max-height": "92px",
    "position": "fixed",
    "left": "0",
    "bottom": "0",
    "background-color": "rgba(53, 53, 53, 1)",
    "overflow": "auto"
}).append($("<div>").css({
    "width": "100%",
    "line-height": "30px",
    "font-size": "13px",
    "overflow": "hidden",
    "display": "flex",
    "flex-wrap": "wrap",
    "margin-top": "-1px",
    "margin-left": "-1px"
}).attr("id", "excel-header-nav")));
var centerChildrenA = $("center").children("a");
if (centerChildrenA.length === 0) {
    $("#excel-header-nav").hide();
}
$(centerChildrenA).each(function (a, b) {
    // 获取a标签对应的target的name值，并设置name对应标签的样式以避免锚点标签标题被覆盖
    var href = $(b).attr("href");
    var name = href.substr(1);
    $("[name=" + name + "]").css({
        "display": "flex",
        "flex-direction": "column",
        "flex-wrap": "wrap",
    });
    $(b).css({
        "padding": "0 8px",
        "border": "1px solid white",
        "color": "#f9f9f9",
        "margin-right": "-1px",
        "margin-bottom": "-1px",
    });
    $("#excel-header-nav").append(b);
});
/**给所有的table添加class=table table-striped样式**/
$("table").addClass("table table-striped");
/**去除顶部空白**/
var prev = $("[name=table0]").prev();
while (prev.length > 0) {
    prev.hide();
    prev = prev.prev();
}
/**显示页面**/
$('body').css({
    'visibility': 'visible',
    'padding-bottom': $("#excel-header-nav").height()
})
/**初始化缩放**/
var touchScale = new TouchScale(document.body);
touchScale.picInit();
