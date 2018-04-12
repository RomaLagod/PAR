if(typeof begun_urls == 'undefined' || begun_urls === null) {
	var begun_urls = {};
}

function chkAgent() {
    if (navigator.userAgent.indexOf('Konqueror') != -1) return false;
    if (navigator.userAgent.match(/Opera [1-7]/)) return false;
    return true;
}

String.prototype.begunSplit = function(limit) {
    var suff = '...';
    limit = this.lastIndexOf(' ', limit);
    if (limit == -1) {
        limit = this.length;
        var suff = '';
    }
    return this.substr(0, limit) + suff;
}

function bJsTs() {
    this.tpl = null;
    this.block = function(block) {
        this.tpl = this.tpl.replace('{{' + block + '}}', '');
        this.tpl = this.tpl.replace('{{/' + block + '}}', '');
    }
    this.parse = function(vars) {
        for (var key in vars) {
            while (this.tpl.match('{' + key + '}'))
                this.tpl = this.tpl.replace('{' + key + '}', vars[key], 'gm');
        }
        var tplA = this.tpl.split(/\{\{[a-z]+\}\}/);
        var tplS = '';
        for (var i = 1; i < tplA.length; i++) {
            var tplA2 = tplA[i].split(/\{\{\/[a-z]+\}\}/);
            tplS = tplS + tplA2[1];
        }
        this.tpl = tplA[0] + tplS;
        return this.tpl;
    }
}

function bJsT() {
    this.tpl = null;
    this.block = function(block) {
        var re = new RegExp('{({/?' + block + '})}', 'gm');
        this.tpl = this.tpl.replace(re, '');
    }
    this.parse = function(vars) {
        for (var key in vars) {
            var re = new RegExp('{' + key + '}', 'g');
            this.tpl = this.tpl.replace(re, vars[key]);
        }

        var re = new RegExp('{({([a-z]+)})}.+?{({/\\2})}', 'gm');
        this.tpl = this.tpl.replace(re, '');
        return this.tpl;
    }
}

function include(file, isAppending) {
	var getHead = function() {
		var head = document.getElementsByTagName("head")[0];
		if (!head) {
			head = document.createElement("head");
			document.documentElement.insertBefore(head, d.documentElement.firstChild);
		}
		return head;
	};
	if (isAppending) {
		var scriptToAdd = document.createElement("script");
		scriptToAdd.setAttribute("type", "text/javascript");
		scriptToAdd.setAttribute("src", file);
		var head = getHead();
		head.appendChild(scriptToAdd);
	} else {
		document.write('<scr'+'ipt type="text/javascript" src="' + file + '"></scr'+'ipt>');
	}
}

function begunAppend(params) {
	var first = true;
	for (var key in params){
		if (params[key] && params.hasOwnProperty && params.hasOwnProperty(key)){
			begun_auto_url += (first ? '' : '&') + key + '=' + encodeURIComponent(params[key]);
			first = false;
		}
	}
};

function getCss() {
    if (begunParams.wide) {
        var css_bgulli_width = parseInt(100 / begun_auto_limit) - 1;
        var css_bgulli_float = 'float:left !important;';
    } else {
        var css_bgulli_width = 100;
        var css_bgulli_float = '';
    }
    if (begunParams.thumbs)
        var css_bgbanner_marginleft = 65;
    else
        var css_bgbanner_marginleft = 0;

    var css_bgulli_margin_bottom = 3;
    if (begunParams.thumbs && !begunParams.wide && !begunParams.autoscroll)
        var css_bgulli_height = 'min-height: 48px;';
    else
        var css_bgulli_height = '';

    if (begunParams.autoscroll) {
        var css_bgulli_height = 'height: ' + begun_scroll_height + 'px !important;';
        var css_bgulli_margin_bottom = 0;
    }
    begun_autowidth_string = new String(begun_auto_width);
    begun_autowidth_string =  begun_autowidth_string.indexOf('%')==-1 ? 'px':'';
    var fixedParam = {'fonttype' : 'font-face', 'bgbanner' : '', 'lipadding' : '0px 0px '+css_bgulli_margin_bottom + 'px 0px'};
    if(begunChkParam('style', 'fixed')) {
        fixedParam.fonttype = 'font-family';
        fixedParam.bgbanner = 'margin-bottom:10px;';
        fixedParam.lipadding = css_bgulli_margin_bottom + 'px 0px 0px 0px'
    }
    var cssTpl = '\
        <style><!-- \
        .begun { ' +fixedParam.fonttype+ ':Arial,sans-serif !important; } \
        .bgul'+rndID+' div, .bgulli'+rndID+' div  {float:none !important;clear:none !important;display:block !important;} \
        a.begun:link { color:'+begun_auto_colors[0]+'; '+fixedParam.fonttype+':Arial,sans-serif !important; line-height: 100% !important; } \
        a.begun:visited { color:'+begun_auto_colors[0]+';'+fixedParam.fonttype+':Arial,sans-serif !important; line-height: 100% !important; } \
        a.begun:hover { color:'+begun_auto_colors[0]+';'+fixedParam.fonttype+':Arial,sans-serif !important; line-height: 100% !important; } \
        a.begun:active { color:'+begun_auto_colors[0]+';'+fixedParam.fonttype+':Arial,sans-serif !important; line-height: 100% !important; } \
        .bgul'+rndID+' { float: none !important; margin:5px 5px 0px 5px !important; padding:0px !important; width: '+begun_auto_width+ begun_autowidth_string+' !important; background-color: '+begun_auto_colors[3]+' !important; overflow: hidden; } \
        .bgul1 { margin:5px 5px 0px 5px !important; padding:0px !important;  background-color: '+begun_auto_colors[3]+' !important; } \
        .bgulli'+rndID+' { '+css_bgulli_float+' list-style:none !important; margin:'+fixedParam.lipadding+' !important; padding:0px 5px 0px 0px !important; width: '+css_bgulli_width+'% !important; '+css_bgulli_height+' font-weight:normal;background:none; overflow: hidden !important; } \
        .bgulli'+rndID+'l { '+css_bgulli_float+' list-style:none !important; margin:3px 0px '+css_bgulli_margin_bottom+'px 0px !important; padding:0px 5px 0px 0px !important; width: '+css_bgulli_width+'% !important; '+css_bgulli_height+' font-weight:normal;background:none; overflow: hidden !important; } \
        .bgthumb { margin:5px !important; background-color:#118F00; /*border: 1px solid '+begun_auto_colors[2]+' !important;*/ } \
        *html .bgthumb { filter:expression(begunFixPNG(this)); } \
        .bgbanner { margin-left:'+css_bgbanner_marginleft+'px !important; text-align: left !important; text-indent: 0px !important; '+fixedParam.bgbanner+'} \
        .ramblersbox, .ramblersbox1 {padding:0px; margin: 0px; }\
        .ramblersbox1 td, .ramblersbox td {padding:0px; margin: 0px; color:#000000; }\
        .ramblersbox1 table, .ramblersbox table {background-color:#009CDE; padding:0px; margin: 0px; }\
        .ramblersbox1 table{background-color:#ffffff; }\
        .ramblersbox1 td{background-color:#ffffff; }\
        .ramblersbox td{background-color:#009CDE; }\
        .ramblersbox1 input, .ramblersbox input {height: 20px;} \
        //--></style>';
    return cssTpl;
}

