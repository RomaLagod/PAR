unit ChartPAR;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Menus, ToolWin, ImgList, Grids, StdCtrls,
  CheckLst,ATCheckedComboBox, ShellApi, ExtActns, ActnList, StdActns, XMLDoc,
  XMLIntf, OleServer, Word2000, TeeProcs, TeEngine, Chart, Series,Para_REPORT;

     //Будує пєзометрични графік
     Procedure BuildChart(Seriya:TLineSeries;OutputData:TStringGrid;LastMag:integer);

implementation

//Будує пєзометрични графік
Procedure BuildChart(Seriya:TLineSeries;OutputData:TStringGrid;LastMag:integer);
var i:integer;
    len:real;
Begin
len:=0;
Seriya.Clear;
ReportPar.Series1.Clear;
   Seriya.AddXY(len,StrToFloat(OutputData.cells[2,2]),'',clRed);
   ReportPar.Series1.AddXY(len,StrToFloat(OutputData.cells[2,2]),'',clRed);
for i:=3 to lastmag+1 do
 Begin
 //Seriya.XValue[i]:=StrToFloat(OutputData.cells[2,i]);
 len:=len+StrToFloat(OutputData.cells[13,i-1]);
 //Seriya.YValue[i-2]:=len;
   Seriya.AddXY(len,StrToFloat(OutputData.cells[2,i]),'',clRed);
   ReportPar.Series1.AddXY(len,StrToFloat(OutputData.cells[2,i]),'',clRed);
 end;{for}
    Seriya.AddXY(len+StrToFloat(OutputData.cells[13,lastmag+1]),StrToFloat(OutputData.cells[30,lastMag+1]),'',clRed);
   ReportPar.Series1.AddXY(len+StrToFloat(OutputData.cells[13,lastmag+1]),StrToFloat(OutputData.cells[30,LastMag+1]),'',clRed);
end;{BuildChart}

end. {Chart.pas}
