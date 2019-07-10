<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>迅雷快鸟</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/res/fastd1ck.js"></script>
<script src="/state.js"></script>
<script src="/help.js"></script>
<style>
	.show-btn1, .show-btn2, .show-btn3 {
		border: 1px solid #222;
		background: linear-gradient(to bottom, #919fa4  0%, #67767d 100%); /* W3C */
		font-size:10pt;
		color: #fff;
		padding: 10px 3.75px;
		border-radius: 5px 5px 0px 0px;
		width:8.45601%;
	}
	.active {
		background: #2f3a3e;
		background: linear-gradient(to bottom, #61b5de  0%, #279fd9 100%); /* W3C */
	}
	.popup_bar_bg_ks{
		position:fixed;	
		margin: auto;
		top: 0;
		left: 0;
		width:100%;
		height:100%;
		z-index:99;
		filter:alpha(opacity=90);  /*IE5、IE5.5、IE6、IE7*/
		background-repeat: repeat;
		visibility:hidden;
		overflow:hidden;
		background-color: #444F53;
		background:rgba(68, 79, 83, 0.9) none repeat scroll 0 0 !important;
	}
	.ss_btn {
		border: 1px solid #222;
		background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
		font-size:10pt;
		color: #fff;
		padding: 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
	}
	.ss_btn:hover {
		border: 1px solid #222;
		background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
		font-size:10pt;
		color: #fff;
		padding: 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
	}
	textarea{
		width:99%;
		font-family:'Lucida Console';
		font-size:12px;
		color:#FFFFFF;
		background:#475A5F;
		border:1px solid #91071f;
	}
	input[type=button]:focus {
		outline: none;
	}
</style>
<script>
var dbus = {};
var _responseLen;
var noChange = 0;
var x = 5;
var kn = '00AC69F5CCC8BDE47CD3D371603748378C9CFAD2938A6B021E0E191013975AD683F5CBF9ADE8BD7D46B4D2EC2D78AF146F1DD2D50DC51446BB8880B8CE88D476694DFC60594393BEEFAA16F5DBCEBE22F89D640F5336E42F587DC4AFEDEFEAC36CF007009CCCE5C1ACB4FF06FBA69802A8085C2C54BADD0597FC83E6870F1E36FD';
var ke = '010001';
var rsa = new RSAKey();
rsa.setPublic(kn, ke);
var params_inp = ['fastd1ck_user', 'fastd1ck_passwd', 'fastd1ck_if', 'fastd1ck_protocal', 'fastd1ck_keepalive', 'fastd1ck_relogin'];
var params_chk = ['fastd1ck_enable', 'fastd1ck_dn_enable', 'fastd1ck_up_enable', 'fastd1ck_logging', 'fastd1ck_logging_v'];
var wans_mode = '<% nvram_get("wans_mode"); %>'


function init() {
	show_menu(menu_hook);
	generate_options();
	get_dbus_data();
}

function conf2obj(){
	for (var i = 0; i < params_inp.length; i++) {
		if(dbus[params_inp[i]]){
			E(params_inp[i]).value = dbus[params_inp[i]];
		}
	}
	for (var i = 0; i < params_chk.length; i++) {
		if(dbus[params_chk[i]]){
			E(params_chk[i]).checked = dbus[params_chk[i]] == "1";
		}
	}
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/fastd1ck",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			toggle_func();
			update_visibility();
			get_run_status();
			setInterval("get_run_status()", 3000);
			get_pid_status();
			set_version();
		}
	});
}

function set_version(){
	if (dbus["fastd1ck_version"]){
		E('fastd1ck_title').innerHTML = "迅雷快鸟  -  " + dbus["fastd1ck_version"]
	}
}

function generate_options(){
	if(wans_mode == "lb"){
		for(var i = 1; i < 3; i++) {
			$("#fastd1ck_if").append("<option value='"  + i + "'>wan" + i + "</option>");
		}
		$("#fastd1ck_if").val(1);
	} else {
		$("#fastd1ck_if").append("<option value='1'>wan1</option>");
		$("#fastd1ck_if").val(1);
	}
}