function begunChkParam(paramName, checkVal) {
    if(!begunParams || !begunParams[paramName]) {
        return false;
    }
    if(checkVal != begunParams[paramName]) {
        return false;
    }
    return true;
}

function getStub(sWidth) {
    var rambler_search_text1 = decodeURIComponent('%D0%A0%D0%B0%D0%BC%D0%B1%D0%BB%D0%B5%D1%80%2C');
    var rambler_search_text = decodeURIComponent('%D0%9D%D0%B0%D0%B9%D1%82%D0%B8!');
    var sWidth = sWidth || begun_auto_width;
    
    var stubFixedTpl = '\
        <div class="begun" style="padding-bottom:3px;background-color: {begun_auto_colors3}; zoom:1; margin: 0px 5px 5px 5px;font-size:{begun_auto_fonts_size3};color:{begun_auto_colors2};width:{begun_auto_width}{begun_autowidth_string};text-align:left" > \
        <div style="' + (begunParams.wide ? 'float: left; width: 33%;text-align:left;' : 'padding-top:3px;') + '"> \
        {{showhref}} \
        <a class="snap_noshots" href="{href0}" style="line-height:100% !important;color:{begun_auto_colors2};" target="_blank">{text0}</a> \
        {{/showhref}} \
        ' + (!begunParams.showhref && begunParams.wide ? '&nbsp;' : '') +  '</div> \
        <div style="' + (begunParams.wide ? 'text-align:center;float: left; width: 33%;' : 'padding-top:3px;') + '"><a class="snap_noshots" href="http://www.begun.ru/advertiser/?r1=Begun&r2=adbegun" style="line-height:100% !important;color:{begun_auto_colors2};" target="_blank">{text1}</a></div> \
        <div style="' + (begunParams.wide ? 'text-align:right;float: left; width: 33%;' : 'padding-top:3px;') + '"><a class="snap_noshots" href="http://www.begun.ru/partner/?r1=Begun&r2=become_partner" style="line-height: 100% !important;color:{begun_auto_colors2};" target="_blank">{text2}</a></div> \
        <div style="clear: both; height:0; font-size:0">&nbsp;</div> \
        </div> ';
    var stubNormlTpl = '<table width="{begun_auto_width}" style="background-color: {begun_auto_colors3}; margin: 0px 5px 5px 5px;"><tr><td width="33%" style="cursor:default;"> \
        {{showhref}} \
            <a class="snap_noshots" href="{href0}" style="color:{begun_auto_colors2};line-height:100% !important;" target="_blank"><font style="font-size:{begun_auto_fonts_size3};" color="{begun_auto_colors2}">{text0}</font></a> \
        {{/showhref}} \
        </td> \
        <td align="center" width="33%" style="cursor:default;"><a class="snap_noshots" href="http://www.begun.ru/advertiser/?r1=Begun&r2=adbegun" style="color:{begun_auto_colors2};line-height:100% !important;" target="_blank"><font style="font-size:{begun_auto_fonts_size3};" color="{begun_auto_colors2}">{text1}</font></a></td> \
        <td align="right"  width="33%" style="cursor:default;"><a class="snap_noshots" href="http://www.begun.ru/partner/?r1=Begun&r2=become_partner" style="color:{begun_auto_colors2};line-height: 100% !important;" target="_blank"><font style="font-size:{begun_auto_fonts_size3};" color="{begun_auto_colors2}">{text2}</font></a> \
        </td></tr></table>';
    var stubRaTpl = '{{showformv}}\
        <form name="ramlerSbegun" class="{begun_rambler_style}" target="_blank" action="http://www.rambler.ru/srch" method="get">\
        <input type="hidden" name="set" value="www" /><input type="hidden" name="sbox" value="{sbox}" />\
        <table width="{begun_auto_width}" cellpadding="0" cellspacing="0" border="0">\
        <tr><td style="padding:2px;padding-left:15px;text-align:left;"><img width="117" height="24" src="http://autocontext.begun.ru/{begun_rambler_img}" alt="Rambler" /></td></tr>\
        <tr><td style="padding-left:11px;">\
        <table width="100%"><tr>\
        <td><input type="text" name="words" value="" style="width:100%;height:18px;" /></td>\
        <td width="75"><input type="submit" name="beguns" style="margin-left:10px;width: 70px; height:24px;" value="'+rambler_search_text+'" /></td>\
        </tr></table>\
        </td></tr></table>\
        </form>\
       {{/showformv}}\
       {{showformh}}\
        <form name="ramlerSbegun" class="{begun_rambler_style}" target="_blank" action="http://www.rambler.ru/srch" method="get">\
        <input type="hidden" name="set" value="www" /><input type="hidden" name="sbox" value="{sbox}" />\
        <table width="{begun_auto_width}" cellpadding="0" cellspacing="0" border="0">\
        <tr><td style="padding:2px;padding-left:15px;text-align:left;" width="125"><img width="117" height="24" src="http://autocontext.begun.ru/{begun_rambler_img}" alt="Rambler" /></td>\
        <td><table width="100%"><tr>\
        <td style="margin:0px;padding:0px;"><input type="text" name="words" value="" style="width:100%;height:18px;" /></td>\
        <td style="margin:0px;padding:0px;" width="75"><input type="submit" name="beguns" style="margin-left:10px;width: 70px; height:24px;" value="'+rambler_search_text+'" /></td>\
        </tr></table>\
        </td></tr></table></form>\
        {{/showformh}}\
    ';
    if(begunChkParam('style', 'fixed')) {
        var stubTpl = stubFixedTpl + stubRaTpl; 
    } else {
        var stubTpl = stubNormlTpl + stubRaTpl; 
    }
    if (isComp)
        var template = new bJsT();
    else
        var template = new bJsTs();
    template.tpl = stubTpl;
    if (begunParams.showhref)
        template.block('showhref');
    begun_rambler_style = 'ramblersbox1';
    begun_rambler_img = 'rambler_2.gif';
    if(window.begun_rambler_type && window.begun_rambler_type == 1) {
        begun_rambler_style='ramblersbox';
        begun_rambler_img='rambler_1.gif';
    }
    if(begunStubs[5] && begunStubs[5].text && sWidth>=250) {
        if(sWidth>=350)
            template.block('showformh');
        else
            template.block('showformv');
    }

    var vars = {
        'begun_auto_colors2': begun_auto_colors[2], 'begun_auto_colors3': begun_auto_colors[3],
        'begun_auto_fonts_size3': begun_auto_fonts_size[3],
        'href0': begunStubs[0].href, 'text0': begunStubs[0].text,
        'text1': begunStubs[1].text, 'text2': begunStubs[2].text,
        'begun_auto_width': sWidth,
        'sbox': begunStubs[5].text,
        'begun_rambler_style' : begun_rambler_style,
        'begun_rambler_img' : begun_rambler_img,
	'begun_autowidth_string' : begun_autowidth_string
    }
    if (begunParams.autoscroll)
        vars.begun_auto_width = sWidth + 3;
    else
        vars.begun_auto_width = sWidth;
    return template.parse(vars);
}

