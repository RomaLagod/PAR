unit HyperImageGrid;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	Grids, HgHGrid, HgGrid,HgColumn , HgGlobal, ImgList;

type
	THyperImageGrid = class(THyperGrid)
	private
		{ Private declarations }
		FImageList 				: TImageList;
		FShowEditImage		: Boolean;
		FOldGetCellImage	: ThgOnGetCellImage;
		procedure SetShowEditImage(value:boolean);
	protected
		{ Protected declarations }
		procedure GetInternalCellImage ( Sender : TObject; ACol , ARow , HeadingIndex : Longint;
			var PictureOrImageList : TObject; var ImageIndex : Integer;
			var Position : ThgImagePosition; var HAlign : TAlignment;
			var VAlign : ThgVAlignment; var Margin : Integer );
	public
		{ Public declarations }
		procedure SortByCol(const col:integer);
		constructor Create( AOwner : TComponent ); override;
		destructor Destroy; override;
	published
		{ Published declarations }
		property ShowEditImage : boolean read FShowEditImage write SetShowEditImage default false;
	end;

implementation
//{$R  hypImagEdit.res}
{
	PROCEDURES FOR SORTING THE ROWS OF A HYPERGRID
	YOU MUST CALL
		QuickSort(hgrd, ACol, F, L);
		hgrd το HyperGrid
		ACol η στήλη ως προς τα οποία θα γίνει η ταξινόμιση
		F    η πρώτη γραμμή
		L    και η τελευταία που θέλουμε την ταξινόμιση

	πχ Αν θέλουμε να ταξινομιθεί ολοόκληρο
	καλούμε
  QuickSort(hgrd, ACol, 1, hgrd.RowCount-1)
}
procedure ExchangeItems(hg: THyperGrid; row1, row2: Integer);
var
	c				: Integer;
	Object1 : TObject;
	Item1		: String;
begin
	for c := 1 to hg.ColCount -1 do
	begin
		Item1 							:= hg.cells[c,row1];
		hg.cells[c,row1] 		:= hg.cells[c,row2];
		hg.cells[c,row2] 		:= Item1;
		Object1 						:= hg.Objects[c,row1];
		hg.Objects[c,row1] 	:= hg.Objects[c,row2];
		hg.Objects[c,row2] 	:= Object1;
	end;
end;

{
	The compare operations returns
	if S1 < S2  a value less than 0
	if S1 > S2  a value greater than 0
	if S1 = S2  returns 0
}

function NumCompareText(const S1, S2: string):Integer;
var n1,n2: double;
begin
	n1	:= StrToFloat(s1);
	n2	:= StrToFloat(s2);
	if n1>n2 then
		result :=  1
	else
		if n1<n2 then
			result := -1
		else
			result := 0;
end;

{
	The compare operations returns
	if S1 < S2  a value less than 0
	if S1 > S2  a value greater than 0
	if S1 = S2  returns 0
}

function DateCompareText(const S1, S2: string):Integer;
var n1,n2: Tdate;
begin
	n1 := StrToDate(s1);
	n2 := StrToDate(s2);
	if n1>n2 then
		result   :=  1
	else
		if n1<n2 then
			result := -1
		else
			result :=  0;
end;

function BooleanCompareObj(const S1, S2: TObject):Integer;
begin
	if (not Assigned(s1)  and not Assigned(s2)) or
		 ( Assigned(s1)     and     Assigned(s2)) then
		result :=  0
	else if Assigned(s1) and not Assigned(s2) then
		result :=  -1
	else
		result := 1
end;

procedure QuickSort(hg: THyperGrid;C, F, L: Integer);
var
	I, J: Integer;
	P : string;
	O : TObject;
