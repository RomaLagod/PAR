unit HgGlobal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs ,
  ExtCtrls , Grids , StdCtrls;

// Versioning

{$I Version.inc}

type
  // Border styles

  ThgBorderStyle = ( hgbrdNone , hgbrdSolid , hgbrdDash , hgbrdDot , hgbrdDashDot ,
    hgbrdDashDotDot , hgbrdDouble );

  // Control types
  ThgControlType = ( hgctlComboBox , hgctlButton );
  ThgControlTypes = set of ThgControlType;

  // Vertical alignment
  ThgVAlignment = ( hgvaTop , hgvaCenter , hgvaBottom );

  // Clip style
  ThgClipStyle = ( hgclpClip , hgclpEllipsis , hgclpWrap );

  // Custom button styles
  ThgButtonStyle = ( hgbstEllipsis , hgbstDropDown , hgbstCustom );

  // Formatting
  ThgFormatType = ( hgfmtNone , hgfmtNumeric , hgfmtDateTime ,
    hgfmtScientific );

  // Exceptions
  EhgException = class( Exception );
  EhgColumnIndexOutOfRange = class( EhgException ) end;
  EhgRowIndexOutOfRange = class( EhgException ) end;
  EhgInvalidColumnName = class( EhgException ) end;
  EhgColumnNameExists = class( EhgException ) end;

  // Internal use only - determines which border is being drawn
  ThgBorderDir = ( hgbdTop , hgbdBottom , hgbdLeft , hgbdRight );

  // Cell states for user events
  ThgCellState = ( hgcsSelected , hgcsFocused , hgcsFixed , hgcsHeading );
  ThgCellStates = set of ThgCellState;

  // ImagePosition used for OnGetCellImage
  ThgImagePosition = ( hgipLeft , hgipRight , hgipTop , hgipBottom );
type
  ThgDateOrder = ( hgdoMDY, hgdoDMY, hgdoYMD);

var
  hgDateFormats: array [ hgdoMDY..hgdoYMD , 0..10 ] of string =
  (
    ( 'm/d' , 'm/d/yy' , 'mm/dd/yy' , 'd-mmm' , 'd-mmm-yy' , 'dd-mmm-yy' ,
      'mmm-yy' , 'mmmm-yy' , 'mmmm d, yyyy' , 'ddd mmmm d, yyyy' ,
      'dddd mmmm d, yyyy' ),
    ( 'd/m' , 'd/m/yy' , 'dd/mm/yy' , 'd-mmm' , 'd-mmm-yy' , 'dd-mmm-yy' ,
      'mmm-yy' , 'mmmm-yy' , 'mmmm d, yyyy' , 'ddd mmmm d, yyyy' ,
      'dddd mmmm d, yyyy' ),
    ( 'm/d' , 'yy/m/d' , 'yy/mm/dd' , 'd-mmm' , 'd-mmm-yy' , 'dd-mmm-yy' ,
      'mmm-yy' , 'mmmm-yy' , 'mmmm d, yyyy' , 'ddd mmmm d, yyyy' ,
      'dddd mmmm d, yyyy' )
  );

  hgTimeFormats : array [ 0..3 ] of string =
  ( 'h:nn' , 'h:nn ampm' , 'h:nn:ss' , 'h:nn:ss ampm' );

const
  // User messages
  hgwmAdjustRowHeight = wm_User + 3000;
  hgwmAdjustColWidth = wm_User + 3001;

  // Defaults, used to initialize column and heading fields
  hgDefaultColumnWidth = 64;
  hgDefaultRowHeight = 20;
  hgDefaultTitleVAlignment = hgvaCenter;
  hgDefaultTitleHAlignment = taCenter;
  hgDefaultTitleColor = clBtnFace;
  hgDefaultTitleClipStyle = hgclpWrap;
  hgDefaultTitleInnerBevel = bvNone;
  hgDefaultTitleOuterBevel = bvRaised;

  hgDefaultColumnVAlignment = hgvaTop;
  hgDefaultColumnHAlignment = taLeftJustify;
  hgDefaultColumnColor = clWindow;
  hgDefaultColumnClipStyle = hgclpEllipsis;
  hgDefaultColumnInnerBevel = bvNone;
  hgDefaultColumnOuterBevel = bvNone;

  hgDefaultReadOnly = False;
  hgDefaultMaxTextLength  = 0;
  hgDefaultAutoSuggest = True;
  hgDefaultComboMaxWidth = False;
  hgDefaultDropDownCount = 8;