function begun_logic_item(item)
{
    if (typeof(item[7])=="undefined"){item[7]='Card, Url';}
    if (item[7]!='Card, Url' && item[7]!='Card' && item[7]!='Url'){item[7]='Card, Url';}

    if (typeof(item[2])=="undefined"){item[2]='';}
    if (typeof(item[6])=="undefined"){item[6]='';}

    if (item[2]=='' && item[6]==''){return item;}
    if (item[2]=='' && item[6]!=''){item[7]='Card';}
    if (item[2]!='' && item[6]==''){item[7]='Url';}
    if (item[2]!='' && item[6]!=''){item[7]=item[7];}

    switch (item[7]) {
        case 'Card':    {item[2]=item[6]; break;}
        case 'Card, Url':   {break;}
        case 'Url': {
            break;
        }
    }
    return item;
}

function getBanner(bb, bWidth, isLast) {
    bb = begun_logic_item( bb );
    if (!bWidth)
        var bWidth = begun_auto_width;

    var suff = isLast ? 'l' : '';
    var rambler_textb_call = decodeURI('%D0%97%D0%B2%D0%BE%D0%BD%D0%B8%D1%82%D1%8C');
	var rambler_textb_call_tooltip = decodeURI('%D0%97%D0%B2%D0%BE%D0%BD%D0%BE%D0%BA%20%D0%B1%D0%B5%D1%81%D0%BF%D0%BB%D0%B0%D1%82%D0%BD%D1%8B%D0%B9');
    var rambler_textb_contacts = decodeURI('%D0%9A%D0%BE%D0%BD%D1%82%D0%B0%D0%BA%D1%82%D1%8B');

    var fixedParam = {'wrap' : 'white-space: nowrap;', 'fixpadding' : false};
    if(begunChkParam('style', 'fixed')) {
        fixedParam['wrap'] = '';
        fixedParam['fixpadding'] = true;
    }
    
    var bannerTpl = '\
    <li class="bgulli{rndID}'+suff+'"> \
        {{thumbs}}<div style="float:left !important;"><a class="snap_noshots" href="{bb2}" {begun_target}><img src="{thumbSrc}" class="bgthumb" border="0" width="56" height="42"></a></div>{{/thumbs}} \
        \
        <div class="bgbanner"> \
            <div style="' + (fixedParam.fixpadding ? 'font-size:{begun_auto_fonts_size0};' : '') + '"><a class="begun snap_noshots" style="color:{begun_auto_colors0};font-size:{begun_auto_fonts_size0};font-weight:{begun_bold};cursor:pointer" {begun_target} href="{bb2}" onmouseover="status=\'http://{domain}/\';return true" onmouseout="status=\'\';return true" title="{domain}">{bb0}</a></div> \
            <div style="' + (fixedParam.fixpadding ? 'font-size:{begun_auto_fonts_size1};' : '') + 'margin-top:3px;"><a class="begun snap_noshots" {begun_target} href="{bb2}" style="font-size:{begun_auto_fonts_size1};color:{begun_auto_colors1};text-decoration:none;" onmouseover="status=\'http://{domain}/\';return true" onmouseout="status=\'\';return true" title="{domain}">{bb1}</a></div> \
            <div style="' + (fixedParam.fixpadding ? 'font-size:{begun_auto_fonts_size2};margin-top:2px;' : 'margin-top:3px;') +' "> \
                {{site}}<a class="begun snap_noshots" {begun_target} href="{bb2}" style="'+fixedParam.wrap+'font-size:{begun_auto_fonts_size2};color:{begun_auto_colors2};text-decoration:none;" onmouseover="status=\'http://{domain}/\';return true" onmouseout="status=\'\';return true" title="{domain}">{bb4}</a>{{/site}} ' +(fixedParam.wrap == '' ? '' : '<span style="white-space: nowrap">' )+ '\
                {{ppcall}}<img src="http://autocontext.begun.ru/phone_icon.gif" style="width:12px;height:8px;border:none;" alt="" />&nbsp;<a href="javascript:void(0);" onClick="Begun.Ppcall.showEnterForm({i}, this,event, null, \'{link}\', {is_mobile});" class="begun snap_noshots" style="font-size:{begun_auto_fonts_size2};color:{begun_auto_colors2};text-decoration:none;" title="' + rambler_textb_call_tooltip + '">'+rambler_textb_call+'</a>{{/ppcall}} \
                {{ppcallcard}}<img src="http://autocontext.begun.ru/phone_icon.gif" style="width:12px;height:8px;border:none;" alt="" />&nbsp;<a href="{card_href}" target="_blank" class="begun snap_noshots" style="font-size:{begun_auto_fonts_size2};color:{begun_auto_colors2};text-decoration:none;">'+rambler_textb_contacts+'</a>&nbsp;<span style="color: #aaa;font-size:10px;">&#149;</span>&nbsp;<a href="javascript:void(0);" onClick="Begun.Ppcall.showEnterForm({i}, this, event, null, \'{link}\', {is_mobile});" class="begun snap_noshots" style="font-size:{begun_auto_fonts_size2};color:{begun_auto_colors2};text-decoration:none;" title="' + rambler_textb_call_tooltip + '">'+rambler_textb_call+'</a>{{/ppcallcard}}\
				{{card}}<img src="http://autocontext.begun.ru/phone_icon.gif" style="width:12px;height:8px;border:none;" alt="" />&nbsp;<a href="{card_href}" target="_blank" class="begun snap_noshots" style="font-size:{begun_auto_fonts_size2};color:{begun_auto_colors2};text-decoration:none;">'+rambler_textb_contacts+'</a>{{/card}}\
	'+ (fixedParam.wrap == '' ? '' : '</span>' ) +' \
            </div> \
        </div> \
    </li> \
    ';

    if (isComp)
        var template = new bJsT();
    else
        var template = new bJsTs();
    template.tpl = bannerTpl;
    if (bb == null)
        return '';
    if (bb[4] == null) bb[4] = '';
    if (begunParams.thumbs) {
        var thumbSrc = begunParams['thumbs_src'] ? 'http://' + begunParams['thumbs_src'] + '/' : 'http://thumbs.begun.ru/';
        if (bb[5] != undefined && bb[5].toString().length > 3) {
            var thematic = bb[9] ? (bb[9].split(',')[0] + '') : '1';
            var bannerId = bb[5].toString();
            thumbSrc = thumbSrc + bannerId.charAt( bannerId.length - 2 );
            thumbSrc = thumbSrc + '/' + bannerId.charAt( bannerId.length - 1 );
            thumbSrc = thumbSrc + '/' + bannerId + '.jpg';
            thumbSrc += '?t=' + thematic + '&r=' + bannerId.charAt(bannerId.length - 3);
        } else {
            thumbSrc = thumbSrc + 'empty.jpg';
        }
        template.block('thumbs');
    }
    if ( typeof( window.ppcallArray ) == 'undefined' || window.ppcallArray == null ){
        window.ppcallArray = [];
    }
    if ( typeof( window.ppcallFormArray ) == 'undefined' || window.ppcallFormArray == null ){
        window.ppcallFormArray = [];
    }
    switch(bb[7]){
        case "Card, Url": {
            template.block("site");
            if(ppcallArray[i]==1)
                template.block('ppcallcard');
            else
                template.block("card");
        } break;
        case "Url": {
            template.block("site");
            if(ppcallArray[i]==1) template.block('ppcall');
        } break;
        case "Card":{
            if(ppcallArray[i]==1)
                template.block('ppcallcard');
            else
                template.block("card");
            bb[2] = bb[6];
        } break;
        default: break;
    }
    function getDomain(s){
        return s.replace(/^(.*?) - (.*?)$/i, "$1");
    }
    var vars = {
        'bb0': bb[0], 'bb1': bb[1], 'bb2': bb[2], 'bb3': bb[3], 'bb4': bb[4],
        'begun_auto_colors0': begun_auto_colors[0], 'begun_auto_colors1': begun_auto_colors[1],
        'begun_auto_colors2': begun_auto_colors[2],
        'begun_auto_fonts_size0': begun_auto_fonts_size[0], 'begun_auto_fonts_size1': begun_auto_fonts_size[1],
        'begun_auto_fonts_size2': begun_auto_fonts_size[2],
        'i': i, 'begun_target': begun_target, 'begun_auto_width': bWidth,
	'link': ppcallFormArray[i],
        'is_mobile': Number(begunParams.is_mobile),
	'begun_bold': begun_bold, 'thumbSrc': thumbSrc, 'rndID': rndID,
        'card_href': bb[6], 'domain': getDomain(bb[4])
    }
    return template.parse(vars);
}

