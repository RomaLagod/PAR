unit MSWord_Exel;

interface

    Uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ComCtrls, ExtCtrls, ToolWin, Grids, ImgList, Dialogs, ExtDlgs,
      XMLDoc,XMLIntf,base,ATCheckedComboBox, Variants,  ShellApi,math,New_Open_Save_Edit,
      ComObj,Chart;

    //Експорт всіх даних у МСВорд
      Function DataToWord(InputData:TStringGrid):Boolean;
    //Експорт всіх даних у МСЕксель
     Function DataToExel(InputData,ShotOutputData,OutputData:TStringGrid):Boolean;



implementation

//Експорт всіх даних у МСВорд
Function DataToWord(InputData:TStringGrid):Boolean;
var
WordApp, NewDoc, WordTable,WordTable1: OLEVariant;
iRows,iCols, iGridRows, jGridCols: Integer;
begin
try
WordApp:=CreateOleObject('Word.Application');
except
Exit;
end;
WordApp.Visible:=True;
NewDoc:=WordApp.Documents.Add;
{Експорт таблиці Вихідних даних sgInputData}
iCols:=InputData.ColCount;
iRows:=InputData.RowCount;
WordTable:=NewDoc.Tables.Add(WordApp.Selection.Range,iRows,iCols);
for iGridRows:=1 to iRows do
for jGridCols:=1 to iCols do
WordTable.Cell(iGridRows,jGridCols).Range.Text:=InputData.Cells[jGridCols-1,iGridRows-1];
WordApp:=Unassigned;
NewDoc:=Unassigned;
WordTable:=Unassigned;
end;{DataToWord}

