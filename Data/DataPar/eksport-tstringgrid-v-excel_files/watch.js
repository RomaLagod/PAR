window.Ya=window.Ya||{};if(!window.ya_hit_param){var ya_hit_param=[]}Ya.Metrika=function(a,c,b){if(!window.__yaCounter){window.__yaCounter=this}this.id=a||0;this.type=b||0;this.initCounter(c);this.lastReferer=null};Ya.Metrika.prototype=new function(){var f=window,a=document,m=f.location,q=f.navigator,v="$Rev: 818 $".match(/(\d+)/)[1],p="application/x-shockwave-flash",c="Shockwave Flash",F="ShockwaveFlash.ShockwaveFlash",u="undefined",E=null,o=null;this.initCounter=function(H){var G=this.id+":"+this.type;if(ya_hit_param[G]){return false}if(this.id){ya_hit_param[G]=1;d(this,H)}};this.reachGoal=function(G,H){this.target=G||"";d(this,H)};function n(G){var H=s();if(H){H.insertBefore(w(G),H.firstChild)}else{(new Image(1,1)).src=G}}this.hit=function(H,K,J,I){if(!H){return}var G=m.protocol+"//mc.yandex.ru/watch/"+this.id+"?"+g.call(this,H,K,J);if(I){G+="&site-info="+B(z(I),512)}G+="&wmode=1";G+="&ar=1";n(G)};function b(H){var J=m.host,G=m.href;if(!H){return G}if(H.search(/^\w+:\/\//)!=-1){return H}if(H.charAt(0)=="?"){var I=G.search(/\?/);if(I==-1){return G+H}return G.substr(0,I)+H}if(H.charAt(0)=="#"){var I=G.search(/#/);if(I==-1){return G+H}return G.substr(0,I)+H}if(H.charAt(0)=="/"){var I=G.search(J);if(I!=-1){return G.substr(0,I+J.length)+H}}else{var K=G.split("/");K[K.length-1]=H;return K.join("/")}return H}function d(G,I){var H=m.protocol+"//mc.yandex.ru/watch/"+G.id+"?"+i(G.type,G.target);if(I){H+="&site-info="+B(z(I),512)}H+="&wmode=1";n(H);if(G.target){j(100)}}function i(I,G){var H="";H+="rn="+Math.floor(Math.random()*1000000);H+="&cnt-class="+I;H+="&page-ref="+B(G?m.href:a.referrer,512);H+="&page-url="+B(G?"goal://"+a.domain+"/"+G:m.href,512);H+="&browser-info="+x();return H}function g(G,J,I){var K="",H=(typeof I!=u)?I:(this.lastReferer===null?m.href:this.lastReferer);K+="rn="+Math.floor(Math.random()*1000000);K+="&cnt-class="+this.type;H=b(H);K+="&page-ref="+B(H,512);G=b(G);K+="&page-url="+B(G,512);K+="&browser-info="+x(J);this.lastReferer=H;return K}function x(K){var I=[],G="";I[0]=q.javaEnabled()?"j:1":"";I[1]="s:"+screen.width+"x"+screen.height+"x"+(screen.colorDepth?screen.colorDepth:screen.pixelDepth);if(E===null){E=C()}I[2]=E;I[3]=(top&&(self!==top))?"fr:1":"";I[4]="w:"+y()+"x"+h();I[5]="z:"+t();I[6]="i:"+e();if(o===null){o=D()}I[7]=o?"l:"+o:"";var L=k();I[8]=L?"en:"+L:"";I[9]="v:"+v;var J=l();I[10]=(typeof K!=u)?"t:"+B(K,100):(J?"t:"+B(J,100):"");for(var H=0;H<I.length;H++){if(I[H]){G+=(G?":":"")+I[H]}}return G}function k(){var K="",J=a.getElementsByTagName("meta");if(J&&J.length>0){for(var H=0,G=J.length;H<G;H++){if(J[H].content){var I=J[H].content.match(/charset=(.*)/);if(I){K=I[1];break}}}}else{K=a.characterSet||a.charset}return K}function C(){var H=null,J=null,G;if(typeof q.plugins!=u&&typeof q.plugins[c]=="object"){H=q.plugins[c].description;if(H&&!(typeof q.mimeTypes!=u&&q.mimeTypes[p]&&!q.mimeTypes[p].enabledPlugin)){J=H.replace(/([a-zA-Z]|\s)+/,"").replace(/(\s+r|\s+b[0-9]+)/,".")}}else{if(typeof f.ActiveXObject!=u){try{G=new ActiveXObject(F);if(G){H=G.GetVariable("$version");if(H){J=H.split(" ")[1].replace(/,/g,".").replace(/[^.\d]/g,"")}}}catch(I){}}}return J&&("f:"+J)}function t(){return(new Date()).getTimezoneOffset()*(-1)}function e(){function I(L){return L<10?"0"+L:L}var H=new Date(),G=[H.getFullYear(),H.getMonth()+1,H.getDate(),H.getHours(),H.getMinutes(),H.getSeconds()],K="";for(var J=0;J<G.length;J++){K+=I(G[J])}return K}function y(){var G=-1;if(f.innerWidth){G=parseInt(f.innerWidth)}else{if(a.documentElement&&a.compatMode=="CSS1Compat"){G=a.documentElement.clientWidth}else{if(a.body){G=a.body.clientWidth}}}return G}function h(){var G=-1;if(f.innerHeight){G=parseInt(f.innerHeight)}else{if(a.documentElement&&a.compatMode=="CSS1Compat"){G=a.documentElement.clientHeight}else{if(a.body){G=a.body.clientHeight}}}return G}function D(){var G=null;if(f.ActiveXObject){try{var L=new ActiveXObject("AgControl.AgControl");function M(Q,O,N,P){while(I(Q,O)){O[N]+=P}O[N]-=P}function I(O,N){return O.isVersionSupported(N[0]+"."+N[1]+"."+N[2]+"."+N[3])}var H=[1,0,0,0];M(L,H,0,1);M(L,H,1,1);M(L,H,2,10000);M(L,H,2,1000);M(L,H,2,100);M(L,H,2,10);M(L,H,2,1);M(L,H,3,1);G=H.join(".")}catch(K){}}else{var J=q.plugins["Silverlight Plug-In"];if(J){G=J.description}}return G}function s(){var G=a.getElementsByTagName("html")[0];if(!a.getElementsByTagName("head")[0]){G.appendChild(a.createElement("head"))}return a.getElementsByTagName("head")[0]}function A(){return a.getElementsByTagName("body")[0]}function l(){var H=a.title;if(typeof H!="string"){var G=a.getElementsByTagName("title");if(G&&G.length){H=G[0].innerHTML}else{H=""}}return H}function r(G){var H=a.createElement("script");H.type="text/javascript";H.src=G;return H}function w(H){var G=a.createElement("link");G.rel="stylesheet";G.type="text/css";G.href=H;return G}function B(H,G){G=G||256;if(!H){return""}if(H.length>G){H=H.substr(0,G)}return(window.encodeURIComponent||escape)(H).replace(/\+/g,"%2B")}function z(I){function L(M){return M?M.replace(/\\/,"\\\\").replace(/"/,'\\"'):""}switch(I.constructor){case Boolean:return I.toString();case Number:return isFinite(I)?I.toString():"null";case String:return'"'+L(I)+'"';case Array:var G=[];for(var K=0,J=I.length;K<J;K++){G[G.length]=z(I[K])}return"["+G.join(",")+"]";case Object:var G="{",K=0;for(var H in I){if(!I.hasOwnProperty(H)){continue}G+=(K==0?"":",")+'"'+L(H)+'":'+z(I[H]);K++}G+="}";return G;default:return"null"}}this.convertToString=z;function j(J){var H=new Date().getTime();for(var I=1;I>0;I++){if(I%1000==0){var G=new Date().getTime();if(G-H>J){break}}}}};if(window.ya_cid){new Ya.Metrika(ya_cid,window.ya_params,window.ya_class)}if(!window.ya_hit){var ya_hit=function(a,b){__yaCounter.reachGoal(a,b)}}if(typeof window.yandex_metrika_callback=="function"){window.yandex_metrika_callback()};