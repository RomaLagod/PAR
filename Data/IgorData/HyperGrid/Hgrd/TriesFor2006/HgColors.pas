unit HgColors;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  ThgColorSelectForm = class(TForm)
    cmbColors: TComboBox;
    Label1: TLabel;
    btnCustom: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    ColorDialog: TColorDialog;
    procedure FormShow(Sender: TObject);
    procedure cmbColorsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnCustomClick(Sender: TObject);
    procedure cmbColorsChange(Sender: TObject);
  private
    TheColor : TColor;
    procedure ColorValueProc( const S : string );
  public
  end;

//------------------------------------------------------------------------------

  ThgColorDialog = class( TComponent )
  private
    FColor : TColor;
    FTitle : string;
  public
    function Execute : Boolean;
  published
    property Color : TColor read FColor write FColor;
    property Title : string read FTitle write FTitle;
  end;

//------------------------------------------------------------------------------

implementation

{$R *.DFM}

procedure ThgColorSelectForm.ColorValueProc( const S : string );
begin
  cmbColors.Items.Add( S );
end;

procedure ThgColorSelectForm.FormShow(Sender: TObject);
begin
  GetColorValues( ColorValueProc );
  cmbColors.ItemIndex := cmbColors.Items.IndexOf( ColorToString( TheColor ) );
end;

procedure ThgColorSelectForm.cmbColorsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
const
  Margin = 2;
var
  Box : TRect;
begin
  with cmbColors.Canvas do
    begin
      FillRect( Rect );
      Box := Rect;
      Box.Right := Box.Left + ( Box.Bottom - Box.Top );
      InflateRect( Box , -Margin , -Margin );
      Pen.Color := clBlack;
      Brush.Color := StringToColor( cmbColors.Items[ Index ] );
      with Box do
        RoundRect( Left , Top , Right , Bottom , Margin , Margin );
      Rect.Left := Box.Right + 2 * Margin;
      Inc( Rect.Top , Margin div 2 );
      Brush.Style := bsClear;
      TextOut( Rect.Left , Rect.Top , cmbColors.Items[ Index ] );
    end;
end;

procedure ThgColorSelectForm.btnCustomClick(Sender: TObject);
begin
  ColorDialog.Color := TheColor;
  if ColorDialog.Execute then
    begin
      TheColor := ColorDialog.Color;
      ModalResult := mrOk;
    end;
end;

procedure ThgColorSelectForm.cmbColorsChange(Sender: TObject);
begin
  if cmbColors.ItemIndex > -1 then
    TheColor := StringToColor( cmbColors.Items[ cmbColors.ItemIndex ] );
end;

//------------------------------------------------------------------------------

function ThgColorDialog.Execute : Boolean;
var
  hgColorSelectForm : ThgColorSelectForm;
begin
  hgColorSelectForm := ThgColorSelectForm.Create( Application );
  try
    hgColorSelectForm.TheColor := Color;
    hgColorSelectForm.Caption := Title;
    Result := hgColorSelectForm.ShowModal = mrOk;
    if Result then
      Color := hgColorSelectForm.TheColor;
  finally
    hgColorSelectForm.Free;
  end;
end;

//------------------------------------------------------------------------------

end.
