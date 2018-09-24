// var ws;
var ws;
var log = function (text) {
  jQuery('#log').val(jQuery('#log').val() + text + "\n");
};
jQuery(document).ready(function(){
	//  ws  = new WebSocket("ws://127.0.0.1:8080/k8s/log");
	//  console.log("====ws======",ws);
	//  ws.onopen = function(){
 //      	console.log("==========",ws);
 //      	ws.send("发送数据");
 //      	console.log("数据发送中...");
 //     };

	// //接收消息
	// ws.onmessage = function (e) {

	// 	jQuery("#chatmessageinner").append("<p class=\"reply\"><span class=\"msg\">"+e.data+"</span></p>");
	// };

	console.log('start connection...');
  	var timerID = 0;
 	function keepAlive() {
	    // 14000 was the default
	    var timeout = 140000;
	    if (ws.readyState == ws.OPEN) {
	      console.log('keep alive: ' + timerID++);
	      ws.send('');
	    } else {
	      console.log('websocket IS CLOSED!! ');
	    }
	    timerId = setTimeout(keepAlive, timeout);
  	}
  	function cancelKeepAlive() {
   	 	if (timerId) {
     		clearTimeout(timerId);
    	}
  	}

	socketinit();
	keepAlive();
	jQuery('#msg').focus();

	jQuery('#msg').keydown(function (e) {
	    if (e.keyCode == 13 && jQuery('#msg').val()) {
	      console.log('ws: ', ws);
	      if (ws.readyState == 1) {
	        ws.send(jQuery('#msg').val());
	        jQuery('#msg').val('');
	      } else {
	        log('Connection with server is lost');
	    	socketinit();
	      }
	    }
  	});

	
});
//发送消息
// function sendChat() {

// 	ws  = new WebSocket("ws://localhost:8080/k8s/log");
// 	console.log("==========",ws);
// 	ws.send(jQuery("#msgbox").val());
// 	jQuery("#msgbox").val("");

// }


function socketinit() {
  console.log('init websocket....');

  let o = window.location.origin;
  let uri = o.replace("http", "ws");
  console.log('location.origin NEW: ', uri)

  ws = new WebSocket(uri + '/k8s/log');
  ws.onopen = function () {
    log('websocket opened');
  };

  ws.onmessage = function (msg) {
    var res = JSON.parse(msg.data);
    log('[' + res.hms + '] ' + res.text);
  };
  ws.onclose = function (evt) {
    log('websocket onclose');
  }
}