function begunFillIfNotExist(oldCollection, newCollection) {
    for(var key in newCollection) {
        oldCollection[key] = oldCollection[key] || newCollection[key];
    }
}

function begunPrint() {
    isComp = chkAgent();
    if (window.begun_block_type == 'Horizontal')
        begunParams.wide = 1;
    if (window.begun_block_type == 'Vertical')
        begunParams.wide = 0;
    if (window.ppcallArray && window.ppcallArray.toString().indexOf("1") !== -1) {
		document.write('<scr' + 'ipt src="http://autocontext.begun.ru/auto_ppcall.js" type="text/javascript"></scr' + 'ipt>');
		var ppcallsShown = 0;
		for (var ppcallIndex = 0; ppcallIndex < window.ppcallArray.length; ppcallIndex++) {
			if (window.ppcallArray[ppcallIndex] == 1) {
				ppcallsShown++;
			}
		}
		var ppcallsLogInfo = "[{\"pad_id\":" + window.begun_auto_pad + ",\"blocks\":[{\"id\":null,\"ppcall_count\":" + ppcallsShown + "}]}]";
		(new Image()).src = "http://autocontext.begun.ru/ppcallcounter?data=" + encodeURIComponent(ppcallsLogInfo) + "&log_ppcall_visibility=1";
    }
    begun_auto_width = window.begun_auto_width || 350;
    begun_auto_limit = window.begun_auto_limit || 3;
    begun_scroll_height = window.begun_scroll_height || '';
    var begunSpans = window.begun_spans;

    var fixedParam = {'font2' : '#00CC00'};
    if(begunChkParam('style', 'fixed')) {
        fixedParam['font2'] = '#167201';
    }
    if(typeof(begun_auto_colors) == "undefined") begun_auto_colors = [];
    if(typeof(begun_auto_fonts_size) == "undefined") begun_auto_fonts_size = [];
    var defFontColor = ['#0000CC', '#000000', fixedParam.font2, '#FFFFFF'];
    begunFillIfNotExist(begun_auto_colors, defFontColor);
    var defFontSize = ['10pt', '9pt', '9pt', '9pt'];
    begunFillIfNotExist(begun_auto_fonts_size, defFontSize);
    begun_target = 'target="_blank"';
    begun_bold = 'bold';

    rndID = Math.round(Math.random() * 99 + 2); // not "+ 1", or else we might have 2 "bgul1" CSS classes

    if (begunParams.multispan)
        begunParams.wide = 0;

    if (begunParams.wide) {
        if (begun_auto_limit < 3)
            begun_auto_limit = 3;
        else if (begun_auto_limit > 5)
            begun_auto_limit = 5;
        begunBanners = begunBanners.slice(0, begun_auto_limit);
    }
    //for (var i in begunBanners) {
    //    begunBanners[i][0] = begunBanners[i][0].begunSplit(30);
    //    begunBanners[i][1] = begunBanners[i][1].begunSplit(70);
    //};

    document.write(getCss());

    var begunContent = '';
    var begunContentHeader = '';

    if (begunParams.autoscroll) {
        _begun_auto_width = begun_auto_width + 3;
        begunContentHeader = '<div id="begunScroll" style="width: ' + _begun_auto_width + 'px; height: '+(begun_view_limit * begun_scroll_height)+'px; background-color:'+begun_auto_colors[3]+'; overflow:hidden;"> \
        <div id="begunSpacer" style="height: 0px"></div>';
    }
    if (typeof window.begunExtLinks == 'object') {
    	for (var indx = 0; indx < window.begunExtLinks.length; indx++) {
    		if (window.begunExtLinks[indx][0] == 'js') {
    			include(window.begunExtLinks[indx][1], true);
    		} else if (window.begunExtLinks[indx][0] == 'img') { 
    			document.write('<img src="' + window.begunExtLinks[indx][1] + '" width="1" height="1" border="0" />');
    		}
    	}
    }
    if (!begunParams.multispan) {
        begunContentHeader += '<div><ul class="bgul'+rndID+'" id="begunRoot">';
        begunContent += begunContentHeader;
        if (begunBanners != null) {
            for (i = 0; i < begunBanners.length; i++)
                begunContent += getBanner(begunBanners[i], null, i == begunBanners.length  - 1 ? 1 : 0);
        }
        begunContent += '</ul>';
        if (begunParams.wide)
            begunContent += '<div style="clear:left;"></div>';
        if (begunParams.autoscroll)
            begunContent += '</div>'
        if (begunParams.stub)
            begunContent += getStub();
        begunContent += '</div>';
    } else {
        begunContentHeader += '<ul class="bgul1" id="begunRoot">';

        if (begunBanners.length && typeof begunSpans !== "undefined") {
            i = 0;
            for (var j = 0 ; j < begunSpans.length; j++ ) {
                begunContent = '';
                var breakFlag = 0;
                if (!document.getElementById(begunSpans[j].span_id)) continue;
                if (begunSpans[j].width)
                    var spanWidth = begunSpans[j].width;
                else
                    var spanWidth = begun_auto_width;
                begunContent += begunContentHeader.substr(0, begunContentHeader.length - 1) + ' style="width:'+spanWidth+'px;">';
                if (begunBanners != null) {
                    for (k = 0; k < begunSpans[j].limit; k++) {
                        if (typeof begunBanners[i] == 'object') {
                            begunContent += getBanner(begunBanners[i], spanWidth, k == begunBanners.length - 1 ? 1 : 0);
                            i++;
                        } else {
                            breakFlag = 1;
                            break;
                        }
                    }
                    if(begunChkParam('style', 'fixed')) {
                        begunContent += '</ul>';
                    }
                    if (begunParams.stub)
                        begunContent += getStub(spanWidth);
                    if(!begunChkParam('style', 'fixed')) {
                        begunContent += '</ul>';
                    }
                    document.getElementById(begunSpans[j].span_id).innerHTML = begunContent;
                    if (breakFlag) break;
                }
            }
        }
    }
    
    if (typeof begunSpans == 'object') {}
    else if (document.getElementById('begunSpan'))
        document.getElementById('begunSpan').innerHTML = begunContent;
    else
        document.write(begunContent);
    if (begunParams.autoscroll) {
        document.write('<scr' + 'ipt type="text/javascript">scrollPrint();</scr' + 'ipt>');
    }

    if (begunParams.begun_auto_hyper) {
        include('http://autocontext.begun.ru/hypertext_a.js');
        document.write('<scr' + 'ipt type="text/javascript">hyperRun();</scr' + 'ipt>');
    }
}