//  hgDefaultControlType = ThgControlTypes( [] );

  hgDefaultVisible = True;

  hgDefaultBorderStyle = hgbrdNone;
  hgDefaultBorderWidth = 1;
  hgDefaultBorderColor = clBlack;

  hgDefaultHeadingIndex = -1;
  hgDefaultButtonStyle = hgbstEllipsis;
  hgDefaultDrawButtonFace = True;
  hgDefaultButtonVAlignment = hgvaCenter;

  hgDefaultFormatType = hgfmtNone;
  hgDefaultDecimals = 2;
  hgDefaultPrefix = '';
  hgDefaultUseThousands = True;
  hgDefaultNegativeParenthesis = False;
  hgDefaultDateFormatIndex = 2;
  hgDefaultTimeFormatIndex = -1;

  // Margin used to show that something is 'pushed in'
  hgPushInMargin = 2;

  // This is how often the hint timer ticks in milliseconds
  hgHintTimerTickInterval = 10;

  // This is how many ofthe above ticks it takes for the hint to show up,
  // that is hgTicksToShowHint * hgHintTimerTickIntervale milliseconds
  hgTicksToShowHint       = 60;

  hgDefaultAutoAcceptSuggestion = True;

type

  // Persistent border class
  ThgBorder = class( TPersistent )
  private
    FStyle   : ThgBorderStyle;
    FWidth   : Integer;
    FColor   : TColor;
  public
    constructor Create;
    procedure Assign( Source : TPersistent ); override;
  published
    property Style : ThgBorderStyle read FStyle write FStyle;
    property Width : Integer read FWidth write FWidth;
    property Color : TColor read FColor write FColor;
  end;

  // Grid helper class - simply allows maintenance of a list of
  // col-row pairs

  ThgCellList = class( TObject )
  private
    FList : TStringList;
    function ColRowToStr( Col , Row : Longint ) : string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add( Col , Row : Longint );
    function Contains( Col , Row : Longint ) : Boolean;
    function Remove( Col ,Row : Longint ) : Boolean;
  end;

  // Draw info, used in calls to hgDrawText
  THgDrawInfo = record
    Canvas  : TCanvas;
    VAlign  : THGVAlignment;
    HAlign  : TAlignment;
    Text    : string;
    Rect    : TRect;
    HMargin : integer;
    VMargin : integer;
    Clip    : ThgClipStyle;
    Col     : Longint;
    Row     : Longint;
    Grid    : TStringGrid;
    State   : TGridDrawState;
  end;

function RectWidth( const ARect : TRect ) : Integer;
function RectHeight( const ARect : TRect ) : Integer;
procedure HGDrawText( const DrawInfo : THGDrawInfo );
function StringBeginsWith( const Partial : string; const Full : string ) : Boolean;
procedure DrawCheckBox( Canvas : TCanvas; var ARect : TRect; Align : ThgVAlignment; Bitmap : TBitmap; Checked : Boolean );
function HgDrawBorder( Canvas : TCanvas; const FromPt , ToPt : TPoint; Border : ThgBorder; Dir : ThgBorderDir ) : Integer;
procedure HgDrawBorders( Canvas : TCanvas; var ARect : TRect; Top , Right , Bottom , Left : ThgBorder );
procedure HgDrawBevel( Canvas : TCanvas; var ARect : TRect; Outer , Inner : TPanelBevel );
function HgDateOrder : ThgDateOrder;

implementation

uses HgGrid;

var
  OSVersionInfo : TOSVersionInfo;

//------------------------------------------------------------------------------

constructor ThgCellList.Create;
begin
  inherited Create;
  FList := TStringList.Create;
  FList.Sorted := True;
  FList.Duplicates := dupIgnore;
end;

destructor ThgCellList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function ThgCellList.ColRowToStr( Col , Row : Longint ) : string;
begin
  Result := IntToStr( Col ) + ':' + IntToStr( Row );
