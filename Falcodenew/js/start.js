$(function() {
	setTimeout(function(){
		$('.start').fadeOut(500);
	},14000); //2.5秒後にロゴ含め真っ白背景をフェードアウト！
});

$(function(){
    $(".mainSite").css({opacity:'0'});
    setTimeout(function(){
    $(".mainSite").css("display", "block");
    $(".mainSite").stop().animate({opacity:'1'},1500);//1秒かけてコンテンツを表示
    },14000);//約4秒後に
   });