function begunAutoRun() {
	begunAdaptResponse();
	begunPrint();

	begunAutoRun = null;
}

function begunGetFrameLevel(){
	var level = 0;
	var _parent = self;
	while (_parent !== top && level < 999){
		_parent = _parent.parent;
		level++;
	}
	return level;
}

begun_auto_url = (begun_urls && begun_urls.daemon) ? begun_urls.daemon : 'http://autocontext.begun.ru/context.jsp?';
var params = {
	'pad_id': window.begun_auto_pad,
	'lmt': Date.parse(document.lastModified) / 1000,
	'n': window.begun_auto_limit,
	'begun_utf8': window.begun_utf8,
	'begun_koi8': window.begun_koi8,
	'begun_scroll': window.begun_scroll,
	'many_span': window.many_span,
	'misc_id': typeof(window.begun_misc_id) == 'undefined' ? window.misc_id : window.begun_misc_id,
	'begun_multispan': window.begun_multispan,
	'sense_mode': 'custom',
	'stopwords': window.stopwords || '',
	'begun_self_keywords': window.begun_self_keywords,
	'jscall': 'begunAutoRun',
	'json': 1,
	'ref': document.referrer,
	'real_refer': document.location,
	'pure_graph_data': window.begun_pure_graph_data || 0
}
if(screen && screen.width && screen.height) {
	params['ut_screen_width'] = screen.width;
	params['ut_screen_height'] = screen.height;
}
begun_frame_level = begunGetFrameLevel();
if (begun_frame_level){
	params['frm_level'] = begun_frame_level;
	try{
		params['frm_top'] = top.location.href;
	}catch(e){
		params['frm_top'] = 'top not accessible';
	}
}