begin
	repeat
		I := F;
		J := L;
		P := hg.cells[c,((F + L) shr 1)];
		O := hg.Objects[c,((F + L) shr 1)];
		repeat
			case hg.Columns[c].FormatType of
				hgfmtNumeric:
					begin
						while NumCompareText(hg.cells[C,I], P) < 0 do Inc(I);
						while NumCompareText(hg.cells[C,J], P) > 0 do Dec(J);
					end;
				hgfmtDateTime:
					begin
						while DateCompareText(hg.cells[C,I], P) < 0 do Inc(I);
						while DateCompareText(hg.cells[C,J], P) > 0 do Dec(J);
					end;
				else
					if hgctlCheckBox in hg.Columns[C].ControlType then
					begin

						while BooleanCompareObj(hg.Objects[C,I], O) < 0 do Inc(I);
						while BooleanCompareObj(hg.Objects[C,J], O) > 0 do Dec(J);
					end
					else
					begin
						while AnsiCompareText(hg.cells[C,I], P) < 0 do Inc(I);
						while AnsiCompareText(hg.cells[C,J], P) > 0 do Dec(J);
					end;
			end;
			if I <= J then
			begin
				ExchangeItems(hg,I, J);
				Inc(I);
				Dec(J);
			end;
		until I > J;
		if F < J then QuickSort(hg, C, F, J);
		F := I;
	until I >= L;
end;

procedure THyperImageGrid.SortByCol(const col:integer);
begin
	if (col>=0) and (col<colcount) then
		QuickSort(self, Col, 1, self.rowcount-1);
end;

procedure THyperImageGrid.SetShowEditImage(value:boolean);
begin
	if FShowEditImage<>value then
	if value = true then
	begin
		FOldGetCellImage		:= Self.OnGetCellImage;
		Self.OnGetCellImage := GetInternalCellImage;
	end
	else
	begin
		Self.OnGetCellImage := FOldGetCellImage;
	end;
	FShowEditImage:= value;
end;

procedure THyperImageGrid.GetInternalCellImage( Sender : TObject; ACol , ARow , HeadingIndex : Longint;
			var PictureOrImageList : TObject; var ImageIndex : Integer;
			var Position : ThgImagePosition; var HAlign : TAlignment;
			var VAlign : ThgVAlignment; var Margin : Integer );
var IsCellReadOnly: boolean;
begin
	if not Self.Focused then exit;
	if FShowEditImage and
		(Acol>=self.FixedCols) and
		(Arow>=FixedRows) and
		(Acol = Self.COl) and (Arow = Self.Row) then
	begin
		PictureOrImageList := FImageList;
		Position 	 	:= hgipLeft;
		HAlign 		 	:= taLeftJustify;
		VAlign 	 		:= hgvaCenter;
		Margin 			:= 2;
		if not (goEditing in Self.Options) or
			Self.Columns[ACol].ReadOnly then
			ImageIndex := 0
		else
		begin
			ImageIndex := 1;
			if Assigned(OnGetReadOnly) then
			begin
				Self.OnGetReadOnly(Self,ACol,ARow,IsCellReadOnly);
				if IsCellReadOnly then
					ImageIndex := 0
			end
		end;
	end
end;

constructor THyperImageGrid.Create( AOwner : TComponent );
begin
	inherited Create( AOwner );
	FOldGetCellImage 	:= Nil;
	FShowEditImage 		:= false;
	Self.Options			:= Self.options - [goDrawFocusSelected];
	Self.HyperOptions	:= Self.HyperOptions -[hgoptHighLightSelection];
	FImageList := TImageList.Create(Self);
	FImageList.GetInstRes(hInstance,rtBitmap,
		'THYPNOEDIT',0,[lrDefaultColor,lrDefaultSize,lrTransparent],clBtnFace);
	FImageList.GetInstRes(hInstance,rtBitmap,
		'THYPDOEDIT',0,[lrDefaultColor,lrDefaultSize,lrTransparent],clBtnFace);
end;

destructor THyperImageGrid.Destroy;
begin
	FImageList.Free;
	inherited Destroy;
end;

end.
