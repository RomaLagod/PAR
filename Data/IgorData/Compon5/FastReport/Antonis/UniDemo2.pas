unit UniDemo2;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	Grids, StdCtrls,
	HgHGrid, HgGrid,
	FR_PSGrids,FR_PTabl,FR_Class;

type
	TForm1 = class(TForm)
		sgrid: TStringGrid;
		Button1: TButton;
		HGrid	 : THyperGrid;
		Button2: TButton;
		frPrintStringGrid1: TfrPrintStringGrid;
		frPrintHyperGrid1: TfrPrintHyperGrid;
    rb1: TRadioButton;
    rb2: TRadioButton;
    Label1: TLabel;
		procedure FormShow(Sender: TObject);
		procedure Button1Click(Sender: TObject);
		procedure Button2Click(Sender: TObject);
    procedure frPrintHyperGrid1PrintData(Acol, Arow: Integer;
      Memo: TStringList; View: TfrView; Section: TfrDataSection);
    procedure frPrintStringGrid1PrintData(Acol, Arow: Integer;
      Memo: TStringList; View: TfrView; Section: TfrDataSection);
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	Form1: TForm1;

implementation

uses unCustomPreview;
{$R *.DFM}

var sumes : array [1..5] of extended;

procedure TForm1.FormShow(Sender: TObject);
var c,r:integer;
begin
	for c:= 0 to sgrid.ColCount - 1 do
	begin
		if c>=sgrid.FixedCols then sgrid.ColWidths[c] := 40;
		for r:= 0 to sgrid.RowCount - 1 do
			sgrid.Cells[c,r] := inttostr(c*1000+r);
	end;
	for c:= 0 to HGrid.ColCount - 2 do
	begin
		for r:= 1 to HGrid.RowCount - 1 do
			HGrid.Cells[c,r] := inttostr(c*1000+r);
	end;
end;

procedure TForm1.Button1Click(Sender: TObject);
	var i:integer;
begin
	for i:= 1 to 5 do sumes[i] := 0;
	if RB2.Checked then
		frmCustomPreview := TfrmCustomPreview.CreateByLanguage(self,1);
	if RB1.Checked then
		frPrintStringGrid1.Preview := nil else
		frPrintStringGrid1.Preview := frmCustomPreview.frPreview1;
	frPrintStringGrid1.ShowReport;
	if RB2.Checked then
	begin
		frmCustomPreview.ShowModal;
		frmCustomPreview.Release;
	end;
end;

procedure TForm1.Button2Click(Sender: TObject);
	var i:integer;
begin
	for i:= 1 to 5 do sumes[i] := 0;
	if RB2.Checked then
		frmCustomPreview := TfrmCustomPreview.CreateByLanguage(self,0);
	if RB1.Checked then
		frPrintHyperGrid1.Preview := nil else
		frPrintHyperGrid1.Preview := frmCustomPreview.frPreview1;
	frPrintHyperGrid1.ShowReport;
	if RB2.Checked then
	begin
		frmCustomPreview.ShowModal;
		frmCustomPreview.Release;
	end;
end;

procedure TForm1.frPrintHyperGrid1PrintData(Acol, Arow: Integer;
	Memo: TStringList; View: TfrView; Section: TfrDataSection);
begin
	if Section = frData then
		if ACol in [2..4] then
			sumes[Acol] := sumes[aCol] + StrToFloat(hgrid.Cells[Acol,ARow]);
	if Section = frFooter then
		if ACol in [2..4] then
		begin
			if Acol = 3 then
				Memo[0] := FormatFloat( '#,###.00' , sumes[Acol])
			else
				Memo[0] := FloatToStr(sumes[Acol]);
			TfrMemoView(View).Alignment := frtaRight + frtaMiddle;
		end
		else
		begin
			Memo[0] := '--';
			TfrMemoView(View).Alignment := frtaCenter + frtaMiddle
		end;
end;

procedure TForm1.frPrintStringGrid1PrintData(Acol, Arow: Integer;
	Memo: TStringList; View: TfrView; Section: TfrDataSection);
begin
	if Section = frFooter then
		if ACol in [2..4] then
		begin
		 Memo[0] := FloatToStr(sumes[Acol]);
		end
		else
			Memo[0] := '';
	if Section = frData then
		if ACol in [2..4] then
		begin
			Sumes[aCol] := sumes[acol] + StrToFloat(sgrid.cells[Acol,Arow]);
			TfrMemoView(View).Alignment := frtaRight;
		end;
end;

end.