//Експорт всіх даних у МСЕксель
Function DataToExel(InputData,ShotOutputData,OutputData:TStringGrid):Boolean;
var
XLApp : variant;
i,n:integer;
oChart: TChart;
begin
    XLApp:= CreateOleObject('Excel.Application');
    XLApp.Workbooks.Add;
    //Таблиця sgInputData
   XLApp.Workbooks[1].WorkSheets[1].Name:='Вихідні дані';
   XLApp.WorkBooks[1].WorkSheets[1].Rows[1].Font.Bold := True;
   XLApp.WorkBooks[1].WorkSheets[1].Rows[1].Font.Color := clBlack;
   XLApp.WorkBooks[1].WorkSheets[1].Rows[1].Font.Size := 10;
   XLApp.WorkBooks[1].WorkSheets[1].Rows[1].Font.Name := 'Arial Cyr';
   XLApp.WorkBooks[1].WorkSheets[1].Range['A1', EmptyParam].ColumnWidth:=20;
   XLApp.WorkBooks[1].WorkSheets[1].Range['B1', EmptyParam].ColumnWidth:=10;
   XLApp.WorkBooks[1].WorkSheets[1].Range['C1', EmptyParam].ColumnWidth:=10;
   XLApp.WorkBooks[1].WorkSheets[1].Range['D1', EmptyParam].ColumnWidth:=10;
   XLApp.WorkBooks[1].WorkSheets[1].Range['E1', EmptyParam].ColumnWidth:=50;
   XLApp.WorkBooks[1].WorkSheets[1].Range['F1', EmptyParam].ColumnWidth:=10;
   XLApp.WorkBooks[1].WorkSheets[1].Range['G1', EmptyParam].ColumnWidth:=15;
   XLApp.WorkBooks[1].WorkSheets[1].Range['A:AA', EmptyParam].WrapText := True;
   XLApp.WorkBooks[1].WorkSheets[1].Range['1:1000', EmptyParam].WrapText := True;
   XLApp.WorkBooks[1].WorkSheets[1].Range['B1:B1000', EmptyParam].NumberFormat := '@';
   XLApp.WorkBooks[1].WorkSheets[1].Cells[1,1] := 'Початковий тиск, Па';
   XLApp.WorkBooks[1].WorkSheets[1].Cells[2,1] := Para_Normal.eStartPressure.Text;
   XLApp.WorkBooks[1].WorkSheets[1].Cells[3,1] := 'Тиск перед споживачем, Па';
   XLApp.WorkBooks[1].WorkSheets[1].Cells[4,1] := Para_Normal.eBeforePressure.Text;
   XLApp.WorkBooks[1].WorkSheets[1].Cells[5,1] := 'Почактова температура, *С';
   XLApp.WorkBooks[1].WorkSheets[1].Cells[6,1] := Para_Normal.eStartTemperature.Text;
   XLApp.WorkBooks[1].WorkSheets[1].Cells[7,1] := 'Загальна довжина магістралі, м';
   XLApp.WorkBooks[1].WorkSheets[1].Cells[8,1] := Para_Normal.eLength.Text;
   XLApp.WorkBooks[1].WorkSheets[1].Cells[9,1] := 'Тип прокладання мережі';
   XLApp.WorkBooks[1].WorkSheets[1].Cells[10,1] := Para_Normal.cbTemperatureOS.Text;
   XLApp.WorkBooks[1].WorkSheets[1].Cells[11,1] := '*С';
   XLApp.WorkBooks[1].WorkSheets[1].Cells[12,1] := Para_Normal.eTOSReal.Text;
    For i:=1 to InputData.RowCount do
     begin
      For n:=1 to InputData.ColCount do
       Begin
         XLApp.WorkBooks[1].WorkSheets[1].Cells[i,n+1] :=InputData.Cells[n-1,i-1] ;
       end;
     end;{For}
     //Таблиця sgShotOutputData
   XLApp.Workbooks[1].WorkSheets[2].Name:='Стисла таблиця результатів';
   XLApp.WorkBooks[1].WorkSheets[2].Rows[1].Font.Bold := True;
   XLApp.WorkBooks[1].WorkSheets[2].Rows[1].Font.Color := clBlack;
   XLApp.WorkBooks[1].WorkSheets[2].Rows[1].Font.Size := 10;
   XLApp.WorkBooks[1].WorkSheets[2].Rows[1].Font.Name := 'Arial Cyr';
   XLApp.WorkBooks[1].WorkSheets[2].Range['A:AA', EmptyParam].WrapText := True;
   XLApp.WorkBooks[1].WorkSheets[2].Range['1:1000', EmptyParam].WrapText := True;
   XLApp.WorkBooks[1].WorkSheets[2].Range['A1:A1000', EmptyParam].NumberFormat := '@';
    For i:=1 to ShotOutputData.RowCount do
     begin
      For n:=1 to ShotOutputData.ColCount do
         XLApp.WorkBooks[1].WorkSheets[2].Cells[i,n] :=ShotOutputData.Cells[n-1,i-1] ;
     end;{For}
    //Таблиця sgOutputData
    XLApp.Workbooks[1].WorkSheets[3].Name:='Вся таблиця результатів';
   XLApp.WorkBooks[1].WorkSheets[3].Rows[1].Font.Bold := True;
   XLApp.WorkBooks[1].WorkSheets[3].Rows[1].Font.Color := clBlack;
   XLApp.WorkBooks[1].WorkSheets[3].Rows[1].Font.Size := 10;
   XLApp.WorkBooks[1].WorkSheets[3].Rows[1].Font.Name := 'Arial Cyr';
   XLApp.WorkBooks[1].WorkSheets[3].Range['R1', EmptyParam].ColumnWidth:=50;
   XLApp.WorkBooks[1].WorkSheets[3].Range['A:AA', EmptyParam].WrapText := True;
   XLApp.WorkBooks[1].WorkSheets[3].Range['1:1000', EmptyParam].WrapText := True;
   XLApp.WorkBooks[1].WorkSheets[3].Range['A1:A1000', EmptyParam].NumberFormat := '@';
    For i:=1 to OutputData.RowCount do
     begin
      For n:=1 to OutputData.ColCount do
         XLApp.WorkBooks[1].WorkSheets[3].Cells[i,n] :=OutputData.Cells[n-1,i-1] ;
     end;{For}

   XLApp.Visible:=true;

end;{DataToExel}

end. {MSWord_Exel.pas}