function get_run_status(){
	$.ajax({
		type: "GET",
		url: "/_api/fastd1ck_",
		dataType: "json",
		async: false,
		success: function(data) {
			var fastd1ck_status = data.result[0];
			if (fastd1ck_status["fastd1ck_status_rx"]) {
				E("down_status").innerHTML = fastd1ck_status["fastd1ck_status_rx"];
			}
			if (fastd1ck_status["fastd1ck_status_tx"]) {
				E("up_status").innerHTML = fastd1ck_status["fastd1ck_status_tx"];
			}
		}
	});
}

function get_pid_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "fastd1ck_status.sh", "params":[1], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			E("script_status").innerHTML = response.result;
			setTimeout("get_pid_status();", 3000);
		},
		error: function(){
			E("script_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_pid_status();", 8000);
		}
	});
}
function save() {
	var dbus_new = {}
	fastd1ck_action = 0;
	//showLoadingBar();
	$('.show-btn1').removeClass('active');
	$('.show-btn2').addClass('active');
	$('.show-btn3').removeClass('active');
	E("fastd1ck_settings").style.display = "none";
	E("fastd1ck_log").style.display = "";
	E("fastd1ck_help").style.display = "none";
	E('cmdBtn1').style.display = "";
	
	// collect data from input and checkbox
	for (var i = 0; i < params_inp.length; i++) {
		dbus_new[params_inp[i]] = E(params_inp[i]).value;
	}
	for (var i = 0; i < params_chk.length; i++) {
		dbus_new[params_chk[i]] = E(params_chk[i]).checked ? '1' : '0';
	}
	// 生成设备签名
	if (wans_mode == "lb" && E("fastd1ck_if").value == 2){
		var wan_mac = '<% nvram_get("wan1_hwaddr"); %>';
	}else{
		var wan_mac = '<% nvram_get("wan0_hwaddr"); %>';
	}
	var fake_device_id = md5(wan_mac);
	var device_sign = "div100."+fake_device_id+md5(hex_sha1(fake_device_id+"com.xunlei.vip.swjsq68700d1872b772946a6940e4b51827e8af"));
	dbus_new["fastd1ck_device_sign"] = device_sign;
	// 生成peerid
	var peerid = wan_mac.split(":").join("") + "004V";
	dbus_new["fastd1ck_peerid"] = peerid;
	// 提交数据
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "fastd1ck_config.sh", "params": [1], "fields": dbus_new };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			console.log(response);
			if (response.result == id){
				get_log();
			}
		}
	});
}

function clean_log() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "fastd1ck_config.sh", "params": [2], "fields": "" };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			console.log(response);
			if (response.result == id){
				E("log_content1").value = "";
			}
		}
	});
}

function get_log() {
	$.ajax({
		url: '/_temp/fastd1ck_log.txt',
		type: 'GET',
		dataType: 'html',
		async: true,
		cache:false,
		success: function(response) {
			var retArea = E("log_content1");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", "");
				retArea.scrollTop = retArea.scrollHeight;
				E("fastd1ck_enable").checked = false;
				//return true;
			}
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 6000) {
				//retArea.value = "当前日志文件为空";
				return false;
			} else {
				if (response.search("XU6J03M7") != -1) {
					setTimeout("get_log();",20000);
				} else {
					setTimeout("get_log();",200);
				}
			}
			//retArea.value = response.replace("XU6J03M7", "");
			if (response.search("XU6J03M7") != -1) {
				retArea.value = response.split("XU6J03M7").join("");
			}else{
				retArea.value = response;
			}
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function(xhr) {
			//setTimeout("get_log();", 1000);
			E("log_content1").value = "暂无日志信息！";
		}
	});
}

