unit ChartPAR;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Menus, ToolWin, ImgList, Grids, StdCtrls,
  CheckLst,ATCheckedComboBox, ShellApi, ExtActns, ActnList, StdActns, XMLDoc,
  XMLIntf, OleServer, Word2000, TeeProcs, TeEngine, Chart, Series;

     //���� ����������� ������
     Procedure BuildChart(Seriya:TLineSeries;OutputData:TStringGrid;LastMag:integer);

implementation

//���� ����������� ������
Procedure BuildChart(Seriya:TLineSeries;OutputData:TStringGrid;LastMag:integer);
var i:integer;
    len:real;
Begin
len:=0;
Seriya.Clear;
for i:=2 to lastmag+1 do
 Begin
 //Seriya.XValue[i]:=StrToFloat(OutputData.cells[2,i]);
 len:=len+StrToFloat(OutputData.cells[13,i]);
 //Seriya.YValue[i-2]:=len;
   Seriya.AddXY(len,StrToFloat(OutputData.cells[2,i]),'',clRed);
 end;{for}
end;{BuildChart}

end. {Chart.pas}
