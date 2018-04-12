unit HgExcel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HgGrid, HgGlobal , HgColumn;

type

  ThgExcelOption = ( hgexlFont , hgexlAlignment );
  ThgExcelOptions = set of ThgExcelOption; 

function HyperGridToExcel( Grid : THyperGrid; Options : ThgExcelOptions ) : Boolean;

implementation

uses OLEAuto , Grids , ExtCtrls;

function HyperGridToExcel( Grid : THyperGrid; Options : ThgExcelOptions ) : Boolean;
var
  Excel     : Variant;
  WorkBook  : Variant;
  WorkSheet : Variant;
  Cell      : Variant;

  Col , Row : Longint;
  Column    : ThgHeading;

  GridState   : TGridDrawState;
  CellState   : ThgCellStates;
  Color       : TColor;
  Font        : TFont;
  DrawInfo    : ThgDrawInfo;
  OuterBevel  : TPanelBevel;
  InnerBevel  : TPanelBevel;
  OldCursor   : TCursor;
begin
  Result := False;
  try
    Excel := CreateOLEObject( 'Excel.Application' );
    WorkBook := Excel.Workbooks.Add;

    WorkSheet := WorkBook.Worksheets.Add;

    Font := TFont.Create;
    OldCursor := Screen.Cursor;
    Screen.Cursor := crHourglass;
    try
      for Col := 0 to Pred( Grid.ColCount ) do
        begin
          Column := Grid.VisibleColumns[ Col ];
          for Row := 0 to Pred( Grid.RowCount ) do
            begin
              GridState := [];
              if ( Col < Grid.FixedCols ) or ( Row < Grid.FixedRows ) then
                GridState := [ gdFixed ];

              Grid.GetCellAttributes( Col , Row , Column , GridState , CellState ,
                Color , Font , DrawInfo , OuterBevel , InnerBevel );

              Cell := Worksheet.Cells[ Row + +1 , Col + 1  ];

              if hgexlFont in Options then
                begin
                  Cell.Font.Name := Font.Name;
                  Cell.Font.Size := Font.Size;
                  Cell.Font.Color := Font.Color;
                  Cell.Font.Bold := fsBold in Font.Style;
                  Cell.Font.Italic := fsItalic in Font.Style;
                  Cell.Font.Underline := fsUnderline in Font.Style;
                  Cell.Font.Strikethrough := fsStrikeout in Font.Style;
                end;

              if hgexlAlignment in Options then
                begin
                  case DrawInfo.VAlign of
                    hgvaTop     : Cell.VerticalAlignment := $FFFFEFC0;
                    hgvaCenter  : Cell.VerticalAlignment := $FFFFEFF4;
                    hgvaBottom  : Cell.VerticalAlignment := $FFFFEFF5;
                  end;

                  case DrawInfo.HAlign of
                    taLeftJustify   : Cell.HorizontalAlignment := $FFFFEFDD;
                    taCenter        : Cell.HorizontalAlignment := $FFFFEFF4;
                    taRightJustify  : Cell.HorizontalAlignment := $FFFFEFC8;
                  end;
                end;

              Cell.Value := DrawInfo.Text;
            end;
        end;

      Excel.Visible := True;
      Result := True;
    finally
      Screen.Cursor := OldCursor;
      Font.Free;
    end;
  except
  end;
end;

end.