begunAppend(params);

if (window.begun_scroll) {
	var host = 'http://autoscroll.begun.ru/';
	var jsfiles = ['prototype.lite.js', 'moo.fx.js', 'moo.fx.scroll.js', 'begunScroll.js'];
	for (var i in jsfiles)
		if (jsfiles[i] && jsfiles.hasOwnProperty && jsfiles.hasOwnProperty(i)) // always check for own property in for .. in ..
			include(host + jsfiles[i]);
} 

function begunIsDefined(value, substitute){
	return typeof value == "undefined" ? substitute : value;
}

(function() {
if (typeof window.begunToolbarLoaded === "undefined") {
	window.begunToolbarLoaded = function() {
		if (typeof Begun === "undefined" || !Begun.Toolbar || !Begun.Toolbar.init) {
			return;
		}
		while (begunAdaptResponse.unhandledDebugs.length > 0) {
			Begun.Toolbar.init(begunAdaptResponse.unhandledDebugs.pop());
		}
	}
} else {
	var btl = window.begunToolbarLoaded;
	window.begunToolbarLoaded = function() {
		btl();
		if (typeof Begun === "undefined" || !Begun.Toolbar || !Begun.Toolbar.init) {
			return;
		}
		while (begunAdaptResponse.unhandledDebugs.length > 0) {
			Begun.Toolbar.init(begunAdaptResponse.unhandledDebugs.pop());
		}
	};
}
})();

