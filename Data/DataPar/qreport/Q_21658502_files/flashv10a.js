var TFclick="TFclick"+tf_id;
if (typeof(tf_window_id) != 'undefined')
  TFclick = tf_window_id;
var ShockMode = false;
var plugin = (navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"]) ? navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0;
var isJavaE = navigator.javaEnabled()==true;

eval("tf_clickURL"+tf_id+"='"+tf_clickURL+"'");
eval("tf_click"+tf_id+"='"+tf_click+"'");
eval("tf_use_embedded_flash_url"+tf_id+"='"+tf_use_embedded_flash_url+"'");
eval("tf_ignore_fscommand_args"+tf_id+"='"+tf_ignore_fscommand_args+"'");
eval("tf_click_command"+tf_id+"='"+tf_click_command+"'");
eval("tf_append_fscmd_args_to_click"+tf_id+"='"+tf_append_fscmd_args_to_click+"'");

document.write('<SC' + 'RIPT LANGUAGE=Javascript\> \n');
document.write('function '+TFclick+'_DoFSCommand(command, args){');
document.write("  if (command == tf_click_command"+tf_id+" && tf_use_embedded_flash_url"+tf_id+" == 1) {");
document.write("	     window.open(tf_click"+tf_id+"+args,'_blank');");
document.write("  } else if (command == tf_click_command"+tf_id+" && tf_append_fscmd_args_to_click"+tf_id+" == 1) {");
document.write("	     window.open(tf_clickURL"+tf_id+"+args,'_blank');");
document.write("  } else if (command == tf_click_command"+tf_id+" || tf_ignore_fscommand_args"+tf_id+" == 1) {");
document.write("	     window.open(tf_clickURL"+tf_id+",'_blank');");
document.write("  } ");
document.write('}');
document.write('<\/SCR' + 'IPT\> \n');

if (plugin) {
	var version = 0;
	plugin.description.toString().replace(/[0-9]+/, function(u) { version = parseInt(u, 10); return u; });
	if (isJavaE && version >= 5) {
		ShockMode = true;
	}
} else if (navigator.userAgent && navigator.userAgent.indexOf("MSIE")>=0
&& (navigator.userAgent.indexOf("Windows 95")>=0 || navigator.userAgent.indexOf("Windows 98")>=0 || navigator.userAgent.indexOf("Windows NT")>=0)) {
	document.write('<SC' + 'RIPT LANGUAGE=VBScript\> \n');
	document.write('on error resume next \n');
	document.write('ShockMode = (IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.5")))\n');
	document.write('Sub '+TFclick+'_FSCommand(ByVal command, ByVal args)\n');
	document.write('  call '+TFclick+'_DoFSCommand(command, args)\n');
	document.write('end sub\n');
	document.write('<\/SC'+'RIPT\> \n');
}

if ( ShockMode ) {
	document.write('<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"');
	document.write(' codebase="http://active.macromedia.com/flash/cabs/swflash.cab"');
	document.write(' ID='+TFclick+' WIDTH='+tf_width+' HEIGHT='+tf_height);
	document.write('>');
	document.write(' <PARAM NAME=movie VALUE='+tf_flashfile+'> ');
	document.write(' <PARAM NAME=quality VALUE=high> ');
 	document.write(' <PARAM name=flashVars value="clickTag=' + escape(tf_clickURL) + '">');
	if (window.tf_background) {
	  document.write(' <PARAM NAME=bgcolor VALUE='+tf_background+'> ');
 	}
	if (window.tf_wmode) {
	  document.write(' <PARAM NAME="wmode" value="' + tf_wmode + '">');
	}
    else {
	  document.write(' <PARAM NAME="wmode" value="opaque">');
    }
	document.write(' <EMBED name='+TFclick+' SRC='+tf_flashfile+'');
	document.write(' swLiveConnect=True WIDTH='+tf_width+' HEIGHT='+tf_height+'');
	document.write(' QUALITY=high');
	document.write(' flashVars="clickTag=' + escape(tf_clickURL) + '" ');
	if (window.tf_background) {
	  document.write('BGCOLOR='+tf_background);
	}
	if (window.tf_wmode) {
	  document.write(" wmode='" + tf_wmode + "'"); 
	}
    else {
	  document.write(" wmode='opaque'"); 
    }
	document.write(' TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash">');
	document.write('<NOEMBED>');
	document.write('<A HREF="'+tf_clickURL+tf_id+'" TARGET="_blank">');
	document.write('<IMG SRC='+tf_imagefile+' WIDTH='+tf_width+' HEIGHT='+tf_height+' BORDER=0></A>');
	document.write('</NOEMBED>');
	document.write('</EMBED>');
	document.write('</OBJECT>');
} else if (!(navigator.appName && navigator.appName.indexOf("Netscape")>=0 && navigator.appVersion.indexOf("2.")>=0)){
	document.write('<A HREF="'+tf_clickURL+'" TARGET="_blank">');
	document.write('<IMG SRC='+tf_imagefile+' WIDTH='+tf_width+' HEIGHT='+tf_height+' BORDER=0></A>');
}