function resizeDiv_Left()
{
 var Dummy = document.getElementById('dummy');
 Dummy.style.height = '1in';
 switch(screen.width)
 {
  case 1280:
   document.getElementById('left_panel').style.left = '69px'; break;
  case 1152:
   document.getElementById('left_panel').style.left = '36px'; break;
  case 1024:
   document.getElementById('left_panel').style.left = '5px'; break;
  case 800:
   document.getElementById('left_panel').style.left = '0px'; break;
 }
 if (Dummy.clientHeight==96)
 { document.getElementById('left_panel').style.top = '180px'; }
 if (Dummy.clientHeight==120)
 { document.getElementById('left_panel').style.top = '182px'; }
}
