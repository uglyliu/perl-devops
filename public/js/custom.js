

function flushHtmlByAjax(url,tagId){
	jQuery.ajax({
		  url: url,
		  type: 'get',
		  dataType: 'html',
		  success: function (data, status) {
			jQuery("#"+tagId).html(data);
		  },
		  fail: function (err, status) {
			console.log("加载页面失败",url,err);
		  }
	})
}

function productEditPage(id){
	flushHtmlByAjax("/product/editPage/"+id,"centerContent");
}

function productVersionPage(id){
	flushHtmlByAjax("/product/version/"+id,"centerContent");
}

function productAddPage(){
	flushHtmlByAjax("/product/addPage","centerContent");
}