end;

procedure ThgCellList.Add( Col , Row : Longint );
begin
  FList.Add( ColRowToStr( Col, Row ) );
end;

function ThgCellList.Contains( Col , Row : Longint ) : Boolean;
var
  Index : Integer;
begin
  Result := FList.Find( ColRowToStr( Col , Row ) , Index );
end;

function ThgCellList.Remove( Col ,Row : Longint ) : Boolean;
var
  Index : Integer;
begin
  Result := FList.Find( ColRowToStr( Col , Row ) , Index );
  if Result then
    FList.Delete( Index );
end;

//------------------------------------------------------------------------------

function RectWidth( const ARect : TRect ) : Integer;
begin
  Result := ARect.Right - ARect.Left + 1;
end;

//------------------------------------------------------------------------------

function RectHeight( const ARect : TRect ) : Integer;
begin
  Result := ARect.Bottom - ARect.Top + 1;
end;

//------------------------------------------------------------------------------
//  ThgBorder

constructor ThgBorder.Create;
begin
  inherited Create;
  FStyle := hgDefaultBorderStyle;
  FWidth := hgDefaultBorderWidth;
  FColor := hgDefaultBorderColor;
end;

procedure ThgBorder.Assign( Source : TPersistent );
begin
  if Source is ThgBorder then
    with Source as ThgBorder do
      begin
        Self.FStyle := FStyle;
        Self.FWidth := FWidth;
        Self.FColor := FColor;
      end
  else
    inherited Assign( Source );
end;

//------------------------------------------------------------------------------

function HgDrawBorder( Canvas : TCanvas; const FromPt , ToPt : TPoint; Border : ThgBorder; Dir : ThgBorderDir) : Integer;
var
  OldPenMode  : TPenMode;
  OldPenColor : TColor;
  OldPenStyle : TPenStyle;
  Index       : Integer;
  AFromPt     : TPoint;
  AToPt       : TPoint;
  XDelta      : Integer;
  YDelta      : Integer;
begin
  Result := 0;
  OldPenMode := Canvas.Pen.Mode;
  OldPenColor := Canvas.Pen.Color;
  OldPenStyle := Canvas.Pen.Style;

  case Border.Style of
    hgbrdNone       : Exit;
    hgbrdSolid      : Canvas.Pen.Style := psSolid;
    hgbrdDash       : Canvas.Pen.Style := psDash;
    hgbrdDot        : Canvas.Pen.Style := psDot;
    hgbrdDashDot    : Canvas.Pen.Style := psDashDot;
    hgbrdDashDotDot : Canvas.Pen.Style := psDashDotDot;
    hgbrdDouble     : Canvas.Pen.Style := psSolid;
  end;
  Canvas.Pen.Mode := pmCopy;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := Border.Color;

  XDelta := 0;
  YDelta := 0;

  case Dir of
    hgbdTop   : YDelta := 1;
    hgbdBottom: YDelta := -1;
    hgbdLeft  : XDelta := 1;
    hgbdRight : XDelta := -1;
  end;

  AFromPt := FromPt;
  AToPt := ToPt;
  case Border.Style of
    hgbrdDouble :
      begin
        Canvas.MoveTo( AFromPt.X , AFromPt.Y );
        Canvas.LineTo( AToPt.X , AToPt.Y );
        Inc( AFromPt.X , ( Border.Width + 1 ) * XDelta );
        Inc( AToPt.X , ( Border.Width + 1 ) * XDelta );
        Inc( AFromPt.Y , ( Border.Width + 1 ) * YDelta );
        Inc( AToPt.Y , ( Border.Width + 1 ) * YDelta );
        Canvas.MoveTo( AFromPt.X , AFromPt.Y );
        Canvas.LineTo( AToPt.X , AToPt.Y );
        Result := Border.Width + 2;
      end
    else
      begin
        for Index := 1 to Border.Width do
          begin
            Canvas.MoveTo( AFromPt.X , AFromPt.Y );
            Canvas.LineTo( AToPt.X , AToPt.Y );
            Inc( AfromPt.X , XDelta );
            Inc( AToPt.X , XDelta );
            Inc( AFromPt.Y , YDelta );
            Inc( AToPt.Y , YDelta );
          end;
        Result := Border.Width;
      end;
  end;
  Canvas.Pen.Mode := OldPenMode;
  Canvas.Pen.Color :=OldPenColor;
  Canvas.Pen.Style :=OldPenStyle;
