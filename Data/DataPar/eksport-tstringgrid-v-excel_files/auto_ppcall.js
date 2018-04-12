if (typeof Begun == 'undefined') {
	var Begun = {};
}
if (typeof Begun.loaderCallbacks === "undefined") {
	Begun.loaderCallbacks = [];
}

Begun.Template = function(tpl) {
	var re;
	tpl = tpl || '';
	this.getTpl = function(){
		return tpl;
	};
	this.REVISION = '$LastChangedRevision: 33403 $';
	this.evaluate = function(vars){
		for (var key in vars) {
			re = new RegExp('\\{\\{' + key + '\\}\\}', 'g');
			tpl = tpl.replace(re, vars[key]);
		}
		// remove unused placeholders
		re = new RegExp('\\{\\{.+?\\}\\}', 'g');
		tpl = tpl.replace(re, '-foo');

		return tpl;
	};
};

if (!Begun.Utils) {
	Begun.$ = function(id) {
		return document.getElementById(id);
	};
	Begun.extend = function(destination, source) {
		for (var property in source) {
			destination[property] = source[property];
		}
		return destination;
	};

	Begun.Browser = new function() {
		var _ua = navigator.userAgent;
		this.IE = !!(window.attachEvent && _ua.indexOf('Opera') === -1);
		this.Opera =  _ua.indexOf('Opera') > -1;
		this.WebKit = _ua.indexOf('AppleWebKit/') > -1;
		this.Gecko =  _ua.indexOf('Gecko') > -1 && _ua.indexOf('KHTML') === -1;
		var ver = null;
		this.version = function() {
			if (ver !== null){
				return ver;
			}
			if (typeof detect !== "undefined") {
				ver = detect();
				return ver;
			} else {
				return;
			}
		};
		var detect;
		function check(re){
			var versionParsed = re.exec(_ua);
			if (versionParsed && versionParsed.length && versionParsed.length > 1 && versionParsed[1]) {
				return versionParsed[1];
			}
		}
		if (this.IE){
			detect = function() { return check(/MSIE (\d*.\d*)/gim); };
		} else if (this.Opera) {
			detect = function() { return check(/Opera\/(\d*\.\d*)/gim); };
		} else if (this.WebKit) {
			detect = function() { return check(/AppleWebKit\/(\d*\.\d*)/gim); };
		} else if (this.Gecko) {
			detect = function() { return check(/Firefox\/(\d*\.\d*)/gim); };
		}
		this.more = function(n) {
			return parseFloat(this.version()) > n;
		};
		this.less = function(n) {
			return parseFloat(this.version()) < n;
		};
	}();

	Begun.Utils = new function() {
		var d = document;
		var script_count = 0;
		var swf_count = 0;
		var script_timeout = 5000;
		var getHead = function(obj) {
			var wnd = obj || window;
			var head = wnd.document.getElementsByTagName("head")[0];
			if (!head){
				head = wnd.document.createElement("head");
				wnd.document.documentElement.insertBefore(head, wnd.document.documentElement.firstChild);
			}
			return head;
		};
		this.REVISION = '$LastChangedRevision: 33403 $';


		this.includeScript = function(url, type, callback, callback_name, check_var){
			var INC_SCRIPT_PREFIX = 'begun_js_';
			var SCRIPT_TYPE = 'text/javascript';
			var scriptTimeoutCounter = "http://autocontext.begun.ru/blockcounter?pad_id={{pad_id}}&block={{block_id}}&script_timeout=1";
			type = type || 'write'; // append or write
			var inc = 0;
			var script = null;
			if (url){
				if (type == 'write'){
					script_count++;
					var id = INC_SCRIPT_PREFIX + script_count;
					if (check_var){
						window.setTimeout(function(){
							var scripts = d.getElementsByTagName("script");
							var s = scripts.length > 0 ? scripts[scripts.length - 1] : null;
							if (s && window[check_var] === undefined){
								s.parentNode.removeChild(s);
								Begun.Utils.includeCounter(scriptTimeoutCounter, {'pad_id': (window.begun_auto_pad || ''), 'block_id': (window.begun_block_id || '')});
							}
						}, script_timeout);
					}
					d.write('<scr'+'ipt type="' + SCRIPT_TYPE + '" src="' + url + '" id="' + id + '"></scr'+'ipt>'); 
					script = Begun.$(id);
				} else if (type == 'append'){
					script = d.createElement("script");
					script.src = url;
					script.type = SCRIPT_TYPE;
					var head = getHead();
					head.appendChild(script);
				}
				if (script && typeof callback == 'function'){
					var callback_fired = false;
					script.onload = function(){
						if (!callback_fired){
							callback();
							callback_fired = true;
						}
					};
					script.onreadystatechange = function(){
						if (callback_fired){
							return;
						}
						var check_statement = (Begun.Browser.Opera ? (this.readyState == "complete") : (this.readyState == "complete" || this.readyState == "loaded"));
						if (check_statement){
							callback();
							callback_fired = true;
						}
					};
				}
			}
		};
		this.evalScript = function(code){
			try {
				eval(code);
			} catch(e) {}
		};
		this.checkFlash = function() {
			for (var i=3;i<10;i++){
				var string = 'ShockwaveFlash.ShockwaveFlash.'+i;
				try{
					var obj = new ActiveXObject(string);
					if(obj) {
						return true;
					}
				} catch (e) {}
			}
			if(navigator.mimeTypes && navigator.mimeTypes.length && navigator.mimeTypes['application/x-shockwave-flash'] && navigator.mimeTypes['application/x-shockwave-flash'].enabledPlugin) {
				return true;
			} else if(navigator.plugins["Shockwave Flash"]) {
				return true;
			} else {
				return false;
			}
		};
		this.reformSWFData = function(url){
			var params = url.split(/\?/);
			if(params[1] && params[1].match(/uuid/)) {
				var data = params[1].split(/&/);
				var reformed_params = '';
				for(var i=0, l=data.length; i<l; i++) {
					var tmp_data = data[i].split(/=/);
					if(tmp_data[1]) {
						reformed_params += encodeURIComponent(tmp_data[0]) + ':' + encodeURIComponent(tmp_data[1]);
						if(i != l-1) {
							reformed_params += ',';
						}
					}
				}
				var postback_url = params[0].replace('.swf', '.xml');
				url = params[0] + '?sync_params=' + reformed_params + '&postback_url=' + encodeURIComponent(postback_url);
			}
			return url;
		};
		this.includeSWF = function(url){
			url = this.reformSWFData(url);
			var INC_SWF_PREFIX = 'begun_swf_';
			swf_count++;
			var swf_wrapper = d.createElement('div');
			swf_wrapper.style.visability = 'hidden';
			swf_wrapper.style.top = '-1000px';
			swf_wrapper.style.left = '-1000px';
			swf_wrapper.innerHTML =
				'<object id="' + INC_SWF_PREFIX + swf_count + '" type="application/x-shockwave-flash" data="' + url + '" width="1" height="1">' + 
					'<param name="movie" value="' + url + '" />' + 
				'</object>';
			d.getElementsByTagName('body') && d.getElementsByTagName('body')[0] && d.getElementsByTagName('body')[0].appendChild(swf_wrapper);
		};
		this.includeStyle = function(css_text, type, id, wnd){
			wnd = wnd || window;
			type = type || 'write'; // append or write
			var DEFUALT_STYLE_ID = 'begun-default-css';
			var style;
			id = id || DEFUALT_STYLE_ID;
			if (css_text){
				if (type == 'write'){
					wnd.document.write('<style type="text/css" id="' + id + '">' + css_text + '</style>');
				} else if (type == 'append'){
					// IE
					if (wnd.document.createStyleSheet){
						style = null;
						try{
							style = wnd.document.createStyleSheet();
							style.cssText += css_text;
						}catch(e){
							for (var i = wnd.document.styleSheets.length - 1; i >= 0; i--){
								try{
									style = wnd.document.styleSheets[i];
									style.cssText += css_text;
									break; // access granted? get outta here!
								}catch(k){
									style = null;
								}
							}
						}
					} else {
						if (Begun.$(id)){
							Begun.$(id).innerHTML = css_text;
						} else {
							style = wnd.document.createElement("style");
							style.setAttribute("type", "text/css");
							style.id = id;
							style.appendChild(wnd.document.createTextNode(css_text));
							getHead(wnd).appendChild(style);
						}
					}
				}
			}
		};
		this.includeCSSFile = function(url){
			var style = d.createElement("link");
			style.setAttribute("type", "text/css");
			style.setAttribute("rel", "stylesheet");
			style.href = url;
			getHead().appendChild(style);
		};
		this.includeCounter = function(src, obj) {
			var re;
			if(!src || !obj) {
				return;
			}
			for (var key in obj) {
				re = new RegExp('\\{\\{' + key + '\\}\\}', 'g');
				src = src.replace(re, obj[key]);
			}
			re = /\{\{.+?\}\}/g;
			src = src.replace(re, '-foo');
			(new Image()).src = src;
		};
		this.toQuery = function(params) {
			var result = '';
			var ampersand = '';
			var toTail = {
				'real_refer': false,
				'ref': false
			};
			var key;
			for (key in params) {
				if (params[key] && params.hasOwnProperty && params.hasOwnProperty(key)) {
					if (typeof toTail[key] !== "undefined") {
						toTail[key] = encodeURIComponent(params[key]);
					} else {
						result += ampersand + key + '=' + encodeURIComponent(params[key]);
						ampersand = '&';
					}
				}
			}
			for (key in toTail) {
				if (toTail[key] && toTail.hasOwnProperty && toTail.hasOwnProperty(key)) {
					result += ampersand + key + '=' + toTail[key];
				}
			}
			return result;
		};
		this.toJSON = function(obj){
			switch (typeof obj) {
				case 'object':
					if (obj) {
						var list = [];
						if (obj instanceof Array) {
						for (var i=0;i < obj.length;i++) {
							list.push(this.toJSON(obj[i]));
						}
						return '[' + list.join(',') + ']';
						} else {
							for (var prop in obj) {
								list.push('"' + prop + '":' + this.toJSON(obj[prop]));
							}
							return '{' + list.join(',') + '}';
						}
					} else {
						return 'null';
					}
				case 'string':
					return '"' + obj.replace(/(["'])/g, '\\$1') + '"';
				case 'number':
					return obj;
				case 'boolean':
					return new String(obj);
			}
		};
		this.in_array = function(arr, value){
			for (var i = 0, l = arr.length; i < l; i++){
					if (arr[i] == value){
						return true;
					}
			}
			return false;
		};
		this.inList = function(string, value){
			var arr = string && string.toLowerCase().split(',');
			if(!arr) {
				return false;
			} else {
				return Begun.Utils.in_array(arr, value.toLowerCase());
			}
		};
		this.countWindowSize = function() {
			var w = 0, h = 0;
			if( typeof( window.innerWidth ) == 'number' ) {
				w = window.innerWidth;
				h = window.innerHeight;
			} else if( d.documentElement && ( d.documentElement.clientWidth || d.documentElement.clientHeight ) ) {
				w = d.documentElement.clientWidth;
				h = d.documentElement.clientHeight;
			} else if( d.body && ( d.body.clientWidth || d.body.clientHeight ) ) {
				w = d.body.clientWidth;
				h = d.body.clientHeight;
			}
			var obj = {
				width: w,
				height: h
			};
			return obj;
		};
		this.getScrollXY = function () {
			var x = 0, y = 0;
			if( typeof( window.pageYOffset ) == 'number' ) {
				y = window.pageYOffset;
				x = window.pageXOffset;
			} else if( d.body && ( d.body.scrollLeft || d.body.scrollTop ) ) {
				y = d.body.scrollTop;
				x = d.body.scrollLeft;
			} else if( d.documentElement && ( d.documentElement.scrollLeft || d.documentElement.scrollTop ) ) {
				y = d.documentElement.scrollTop;
				x = d.documentElement.scrollLeft;
			}
			var obj = {
				x: x,
				y: y
			};
			return obj;
		};
		this.findPos = function(obj) {
			var curleft = 0;
			var curtop = 0;
			if (obj && obj.offsetParent) {
				do {
					curleft += obj.offsetLeft;
					curtop += obj.offsetTop;
				} while (obj = obj.offsetParent);
				obj = {
					left: curleft,
					top: curtop
				};
				return obj;
			}
		};
		this.addEvent = function (obj,name,func) {
			if(obj.addEventListener) {
				obj.addEventListener(name, func, false);
			} else if (obj.attachEvent) {
				obj.attachEvent('on'+name, func);
			}
		};
		this.hasClassName = function(element, className) {
			return new RegExp("\\b" + className + "\\b").test(element.className);
		};
		this.addClassName = function(element, className) {
			if (!this.hasClassName(element, className)) {
				element.className += (element.className ? ' ' : '') + className;
			}
				return element;
		};
		this.removeClassName = function(element, className) {
			if (this.hasClassName(element,className)) {
				var reg = new RegExp('(\\s|^)'+className+'(\\s|$)');
				element.className=element.className.replace(reg,' ');
			}
		};
		this.toCamelCase = function(s){
			for(var exp=/-([a-z])/; exp.test(s); s=s.replace(exp,RegExp.$1.toUpperCase())) {}
			return s;
		};
		this.getStyle = function(el, a) {
			if (!el) {
				return;
			}
			el = el || Begun.$(el); 
			var v = null;
			if(d.defaultView && d.defaultView.getComputedStyle){
				var cs = d.defaultView.getComputedStyle(el,null);
				if(cs && cs.getPropertyValue) {
					v = cs.getPropertyValue(a);
				}
			}
			if(!v && el && el.currentStyle) {
				v = el.currentStyle[this.toCamelCase(a)];
			}
			return v;
		};
		this.getElementsByClassName = function(oElm, strTagName, strClassName){
			var arrElements = (strTagName == "*" && oElm.all)? oElm.all : oElm.getElementsByTagName(strTagName);
			var arrReturnElements = new Array();
			strClassName = strClassName.replace(/\-/g, "\\-");
			var oRegExp = new RegExp("(^|\\s)" + strClassName + "(\\s|$)");
			var oElement;
			for (var i=0; i<arrElements.length; i++) {
				oElement = arrElements[i];     
				if (oRegExp.test(oElement.className)){
					arrReturnElements.push(oElement);
				}   
			}
			return (arrReturnElements);
		};
	}();
}

Begun.Ppcall = function() {
	this.element = false;
	this.isHide = true;
	this.REVISION = '$LastChangedRevision: 33403 $';
	this.WIDTH = 350;
	this.HEIGHT = 260;
	var css_text = (new Begun.Template(this.tpls.css)).evaluate({width:this.WIDTH, height:this.HEIGHT});
	Begun.Utils.includeStyle(css_text, 'append', 'begun-ppcall-css');
};
Begun.Ppcall.prototype = {
	show: function(event, is_mobile) {
		if (!this.isHide) {
			this.hide();
		}
		if (this.isHide) {
			this.pos(event, is_mobile);
			this.element.innerHTML = '';
		}
		return true;
	},
	hide: function() {
		if (!this.isHide) {
			this.element.innerHTML = '';
			this.element.style.display = 'none';
			this.isHide = true;
		}
		return true;
	},
	pos: function(event, is_mobile) {
		if (is_mobile) {
			this.element.style.top = '50%';
			this.element.style.left = '50%';
			this.element.style.marginLeft = (this.WIDTH / -2) + 'px';
			this.element.style.marginTop = (this.HEIGTH / -2) + 'px';
			this.element.style.display = 'block';
			return;
		}
		var position = new Object();
		if (Begun.Browser.IE) {
			position.x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
			position.y = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
		} else if (Begun.Browser.Opera)  {
			position.x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
			position.y = window.event.clientY + document.documentElement.scrollTop;
		} else {
			position.x = event.clientX + window.scrollX;
			position.y = event.clientY + window.scrollY;
		}
		var clientHeight = Begun.Utils.countWindowSize().height + Begun.Utils.getScrollXY().y;
		var clientWidth  = window.document.body.clientWidth;
		if (!clientWidth) {
			clientWidth  = window.innerWidth;
		}

		position.y = position.y + 5;
		position.x = position.x + 15;

		//width
		if ((clientWidth-position.x) < 350) {
			position.x = (clientWidth - 353);
		}

		//Height
		if ((clientHeight-position.y) < 260) {
			position.y = (position.y - 260);
		}

		if (position.y < 0) position.y = 5;
		if (position.x < 0) position.x = 5;

		this.element.style.top = position.y + 'px';
		this.element.style.left = position.x + 'px';
		this.element.style.display = 'block';
	},

	showEnterForm: function(i,a_obj,event, pad_id, iframe_link, is_mobile, url) {
		iframe_link = (function() {
			if (!iframe_link) {
				var _ppcall_iframe_link = (window.begun_urls && window.begun_urls.ppcall_iframe_link) || (Begun.Autocontext && Begun.Autocontext.Strings.urls.ppcall_iframe_link);
				if (_ppcall_iframe_link) {
					iframe_link = new Begun.Template(_ppcall_iframe_link).evaluate({ppcall_url: url});
				} else {
					iframe_link = 'http://ppcall.begun.ru/acont_xmlhttp.php?action=get_form&url=' + url;
				}
			}
			return iframe_link; 
		})();
		if (is_mobile) {
			window.location.href = iframe_link;
			return;
		}
		if (!this.element){
			var a = document.createElement("div");
			document.body.appendChild(a);
			a.style.position = 'absolute';
			a.style.zIndex = '2147483647';
			a.style.display = 'none';
			a.style.background = "#0099CC";
			a.id = 'EF1';
			this.element = a;
		}
		if (!url) {
			if (typeof begunBanners != 'undefined' && begunBanners.length && begunBanners.length > 2) {
				url = begunBanners[i][2];
			} else if (typeof Begun != 'undefined' && Begun.Autocontext && Begun.Autocontext.getBanner) {
				if (Begun.Autocontext.getBanner('autocontext', i, pad_id)) {
					url = Begun.Autocontext.getBanner('autocontext', i, pad_id)['url'];
				} else if (Begun.Autocontext.getBanner('hypercontext', i, pad_id)) {
					url = Begun.Autocontext.getBanner('hypercontext', i, pad_id)['url'];
				}
			}
		} else {
			url = '';
		}
		this.show(event, is_mobile);
		this.element.innerHTML = this.tpls.html;
		this.isHide = false;
		Begun.$('begun_iframeid').src = iframe_link;
	},
	tpls: {
		css: '\
#begun_ppcall {\
width:{{width}}px;\
height:{{height}}px;\
position:absolute;\
top:0;\
left:0;\
border:1px solid #666;\
background-color:#fff;\
z-index:2147483647;\
}\
#begun_ppcall * {\
color:#000;\
font-family:Arial, Helvetica, sans-serif;\
font-size:12px;\
margin:0;\
padding:0;\
}\
#begun_ppcall .begun_ppcall_inner {height:240px;position:relative;padding:7px 10px 10px;}\
#begun_ppcall .begun_ppcall_inner .begun_ppcall_close {position:absolute;right:10px;top:6px;}\
',
	html: '\
<div id="begun_ppcall">\
<div class="begun_ppcall_inner">\
<iframe scrolling="no" frameborder="0" style="margin:0;padding:0;" width="100%" height="100%" src="#" id="begun_iframeid"></iframe>\
<a class="begun_ppcall_close" href="javascript:void(0);" onclick="Begun.Ppcall.hide();return false;">&#1047;&#1072;&#1082;&#1088;&#1099;&#1090;&#1100;</a>\
</div>\
</div>\
'
	}
};
Begun.Ppcall = new Begun.Ppcall();
showEnterForm = function(i,a_obj,event, pad_id, link) {
	Begun.Ppcall.showEnterForm.apply(Begun.Ppcall, arguments);
};
