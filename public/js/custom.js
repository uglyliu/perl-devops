

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

//编辑产品页面
function productEditPage(id){
	flushHtmlByAjax("/product/editPage/"+id,"centerContent");
}

//新增产品页面
function productAddPage(){
	flushHtmlByAjax("/product/addPage","centerContent");
}

//新增产品版本页面
function versionAddPage(productId){
	flushHtmlByAjax("/product/version/addPage/"+productId,"centerContent");
}

//编辑产品版本页面
function productEditPage(id){
	flushHtmlByAjax("/product/version/editPage/"+id,"centerContent");
}