end;

procedure HgDrawBorders( Canvas : TCanvas; var ARect : TRect; Top , Right , Bottom , Left : ThgBorder );
var
  BRect : TRect;
begin
  BRect := ARect;

  Inc( ARect.Top , hgDrawBorder( Canvas , Point( BRect.Left , BRect.Top ) ,
    Point( BRect.Right , BRect.Top ) , Top , hgbdTop ) );

  Dec( ARect.Right , hgDrawBorder( Canvas , Point( BRect.Right - 1, BRect.Top ) ,
    Point( BRect.Right - 1 , BRect.Bottom ) , Right , hgbdRight ) );

  Dec( ARect.Bottom , hgDrawBorder( Canvas , Point( BRect.Right - 1, BRect.Bottom - 1 ) ,
    Point( BRect.Left - 1 , BRect.Bottom -1 ) , Bottom , hgbdBottom ) );

  Inc( ARect.Left , hgDrawBorder( Canvas , Point( BRect.Left , BRect.Bottom - 1 ) ,
    Point( BRect.Left , BRect.Top - 1 ) , Left , hgbdLeft ) );
end;
//------------------------------------------------------------------------------
// This routine is used to draw all text in HyperGrid

var
  LocalDrawText : function ( DC : HDC; lpString : PChar; nCount : Integer; var lpRect : TRect; uFormat : Integer ) : Integer;

function NT3LocalDrawText( DC : HDC; lpString : PChar; nCount : Integer; var lpRect : TRect; uFormat : Integer ) : Integer;
begin
  Result := DrawText( DC , lpString , nCount , lpRect , uFormat )
end;

function NT4LocalDrawText( DC : HDC; lpString : PChar; nCount : Integer; var lpRect : TRect; uFormat : Integer ) : Integer;
begin
  Result := DrawTextEx( DC , lpString , nCount , lpRect , uFormat , nil );
end;

procedure HGDrawText( const DrawInfo : THGDrawInfo );
var
  DRect   : TRect;
  Flags   : UINT;
  Height  : integer;
  ORect   : TRect;
begin
  with DrawInfo do
    begin
      ORect := Rect;

      InflateRect( ORect , -HMargin , -VMargin );
      if gdFixed in State then
        Dec( ORect.Top , VMargin * 2 );

      Flags := DT_NOPREFIX or DT_EXPANDTABS;

      case Clip of
        hgclpWrap       : Flags := Flags or DT_WORDBREAK;
        hgclpEllipsis   : Flags := Flags or DT_END_ELLIPSIS;
      end;

      case HAlign of
        taLeftJustify   : Flags := Flags or DT_LEFT;
        taCenter        : Flags := Flags or DT_CENTER;
        taRightJustify  : Flags := Flags or DT_RIGHT;
      end;

      DRect := ORect;
      Height := LocalDrawText( Canvas.Handle , PChar( Text ) , Length( Text ) , DRect , Flags or DT_CALCRECT );

      if ( Height > RectHeight( ORect ) ) and ( THyperGrid( Grid ).HyperAdjustRowHeight ) then
        PostMessage( Grid.Handle , hgwmAdjustRowHeight , Row , Height + ( VMargin * 2 ) );

      if ( RectWidth( DRect ) > RectWidth( ORect ) ) and ( THyperGrid( Grid ).HyperAdjustColWidth ) then
        PostMessage( Grid.Handle , hgwmAdjustColWidth , Col , RectWidth( DRect ) + ( HMargin * 2 ) );

      if Height < RectHeight( ORect ) then
        case VAlign of
          hgvaCenter  : ORect.Top := ORect.Top + ( ( RectHeight( ORect ) - Height ) div 2 );
          hgvaBottom  : ORect.Top := ORect.Bottom - Height;
        end;

      Canvas.Brush.Style := bsClear;
      LocalDrawText( Canvas.Handle , PChar( Text ) , Length( Text ) , ORect , Flags );
    end;
