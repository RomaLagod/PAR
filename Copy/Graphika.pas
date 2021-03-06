{$N+}
unit Graphika;

interface
 uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ActnList, StdActns, ExtCtrls, ToolWin, ComCtrls, StdCtrls, Buttons,
  Printers,ExtDlgs,FileCtrl, Spin,QuickRpt, QRCtrls,Variants, Grids,math;
const
     Infinity=1.0E+4932;

      Function ArcCos(x:Extended):Extended;
      Function Tan(x:Extended):Extended;
      //��������� ���� ��������� ����� ����� ����������� �� � ���� ���������� (��� ˳����� ������,�������, �����)
     Procedure ScaleMinMaxLSP(ShemaData:TstringGrid; ImageName:TImage ; {var mx,my:real ;}var xmin,ymin,xmax,ymax:real ;var h,w:integer);
     //������ ����� �����������
     Procedure DrawMagistral(ShemaData:TStringGrid; ImageName:TImage);
     {������� ��������������� �� ��� OX}
     function CoorXToPoint(x: real): integer;
     {������� ��������������� �� ��� OY}
     function CoorYToPoint(y: real): integer;
     {���� ���� �� ������ ��� �������� �����}
     procedure AddCulcDataToShema(lastmag:integer;OutputData,ShemaData:TStringGrid);
     //������ ������ ������� ����
     {SX, SY - ���������� ������ �����
      EX, EY - ���������� ����� �����
      R - ���������� �� ����� ������� �� ����� �������
      ACanvas - �����, �� ������� ���� ��������
      }
     procedure DrawArrow(ACanvas:TCanvas;SX,SY,EX,EY:integer);
//------------------------------------------
   var
      xmax1,xmin1,ymin1,ymax1:real;
      hmax,wmax:integer;
//------------------------------------------
implementation


Function ArcCos(x:Extended):Extended;
var
    Resylt:Extended;
begin
 if x = 0.0 then
    ArcCos:=Pi/2.0
 else
  begin
    Resylt:=ArcTan(sqrt(1-sqr(x))/x);
     if x < 0.0 then
       ArcCos:=Resylt+Pi
    else
       ArcCos:=Resylt;
  end;{else}
end; {Function}

Function Tan(x:Extended):Extended;
var
   Cosine,Tangent:Extended;
Begin
   Cosine:=cos(x);
  If cosine = 0.0 then
      if sin(x) >= 0 then
        Tan:=Infinity
      else
        Tan:=-Infinity
   else
     Begin
       Tangent:=sin(x)/cosine;
       if Tangent > Infinity Then
           Tan:=Infinity
     else
       if Tangent < - Infinity then
           Tan:= - Infinity
       else
            Tan:=Tangent;
        end;{else}
end;{Function}

 //��������� ���� ��������� ����� ����� ����������� �� � ���� ���������� (��� ˳����� ������,�������, �����)
Procedure ScaleMinMaxLSP(ShemaData:TstringGrid; ImageName:TImage ; {var mx,my:real ;}var xmin,ymin,xmax,ymax:real ;var h,w:integer);
var
   xmaxS,ymaxS,xminS,yminS:real;
   i:integer;
Begin
 //������ ��������� ����������
 h:=ImageName.ClientHeight-40 ;
 w:=imageName.ClientWidth-40;
 //��������� �� ���� �������� ���������
 xmaxS:=StrToFloat(ShemaData.Cells[1,1]);
 ymaxS:=StrToFloat(ShemaData.Cells[2,1]);
 xminS:=StrToFloat(ShemaData.Cells[1,1]);
 yminS:=StrToFloat(ShemaData.Cells[2,1]);
  For i:=1 to ShemaData.Rowcount-1 do
   Begin
    if xmaxS< StrToFloat(ShemaData.Cells[1,i]) then xmaxS:=StrToFloat(ShemaData.Cells[1,i]);
    if xminS> StrToFloat(ShemaData.Cells[1,i]) then xminS:=StrToFloat(ShemaData.Cells[1,i]);
    if ymaxS< StrToFloat(ShemaData.Cells[2,i]) then ymaxS:=StrToFloat(ShemaData.Cells[2,i]);
    if yminS> StrToFloat(ShemaData.Cells[2,i]) then yminS:=StrToFloat(ShemaData.Cells[2,i]);
   end;{for}
 xmin:=xminS;
 xMax:=xmaxS;
 ymin:=yminS;
 ymax:=ymaxs;
end;{ScaleMinMaxLSP}

//----------------------------------------------------------------test
function CoorXToPoint(x: real): integer;
{������� ��������������� �� ��� OX}
var
   w0:integer;
begin
w0:=20;
CoorXToPoint:=w0+Trunc((x-xmin1)*(wmax-w0)/(xmax1-xmin1));
end;
function CoorYToPoint(y: real): integer;
{������� ��������������� �� ��� OY}
var
   h0:integer;
begin
h0:=20;
CoorYToPoint:=hmax+Trunc((y-ymin1)*(h0-hmax)/(ymax1-ymin1));
end;
//-----------------------------------------------------------------test