if (typeof begunAdaptResponse === "undefined") {
begunAdaptResponse = function() {

	if (typeof window.begunAds == "undefined"){
		return;
	}

	if (window.begunAds.debug) {
		if (typeof begunAdaptResponse.unhandledDebugs === "undefined") {
			begunAdaptResponse.unhandledDebugs = [];
		}

		var debugCopy = {};
		for (var debugEntity in window.begunAds.debug) {
			if (window.begunAds.debug.hasOwnProperty(debugEntity)) {
				debugCopy[debugEntity] = window.begunAds.debug[debugEntity];
			}
		}
		delete begunAds.debug;
		begunAdaptResponse.unhandledDebugs.push(debugCopy);
		begunToolbarLoaded();
	}

	var obj, emptyStr = "";

	function begunParseBanners(){
		if (typeof window.ppcallFormArray === "undefined") {
			window.ppcallFormArray = [];
		}
		window.begunBanners = [];
	
		for (var i = 0; i < window.begunAds.banners.autocontext.length; i++){
			obj = window.begunAds.banners.autocontext[i];
			window.ppcallFormArray[i] = obj.ppcall_form;
			window.begunBanners[i] = [
				begunIsDefined(obj.title, emptyStr),
				begunIsDefined(obj.descr, emptyStr),
				begunIsDefined(obj.url, emptyStr),
				begunIsDefined(obj.price, 0.0),
				begunIsDefined(obj.domain, emptyStr),
				begunIsDefined(obj.banner_id, 0),
				begunIsDefined(obj.card, emptyStr),
				begunIsDefined(obj.cards_mode, emptyStr),
				begunIsDefined(obj.constraints, emptyStr),
				begunIsDefined(obj.thematics, emptyStr)
			];
		}
	}

	function begunParseLinks(){

		window.begunExtLinks = [];

		for (var i = 0; i < window.begunAds.links.length; i++){
			obj = window.begunAds.links[i];
			window.begunExtLinks[i] = [];
			window.begunExtLinks[i][0] = obj.type;
			window.begunExtLinks[i][1] = obj.url;
		}
	}

	function begunParseParams(){
		window.begunParams = window.begunAds.params;
	}

	function begunParsePPCall(){
		if (typeof window.ppcallArray === "undefined") {
			window.ppcallArray = [];
		}
		for (var i = 0; i < window.begunAds.banners.autocontext.length; i++){
			window.ppcallArray[i] = parseInt(window.begunAds.banners.autocontext[i].ppcall);
			window.ppcallFormArray[i] = window.begunAds.banners.autocontext[i].ppcall_form;
		}
	}

	function begunParseStubs(){
	
		window.begunStubs = [];
	
		var stubs = {
			begun_advert: '&#1056;&#1077;&#1082;&#1083;&#1072;&#1084;&#1072; &#1085;&#1072; &#1041;&#1077;&#1075;&#1091;&#1085;&#1077;',
			/*place_here: '&#1044;&#1072;&#1090;&#1100; &#1086;&#1073;&#1098;&#1103;&#1074;&#1083;&#1077;&#1085;&#1080;&#1077;',*/
			all_banners: '&#1042;&#1089;&#1077; &#1086;&#1073;&#1098;&#1103;&#1074;&#1083;&#1077;&#1085;&#1080;&#1103;',
			become_partner: '&#1057;&#1090;&#1072;&#1090;&#1100; &#1087;&#1072;&#1088;&#1090;&#1085;&#1077;&#1088;&#1086;&#1084;'};
	
		obj = window.begunAds.stubs;
	
		window.begunStubs[0] = {
			href:	obj.all_banners,
			text:	stubs.all_banners
		};
		window.begunStubs[1] = {text:	stubs.begun_advert};
		window.begunStubs[2] = {text:	stubs.become_partner};
		window.begunStubs[3] = {text:	obj.rambler_sbox_btn_text};
		window.begunStubs[4] = {text:	obj.rambler_sbox_auto};
		window.begunStubs[5] = {text:	obj.rambler_sbox};
		window.begunStubs[6] = {href:	obj.behav_all_banners};
	
	}

	begunParseBanners();
	begunParseLinks();
	begunParseParams();
	begunParsePPCall();
	begunParseStubs();
}
}

