

function flushHtmlByAjax(url,tagId){
	jQuery.ajax({
		  url: url,
		  type: 'get',
		  dataType: 'html',
		  success: function (data, status) {
			jQuery("#"+tagId).html(data);
		  },
		  fail: function (err, status) {
			console.log(err)
		  }
	})

}


function productDetail(id){
	flushHtmlByAjax("/product/detail/"+id,"centerContent");
}