//----------------------------------------------------------------------
//������ ����� �����������
Procedure DrawMagistral(ShemaData:TStringGrid; ImageName:TImage);
var
   rc:TRect;
   msg:string;
   Bitmap:TBitmap;
   i:integer;
Begin
 Bitmap:=nil;
  try
   Bitmap := TBitmap.Create;
   //����������� ����� �� ������ ������
   Bitmap.Width := ImageName.Width;
   Bitmap.Height := ImageName.Height;
   ImageName.Picture.Graphic := Bitmap;
   ImageName.Canvas.FillRect(Rect(0,0,ImageName.Width,ImageName.Height));
  finally
  Bitmap.Free;
  end;{try}
//��������� ���������� ����������
ScaleMinMaxLSP(ShemaData,ImageName,xmin1,ymin1,xmax1,ymax1,hmax,wmax);
 //������ ��������� ������
   //ImageName.Canvas.font.Color:=clred;
   ImageName.Canvas.Brush.Style:=bsClear;
//³��������� �����
 for i:=1 to ShemaData.Rowcount-2 do
  Begin
  with ImageName.Canvas do
  Begin
     //�"������ �����----------------------------------------------------------
     pen.Style:=psSolid;
     pen.Color:=clred;
     pen.Width:=2;
     MoveTo(CoorXtopoint(StrToFloat(ShemaData.Cells[1,i])),
                 CoorYToPoint(StrToFloat(ShemaData.Cells[2,i])));
     LineTo(CoorXtopoint(StrToFloat(ShemaData.Cells[1,i+1])),
                 CoorYToPoint(StrToFloat(ShemaData.Cells[2,i+1])));

     pen.Color:=clBlack;
     pen.Width:=1;
     pen.Style:=psdash;
     pen.Style:=psSolid;
           //������ ������ ������� ����
     {SX, SY - ���������� ������ �����
      EX, EY - ���������� ����� �����
      R - ���������� �� ����� ������� �� ����� �������
      ACanvas - �����, �� ������� ���� ��������
      }
      DrawArrow(ImageName.Canvas,CoorXtopoint(StrToFloat(ShemaData.Cells[1,i])),CoorYToPoint(StrToFloat(ShemaData.Cells[2,i])),
                 CoorXtopoint(StrToFloat(ShemaData.Cells[1,i+1])),CoorYToPoint(StrToFloat(ShemaData.Cells[2,i+1])));
      {ϳ���� �����}
    rc:=Rect(10+CoorXtopoint(StrToFloat(ShemaData.Cells[1,i]))+20,
                CoorYToPoint(StrToFloat(ShemaData.Cells[2,i]))-14,
             70+CoorXtopoint(StrToFloat(ShemaData.Cells[1,i])),
                CoorYToPoint(StrToFloat(ShemaData.Cells[2,i]))+24+TextHeight('W')*7);
             msg:=ShemaData.Cells[3,i]+#13+'��������'+#13+ShemaData.Cells[4,i]+#13+'��������'+#13+ShemaData.Cells[5,i];
    DrawText(Handle,PCHar(msg),-1,rc, DT_CALCRECT);
    rectangle(rc);
    DrawText(Handle,PCHar(msg),-1,rc,  DT_CENTER);
    end;{wiyh}
   end;{for}
   for i:=1 to ShemaData.Rowcount-1 do
  Begin
  with ImageName.Canvas do
  Begin
    //�����---------------------------------------------------------------------
    brush.Style:=bsSolid;
    brush.Color:=clgreen;
    Ellipse(CoorXtopoint(StrToFloat(ShemaData.Cells[1,i]))-5,
            CoorYToPoint(StrToFloat(ShemaData.Cells[2,i]))-5,
            CoorXtopoint(StrToFloat(ShemaData.Cells[1,i]))+5,
            CoorYToPoint(StrToFloat(ShemaData.Cells[2,i]))+5);
    brush.Color:=clwhite;
    Ellipse(CoorXtopoint(StrToFloat(ShemaData.Cells[1,i]))-2,
            CoorYToPoint(StrToFloat(ShemaData.Cells[2,i]))-2,
            CoorXtopoint(StrToFloat(ShemaData.Cells[1,i]))+2,
            CoorYToPoint(StrToFloat(ShemaData.Cells[2,i]))+2);

    brush.Style:=bsclear;
    //ϳ���� �����
    rc:=Rect(CoorXtopoint(StrToFloat(ShemaData.Cells[1,i]))-20,
             CoorYToPoint(StrToFloat(ShemaData.Cells[2,i]))+14,
             70+CoorXtopoint(StrToFloat(ShemaData.Cells[1,i])),
             CoorYToPoint(StrToFloat(ShemaData.Cells[2,i]))+24+TextHeight('W')*3);
             msg:=ShemaData.Cells[0,i];
    DrawText(Handle,PCHar(msg),-1,rc, DT_CALCRECT);
    //rectangle(rc);
    DrawText(Handle,PCHar(msg),-1,rc,  DT_CENTER);

    end;{with}
   { //�����2----------------------------------------------------------------------
    brush.Style:=bsSolid;
    brush.Color:=clgreen;
    Ellipse(CoorXtopoint(StrToFloat(EditName2y.Text))-5,
            CoorYToPoint(StrToFloat(EditName2x.Text))-5,
            CoorXtopoint(StrToFloat(EditName2y.Text))+5,
            CoorYToPoint(StrToFloat(EditName2x.Text))+5);
    brush.Color:=clwhite;
    Ellipse(CoorXtopoint(StrToFloat(EditName2y.Text))-2,
            CoorYToPoint(StrToFloat(EditName2x.Text))-2,
            CoorXtopoint(StrToFloat(EditName2y.Text))+2,
            CoorYToPoint(StrToFloat(EditName2x.Text))+2);
    brush.Style:=bsclear;
    //ϳ���� �����
    rc:=Rect(CoorXtopoint(StrToFloat(EditName2y.Text))-20,
             CoorYToPoint(StrToFloat(EditName2x.Text))+14,
             70+CoorXtopoint(StrToFloat(EditName2y.Text)),
             CoorYToPoint(StrToFloat(EditName2x.Text))+24+TextHeight('W')*3);
             msg:=EditNameP2.Text;
    DrawText(Handle,PCHar(msg),-1,rc, DT_CALCRECT);
    //rectangle(rc);
    DrawText(Handle,PCHar(msg),-1,rc,  DT_CENTER);
    //�����3--------------------------------------------------------------------
    brush.Style:=bsSolid;
    brush.Color:=clred;
    Ellipse(CoorXtopoint(StrToFloat(EditName3y.Text))-5,
            CoorYToPoint(StrToFloat(EditName3x.Text))-5,
            CoorXtopoint(StrToFloat(EditName3y.Text))+5,
            CoorYToPoint(StrToFloat(EditName3x.Text))+5);
    brush.Color:=clwhite;
    Ellipse(CoorXtopoint(StrToFloat(EditName3y.Text))-2,
            CoorYToPoint(StrToFloat(EditName3x.Text))-2,
            CoorXtopoint(StrToFloat(EditName3y.Text))+2,
            CoorYToPoint(StrToFloat(EditName3x.Text))+2);
    brush.Style:=bsclear;
    //ϳ���� �����
    rc:=Rect(CoorXtopoint(StrToFloat(EditName3y.Text))-20,
             CoorYToPoint(StrToFloat(EditName3x.Text))+14,
             70+CoorXtopoint(StrToFloat(EditName3y.Text)),
             CoorYToPoint(StrToFloat(EditName3x.Text))+24+TextHeight('W')*3);
             msg:=EditNameP3.Text;
    DrawText(Handle,PCHar(msg),-1,rc, DT_CALCRECT);
    //rectangle(rc);
    DrawText(Handle,PCHar(msg),-1,rc,  DT_CENTER);
  end;{with}
  end;{for}
end;{DrawLinZas}

{���� ���� �� ������ ��� �������� �����}
procedure AddCulcDataToShema(lastmag:integer;OutputData,ShemaData:TStringGrid);
var i:integer;
Begin
 ShemaData.RowCount:=LastMag+2;
 for i:=1 to lastmag do
  Begin
   ShemaData.Cells[0,i]:=OutputData.Cells[0,i+1];
   ShemaData.Cells[3,i]:=OutputData.Cells[1,i+1];
   ShemaData.Cells[4,i]:=OutputData.Cells[13,i+1];
   ShemaData.Cells[5,i]:=OutputData.Cells[11,i+1];
  end;{for}
end;{AddCulcDataToShema}

{������ ������ ������� ����}
procedure DrawArrow(ACanvas:TCanvas;SX,SY,EX,EY:integer);
var Arrow: array[0..2] of TPoint;
    TanOfAngle: Extended;
    Angle, D,r: Extended;
begin
  if SX = EX then TanOfAngle:=MaxExtended / 100 * Sign(SY - EY)
  else TanOfAngle:=(SY - EY) / (SX - EX);
  D:=Sqrt(Sqr(SX - EX) + Sqr(SY - EY));
  R:=D/2;
  EX:=Round((R * SX + (D - R) * EX) / D);
  EY:=Round((R * SY + (D - R) * EY) / D);
  Arrow[0].X:=EX;
  Arrow[0].Y:=EY;
  Angle:=ArcTan(TanOfAngle) + 0.2;
  if SX < EX then Angle:=Angle + Pi;
  Arrow[1].X:=EX + Round(20 * Cos(Angle));
  Arrow[1].Y:=EY + Round(20 * Sin(Angle));
  Angle:=ArcTan(TanOfAngle) - 0.2;
  if SX < EX then Angle:=Angle + Pi;
  Arrow[2].X:=EX + Round(20 * Cos(Angle));
  Arrow[2].Y:=EY + Round(20 * Sin(Angle));
  ACanvas.Polygon(Arrow);
end;{DrawArrow}
end.{Graphika.pas}