function count_down_close() {
	if (x == "0") {
		hideSSLoadingBar();
	}
	if (x < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + x + "）"
		--x;
	setTimeout("count_down_close();", 1000);
}

function showLoadingBar() {
	if (window.scrollTo)
		window.scrollTo(0, 0);

	disableCheckChangedStatus();

	htmlbodyforIE = document.getElementsByTagName("html"); //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
	htmlbodyforIE[0].style.overflow = "hidden"; //hidden the Y-scrollbar for preventing from user scroll it.

	winW_H();

	var blockmarginTop;
	var blockmarginLeft;
	if (window.innerWidth)
		winWidth = window.innerWidth;
	else if ((document.body) && (document.body.clientWidth))
		winWidth = document.body.clientWidth;

	if (window.innerHeight)
		winHeight = window.innerHeight;
	else if ((document.body) && (document.body.clientHeight))
		winHeight = document.body.clientHeight;

	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
		winHeight = document.documentElement.clientHeight;
		winWidth = document.documentElement.clientWidth;
	}

	if (winWidth > 1050) {

		winPadding = (winWidth - 1050) / 2;
		winWidth = 1105;
		blockmarginLeft = (winWidth * 0.3) + winPadding - 150;
	} else if (winWidth <= 1050) {
		blockmarginLeft = (winWidth) * 0.3 + document.body.scrollLeft - 160;

	}

	if (winHeight > 660)
		winHeight = 660;

	blockmarginTop = winHeight * 0.3 - 140

	E("loadingBarBlock").style.marginTop = blockmarginTop + "px";
	E("loadingBarBlock").style.marginLeft = blockmarginLeft + "px";
	E("loadingBarBlock").style.width = 770 + "px";
	E("LoadingBar").style.width = winW + "px";
	E("LoadingBar").style.height = winH + "px";
	LoadingProgress();
}

function LoadingProgress() {
	E("LoadingBar").style.visibility = "visible";
	if (fastd1ck_action == 0) {
		if(E("fastd1ck_enable").checked ? '1' : '0' == "1"){
			E("loading_block3").innerHTML = "迅雷快鸟启用中 ..."
		}else{
			E("loading_block3").innerHTML = "迅雷快鸟关闭中 ..."
		}
	} else if (fastd1ck_action == 1) {
		E("loading_block3").innerHTML = "fastd1ck配置恢复 ..."
	}
	$("#loading_block2").html("<li><font color='#ffcc00'>插件工作有问题？请到我们的论坛 <a href='http://koolshare.cn/forum-98-1.html' target='_blank'><u><em>http://koolshare.cn</em></u></a> 反馈...</li></font>");
}

function hideSSLoadingBar() {
	x = -1;
	E("LoadingBar").style.visibility = "hidden";
	refreshpage();
}


function toggle_func() {
	$('.show-btn1').addClass('active');
	$(".show-btn1").click(
		function() {
			$('.show-btn1').addClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			E("fastd1ck_settings").style.display = "";
			E("fastd1ck_log").style.display = "none";
			E("fastd1ck_help").style.display = "none";
			E('cmdBtn1').style.display = "none";
		});
	$(".show-btn2").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').addClass('active');
			$('.show-btn3').removeClass('active');
			E("fastd1ck_settings").style.display = "none";
			E("fastd1ck_log").style.display = "";
			E("fastd1ck_help").style.display = "none";
			E('cmdBtn1').style.display = "";
			get_log();
		});
	$(".show-btn3").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').addClass('active');
			E("fastd1ck_settings").style.display = "none";
			E("fastd1ck_log").style.display = "none";
			E("fastd1ck_help").style.display = "";
			E('cmdBtn1').style.display = "none";
		});
	$("#log_content2").click(
		function() {
			x = -1;
		});
}

function update_visibility(){
	if($('.show-btn1').hasClass("active")){
		E('fastd1ck_status').style.display = "";
		E('tablet_show').style.display = "";
		E('fastd1ck_settings').style.display = "";
		E('fastd1ck_log').style.display = "none";
		E('fastd1ck_help').style.display = "none";
		E('cmdBtn1').style.display = "none";
	}else if($('.show-btn2').hasClass("active")){
		E('fastd1ck_status').style.display = "";
		E('tablet_show').style.display = "";
		E('fastd1ck_settings').style.display = "none";
		E('fastd1ck_log').style.display = "";
		E('fastd1ck_help').style.display = "none";
		E('cmdBtn1').style.display = "";
	}else if($('.show-btn3').hasClass("active")){
		E('fastd1ck_status').style.display = "";
		E('tablet_show').style.display = "";
		E('fastd1ck_settings').style.display = "none";
		E('fastd1ck_log').style.display = "none";
		E('fastd1ck_help').style.display = "";
		E('cmdBtn1').style.display = "none";
	}
}