(function(){
	var USE_NEW_BLOCKS = true; // new blocks or no new blocks
	var is_multispan = (window.begun_spans || window.begun_multispan || document.getElementById("begunSpan"));

	if (!is_multispan){
		var old_params = ['begun_auto_pad', 'begun_auto_limit', 'begun_view_limit', 'begun_auto_width', 'begun_auto_colors[0]', 'begun_auto_colors[1]', 'begun_auto_colors[2]', 'begun_auto_colors[3]', 'begun_auto_fonts_size[0]', 'begun_auto_fonts_size[1]', 'begun_auto_fonts_size[2]', 'begun_auto_fonts_size[3]', 'begun_block_type', 'misc_id', 'begun_scroll', 'begun_rambler_type'];
		var old_block_counter = 'http://autocontext.begun.ru/blockimport.png?';
		for (var i = 0; i < old_params.length; i++){
			var res = '';
			try{
				res = eval(old_params[i]);
			}catch(e){
				//
			}
			old_block_counter += (res ? old_params[i] + '=' + encodeURIComponent(res) + '&' : '');
		}
		(new Image()).src = old_block_counter; // log 'em all, except is_multispan
	}

	if ((!USE_NEW_BLOCKS) || (USE_NEW_BLOCKS && is_multispan)){
		include(begun_auto_url.substring(0, 1524).replace(/%[0-9a-fA-F]?$/, ''));
		(new Image()).src = "http://autocontext.begun.ru/blockcounter?pad_id=" + window.begun_auto_pad + "&old_block=1";
		return;
	}
	
	var VERTICAL_BLOCK_TYPE = "vertical";
	var HORIZONTAL_BLOCK_TYPE = "horizontal";
	var OLD_HORIZONTAL_BLOCK_TYPE = "Horizontal";
	
	window.begun_urls = window.begun_urls || {};
	window.begun_urls.block_js = '';
	
	window.begun_block_id = Math.round(Math.random() * 10000000);
	window.begun_total_banners = window.begun_auto_limit || 0;
	
	window.begun_extra_block = (function(){
		return {
			id: window.begun_block_id,
			options: {
				visual: getVisualParams(),
				dimensions: {
					type: getBlockType(),
					width: window.begun_auto_width || 0
				},
				banners_count: getBannersCount(),
				use_scroll:	isNaN(window.begun_scroll) ? 0 : window.begun_scroll
			}
		}
	})();
	
	function getBannersCount(){
		return typeof window.begun_scroll != 'undefined' && window.begun_scroll && typeof window.begun_view_limit != 'undefined' && window.begun_view_limit ? window.begun_view_limit : window.begun_total_banners;
	}

	function getVisualParams() {
		var res = {};
		
		if (typeof window.begun_auto_colors !== "undefined") {
			if (begun_auto_colors[0]) {
				res.title = res.title || {};
				res.title.color = begun_auto_colors[0] || 'inherit';
			}
			if (begun_auto_colors[1]) {
				res.text = res.text || {};
				res.text.color = begun_auto_colors[1] || 'inherit';
			}
			if (begun_auto_colors[2]) {
				res.domain = res.domain || {};
				res.domain.color = begun_auto_colors[2] || 'inherit';
			}
			if (begun_auto_colors[3]) {
				res.block = res.block || {};
				res.block.backgroundColor = begun_auto_colors[3] || 'inherit';
			}
		}
		if (typeof window.begun_auto_fonts_size !== "undefined") {
			if (begun_auto_fonts_size[0]) {
				res.title = res.title || {};
				res.title.fontSize = begun_auto_fonts_size[0] || 'inherit';
			}
			if (begun_auto_fonts_size[1]) {
				res.text = res.text || {};
				res.text.fontSize = begun_auto_fonts_size[1] || 'inherit';
			}
			if (begun_auto_fonts_size[2]) {
				res.domain = res.domain || {};
				res.domain.fontSize = begun_auto_fonts_size[2] || 'inherit';
			}
			if (begun_auto_fonts_size[3]) {
				res.block = res.block || {};
				res.block.fontSize = begun_auto_fonts_size[3] || 'inherit';
			}
		}
		
		return res;
	}
	
	function getBlockType(){
		if (window.begun_block_type === undefined){
			return VERTICAL_BLOCK_TYPE;
		}
		return window.begun_block_type == OLD_HORIZONTAL_BLOCK_TYPE ?
			HORIZONTAL_BLOCK_TYPE : VERTICAL_BLOCK_TYPE;
	}

	include(getACPath());

	function getACPath(){
		return (typeof window.begun_urls !== "undefined" && typeof window.begun_urls.base_scripts_url !== "undefined") ?
			window.begun_urls.base_scripts_url + "/autocontext2.js" :
				"http://autocontext.begun.ru/autocontext2.js";
	}
})();
function begunFixPNG(element)
{
	if (/MSIE (5\.5|6).+Win/.test(navigator.userAgent))
	{
		var src;
		
		if (element.tagName=='IMG')
		{
			if (/\.jpg/.test(element.src))
			{
				src = element.src;
				element.src = "http://autocontext.begun.ru/img/blank.gif";
			}
		}
		
		if (src) element.runtimeStyle.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + src + "',sizingMethod='scale')";
	}
}
