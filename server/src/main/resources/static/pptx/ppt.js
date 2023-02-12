/**
 * Copyright 2013 I Doc View
 * @author Godwin <I Doc View>
 */
var ratio = 0.75;
var pages;
var slideUrls = new Array();
var slideThumbUrls = new Array();
var curSlide = 1;
var totalSize = 1;	// PPT当前获取到的总页数
var slideCount = 1;	// PPT文件总页数

$(document).ready(function () {
    var data = resultData
    var code = data.code;
    if (1 == code) {
        uuid = data.uuid;
        pages = data.data;
        totalSize = pages.length;
        slideCount = data.totalSize;

        // title
        if (typeof uuid !== "undefined") {
            $('.container-fluid:first .btn:first').after('<a class="brand lnk-file-title" style="text-decoration: none;">' + data.name + '</a>');
        }
        document.title = data.name;

        // set ratio
        ratio = pages[0].ratio;

        // reset all content
        resetContent();

        afterLoad();
    } else {
        $('.container-fluid .row-fluid').html('<section><div class="alert alert-error">' + data.desc + '</div></section>');
    }
    clearProgress();

    // 是否显示全屏按钮
    $('.fullscreen-link').toggle(screenfull.enabled);
    // 全屏事件
    $('.fullscreen-link').click(function () {
        if (screenfull.enabled) {
            screenfull.toggle($('.slide-img-container')[0]);
        }
    });
    $(document).bind("fullscreenchange", function () {
        if (screenfull.isFullscreen) {
            $('.slide-img-container').css('background-color', 'black');
            $('.slide-img-container').contextMenu(true);
        } else {
            $('.slide-img-container').css('background-color', '');
            $('.slide-img-container').contextMenu(false);
        }
    });

    $('.select-page-selector').change(function () {
        var selectNum = $(".select-page-selector option:selected").text();
        gotoSlide(selectNum);
    });

	var isSupportTouch = "ontouchend" in document;
	var imgContainer = $('.slide-img-container');
	var leftMask = $('.slide-img-container .ppt-turn-left-mask');
	var rightMask = $('.slide-img-container .ppt-turn-right-mask');
	if (isSupportTouch) {
		leftMask.hide();
		rightMask.hide();
		var mRatio = Math.min(80, $(window).width() * 0.3)
		var isTouch = false;
		var touchMX
		imgContainer[0].addEventListener('touchstart', function(e){
            isTouch = true;
			touchMX = e.touches[0].clientX;
		});
		imgContainer[0].addEventListener('touchmove', function(e){
			if (isTouch) {
				e.preventDefault();
				var moX = touchMX - e.touches[0].clientX;
				if (moX > mRatio) {
					isTouch = false;
					nextSlide();
				} else if (moX < mRatio * -1) {
					isTouch = false;
					preSlide();
				}
			}
		});
		imgContainer[0].addEventListener('click', function() {
			if (window.parent) {
				var array = [];
				$.each(pages, function(index, page) {
					array.push(page.url);
				});
				window.parent.postMessage({
					source: 'fileView',
					action: 'picture',
					params: {
						index: getCurSlide() - 1,
						array: array
					}                        
				}, "*");
			}
		});
	} else {
		leftMask.click(function () {
			preSlide();
		});
		rightMask.click(function () {
			nextSlide();
		});
	}

    // Right click (NOT supported in SOUGOU browser)
    /*
    $.contextMenu({
        selector: '.slide-img-container',
        items: {
            "next": {
                name: "下一张",
                callback: function(key, options) {
                    nextSlide();
                }
            },
            "previous": {
                name: "上一张",
                callback: function(key, options) {
                    preSlide();
                }
            },
            "sep1": "---------",
            "exit": {
                name: "结束放映",
                callback: function(key, options) {
                    $('.slide-img-container').fullScreen(false);
                }
            },
        }
    });
    */
    $('.slide-img-container').contextMenu(false);

    // Swipe method is NOT supported in IE6, so it should be the last one.
    try {
        $('.slide-img-container').swipeleft(function () {
            nextSlide();
        });
        $('.slide-img-container').swiperight(function () {
            preSlide();
        });
    } catch (err) {

    }
    
	//
	if (window.parent) {
		window.parent.postMessage({
			source: 'fileView',
			action: 'ready',
			params: {}
		}, '*');
	}
});

var remainContentInterval;

function checkRemainContent() {
    clearInterval(remainContentInterval);
    if (slideCount == totalSize) {
        return;
    }

}

