function BegunCodeProcessor()
{
	this.spans = new Array();
	this.style = {};

	this.getElementsByClass = function(sClass, sTag, oRootEl)
	{
		sTag = sTag || "*";
		oRootEl = oRootEl || document;
		var a = new Array();
		var oColl = oRootEl.getElementsByTagName(sTag);
		if (!oColl.length && sTag == "*" && oRootEl.all)
			oColl = oRootEl.all
		for (var i = 0, j = oColl.length; i < j; i++)
		{
			var aObjClass = oColl[i].className.split(' ');
			for (var k = 0, l = aObjClass.length; k < l; k++)
			{
				if (sClass == aObjClass[k])
				{
					a.push(oColl[i]);
					break;
				}
			}
		}
		return a;
	}

	this.getElementByClass = function(sClass, sTag, oRootEl)
	{
		sTag = sTag || "*";
		oRootEl = oRootEl || document;
		var oColl = oRootEl.getElementsByTagName(sTag);
		if (!oColl.length && sTag == "*" && oRootEl.all)
			oColl = oRootEl.all;
		for (var i = 0, j = oColl.length; i < j; i++)
		{
			var aObjClass = oColl[i].className.split(' ');
			for (var k = 0, l = aObjClass.length; k < l; k++)
			{
				if (sClass == aObjClass[k])
					return oColl[i];
			}
		}
	}

	this.setCookie = function(name, value, expireDays)
	{
		var date = new Date();
		date.setTime(date.getTime() + expireDays * 24 * 60 * 60 * 1000);
		document.cookie = name +'='+ value + '; expires='+ date.toGMTString() +'; path=/';
	}

	this.getCookie = function(searchName)
	{
		var aCookies = document.cookie.split(';');
		var aTemp = '';
		var name = '';
		var value = '';

		for (var i = 0; i < aCookies.length; i++)
		{
			aTemp = aCookies[i].split('=');
			name = aTemp[0].replace(/^\s+|\s+$/g, '');

			if (name == searchName)
			{
				if (aTemp.length > 1)
					value = unescape(aTemp[1].replace(/^\s+|\s+$/g, ''));
				return value;
			}
		}
		return '';
	}

	this.getSpanByName = function(sName)
	{
		for (var i = 0; i < this.spans.length; i++)
		{
			if (this.spans[i].span_id == sName)
				return this.spans[i];
		}
	}

	this.swoopInitValues = function(oBlock, oSpan)
	{
		var oBegunDiv = this.getElementByClass('begunBegun', 'div', oBlock);
		if (typeof(oBegunDiv) != 'undefined')
		{
			if (oBegunDiv.style.height == '')
				oBegunDiv.style.height = parseInt(oBegunDiv.offsetHeight) +'px';
			if (typeof(oSpan.swoopBegunHeight) == 'undefined')
				oSpan.swoopBegunHeight = parseInt(this.getElementByClass('begunSubBegun', 'div', oBlock).offsetHeight);
		}
		else
			oSpan.swoopBegunHeight = 0;
		var aElements = this.getElementsByClass('begunRecord', 'div', oBlock);
		for (var i = 0; i < aElements.length; i++)
		{
			if (aElements[i].style.height == '')
				aElements[i].style.height = parseInt(aElements[i].offsetHeight) +'px';
		}
		if (typeof(oSpan.swoopMaxHeight) == 'undefined')
		{
			oSpan.swoopMaxHeight = 0;
			for (var i = 0; i < aElements.length; i++)
			{
				var iMaxHeight = parseInt(this.getElementByClass('begunSubRecord', 'div', aElements[i]).offsetHeight);
				if (oSpan.swoopMaxHeight < iMaxHeight)
					oSpan.swoopMaxHeight = iMaxHeight;
			}
		}
		if (typeof(oSpan.swoopMinHeight) == 'undefined')
		{
			oSpan.swoopMinHeight = 0;
			for (var i = 0; i < aElements.length; i++)
			{
				iMinHeight = parseInt(this.getElementByClass('begunTitle', 'div', aElements[i]).offsetHeight);
				if (oSpan.swoopMinHeight < iMinHeight)
					oSpan.swoopMinHeight = iMinHeight;
			}
		}
	}

	this.swoopInit = function(sBlock, bExpand, bForceMarker)
	{
		var oBlock = document.getElementById(sBlock);
		var oSpan = this.getSpanByName(sBlock);
		if (typeof(oBlock) == 'undefined' || typeof(oSpan) == 'undefined')
			return;
		if (typeof(oSpan.swoopPid) == 'undefined')
			oSpan.swoopPid = 0;
		this.swoopInitValues(oBlock, oSpan);
		if (oSpan.swoopPid != 0 && !bForceMarker)
			return;
		oSpan.swoopPid = Math.round(Math.random() * 1000 + 1);
		if (bExpand)
			this.swoopSwitchVisibility(oBlock, bExpand);
		setTimeout('begun.swoop("'+ sBlock +'", '+ bExpand +', '+ oSpan.swoopPid +');', 20);
	}

	this.swoopSwitchVisibility = function(oBlock, bExpand)
	{
		var aElements = this.getElementsByClass('begunThumb', 'div', oBlock);
		for (var i = 0; i < aElements.length; i++)
			aElements[i].style.visibility = (bExpand ? 'visible' : 'hidden');
		var aElements = this.getElementsByClass('begunBody', 'div', oBlock);
		for (var i = 0; i < aElements.length; i++)
			aElements[i].style.visibility = (bExpand ? 'visible' : 'hidden');
	}

	this.swoop = function(sBlock, bExpand, iPid)
	{
		var oBlock = document.getElementById(sBlock);
		var oSpan = this.getSpanByName(sBlock);
		if (typeof(oBlock) == 'undefined' || typeof(oSpan) == 'undefined' || iPid != oSpan.swoopPid)
			return;
		var aElements = this.getElementsByClass('begunRecord', 'div', oBlock);
		var oBegunDiv = this.getElementByClass('begunBegun', 'div', oBlock);
		var bStop = true;
		if (bExpand)
		{
			if (typeof(oBegunDiv) != 'undefined')
			{
				oBegunDiv.style.display = 'block';
				oBegunDiv.style.height = (parseInt(oBegunDiv.style.height) + 5 >= oSpan.swoopBegunHeight ? oSpan.swoopBegunHeight : parseInt(oBegunDiv.style.height) + 5) +'px';
			}
			for (var i = 0; i < aElements.length; i++)
			{
				if (parseInt(aElements[i].style.height) >= oSpan.swoopMaxHeight)
					continue;
				aElements[i].style.height = (parseInt(aElements[i].style.height) + 5 >= oSpan.swoopMaxHeight ? oSpan.swoopMaxHeight : parseInt(aElements[i].style.height) + 5) +'px';
				bStop = false;
			}
		}
		else
		{
			if (typeof(oBegunDiv) != 'undefined')
			{
				if (parseInt(oBegunDiv.style.height) - 5 <= 0)
				{
					oBegunDiv.style.height = 0;
					oBegunDiv.style.display = 'none';
				}
				else
					oBegunDiv.style.height = parseInt(oBegunDiv.style.height) - 5 +'px';
			}
			for (var i = 0; i < aElements.length; i++)
			{
				if (parseInt(aElements[i].style.height) <= oSpan.swoopMinHeight)
					continue;
				aElements[i].style.height = (parseInt(aElements[i].style.height) - 5 <= oSpan.swoopMinHeight ? oSpan.swoopMinHeight : parseInt(aElements[i].style.height) - 5) +'px';
				bStop = false;
			}
		}
		if (bStop)
		{
			oSpan.swoopPid = 0;
			if (!bExpand)
				this.swoopSwitchVisibility(oBlock, bExpand);
			return;
		}
		setTimeout('begun.swoop("'+ sBlock +'", '+ bExpand +', '+ iPid +');', 20);
	}

	this.swoopCollapse = function(sBlock, bExpand)
	{
		var oBlock = document.getElementById(sBlock);
		var oSpan = this.getSpanByName(sBlock);
		if (typeof(oBlock) == 'undefined' || typeof(oSpan) == 'undefined' || oBlock.style.display == 'none')
			return;
		clearInterval(oSpan.swoopCollapsePid);
		oSpan.swoopCollapsePid = 0;
		this.swoopInitValues(oBlock, oSpan);
		var aElements = this.getElementsByClass('begunRecord', 'div', oBlock);
		var oBegunDiv = this.getElementByClass('begunBegun', 'div', oBlock);
		if (typeof(oBegunDiv) != 'undefined')
		{
			oBegunDiv.style.height = (bExpand ? oSpan.swoopBegunHeight : 0) +'px';
			oBegunDiv.style.display = (bExpand ? 'block' : 'none');
		}
		for (var i = 0; i < aElements.length; i++)
			aElements[i].style.height = (bExpand ? oSpan.swoopMaxHeight : oSpan.swoopMinHeight) +'px';
		this.swoopSwitchVisibility(oBlock, bExpand);
	}

	this.logicItem = function(item)
	{
		if (typeof(item[7]) == "undefined" || (item[7] != 'Card' && item[7] != 'Url'))
			item[7] = 'Card, Url';

		if (typeof(item[2]) == "undefined")
			item[2] = '';
		if (typeof(item[6]) == "undefined")
			item[6] = '';

		if (item[2] == '' && item[6] == '')
			return item;
		if (item[2] == '' && item[6] != '')
			item[7] = 'Card';
		if (item[2] != '' && item[6] == '')
			item[7] = 'Url';
		if (item[7] == 'Card')
			item[2] = item[6];
		return item;
	}

	this.setRecordStyle = function(oRecord, bHover)
	{
		oRecord.style.background = bHover ? this.style.record.hoverBgColor : this.style.record.bgColor;
		oRecord.style.border = bHover ? this.style.record.hoverBorder : this.style.record.border;
		var oTitle = this.getElementByClass('begunTitle', 'a', oRecord);
		oTitle.style.textDecoration = bHover ? this.style.title.hoverDecoration : this.style.title.decoration;
		oTitle.style.color = bHover ? this.style.title.hoverColor : this.style.title.color;
		var oText = this.getElementByClass('begunText', 'a', oRecord);
		oText.style.textDecoration = bHover ? this.style.text.hoverDecoration : this.style.text.decoration;
		oText.style.color = bHover ? this.style.text.hoverColor : this.style.text.color;
		var oDomain = this.getElementByClass('begunDomain', 'a', oRecord);
		oDomain.style.textDecoration = bHover ? this.style.domain.hoverDecoration : this.style.domain.decoration;
		oDomain.style.color = bHover ? this.style.domain.hoverColor : this.style.domain.color;
	}

	this.getBanner = function(bb, bWidth, iWide, bSwoopCollapse)
	{
		var style = this.style;
		if (bb == null)
			return '';
		if (bb[4] == null)
			bb[4] = '';
		var domain = bb[4].replace(/^(.*?) - (.*?)$/i, "$1");
		bb = this.logicItem(bb);
		var rambler_textb_call = decodeURI('%D0%97%D0%B2%D0%BE%D0%BD%D0%B8%D1%82%D1%8C');
		var rambler_textb_contacts = decodeURI('%D0%9A%D0%BE%D0%BD%D1%82%D0%B0%D0%BA%D1%82%D1%8B');

		var css_bgulli_width = 100;
		if (iWide)
			css_bgulli_width = parseInt(100 / iWide) - 1;
		css_bgulli_width = 'width: '+ css_bgulli_width +'% !important;';
		var css_bgulli_height = '';
		if (style.thumbs && !iWide)
			css_bgulli_height = 'min-height: 48px;';
		var css_bgbanner_marginleft = 0;
		if (style.thumbs)
			css_bgbanner_marginleft = 9 + style.thumbWidth;
		css_bgbanner_marginleft = 'margin-left: '+ css_bgbanner_marginleft +'px !important;';
		if (style.thumbs)
		{
			var thumbSrc = begunParams['thumbs_src'] ? 'http://'+ begunParams['thumbs_src'] +'/' : 'http://thumbs.begun.ru/';
			if (bb[5] != undefined && bb[5].toString().length > 3)
			{
				var thematic = bb[9] ? (bb[9].split(',')[0] + '') : '1';
				var bannerId = bb[5].toString();
				thumbSrc += bannerId.charAt(bannerId.length - 2);
				thumbSrc += '/'+ bannerId.charAt(bannerId.length - 1);
				thumbSrc += '/'+ bannerId +'.jpg';
				thumbSrc += '?t='+ thematic +'&r='+ bannerId.charAt(bannerId.length - 3);
			}
			else
				thumbSrc += 'empty.jpg';
		}
		if (typeof(window.ppcallArray) == 'undefined' || window.ppcallArray == null)
			window.ppcallArray = [];

		var bannerTpl = (iWide ? '' : '<tr>') +'\
<td style="'+ css_bgulli_width + css_bgulli_height +'; padding: '+ style.record.padding +'; margin: 0px; font-weight: normal; background: '+ style.record.bgColor +'; overflow: hidden; border: '+ style.record.border +'; vertical-align: top; display: table-cell" onmouseover="begun.setRecordStyle(this, 1)" onmouseout="begun.setRecordStyle(this, 0)"> \
<div class="begunRecord" style="overflow: hidden; margin: 0px; padding: 0px; display: block; clear: both; float: none'+ (bSwoopCollapse ? '; height: 0px' : '') +'"> \
<div class="begunSubRecord" style="margin: 0px; padding: 0px; display: block; clear: both; float: none"> \
'+ (style.thumbs ? '<div class="begunThumb" style="float: left; clear: none; display: block"><a href="'+ bb[2] +'" target="_blank"><img src="'+ thumbSrc +'" style="margin: 5px; width: '+ style.thumbWidth +'px; height: '+ Math.round(style.thumbWidth / 56 * 42) +'px; border: 0px"></a></div>' : '') +' \
\
<div style="margin: 0px; padding: 0px; text-align: left; text-indent: 0px; margin-bottom: 10px; '+ style.divBlock + css_bgbanner_marginleft +'"> \
<div class="begunTitle" style="margin: 0px; padding: 0px; font-size:'+ style.title.fontSize +'; '+ style.divBlock +'"><a class="begunTitle" style="color:'+ style.title.color +';font-size:'+ style.title.fontSize +';font-weight:bold;text-decoration:'+ style.title.decoration +'; '+ style.fontFamily +' cursor:pointer;'+ style.lineHeight +'" target="_blank" href="'+ bb[2] +'" onmouseover="status=\'http://'+ domain +'/\';" onmouseout="status=\'\';" title="'+ domain +'">'+ bb[0] +'</a></div> \
<div class="begunBody" style="margin: 0px; padding: 0px; display: block; float: none"> \
<div class="begunText" style="margin: 0px; padding: 0px; font-size:'+ style.text.fontSize +';margin-top:3px; '+ style.divBlock +'"><a class="begunText" target="_blank" href="'+ bb[2] +'" style="font-size:'+ style.text.fontSize +';color:'+ style.text.color +';text-decoration:'+ style.text.decoration +'; '+ style.fontFamily + style.lineHeight +'" onmouseover="status=\'http://'+ domain +'/\';" onmouseout="status=\'\';" title="'+ domain +'">'+ bb[1] +'</a></div> \
<div class="begunDomain" style="margin: 0px; padding: 0px; font-size:'+ style.domain.fontSize +';margin-top:2px; '+ style.divBlock +'"> \
'+ ((bb[7] == 'Card, Url' || bb[7] == 'Url') ? '<a class="begunDomain" target="_blank" href="'+ bb[2] +'" style="font-size:'+ style.domain.fontSize +';color:'+ style.domain.color +';text-decoration:'+ style.domain.decoration +'; '+ style.fontFamily + style.lineHeight +'" onmouseover="status=\'http://'+ domain +'/\';" onmouseout="status=\'\';" title="'+ domain +'">'+ bb[4] +'</a>' : '') +' \
'+ ((bb[7] == 'Url' && ppcallArray[i] == 1) ? '<img src="http://autocontext.begun.ru/phone_icon.gif" style="width: 12px; height: 8px; border: none" />&nbsp;<a href="javascript:void(0);" onClick="showEnterForm('+ i +', this,event);return false" style="font-size:'+ style.domain.fontSize +';color:'+ style.domain.color +';text-decoration:'+ style.domain.decoration +'; '+ style.fontFamily + style.lineHeight +'">'+rambler_textb_call+'</a>' : '') +' \
'+ (((bb[7] == 'Card, Url' || bb[7] == 'Card') && ppcallArray[i] == 1) ? '<img src="http://autocontext.begun.ru/phone_icon.gif" style="width: 12px; height: 8px; border: none" alt="" />&nbsp;<a href="'+ bb[6] +'" target="_blank" style="font-size:'+ style.domain.fontSize +';color:'+ style.domain.color +';text-decoration:'+ style.domain.decoration +'; '+ style.fontFamily + style.lineHeight +'">'+rambler_textb_contacts+'</a>&nbsp;<span style="color: #AAA; font-size: 10px">&#149;</span>&nbsp;<a href="javascript:void(0);" onClick="showEnterForm('+ i +', this, event);return false" style="font-size:'+ style.domain.fontSize +';color:'+ style.domain.color +';text-decoration:'+ style.domain.decoration +'; '+ style.fontFamily + style.lineHeight +'">'+rambler_textb_call+'</a>' : '') +'\
'+ (((bb[7] == 'Card, Url' || bb[7] == 'Card') && ppcallArray[i] != 1) ? '<img src="http://autocontext.begun.ru/phone_icon.gif" style="width: 12px; height: 8px; border: none" />&nbsp;<a href="'+ bb[6] +'" target="_blank" style="font-size:'+ style.domain.fontSize +';color:'+ style.domain.color +';text-decoration:'+ style.domain.decoration +'; '+ style.fontFamily + style.lineHeight +'">'+rambler_textb_contacts+'</a>' : '') +'\
</div> \
</div> \
</div> \
<div style="clear: both; height: 0px; overflow: hidden; margin: 0px; padding: 0px; font-size: 0px"></div> \
</div> \
</div> \
</td> \
'+ (iWide ? '' : '</tr>');
		return bannerTpl;
	}

	this.getStub = function(bSwoopCollapse)
	{
		var style = this.style;
		var stubFixedTpl = '\
<div class="begunBegun" style="margin: 0px; padding: 0px; overflow: hidden; display: block; clear: both; float: none'+ (bSwoopCollapse ? '; height: 0px' : '') +'"> \
<div class="begunSubBegun" style="padding: 3px; background: none; margin: 0px 5px 5px 5px; font-size: '+ style.begun.fontSize +'; color: '+ style.begun.color +'; text-decoration: '+ style.begun.decoration +'; display: block; text-align: right; clear: both; float: none; overflow: hidden"> \
'+ (begunParams.showhref ? ' \
<a href="'+ begunStubs[0].href +'" style="'+ style.lineHeight +'color: '+ style.begun.color +'; text-decoration: '+ style.begun.decoration +'; '+ style.fontFamily +'; font-size: '+ style.begun.fontSize +'; white-space: nowrap" target="_blank" onmouseover="this.style.textDecoration=\''+ style.begun.hoverDecoration +'\';this.style.color=\''+ style.begun.hoverColor +'\'" onmouseout="this.style.textDecoration=\''+ style.begun.decoration +'\';this.style.color=\''+ style.begun.color +'\'">'+ begunStubs[0].text +'</a> &nbsp; ' : '') +' \
<a href="http://www.begun.ru/advertiser/?r1=Begun&r2=adbegun" style="'+ style.lineHeight +'color: '+ style.begun.color +'; text-decoration: '+ style.begun.decoration +'; '+ style.fontFamily +'; font-size: '+ style.begun.fontSize +'; white-space:nowrap" target="_blank" onmouseover="this.style.textDecoration=\''+ style.begun.hoverDecoration +'\';this.style.color=\''+ style.begun.hoverColor +'\'" onmouseout="this.style.textDecoration=\''+ style.begun.decoration +'\';this.style.color=\''+ style.begun.color +'\'">'+ begunStubs[1].text +'</a> &nbsp; \
<a href="http://www.begun.ru/partner/?r1=Begun&r2=become_partner" style="'+ style.lineHeight +'color: '+ style.begun.color +'; text-decoration: '+ style.begun.decoration +'; '+ style.fontFamily +'; font-size: '+ style.begun.fontSize +'; white-space:nowrap" target="_blank" onmouseover="this.style.textDecoration=\''+ style.begun.hoverDecoration +'\';this.style.color=\''+ style.begun.hoverColor +'\'" onmouseout="this.style.textDecoration=\''+ style.begun.decoration +'\';this.style.color=\''+ style.begun.color +'\'">'+ begunStubs[2].text +'</a> &nbsp; \
</div> \
</div>';
		return stubFixedTpl;
	}

	this.isValidChild = function(o)
	{
		if (o == null || typeof(o) == 'undefined' || typeof(o.offsetWidth) == 'undefined' || o.id == 'zorkaClearFix')
			return false;
		if (o.id)
		{
			for (var i = 0; i < this.spans.length; i++)
			{
				if (this.spans[i].span_id == o.id)
					return false;
			}
		}
		return true;
	}

	this.print = function()
	{
		begunParams.wide = 0;
		if (window.begun_block_type == 'Horizontal')
			begunParams.wide = 1;
		if (window.ppcallArray != null)
			this.include('http://ppcall.begun.ru/auto_ppcall.js');
		begun_auto_width = window.begun_auto_width || 350;
		begun_auto_limit = window.begun_auto_limit || 3;
		this.spans = window.begun_spans;

		if (typeof(begun_config)  == "undefined") config = {}; else config = begun_config;
		if (typeof(config.title)  == "undefined") config.title = {};
		if (typeof(config.text)   == "undefined") config.text = {};
		if (typeof(config.domain) == "undefined") config.domain = {};
		if (typeof(config.begun)  == "undefined") config.begun = {};
		if (typeof(config.block)  == "undefined") config.block = {};
		if (typeof(config.record) == "undefined") config.record = {};

		var style = {
			'title': {
				'fontSize': config.title.fontSize || '10pt',
				'color': config.title.color || '#0000CC',
				'decoration': config.title.decoration || 'underline',
				'hoverColor': config.title.hoverColor || config.title.color || '#0000CC',
				'hoverDecoration': config.title.hoverDecoration || config.title.decoration || 'underline'
			},
			'text': {
				'fontSize': config.text.fontSize || '9pt',
				'color': config.text.color || '#000000',
				'decoration': config.text.decoration || 'none',
				'hoverColor': config.text.hoverColor || config.text.color || '#000000',
				'hoverDecoration': config.text.hoverDecoration || config.text.decoration || 'none'
			},
			'domain': {
				'fontSize': config.domain.fontSize || '9pt',
				'color': config.domain.color || '#167201',
				'decoration': config.domain.decoration || 'none',
				'hoverColor': config.domain.hoverColor || config.domain.color || '#167201',
				'hoverDecoration': config.domain.hoverDecoration || config.domain.decoration || 'none'
			},
			'begun': {
				'fontSize': config.begun.fontSize || '9pt',
				'color': config.begun.color || '#167201',
				'decoration': config.begun.decoration || 'underline',
				'hoverColor': config.begun.hoverColor || config.begun.color || '#167201',
				'hoverDecoration': config.begun.hoverDecoration || config.begun.decoration || 'underline'
			},
			'block': {
				'padding': config.block.padding || '0px',
				'bgColor': config.block.bgColor || '#FFFFFF',
				'border': config.block.border || '0px solid #FFFFFF',
				'hoverBgColor': config.block.hoverBgColor || config.block.bgColor || '#FFFFFF',
				'hoverBorder': config.block.hoverBorder || config.block.border || '0px solid #FFFFFF'
			},
			'record': {
				'padding': config.record.padding || '0px',
				'bgColor': config.record.bgColor || '#FFFFFF',
				'border': config.record.border || '0px solid #FFFFFF',
				'hoverBgColor': config.record.hoverBgColor || config.record.color || '#FFFFFF',
				'hoverBorder': config.record.hoverBorder || config.record.border || '0px solid #FFFFFF'
			},
			'thumbs': config.thumbs || 0,
			'thumbWidth': parseInt(config.thumbWidth) || 56,
			'fontFamily': '',
			'lineHeight': 'line-height: 120%;',
			'divBlock': 'float: none; clear: none; display: block;'
		};
		if (typeof(config.fontFamily) == 'undefined')
			config.fontFamily = 'Arial';
		switch (config.fontFamily)
		{
			case 'Times': style.fontFamily = 'font-family: Times, serif;'; break;
			case 'Verdana': style.fontFamily = 'font-family: Verdana, sans-serif;'; break;
			case 'Arial': style.fontFamily = 'font-family: Arial, sans-serif;'; break;
		}
		this.style = style;

		if (begunBanners.length && config.forbidden_urls)
		{
			var aTmp = begunBanners;
			begunBanners = new Array();
			for (var i = 0; i < aTmp.length; i++)
			{
				var bFlag = true;
				var domain = aTmp[i][4].replace(/^(.*?) - (.*?)$/i, "$1");
				domain = domain.toString();
				for (var j = 0; j < config.forbidden_urls.length; j++)
				{
					if (new RegExp("^(.*\.)?"+ config.forbidden_urls[j] +"$", "i").test(domain))
					{
						bFlag = false;
						break;
					}
				}
				if (bFlag)
					begunBanners.push(aTmp[i]);
			}
		}

		i = 0;
		var breakFlag = 0;
		for (var j = 0; j < this.spans.length; j++)
		{
			var o = document.getElementById(this.spans[j].span_id);
			if (!o)
			{
				if (!this.spans[j].context)
					continue;
				o = document.createElement('div');
				o.id = this.spans[j].span_id;
			}
			o.innerHTML = ''; // clear div, if there is begun content
			o.style.display = 'block';

			if (!begunBanners.length || typeof(begunBanners[i]) != 'object' || breakFlag)
				continue;

			var content = '';
			if (this.spans[j].width)
				var spanWidth = this.spans[j].width;
			else
				var spanWidth = begun_auto_width;
			if (typeof(this.spans[j].type) != 'undefined' && this.spans[j].type.toLowerCase() == 'horizontal')
				spanWide = this.spans[j].limit ? this.spans[j].limit : begun_auto_limit;
			else if (typeof(this.spans[j].type) != 'undefined' && this.spans[j].type.toLowerCase() == 'vertical')
				spanWide = 0;
			else
				spanWide = begunParams.wide;

			var bSwoopCollapse = 0;
			if (this.spans[j].swoop)
			{
				var iSwoopShows = parseInt(this.getCookie('begunSwoopShown_'+ begun_auto_pad +'_'+ j));
				if (isNaN(iSwoopShows))
					iSwoopShows = 0;
				this.setCookie('begunSwoopShown_'+ begun_auto_pad +'_'+ j, iSwoopShows + 1, 1);
				if (iSwoopShows >= this.spans[j].swoopLimit)
					bSwoopCollapse = 1;
			}

			content += '<div style="padding: 0px; margin: 0px; border: 0px; display: block; width: '+ (this.spans[j].context ? '100%' : spanWidth + ((spanWidth.substring(spanWidth.length - 1, spanWidth.length) == '%' || spanWidth.substring(spanWidth.length - 2, spanWidth.length) == 'px') ? '' : 'px')) +'; overflow: hidden; '+ style.fontFamily +'"'+ (this.spans[j].swoop ? ' onmouseover="begun.swoopInit(\''+ this.spans[j].span_id +'\', 1, 1)" onmouseout="begun.swoopInit(\''+ this.spans[j].span_id +'\', 0, 1)"' : '') +'> \
<table cellpadding="0" cellspacing="'+ style.block.padding +'" style="width: 100%; margin: 0px; padding: 0px; float: none; border: '+ style.block.border +'; background: '+ style.block.bgColor +'; border-collapse: separate; border-spacing: '+ style.block.padding +'" onmouseover="this.style.background=\''+ style.block.hoverBgColor +'\';this.style.border=\''+ style.block.hoverBorder +'\'" onmouseout="this.style.background=\''+ style.block.bgColor +'\';this.style.border=\''+ style.block.border +'\'">';
			if (this.spans[j].swoop)
			{
				this.spans[j].swoopCollapsePid = window.setInterval('begun.swoopCollapse("'+ this.spans[j].span_id +'", 0)', 10);
				if (!bSwoopCollapse)
				{
					window.setTimeout('begun.swoopInit("'+ this.spans[j].span_id +'", 1, 0)', 20);
					window.setTimeout('begun.swoopInit("'+ this.spans[j].span_id +'", 0, 0)', parseInt(this.spans[j].swoopTime) * 1000 || 5000);
				}
			}
			for (var k = 0; k < this.spans[j].limit; k++)
			{
				if (typeof begunBanners[i] == 'object')
				{
					content += this.getBanner(begunBanners[i], spanWidth, spanWide, this.spans[j].swoop);
					i++;
				} else {
					breakFlag = 1;
					break;
				}
			}
			content += '</table>';
			if (begunParams.stub)
				content += this.getStub(this.spans[j].swoop);
			content += '</div>';
			o.innerHTML = content;

			if (this.spans[j].context)
			{
				if (!this.spans[j].contextTarget)
					continue;
				var oContext = document.getElementById(this.spans[j].contextTarget);
				if (!oContext || !oContext.childNodes)
					continue;
				o.style.width = spanWidth + ((spanWidth.substring(spanWidth.length - 1, spanWidth.length) == '%' || spanWidth.substring(spanWidth.length - 2, spanWidth.length) == 'px') ? '' : 'px');
				o.style.display = 'block';
				o.style.margin = '5px';
				if (this.spans[j].contextAlign == 'left')
				{
					o.style.cssFloat = 'left';
					o.style.styleFloat = 'left';
				}
				else if (this.spans[j].contextAlign == 'right')
				{
					o.style.cssFloat = 'right';
					o.style.styleFloat = 'right';
				}
				else
				{
					o.style.width = '100%';
					o.style.textAlign = 'center';
					o.firstChild.style.margin = '0px auto';
					o.firstChild.style.width = spanWidth + ((spanWidth.substring(spanWidth.length - 1, spanWidth.length) == '%' || spanWidth.substring(spanWidth.length - 2, spanWidth.length) == 'px') ? '' : 'px');
				}
				if (this.spans[j].contextValign == 'top')
					oContext.insertBefore(o, oContext.childNodes[0]);
				else if (this.spans[j].contextValign == 'center')
				{
					var aTrueNodes = new Array();
					var iCount = 0;
					for (var k = 0; k < oContext.childNodes.length; k++)
					{
						if (this.isValidChild(oContext.childNodes[k]))
						{
							aTrueNodes[iCount] = oContext.childNodes[k];
							iCount++;
						}
					}
					oContext.insertBefore(o, aTrueNodes[Math.floor(aTrueNodes.length / 2)]);
				}
				else
				{
					for (var k = oContext.childNodes.length - 1; k >= 0; k--)
					{
						if (this.isValidChild(oContext.childNodes[k]))
							break;
					}
					oContext.insertBefore(o, oContext.childNodes[k]);
					oClearFix = document.createElement('div');
					oClearFix.style.clear = 'both';
					oClearFix.id = 'zorkaClearFix';
					oContext.appendChild(oClearFix);
				}
			} // if span is context
		} // for each spans
	}

/* parse response */

	this.isDefined = function(value, substitute)
	{
		return typeof value == "undefined" ? substitute : value;
	}

	this.parseBanners = function()
	{
		window.begunBanners = [];
		var obj;
		for (var i = 0; i < window.begunAds.banners.autocontext.length; i++)
		{
			obj = window.begunAds.banners.autocontext[i];
			window.begunBanners[i] = [
				this.isDefined(obj.title, ''),
				this.isDefined(obj.descr, ''),
				this.isDefined(obj.url, ''),
				this.isDefined(obj.price, 0.0),
				this.isDefined(obj.domain, ''),
				this.isDefined(obj.banner_id, 0),
				this.isDefined(obj.card, ''),
				this.isDefined(obj.cards_mode, ''),
				this.isDefined(obj.constraints, ''),
				this.isDefined(obj.thematics, '')
			];
		}
	}

	this.parseParams = function()
	{
		window.begunParams = window.begunAds.params;
	}

	this.parsePPCall = function()
	{
		window.ppcallArray = [];
		for (var i = 0; i < window.begunAds.banners.autocontext.length; i++)
			window.ppcallArray[i] = parseInt(window.begunAds.banners.autocontext[i].ppcall);
	}

	this.parseStubs = function()
	{
		window.begunStubs = [];
		var stubs = {
			begun_advert: '&#1056;&#1077;&#1082;&#1083;&#1072;&#1084;&#1072; &#1085;&#1072; &#1041;&#1077;&#1075;&#1091;&#1085;&#1077;',
			all_banners: '&#1042;&#1089;&#1077; &#1086;&#1073;&#1098;&#1103;&#1074;&#1083;&#1077;&#1085;&#1080;&#1103;',
			become_partner: '&#1057;&#1090;&#1072;&#1090;&#1100; &#1087;&#1072;&#1088;&#1090;&#1085;&#1077;&#1088;&#1086;&#1084;'};
		var obj = window.begunAds.stubs;
		window.begunStubs[0] = {
			href: obj.all_banners,
			text: stubs.all_banners
		};
		window.begunStubs[1] = {text: stubs.begun_advert};
		window.begunStubs[2] = {text: stubs.become_partner};
		window.begunStubs[3] = {text: obj.rambler_sbox_btn_text};
		window.begunStubs[4] = {text: obj.rambler_sbox_auto};
		window.begunStubs[5] = {text: obj.rambler_sbox};
		window.begunStubs[6] = {href: obj.behav_all_banners};
	}

	this.adaptResponse = function()
	{
		if (typeof window.begunAds == "undefined")
			return;

		this.parseBanners();
		this.parseParams();
		this.parsePPCall();
		this.parseStubs();
	}

	this.getFeeds = function()
	{
		var re = new RegExp("&", "g");
		var url = 'http://xml.zorkabiz.ru/get_feeds.php?pad='+ begun_auto_pad
			+'&referrer='+ (document.referrer.replace(re, "^^"))
			+'&url='+ (window.location.href.replace(re, "^^"))
			+'&rand='+ Math.random()
			+'&spans='+ window.begun_spans.length
			+'&length='+ begunBanners.length;
		this.include(url);
//		this.sendRecords();
	}

	this.sendRecords = function()
	{
		if (!document.createElement || !begunBanners.length)
			return;
		var sId = 'zorka_' + Math.floor(Math.random() * 99999);
		var sUrl = 'http://xml.zorkabiz.ru/log_records.php';

		var re = new RegExp('MSIE 8.0');
		if (re.exec(navigator.userAgent) != null)
		{
//			return false;
/*			for (var i = 0, j = begunBanners.length; i < j; i++)
			{
				this.include(sUrl + '?pad='+ begun_auto_pad
				+'&encoding='+ (typeof(begun_utf8) != 'undefined' ? 'utf-8' : (typeof(begun_koi8) != 'undefined' ? 'koi8-r' : 'windows-1251'))
				+'&title[]='+ encodeURI(begunBanners[i][0])
				+'&descr[]='+ encodeURI(begunBanners[i][1])
				+'&domain[]='+ encodeURI(begunBanners[i][4])
				+'&banner_id[]='+ encodeURI(begunBanners[i][5])
				+'&rand='+ sId);
			}*/
		}

		var oDiv = document.createElement('div');
		oDiv.innerHTML = '<iframe id="'+ sId +'" name="'+ sId +'" style="display: none"></iframe>';
		document.body.appendChild(oDiv);
		var oFrame = document.getElementById(sId);
		var oForm = document.createElement('form');
		oForm.setAttribute('method', 'post');
		oForm.setAttribute('target', oFrame.id);
		oForm.setAttribute('action', sUrl);
		oForm.style.display = 'none';
		oForm.innerHTML = '<input type="text" name="pad" value="'+ begun_auto_pad +'" style="display: none">';
		oForm.innerHTML += '<input type="text" name="encoding" value="'+ (typeof(begun_utf8) != 'undefined' ? 'utf-8' : (typeof(begun_koi8) != 'undefined' ? 'koi8-r' : 'windows-1251')) +'" style="display: none">';
		for (var i = 0, j = begunBanners.length; i < j; i++)
		{
			oForm.innerHTML += '<input type="text" name="title[]" value="'+ encodeURI(begunBanners[i][0]) +'" style="display: none">';
			oForm.innerHTML += '<input type="text" name="descr[]" value="'+ encodeURI(begunBanners[i][1]) +'" style="display: none">';
			oForm.innerHTML += '<input type="text" name="domain[]" value="'+ encodeURI(begunBanners[i][4]) +'" style="display: none">';
			oForm.innerHTML += '<input type="text" name="banner_id[]" value="'+ encodeURI(begunBanners[i][5]) +'" style="display: none">';
		}
		document.body.appendChild(oForm);
		oForm.submit();
	}

	this.include = function(url)
	{
		o = document.createElement('script');
		o.setAttribute('type', 'text/javascript');
		o.setAttribute('src', url);
		try
		{
			document.documentElement.firstChild.appendChild(o);
		}
		catch (e)
		{
			document.getElementsByTagName('*')[0].appendChild(o);
		}
	}
}

/* execution */
function begunReadyCheck()
{
	if (typeof(window.begunAds) == "undefined")
		return;
	clearInterval(begunPid);
	begun.adaptResponse();
	begun.getFeeds();
	begun.print();
}

if (typeof(begun) == 'undefined')
{
	var begun = new BegunCodeProcessor();
	var begunPid = window.setInterval('begunReadyCheck()', 100);
}