end;

//------------------------------------------------------------------------------
//  Function used for auto suggest on drop downs

function StringBeginsWith( const Partial : string; const Full : string ) : Boolean;
var
  Index : Integer;
begin
  Result := False;
  if Length( Full ) < Length( Partial ) then
    Exit;
  for Index := 1 to Length( Partial ) do
    if Partial[ Index ] <> Full[ Index ] then
      Exit;
  Result := True;
end;


//------------------------------------------------------------------------------
//  Bevel drawing

procedure HgDrawBevel( Canvas : TCanvas; var ARect : TRect; Outer , Inner : TPanelBevel );
var
  TopColor : TColor;
  BottomColor : TColor;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    case Bevel of
      bvNone :
        begin
          TopColor := clBtnFace;
          BottomColor := clBtnFace;
        end;
      bvRaised :
        begin
          TopColor := clBtnHighlight;
          BottomColor := clBtnShadow;
        end;
      bvLowered :
        begin
          TopColor := clBtnShadow;
          BottomColor := clBtnHighlight;
        end;
    end;
  end;

begin
  if ( Inner = bvNone ) and ( Outer = bvNone ) then
    Exit;
  if ( Outer <> bvNone ) then
    begin
      AdjustColors( Outer );
      Frame3D( Canvas , ARect , TopColor , BottomColor , 1 );
    end;
  if ( Inner <> bvNone ) then
    begin
      AdjustColors( bvNone );
      Frame3D( Canvas , ARect , TopColor , BottomColor , 1 );

      AdjustColors( Inner );
      Frame3D( Canvas , ARect , TopColor , BottomColor , 1 );
    end;
end;

//------------------------------------------------------------------------------

procedure DrawCheckBox( Canvas : TCanvas; var ARect : TRect; Align : ThgVAlignment; Bitmap : TBitmap; Checked : Boolean );
const
  Margin = 4;
var
  BmpSrcRect  : TRect;
  DestRect    : TRect;
begin
  if Checked then
    BmpSrcRect := Rect( Bitmap.Width div 2 , 0 , Bitmap.Width , Bitmap.Height )
  else
    BmpSrcRect := Rect( 0 , 0 , Bitmap.Width div 2 , Bitmap.Height );

  DestRect := ARect;
  case Align of
    hgvaTop    : Inc( DestRect.Top , Margin );
    hgvaBottom : DestRect.Top := DestRect.Bottom - Bitmap.Height - ( Margin * 2 );
    hgvaCenter : Inc( DestRect.Top , ( ( RectHeight( DestRect ) - Bitmap.Height ) div 2 ) );
  end;
  Inc( DestRect.Left , Margin );
  DestRect.Right := DestRect.Left + Bitmap.Width div 2;
  DestRect.Bottom := DestRect.Top + Bitmap.Height;
  if Canvas <> nil then
    Canvas.CopyRect( DestRect , Bitmap.Canvas , BmpSrcRect );

  Inc( ARect.Left , ( Margin * 2 ) + ( Bitmap.Width div 2 ) - 1);
end;

//------------------------------------------------------------------------------

function HgDateOrder : ThgDateOrder;
var
  I: Integer;
  DateFormat : string;
begin
  Result := hgdoMDY;
  DateFormat := ShortDateFormat;
  I := 1;
  while I <= Length(DateFormat) do
  begin
    case Chr(Ord(DateFormat[I]) and $DF) of
      'Y': Result := hgdoYMD;
      'M': Result := hgdoMDY;
      'D': Result := hgdoDMY;
    else
      Inc(I);
      Continue;
    end;
    Exit;
  end;
end;

initialization
  try
    FillChar( OSVersionInfo , SizeOf( OSVersionInfo ) , 0 );
    OSVersionInfo.dwOSVersionInfoSize := SizeOf( OSVersionInfo );
    if not GetVersionEx( OSVersionInfo ) then
      OSVersionInfo.dwMajorVersion := 3;
  finally
    if OsVersionInfo.dwMajorVersion = 3 then
      LocalDrawText := NT3LocalDrawText
    else
      LocalDrawText := NT4LocalDrawText;
  end;
end.