function resetContent() {
    remainContentInterval = setInterval(checkRemainContent, 8000);

    // clear all content
    $('.row-fluid .span2').empty();
    $('.select-page-selector').empty();
    $('.select-page-selector-sync').empty();
    $('.slide-img-container img').remove();

    // 限制预览页数开始
    var viewCheck = authMap.view;
    if (!!viewCheck && (viewCheck > 1) && (pages.length > viewCheck)) {
        $('.navbar').after('<div class="alert alert-info" style="text-align: center; color: red;">试读结束，支付后阅读全文！</div>');
        totalSize = viewCheck;
        clearInterval(remainContentInterval);
    }
    // 限制预览页数结束

    // pages
    for (i = 0; i < totalSize; i++) {
        var page = pages[i];
        slideUrls[i] = page.url;
        slideThumbUrls[i] = page.thumbUrl;
        $('.row-fluid .span2').append('<div class="thumbnail" page="' + (i + 1) + '"><img src="' + page.thumbUrl + '"></div><div class="thumb-page-number-container">' + (i + 1) + '/' + slideCount + '</div>');
        $('.select-page-selector').append('<option>' + (i + 1) + '</option>');
        $('.select-page-selector-sync').append('<option>' + (i + 1) + '</option>');
    }

    // 未转换完成提示信息
    if (totalSize < slideCount) {
        $('.row-fluid .span2').prepend('<div style="color: red;">转换中(' + Math.floor((totalSize / slideCount) * 100) + '%)，请稍候……</div>');
    }

    $('.slide-img-container').append('<img src="' + slideUrls[curSlide - 1] + '" class="img-polaroid" style="height: 100%;">');
    var thumbnailWidth = $('.thumbnail:first').width();
    var thumbnailHeight = thumbnailWidth * ratio;
    $('.thumbnail').height(thumbnailHeight);
    $('.thumbnail>img').width(thumbnailWidth).height(thumbnailHeight);

    var slideImgContainerWidth = $('.slide-img-container:first').width();
    var slideImgContainerHeight = slideImgContainerWidth * ratio;
    $('.slide-img-container').height(slideImgContainerHeight);

    resetImgSize();

    var percent = Math.ceil((curSlide / slideUrls.length) * 100);
    $('.thumbnail[page="' + curSlide + '"]').addClass('ppt-thumb-border');

    // $('.thumbnail[page="' + curSlide + '"]').animate({scrollTop:($(window).height()/2)}, 'slow');

    $('.select-page-selector').val(curSlide);
    $('.bottom-paging-progress .bar').width('' + percent + '%');

    $('.thumbnail').click(function () {
        var page_num = $(this).attr('page');
        gotoSlide(page_num);
    });
}

$(window).resize(function () {
    resetImgSize();
});

function resetImgSize() {
    var ww;
	var wh = $(window).height() - 90;
	var span2 = $('.row-fluid .span2');
    var windowW = $(window).width();
    if (windowW < 768) {
        $('.hidden-phone').css('display', 'none');
        $('.span9').removeClass('offset2');
        ww = windowW - $('.span9').offset().left * 2;
    } else {
        $('.hidden-phone').css('display', 'block');
        $('.span9').addClass('offset2');
        ww = windowW - $('.span9').offset().left * 2 + span2.outerWidth() + span2.offset().left;
    }
    if (screenfull.isFullscreen) {
		ww = windowW - 30;
        wh = wh + 80;
    }
	var ch;
    if (wh / ww < ratio) {
		ch = wh
		$('.slide-img-container').height(ch);
        $('.slide-img-container').width(wh / ratio);
    } else {
		ch = ww * ratio
        $('.slide-img-container').width(ww);
		$('.slide-img-container').height(ch);
	}
	//
	var tbh;
	if (screenfull.enabled) {
		tbh = 60;
		$('.navbar').show();
	} else {
		tbh = 75;
		$('.navbar').hide();
    }
	$('.slide-img-container').css('top', `${$(window).height() / 2 - tbh - (ch / 2)}px`);
	$('.slide-img-container img').css('box-sizing', 'border-box');
}

$(document).keydown(function (event) {
    if (event.keyCode == 37 || event.keyCode == 38 || event.keyCode == 33) {	// 37 left, 38 up, 33 pageUp
        preSlide();
    } else if (event.keyCode == 39 || event.keyCode == 40 || event.keyCode == 32 || event.keyCode == 34) {	// 39 right, 40 down, 32 space, 34 pageDown
        nextSlide();
    } else if (event.keyCode == 13) {
        screenfull.toggle($('.slide-img-container')[0]);
    }
});

function getCurSlide() {
    return curSlide;
}

function preSlide() {
    var preSlide = eval(Number(getCurSlide()) - 1);
    gotoSlide(preSlide);
}

function nextSlide() {
    var nextSlide = eval(Number(getCurSlide()) + 1);
    gotoSlide(nextSlide);
}

function gotoSlide(slide) {
    var slideSum = slideUrls.length;
    if (slide <= 0) {
        slide = 1;
    } else if (slideSum < slide) {
        slide = slideSum;
    }
    curSlide = slide;
    /*
    $(".slide-img-container img").fadeOut(function() {
        $(this).attr("src", slideUrls[slide - 1]).fadeIn();
    });
    */
    $(".slide-img-container img").attr("src", slideUrls[slide - 1]);
    var percent = Math.ceil((curSlide / slideUrls.length) * 100);
    $('.thumbnail').removeClass('ppt-thumb-border');
    $('.thumbnail[page="' + slide + '"]').addClass('ppt-thumb-border');
    var thumbTop = slide * ($('.thumbnail[page="' + 1 + '"]').height() + 10 + $('.thumb-page-number-container').height()) - ($(document).height() / 2);
    $('.span2 ').animate({scrollTop: (thumbTop)}, 'slow');
    $('.select-page-selector').val(slide);
    $('.select-page-selector-sync').val(slide);
    $('.bottom-paging-progress .bar').width('' + percent + '%');


}
