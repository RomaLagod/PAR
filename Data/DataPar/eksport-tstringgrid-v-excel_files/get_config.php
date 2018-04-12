var sZorkaStatus = "Ok";

if (typeof(begun_auto_pad) == "undefined") var begun_auto_pad = 194938729;
var begun_multispan = 1;
var begun_utf8 = 1;
if (typeof(begun_spans) == "undefined") var begun_spans = new Array({});
if (typeof(begun_spans[0]) == "undefined") begun_spans[0] = new Object();
if (typeof(begun_spans[0].span_id)    == "undefined") begun_spans[0].span_id    = "block-1269792198";
if (typeof(begun_spans[0].limit)      == "undefined") begun_spans[0].limit      = 5;
if (typeof(begun_spans[0].width)      == "undefined") begun_spans[0].width      = "100%";
if (typeof(begun_spans[0].type)       == "undefined") begun_spans[0].type       = "vertical";
if (typeof(begun_spans[0].swoop)      == "undefined") begun_spans[0].swoop      = 0;
if (typeof(begun_spans[0].swoopTime)  == "undefined") begun_spans[0].swoopTime  = 3;
if (typeof(begun_spans[0].swoopLimit) == "undefined") begun_spans[0].swoopLimit = 1;
if (typeof(begun_auto_limit) == "undefined" || begun_auto_limit < 15) var begun_auto_limit = 15;

if (typeof(begun_config) == "undefined") var begun_config = new Object();
if (typeof(begun_config.title)  == "undefined") begun_config.title  = new Object();
if (typeof(begun_config.text)   == "undefined") begun_config.text   = new Object();
if (typeof(begun_config.domain) == "undefined") begun_config.domain = new Object();
if (typeof(begun_config.begun)  == "undefined") begun_config.begun  = new Object();
if (typeof(begun_config.block)  == "undefined") begun_config.block  = new Object();
if (typeof(begun_config.record) == "undefined") begun_config.record = new Object();

if (typeof(begun_config.title.fontSize)        == "undefined") begun_config.title.fontSize        = "12px";
if (typeof(begun_config.title.color)           == "undefined") begun_config.title.color           = "#0000CC";
if (typeof(begun_config.title.decoration)      == "undefined") begun_config.title.decoration      = "underline";
if (typeof(begun_config.title.hoverColor)      == "undefined") begun_config.title.hoverColor      = "#D50303";
if (typeof(begun_config.title.hoverDecoration) == "undefined") begun_config.title.hoverDecoration = "underline";

if (typeof(begun_config.text.fontSize)        == "undefined") begun_config.text.fontSize        = "12px";
if (typeof(begun_config.text.color)           == "undefined") begun_config.text.color           = "#000000";
if (typeof(begun_config.text.decoration)      == "undefined") begun_config.text.decoration      = "none";
if (typeof(begun_config.text.hoverColor)      == "undefined") begun_config.text.hoverColor      = "#000000";
if (typeof(begun_config.text.hoverDecoration) == "undefined") begun_config.text.hoverDecoration = "none";

if (typeof(begun_config.domain.fontSize)        == "undefined") begun_config.domain.fontSize        = "11px";
if (typeof(begun_config.domain.color)           == "undefined") begun_config.domain.color           = "#00AA00";
if (typeof(begun_config.domain.decoration)      == "undefined") begun_config.domain.decoration      = "underline";
if (typeof(begun_config.domain.hoverColor)      == "undefined") begun_config.domain.hoverColor      = "#00AA00";
if (typeof(begun_config.domain.hoverDecoration) == "undefined") begun_config.domain.hoverDecoration = "underline";

if (typeof(begun_config.begun.fontSize)        == "undefined") begun_config.begun.fontSize        = "11px";
if (typeof(begun_config.begun.color)           == "undefined") begun_config.begun.color           = "#00AA00";
if (typeof(begun_config.begun.decoration)      == "undefined") begun_config.begun.decoration      = "none";
if (typeof(begun_config.begun.hoverColor)      == "undefined") begun_config.begun.hoverColor      = "#00AA00";
if (typeof(begun_config.begun.hoverDecoration) == "undefined") begun_config.begun.hoverDecoration = "underline";

if (typeof(begun_config.block.padding)      == "undefined") begun_config.block.padding      = "1px";
if (typeof(begun_config.block.bgColor)      == "undefined") begun_config.block.bgColor      = "#EBEBEB";
if (typeof(begun_config.block.border)       == "undefined") begun_config.block.border       = "1px solid #EBEBEB";
if (typeof(begun_config.block.hoverBgColor) == "undefined") begun_config.block.hoverBgColor = "#CCCCCC";
if (typeof(begun_config.block.hoverBorder)  == "undefined") begun_config.block.hoverBorder  = "1px solid #CCCCCC";

if (typeof(begun_config.record.padding)      == "undefined") begun_config.record.padding      = "1px";
if (typeof(begun_config.record.bgColor)      == "undefined") begun_config.record.bgColor      = "#F8F8F8";
if (typeof(begun_config.record.border)       == "undefined") begun_config.record.border       = "1px solid #EBEBEB";
if (typeof(begun_config.record.hoverBgColor) == "undefined") begun_config.record.hoverBgColor = "#CCCCCC";
if (typeof(begun_config.record.hoverBorder)  == "undefined") begun_config.record.hoverBorder  = "1px solid #CCCCCC";

if (typeof(begun_config.thumbs)     == "undefined") begun_config.thumbs     = 0;
if (typeof(begun_config.thumbWidth) == "undefined") begun_config.thumbWidth = "56";
if (typeof(begun_config.fontFamily) == "undefined") begun_config.fontFamily = "Arial";