function menu_hook() {
	tabtitle[tabtitle.length - 1] = new Array("", "迅雷快鸟");
	tablink[tablink.length - 1] = new Array("", "Module_fastd1ck.asp");
}

function reload_Soft_Center(){
	location.href = "/Module_Softcenter.asp";
}
</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<div id="LoadingBar" class="popup_bar_bg_ks" style="z-index: 200;" >
	<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock"  align="center">
		<tr>
			<td height="100">
			<div id="loading_block3" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
			<div id="loading_block2" style="margin:10px auto;width:95%;"></div>
			<div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
				<textarea cols="50" rows="36" wrap="off" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:3px;padding-right:22px;overflow-x:hidden"></textarea>
			</div>
			<div id="ok_button" class="apply_gen" style="background: #000;display: none;">
				<input id="ok_button1" class="button_gen" type="button" onclick="hideSSLoadingBar()" value="确定">
			</div>
			</td>
		</tr>
	</table>
</div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<input type="hidden" name="current_page" value="Module_ssserver.asp"/>
<input type="hidden" name="next_page" value="Module_ssserver.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="ssserver_config.sh"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td width="17">&nbsp;</td>
        <td valign="top" width="202">
            <div id="mainMenu"></div>
            <div id="subMenu"></div>
        </td>
        <td valign="top">
            <div id="tabMenu" class="submenuBlock"></div>
            <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
                						<div id="fastd1ck_title" style="float:left;" class="formfonttitle" style="padding-top: 12px">迅雷快鸟</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote" id="head_illustrate"><i></i><em>迅雷快鸟，上网必备神器，宽带平均提升5倍，最高可达500M。</em></div>
										<div id="fastd1ck_switch" style="margin:0px 0px 0px 0px;">
                							<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">迅雷快鸟 - 开关</td>
												</tr>
												</thead>
												<tr id="switch_tr">
													<th>
														<label>开启迅雷快鸟</label>
													</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell">
															<label for="fastd1ck_enable">
																<input id="fastd1ck_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container" >
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
														<div style="display:table-cell;float: left;margin-left:270px;margin-top:-32px;position: absolute;padding: 5.5px 0px;">
															<a type="button" class="ss_btn" target="_blank" href="https://github.com/koolshare/armsoft/blob/master/fastd1ck/Changelog.txt">更新日志</a>
														</div>
													</td>
												</tr>
											</table>
										</div>
										<div id="fastd1ck_status" style="margin:10px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">迅雷快鸟 - 状态</td>
													</tr>
												</thead>
												<tr id="script_status_tr">
													<th>快鸟运行状态</th>
													<td>
														<span id="script_status"></span>
													</td>
												</tr>
												<tr id="down_status_tr">
													<th>下行提速状态</th>
													<td>
														<span id="down_status"><font color="white">未启用</font></span>
													</td>
												</tr>
												<tr id="down_status_tr">
													<th>上行提速状态</th>
													<td>
														<span id="up_status"><font color="white">未启用</font></span>
													</td>
												</tr>
											</table>
										</div>
										<div id="tablet_show">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
												<tr	width="235px">
													<td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
														<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="基本设置"/>
														<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="查看日志"/>
														<input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="帮助信息"/>
													</td>
													</tr>
											</table>
										</div>
										<div id="fastd1ck_settings" style="margin:-1px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th>迅雷快鸟帐号</th>
													<td>
														<input type="text" class="input_ss_table" name="fastd1ck_user" id="fastd1ck_user" value="" />
													</td>
												</tr>
												<tr>
													<th>迅雷快鸟密码</th>
													<td>
														<input type="password" name="fastd1ck_passwd" id="fastd1ck_passwd" class="input_ss_table" autocomplete="off" autocorrect="off" autocapitalize="off" maxlength="100" value="" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');"/>
													</td>
												</tr>
												<tr>
													<th>开启下行提速</th>
													<td>
														<input type="checkbox" id="fastd1ck_dn_enable" name="fastd1ck_dn_enable" checked="checked" >
													</td>
												</tr>
												<tr>
													<th>开启上行提速</th>
													<td>
														<input type="checkbox" id="fastd1ck_up_enable" name="fastd1ck_up_enable" >
													</td>
												</tr>
												<tr>
													<th>启用日志记录</th>
													<td>
														<input type="checkbox" id="fastd1ck_logging" name="fastd1ck_logging" checked="checked" >
													</td>
												</tr>
												<tr>
													<th>启用详细日志</th>
													<td>
														<input type="checkbox" id="fastd1ck_logging_v" name="fastd1ck_logging_v" >
													</td>
												</tr>
												<tr id="fastd1ck_if_tr">
													<th>选择提速接口</th>
													<td>
														<select class="input_ss_table" style="width:86px;height:25px;" name="fastd1ck_if" id="fastd1ck_if">
														</select>
													</td>
												</tr>
												<tr>
													<th>选择快鸟协议</th>
													<td>
														<select class="input_ss_table" style="width:86px;height:25px;" name="fastd1ck_protocal" id="fastd1ck_protocal">
															<option value="200">200</option>
															<option value="300" selected>300</option>
														</select>
													</td>
												</tr>
												<tr>
													<th>心跳检测周期</th>
													<td>
														<input type="text" class="input_ss_table" name="fastd1ck_keepalive" id="fastd1ck_keepalive" style="width:78.81px;" value="10" />
														<small>(范围: 5 - 60; 默认: 10; 单位: 分钟)</small>
													</td>
												</tr>
												<tr>
													<th>帐号重新登录</th>
													<td>
														<input type="text" class="input_ss_table" name="fastd1ck_relogin" id="fastd1ck_relogin" style="width:78.81px;" value="0" />
														<small>(最大: 48; 默认: 0; 单位: 小时)</small>
													</td>
												</tr>
											</table>
										</div>											
										<div id="fastd1ck_log" style="margin:-1px 0px 0px 0px;display: none;">
											<div id="log_content" style="margin-top:-1px;display:block;overflow:hidden;">
												<textarea cols="63" rows="36" wrap="on" readonly="readonly" id="log_content1" style="margin-top:-1px;width:97%; padding-left:4px;padding-right:37px;border:0px solid #222;font-family:'Lucida Console';font-size:11px;color:#FFFFFF;outline:none;overflow-x:hidden;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
										</div>
										<div id="fastd1ck_help" style="margin:-1px 0px 0px 0px;display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
												<td>
													<ul>
														<li>本插件仅支持koolshare armV7架构384梅林改版固件。</li>
														<li>本插件是对<a href="https://github.com/sensec/luci-app-xlnetacc" target="_blank" ><i><u>luci-app-xlnetacc</u></i></a>项目的移植，感谢原作<a href="https://github.com/sensec" target="_blank" ><i><u>sensec</u></i></a>！</li>
														<li>为了方便移植，本插件使用jq笨拙的模拟了jshn函数，用法不完全一样。</li>
														<li>迅雷快鸟提速主脚本为在/jffs/koolshare/fastd1ck_main.sh，有能力的可以自行调试修改。</li>
														<li>本插件的维护地址在<a href="https://github.com/koolshare/armsoft" target="_blank" ><i><u>https://github.com/koolshare/armsoft</u></i></a>，欢迎到此反馈问题！</li>
													</ul>
												</td>
												</tr>
											</table>
										</div>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="save()">提交</button>
											<button id="cmdBtn1" class="button_gen" onclick="clean_log()">清空日志</button>
										</div>
										<div class="KoolshareBottom">
											论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											Github项目： <a href="https://github.com/koolshare/armsoft" target="_blank"> <i><u>github.com/koolshare/armsoft</u></i> </a> <br/>
											Shell by： <i>sensec, modified by sadog</i>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
        </td>
    </tr>
</table>
<div id="footer"></div>
</body>
</html>

