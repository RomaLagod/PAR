unit HgGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids , StdCtrls , HgColumn , HgGlobal , ExtCtrls , HgEdit , HgHGrid,
  Db;

type
  ThgOption = ( hgoptDrawFocusRectangle , hgoptHighlightSelection );
  ThgOptions = set of ThgOption;

  //----------------------------------------------------------------------------
  // Event types

  ThgOnConversionError = procedure( Sender : TObject; ACol , ARow : Longint;
    Column : ThgColumn; var S : string ) of object;

  ThgOnGetDisplayText = procedure( Sender : TObject; ACol , ARow : Longint;
    Column : ThgColumn; var S : string; var Convert : Boolean ) of object;

  ThgOnChangeCellBorders = procedure( Sender : TObject; ACol , ARow : Longint;
    Column : ThgHeading; State : ThgCellStates;
    TopBorder , RightBorder , BottomBorder , LeftBorder : ThgBorder ) of object;

  ThgOnChangeCellAttributes = procedure( Sender : TObject; ACol , ARow : Longint;
    Column : ThgHeading; State : ThgCellStates;
    var AColor : TColor; AFont : TFont; var HAlign : TAlignment; var VAlign : ThgVAlignment;
    var OuterBevel , InnerBevel : TPanelBevel ) of object;

  ThgOnFixedCellClick = procedure( Sender : TObject; ACol , ARow , HeadingIndex : Longint;
    Button : TMouseButton; Shift : TShiftState; X , Y : Integer ) of object;

  ThgOnGetSuggestion = procedure( Sender : TObject; ACol , ARow : Longint;
    CellText : string; var Suggestion : string ) of object;

  ThgOnGetReadOnly = procedure( Sender : TObject; ACol , ARow : Longint;
    var ReadOnly : Boolean ) of object;

  ThgOnButtonClick = procedure( Sender : TObject; ACol , ARow : Longint ) of object;

  ThgOnGetCellImage = procedure( Sender : TObject; ACol , ARow , HeadingIndex : Longint;
    var PictureOrImageList : TObject; var ImageIndex : Integer;
    var Position : ThgImagePosition; var HAlign : TAlignment;
    var VAlign : ThgVAlignment; var Margin : Integer ) of object;

  ThgOnExitCell = procedure( Sender : TObject; ACol , ARow : Longint;
    var CanExit : Boolean ) of object;

  ThgOnEnterCell = procedure( Sender : TObject; ACol , ARow : Longint ) of object;

  ThgOnComboSelection = procedure( Sender : TObject; ACol , ARow : Longint ) of object;

  ThgOnCellEdited = procedure( Sender : TObject; ACol , ARow : Longint ) of object;

  //----------------------------------------------------------------------------

  THyperGrid = class( THgHintGrid )
  private
    FColumns                : ThgColumns;
    FHyperOptions           : ThgOptions;
    FHighlight              : TColor;
    FHighlightFont          : TColor;
    FAdjustWidth            : Boolean;
    FAdjustHeight           : Boolean;
    FColumnClick            : Boolean;
    FColumnsRegistryKey     : string;
    FAutoAcceptSuggestion   : Boolean;

    FOnButtonClick          : ThgOnButtonClick;
    FOnConversionError      : ThgOnConversionError;
    FOnGetDisplayText       : ThgOnGetDisplayText;
    FOnChangeCellBorders    : ThgOnChangeCellBorders;
    FOnChangeCellAttributes : ThgOnChangeCellAttributes;
    FOnFixedCellClick       : ThgOnFixedCellClick;
    FOnGetSuggestion        : ThgOnGetSuggestion;
    FOnGetReadOnly          : ThgOnGetReadOnly;
    FOnGetCellImage         : ThgOnGetCellImage;
    FOnExitCell             : ThgOnExitCell;
    FOnEnterCell            : ThgOnEnterCell;
    FOnComboSelection       : ThgOnComboSelection;
    FOnCellEdited           : ThgOnCellEdited;
    FOnEnterRow             : ThgOnEnterCell;
    FOnExitRow              : ThgOnExitCell;
  private
    procedure DrawHeading( ACol , ARow : Longint; Column : ThgColumn );
  private
    FHeadings       : ThgHeadings;
    FHeadingBmp     : TBitmap;
  public
//    FOrgCheckBoxBmp : TBitmap;
  private
    function GetVisibleColumn( Index : Integer ) : ThgColumn;
    function GetVisibleColumnCount : Integer;
    procedure SetHighlight( Value : TColor );
    procedure SetHighlightFont( Value : TColor );
    procedure SetOptions( Value : ThgOptions );
    procedure OnColumnPropertyChange( Column : ThgHeading; Prop : ThgProperty );
    procedure HideColumn( Column : ThgColumn );
    procedure ShowColumn( Column : ThgColumn );
    procedure hgwmHandleAdjustColumnWidth( var Msg : TMessage ); message hgwmAdjustColWidth;
    procedure hgwmHandleAdjustRowHeight( var Msg :TMessage ); message hgwmAdjustRowHeight;
    function GetColByName( Value : string ) :ThgColumn;
    function GetVersion : string;
    function GetAuthor : string;
    procedure SetVersion( S : string );
    procedure SetAuthor( S : string );
  private
    FLastFocus : TGridCoord;
  public
    // These should be private, but are public so that ThgInPlaceEdit can use it
    procedure GetCellAttributes( ACol , ARow : Longint; Column : ThgHeading;
      AState : TGridDrawState; var CellState : ThgCellStates; var AColor : TColor;
      AFont : TFont; var DrawInfo : ThgDrawInfo; var OuterBevel , InnerBevel : TPanelBevel );
    procedure DoCellEdited( ACol , ARow : Longint ); virtual;
    // This one should be private but is public for HgDialog
    procedure SetColCount( const C : Longint );
    procedure DoComboSelection( ACol , ARow : Longint );
  private
    // Temporary objects used by the grid
    FTopBorder    : ThgBorder;
    FLeftBorder   : ThgBorder;
    FRightBorder  : ThgBorder;
    FBottomBorder : ThgBorder;
    FFont         : TFont;
  private
    // This is used to signal flag an internal column move ( not done by the user )
    FInternalMove : Boolean;
  private
    // Variables used to track mouse clicks on fixed cells
    FTracking       : Boolean;
    FTrackCol       : Longint;
    FTrackRow       : Longint;
    FDown           : Boolean;
    FTrackHeading   : Longint;
    FButtonDown     : TMouseButton;
    FInsideOriginal : Boolean;
    procedure TrackButton( X , Y : Integer );
    function MouseOnHeading( X , Y : Integer ) : Integer;
    procedure RefreshTrackingHeading;
    function IsFixedCell( Coord : TGridCoord ) : Boolean;
  private
    function GetDisplayText( ACol , ARow : Longint ) : string;
    procedure ReadVisibleColCount( Reader : TReader );
    procedure WriteVisibleColCount( Writer : TWriter );
  protected
    function SolveFormula( const Formula : string ) : string; virtual;
    procedure CreateColumns;
    procedure DefineProperties( Filer : TFiler ); override;
    procedure WMCommand( var Msg : TWMCommand ); message WM_COMMAND;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure RowMoved( FromIndex , ToIndex : Longint ); override;
    function CreateEditor : TInPlaceEdit; override;
    procedure SizeChanged(OldColCount, OldRowCount: Longint);override;
    procedure Loaded;override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure DoExit; override;
    procedure DoEnter; override;
    procedure DoEnterCell; virtual;
    function DoExitCell : Boolean; virtual;
    procedure DoEnterRow; virtual;
    function DoExitRow : Boolean; virtual;
  public
    procedure DrawCellImage( ACol , ARow , HeadingIndex : Longint;
      var ARect : TRect; DrawIt : Boolean; ACanvas : TCanvas );

{   Only needed for hint stuff
    procedure KeyDown( var Key: Word; Shift: TShiftState); override;
}
  public
    constructor Create( AOwner : TComponent ); override;
    destructor Destroy; override;
		procedure DeleteRow( ARow : Longint ); reintroduce;
    procedure InsertRow( const ARow : Longint );
    procedure SelectEntireRow( const ARow : Longint );
    procedure SelectEntireColumn( const ACol : Longint );
    procedure InvalidateRow( const ARow : Longint );
    procedure InvalidateColumn( const ACol : Longint );

    procedure SaveColumnWidthsToRegistry( const Key : string );
    procedure LoadColumnWidthsFromRegistry( const Key : string );
    function GridColumnForColumnObject( Column : ThgColumn ) : Longint;
    procedure ClearRange( TopLeft , BottomRight : TGridCoord );
    procedure Clear;
    procedure LoadFromStream( StartCol , StartRow : Longint; Stream : TStream );
    procedure LoadFromFile( StartCol , StartRow : Longint; const FileName : string );
    procedure SaveToStream( StartCol , StartRow : Longint; Stream : TStream );
    procedure SaveToFile( StartCol , StartRow : Longint; const FileName : string );
    procedure LoadFromDataSet( DataSet : TDataSet; LoadFieldNames : Boolean; StartCol , StartRow : Longint );
    procedure ClearHeadings;
  public
    property VisibleColumns[ Index : Integer ] : ThgColumn read GetVisibleColumn;
    property VisibleColumnCount : Integer read GetVisibleColumnCount;
    property ColumnByName[ Index : string ] : ThgColumn read GetColByName;
  published
    property Columns                  : ThgColumns read FColumns write FColumns;
    property Headings                 : ThgHeadings read FHeadings write FHeadings;
    property ColumnsRegistryKey       : string read FColumnsRegistryKey write FColumnsRegistryKey;
    property HyperOptions             : ThgOptions read FHyperOptions write SetOptions;
    property HyperHighlightColor      : TColor read FHighlight write SetHighlight default clHighlight;
    property HyperHighlightFontColor  : TColor read FHighlightFont write SetHighlightFont default clHighlightText;
    property HyperAdjustColWidth      : Boolean read FAdjustWidth write FAdjustWidth default False;
    property HyperAdjustRowHeight     : Boolean read FAdjustHeight write FAdjustHeight default False;
    property HyperColumnClick         : Boolean read FColumnClick write FColumnClick default True;
    property AutoAcceptSuggestion     : Boolean read FAutoAcceptSuggestion write FAutoAcceptSuggestion default hgDefaultAutoAcceptSuggestion;
    property Version : string read GetVersion write SetVersion stored False;
    property Author : string read GetAuthor write SetAuthor stored False;

  published
    // events
    property OnButtonClick          : ThgOnButtonClick read FOnButtonClick write FOnButtonClick;
    property OnConversionError      : ThgOnConversionError read FOnConversionError write FOnConversionError;
    property OnDisplayText          : ThgOnGetDisplayText read FOnGetDisplayText write FOnGetDisplayText;
    property OnChangeCellBorders    : ThgOnChangeCellBorders read FOnChangeCellBorders write FOnChangeCellBorders;
    property OnChangeCellAttributes : ThgOnChangeCellAttributes read FOnChangeCellAttributes write FOnChangeCellAttributes;
    property OnFixedCellClick       : ThgOnFixedCellClick read FonFixedCellClick write FOnFixedCellClick;
    property OnGetSuggestion        : ThgOnGetSuggestion read FOnGetSuggestion write FOnGetSuggestion;
    property OnGetReadOnly          : ThgOnGetReadOnly read FOnGetReadOnly write FOnGetReadOnly;
    property OnGetCellImage         : ThgOnGetCellImage read FOnGetCellImage write FOnGetCellImage;
    property OnExitCell             : ThgOnExitCell read FOnExitCell write FOnExitCell;
    property OnEnterCell            : ThgOnEnterCell read FOnEnterCell write FOnEnterCell;
    property OnComboSelection       : ThgOnComboSelection read FOnComboSelection write FOnComboSelection;
    property OnCellEdited           : ThgOnCellEdited read FOnCellEdited write FOnCellEdited;
    property OnEnterRow             : ThgOnEnterCell read FOnEnterRow write FOnEnterRow;
    property OnExitRow              : ThgOnExitCell read FOnExitRow write FOnExitRow;
  end;

  function HyperGridVersionString : string;

implementation

{$R HgRes.res}

uses Registry;

const
  hgTicksToHint         = 50;
  hgHintTickInterval    = 1;
  hgTicksToHintAfterkey = 150;

//------------------------------------------------------------------------------

type
  { System Locale information record }
  TSysLocale = packed record
    DefaultLCID: LCID;
    PriLangID: LANGID;
    SubLangID: LANGID;
    FarEast: Boolean;
  end;

  TMbcsByteType = (mbSingleByte, mbLeadByte, mbTrailByte);

var
  LeadBytes: set of Char = [];
  SysLocale: TSysLocale;

procedure InitSysLocale;
var
  DefaultLCID: LCID;
  DefaultLangID: LANGID;
  AnsiCPInfo: TCPInfo;
  I: Integer;
  J: Byte;
begin
  { Set default to English (US). }
  SysLocale.DefaultLCID := $0409;
  SysLocale.PriLangID := LANG_ENGLISH;
  SysLocale.SubLangID := SUBLANG_ENGLISH_US;
  SysLocale.FarEast := False;

  DefaultLCID := GetThreadLocale;
  if DefaultLCID <> 0 then SysLocale.DefaultLCID := DefaultLCID;

  DefaultLangID := Word(DefaultLCID);
  if DefaultLangID <> 0 then
  begin
    SysLocale.PriLangID := DefaultLangID and $3ff;
    SysLocale.SubLangID := DefaultLangID shr 10;
  end;

  SysLocale.FarEast := GetSystemMetrics(SM_DBCSENABLED) <> 0;
  if not SysLocale.FarEast then Exit;

  GetCPInfo(CP_ACP, AnsiCPInfo);
  with AnsiCPInfo do
  begin
    I := 0;
    while (I < MAX_LEADBYTES) and ((LeadByte[I] or LeadByte[I+1]) <> 0) do
    begin
      for J := LeadByte[I] to LeadByte[I+1] do
        Include(LeadBytes, Char(J));
      Inc(I,2);
    end;
  end;
end;

function ByteTypeTest(P: PChar; Index: Integer): TMbcsByteType;
begin
  Result := mbSingleByte;
  if (Index = 0) then
  begin
    if P[Index] in LeadBytes then Result := mbLeadByte;
  end
  else
  begin
    if (P[Index-1] in LeadBytes) and (ByteTypeTest(P, Index-1) = mbLeadByte) then
      Result := mbTrailByte
    else if P[Index] in LeadBytes then
      Result := mbLeadByte;
  end;
end;
  
function StrByteType(Str: PChar; Index: Cardinal): TMbcsByteType;
begin
  Result := mbSingleByte;
  if SysLocale.FarEast then
    Result := ByteTypeTest(Str, Index);
end;

function AnsiStrScan(Str: PChar; Chr: Char): PChar;
begin
  Result := StrScan(Str, Chr);
  while Result <> nil do
  begin
    case StrByteType(Str, Integer(Result-Str)) of
      mbSingleByte: Exit;
      mbLeadByte: Inc(Result);
    end;
    Inc(Result);
    Result := StrScan(Result, Chr);
  end;
end;

function AnsiQuotedStr(const S: string; Quote: Char): string;
var
  P, Src, Dest: PChar;
  AddCount: Integer;
begin
  AddCount := 0;
  P := AnsiStrScan(PChar(S), Quote);
  while P <> nil do
  begin
    Inc(P);
    Inc(AddCount);
    P := AnsiStrScan(P, Quote);
  end;
  if AddCount = 0 then
  begin
    Result := Quote + S + Quote;
    Exit;
  end;
  SetLength(Result, Length(S) + AddCount + 2);
  Dest := Pointer(Result);
  Dest^ := Quote;
  Inc(Dest);
  Src := Pointer(S);
  P := AnsiStrScan(Src, Quote);
  repeat
    Inc(P);
    Move(Src^, Dest^, P - Src);
    Inc(Dest, P - Src);
    Dest^ := Quote;
    Inc(Dest);
    Src := P;
    P := AnsiStrScan(Src, Quote);
  until P = nil;
  P := StrEnd(Src);
  Move(Src^, Dest^, P - Src);
  Inc(Dest, P - Src);
  Dest^ := Quote;
end;

function AnsiExtractQuotedStr(var Src: PChar; Quote: Char): string;
var
  P, Dest: PChar;
  DropCount: Integer;
begin
  Result := '';
  if (Src = nil) or (Src^ <> Quote) then Exit;
  Inc(Src);
  DropCount := 1;
  P := Src;
  Src := AnsiStrScan(Src, Quote);
  while Src <> nil do   // count adjacent pairs of quote chars
  begin
    Inc(Src);
    if Src^ <> Quote then Break;
    Inc(Src);
    Inc(DropCount);
    Src := AnsiStrScan(Src, Quote);
  end;
  if Src = nil then Src := StrEnd(P);
  if ((Src - P) <= 1) then Exit;
  if DropCount = 1 then
    SetString(Result, P, Src - P - 1)
  else
  begin
    SetLength(Result, Src - P - DropCount);
    Dest := PChar(Result);
    Src := AnsiStrScan(P, Quote);
    while Src <> nil do
    begin
      Inc(Src);
      if Src^ <> Quote then Break;
      Move(P^, Dest^, Src - P);
      Inc(Dest, Src - P);
      Inc(Src);
      P := Src;
      Src := AnsiStrScan(Src, Quote);
    end;
    if Src = nil then Src := StrEnd(P);
    Move(P^, Dest^, Src - P - 1);
  end;
end;


function HyperGridVersionString : string;
begin
  Result := IntToStr( MajorVersion ) + '.' + IntToStr( MinorVersion );
end;

//------------------------------------------------------------------------------
//  Constructor

{
function blah( c : Tcomponent ) : string;
begin
  Result := '';
  if csAncestor in c.ComponentState then Result := Result   + 'csAncestor ';
  if csDesigning in c.ComponentState then Result := Result  + 'csDesigning ';
  if csDestroying in c.ComponentState then Result := Result + 'csDestroying ';
  if csFixups in c.ComponentState then Result := Result     + 'csFixups ';
  if csLoading in c.ComponentState then Result := Result    + 'csLoading ';
  if csReading in c.ComponentState then Result := Result    + 'csReading ';
  if csUpdating in c.ComponentState then Result := Result   + 'csUpdating ';
  if csWriting in c.ComponentState then Result := Result    + 'csWriting ';
end;
}

constructor THyperGrid.Create( AOwner : TComponent );
begin
  inherited Create( AOwner );
  FColumns := THgColumns.Create;
  FHeadings := ThgHeadings.Create( ThgHeading );
  FColumns.OnPropertyChange := OnColumnPropertyChange;
  FHighlight := clHighlight;
  FHighlightFont := clHighlightText;
  FAdjustWidth := False;
  FAdjustHeight := False;
  FColumnClick := True;
  FAutoAcceptSuggestion := hgDefaultAutoAcceptSuggestion;

  FInternalMove := False;
  DefaultDrawing := False;

  DefaultRowHeight := hgDefaultRowHeight;

  // If we are not being loaded from a DFM, we need to create
  // the initial ThgColumn objects

  if not ( csLoading in Owner.ComponentState ) then
    begin
      CreateColumns;
    end;

  FHyperOptions := [ hgoptDrawFocusRectangle , hgoptHighlightSelection ];

{
  FOrgCheckBoxBmp := TBitmap.Create;
  FOrgCheckBoxBmp.Handle := LoadBitmap( hInstance , 'ORG_CHECKBOX' );
}
  FHeadingBmp := TBitmap.Create;

  // create temp objects
  FTopBorder := ThgBorder.Create;
  FLeftBorder := ThgBorder.Create;
  FBottomBorder := ThgBorder.Create;
  FRightBorder := ThgBorder.Create;
  FFont := TFont.Create;

  FLastFocus.X := FixedCols;
  FLastFocus.Y := FixedRows;
end;


//------------------------------------------------------------------------------
//  Destructor

destructor THyperGrid.Destroy;
begin
  if not ( csDesigning in ComponentState ) then
    SaveColumnWidthsToRegistry( ColumnsregistryKey );
  FColumns.Free;
  FHeadings.Free;
 {
  FOrgCheckBoxBmp.Free;
 }
  FHeadingBmp.Free;

  FTopBorder.Free;
  FLeftBorder.Free;
  FBottomBorder.Free;
  FRightBorder.Free;
  FFont.Free;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure THyperGrid.Loaded;
begin
  inherited Loaded;
  SetColCount( VisibleColumnCount );
  if not ( csDesigning in ComponentState ) then
    LoadColumnWidthsFromRegistry( ColumnsRegistryKey );
end;

//------------------------------------------------------------------------------
//  The following kludge is for the ColWidths array
//  We save a fake property called AVisibleColumnCount which we retrieve
//  later so that TCustomGrid knows how many entries to retrieve for the
//  ColWidths array.
//  Example:
//    Let's say that our grid has only 4 visible columns.
//    When TCustomGrid is created, it is initialized as having 5 columns, the default
//    When the grid is read from the DFM, it expects to find 5 entries in
//    the ColWidths array, otherwise and exception is raised and you cannot load
//    the form. But since only four columns are visible, only 4 entries are in the
//    ColWidths array.
//    By adding this fake property, we set the column count before the ColWidths
//    array is read and, therefore, avoid the exception.
//
//  To accomplish this, we use the following three methods

procedure THyperGrid.ReadVisibleColCount( Reader : TReader );
begin
  SetColCount( Reader.ReadInteger );
end;

procedure THyperGrid.WriteVisibleColCount( Writer : TWriter );
begin
  Writer.WriteInteger( VisibleColumnCount );
end;

//  The call to the inherited procedure has to be placed last, so that we
//  ensure our property will be read first

procedure THyperGrid.DefineProperties( Filer : TFiler );
begin
  Filer.DefineProperty( 'AVisibleColumnCount' , ReadVisibleColCount , WriteVisibleColCount , True );
  inherited DefineProperties( Filer );
end;

//------------------------------------------------------------------------------
//  Creates InPlaceEditor as defined in HgEdit

function THyperGrid.CreateEditor : TInPlaceEdit;
begin
  Result := THgInPlaceEdit.Create( Self );
end;

//------------------------------------------------------------------------------
//  This method is called when the number of columns or rows changes

procedure THyperGrid.SizeChanged(OldColCount, OldRowCount: Longint);
var
  Index : Integer;
  ACol : Integer;
begin
  if RowCount <> OldRowCount then
    begin
      for ACol := 0 to Pred( Columns.Count ) do
        if not Columns[ ACol ].Visible then
          while Columns[ ACol ].Cols.Count < RowCount do
            Columns[ ACol ].Cols.Add( '' );
    end;

  // The FInternalMove flag is used by THyperGrid when it wants to
  // adjust the number of grid columns and NOT the number of
  // ThgColumn objects

  if not FInternalMove then
    begin
      if OldColCount < ColCount then
        for Index := OldColCount to Pred( ColCount ) do
          FColumns.Add
      else if OldColCount > ColCount then
        begin
          ACol := OldColCount - ColCount;
          Index := Pred( FColumns.Count );
          while ( ACol > 0 ) and ( Index >= 0 ) do
            begin
              if FColumns[ Index ].Visible then
                begin
                  FColumns[ Index ].Free;
                  Dec( ACol );
                end;
              Dec( Index );
            end;
        end;
    end;
end;

//------------------------------------------------------------------------------
//  This procedure is invoked by the constructor to create the column objects
//  initially

procedure THyperGrid.CreateColumns;
var
  Index : Integer;
begin
  for Index := 0 to Pred( ColCount ) do
    FColumns.Add;
end;

//------------------------------------------------------------------------------
//  Responds to wm_command message
//  Used to capture EN_Change messages from our InPlaceEdit and forward them
//  to it.
//  I suppose I could have used one of the component notifications, but this
//  already works, so I will not mess with it

procedure THyperGrid.WMCommand( var Msg : TWMCommand );
begin
  inherited;
  if ( Msg.NotifyCode = EN_CHANGE ) and ( Msg.ctl = InPlaceEditor.Handle ) then
    ThgInPlaceEdit( InPlaceEditor ).TextChange;
end;

//------------------------------------------------------------------------------
// Given a grid column number it returns the correpsonding ThgColumn object

function THyperGrid.GetVisibleColumn( Index : Integer ) : ThgColumn;
var
  ColIndex : Integer;
begin
  ColIndex := 0;
  while ( ColIndex <= Index ) and ( Index < FColumns.Count ) do
    begin
      if not FColumns[ ColIndex ].Visible then
        Inc( Index );
      Inc( ColIndex );
    end;

  if Index >= FColumns.Count then
    raise EhgColumnIndexOutOfRange.Create( 'THyperGrid: Column index out of range' )
  else
    Result := FColumns[ Index ];
end;

//------------------------------------------------------------------------------
//  This is an event handler attached to the Columns and Headings collections
//  It is necessary to know when a property of an object in the collection is
//  changed and the grid needs to be refreshed
//  In the case of the visible property, we need to do some special processing

procedure THyperGrid.OnColumnPropertyChange( Column : ThgHeading; Prop : ThgProperty );
begin
  case Prop of
    hgpropVisible :
      begin
        HideEditor;
        if ThgColumn( Column ).Visible then
          ShowColumn( ThgColumn( Column ) )
        else
          HideColumn( ThgColumn( Column ) );
        Invalidate;
      end;
    hgpropRefresh :
      Invalidate;
  end;
end;

//------------------------------------------------------------------------------
//  Called when the visible property of a column is changed to False

procedure THyperGrid.HideColumn( Column : ThgColumn );
var
  GridIndex : Integer;
  Index : Integer;
begin
  GridIndex := 0;
  for Index := 0 to Pred( FColumns.Count ) do
    begin
      if FColumns[ Index ].Visible then
        Inc( GridIndex );
      if Column = FColumns[ Index ] then
        break;
    end;
  Column.Cols.Assign( Cols[ GridIndex ] );
  Column.Width := ColWidths[ GridIndex ];

  FInternalMove := True;
  inherited DeleteColumn( GridIndex );
  FInternalMove := False;
end;

//------------------------------------------------------------------------------
// Called when the visible property of a column is changed to true

// TODO fix this method

procedure THyperGrid.ShowColumn( Column : ThgColumn );
var
  GridIndex : Integer;
  Index : Integer;
  LastColWidth : Integer;
begin
  LastColWidth := ColWidths[ Pred( ColCount ) ];

  SetColCount( ColCount + 1 );

  ColWidths[ Pred( Pred( ColCount ) ) ] := LastColWidth;
  GridIndex := 0;
  for Index := 0 to Pred( FColumns.Count ) do
    begin
      if FColumns[ Index ].Visible then
        Inc( GridIndex );
      if Column = FColumns[ Index ] then
        begin
          Dec( GridIndex );
          break;
        end;
    end;

  ColWidths[ Pred( ColCount ) ] := Column.Width;
  Cols[ Pred( ColCount ) ].Assign( Column.Cols );
  FInternalMove := True;
  inherited MoveColumn( Pred( ColCount ) , GridIndex );
  FInternalMove := False;

  Column.Cols.Clear;
end;

//------------------------------------------------------------------------------
//  Returns the number of Column objects that have the Visible property true

function THyperGrid.GetVisibleColumnCount : Integer;
var
  Index : Integer;
begin
  Result := 0;
  for Index := 0 to Pred( FColumns.Count ) do
    if FColumns[ Index ].Visible then
      Inc( Result );
end;

//------------------------------------------------------------------------------
//  Handles the wm_AdjustColumnWidth - a user message sent when the text in
//  a cell does not fit

procedure THyperGrid.hgwmHandleAdjustColumnWidth( var Msg : TMessage );
begin
  if not ( goColSizing in Options ) and ( not ( csDesigning in ComponentState ) ) then
    ColWidths[ Msg.wParam ] := Msg.lParam;
end;

//------------------------------------------------------------------------------
//  Handles the wm_AdjustRowHeight - a user message sent when the text in
//  a cell does not fit

procedure THyperGrid.hgwmHandleAdjustRowHeight( var Msg :TMessage );
begin
  if not ( goRowSizing in Options )  and ( not ( csDesigning in ComponentState ) ) then
    RowHeights[ Msg.wParam ] := Msg.lParam;
end;

//------------------------------------------------------------------------------
//  Property setters

procedure THyperGrid.SetHighlight( Value : TColor );
begin
  if FHighlight <> Value then
    begin
      FHighlight := Value;
      Invalidate;
    end;
end;

procedure THyperGrid.SetHighlightFont( Value : TColor );
begin
  if FHighlightFont <> Value then
    begin
      FHighlightFont := Value;
      Invalidate;
    end;
end;

procedure THyperGrid.SetOptions( Value : ThgOptions );
begin
  if Value <> FHyperOptions then
    begin
      FHyperOptions := Value;
      Invalidate;
    end;
end;

//------------------------------------------------------------------------------
//  Version and Author strings are actually supplied by their own property
//  editors

function THyperGrid.GetVersion : string;
begin
  Result := HyperGridVersionString;
end;

function THyperGrid.GetAuthor : string;
begin
  Result := 'Pablo Pissanetzky - pablo@neosoft.com';
end;

procedure THyperGrid.SetVersion( S : string ); begin end;

procedure THyperGrid.SetAuthor( S : string ); begin end;

//------------------------------------------------------------------------------
//  This method decides what a cell's attributes will be and fires the
//  OnChangeCellAttribute event to allow the user to modify them
//  It requires the col and row coordinates of the cell ,the Column object
//  ( or ThgHeading object ) and the AState parameters
//  This method is used by the InPlace edit to discover what font and colors
//  it has to use.
//  It is also used by the HyperGridToExcel method to discover each
//  cells's attributes

procedure THyperGrid.GetCellAttributes( ACol , ARow : Longint; Column : ThgHeading;
  AState : TGridDrawState; var CellState : ThgCellStates; var AColor : TColor;
  AFont : TFont; var DrawInfo : ThgDrawInfo; var OuterBevel , InnerBevel : TPanelBevel );
begin
  // prepare the cellstate
  CellState := [];

  if gdFocused in AState then
    Include( CellState , hgcsFocused );
  if gdFixed in AState then
    Include( CellState , hgcsFixed );
  if gdSelected in AState then
    Include( CellState , hgcsSelected );

  if not ( Column is THGColumn ) then
    Include( CellState , hgcsHeading );

  // Prepare the draw info structure for text drawing
  with DrawInfo do
    begin
      Canvas := Self.Canvas;
      HMargin := 2;
      VMargin := 2;
      VAlign := hgvaTop;
      HAlign := taLeftJustify;
      Text := Cells[ ACol , ARow ];
      Clip := hgclpClip;
      Col := ACol;
      Row := ARow;
      Grid := Self;
      State := AState;
    end;

  // If it is a fixed cell, then make the appropriate changes to the draw info
  if ( gdFixed in AState ) then
    begin
      with DrawInfo do
        begin
          if ( ARow = 0 ) and ( Length( Column.Caption ) > 0 ) then
            Text := Column.Caption;
          HAlign := Column.TitleHAlignment;
          VAlign := Column.TitleVAlignment;
          Clip := Column.TitleClipStyle;
        end;
      AColor := Column.TitleColor;
      if Column.TitleParentFont then
        AFont.Assign( Self.Font )
      else
        AFont.Assign( Column.TitleFont );
      OuterBevel := Column.TitleOuterBevel;
      InnerBevel := Column.TitleInnerBevel;
    end
  // non fixed cell, so the Column parameter must actually point to a ThgColumn
  else
    begin
      with DrawInfo , Column as ThgColumn do
        begin
          HAlign := ColumnHAlignment;
          VAlign := ColumnVAlignment;
          Clip := ColumnClipStyle;
          OuterBevel := ColumnOuterBevel;
          InnerBevel := ColumnInnerBevel;
          if ColumnParentFont then
            AFont.Assign( Self.Font )
          else
            AFont.Assign( ColumnFont );
          AColor := ColumnColor;
        end;
    end;

  // If it is selected / focused then make the appropriate color selections
  if ( ( ( gdFocused in AState ) and ( goDrawFocusSelected in Options ) ) or
    ( ( gdSelected in AState ) and not ( gdFocused in AState ) ) )
    and ( hgoptHighlightSelection in HyperOptions ) then
    begin
      AColor := FHighlight;
      AFont.Color := FHighlightFont;
    end;

  // Fire off event to let user change cell attributes
  if Assigned( FOnChangeCellAttributes ) then
    FOnChangeCellAttributes(Self , ACol , ARow , Column , CellState ,
      AColor , AFont , DrawInfo.HAlign , DrawInfo.VAlign , OuterBevel , InnerBevel );
end;

//------------------------------------------------------------------------------
//  Draws cells

procedure THyperGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
  Column      : ThgColumn;
  DrawInfo    : ThgDrawInfo;
  FullRect    : TRect;
  OriginalRect: TRect;
  FillColor   : TColor;
  CellState   : thgCellStates;
  InnerBevel  : TPanelBevel;
  OuterBevel  : TPanelBevel;
begin
  // Keep the rectangle passed to us
  OriginalRect := ARect;

  // Get the Column object belonging to this grid column
  Column := VisibleColumns[ ACol ];

  // If it is a fixed column and it is on the first row and has a heading,
  // then draw the heading. Also cut the rectangle vertically in half, since
  // the heading will use the top half.
  if ( gdFixed in AState ) and ( Arow = 0 ) and ( Column.HeadingIndex >=0 ) then
    begin
      DrawHeading( Acol , Arow , Column );
      Inc( ARect.Top , ( RowHeights[ ARow ] div 2 ) - 1 );
    end;

  // Make our decisions about all cell attributes
  GetCellAttributes( ACol , ARow , Column , AState , CellState , FillColor ,
    FFont , DrawInfo , OuterBevel , InnerBevel );

  // Assign the column's borders to the temp borders to give the user a
  // chance to change them for this individual cell
  FTopBorder.Assign( Column.TopBorder );
  FRightBorder.Assign( Column.RightBorder );
  FBottomBorder.Assign( Column.BottomBorder );
  FLeftBorder.Assign( Column.LeftBorder );

  // Fire the event
  if Assigned( FOnChangeCellBorders ) then
    begin
      FOnChangeCellBorders( Self , ACol , ARow , Column , CellState , FTopBorder , FRightBorder ,
        FBottomBorder , FLeftBorder );
    end;

  // Draw borders
  HgDrawBorders( Canvas , ARect , FTopBorder , FRightBorder , FBottomBorder , FLeftBorder );

  // This is the rectangle that will be used to draw the FocusRect
  FullRect := ARect;

  // Clear the rectangle
  Canvas.Brush.Color := FillColor;
  Canvas.FillRect( ARect );

  // If this cell is pushed in, adjust the bevels
  if ( FTrackHeading = -1 ) and ( FTracking ) and ( FDown ) and
    ( FTrackCol = ACol ) and ( FTrackRow = ARow ) then
    begin
      OuterBevel := bvLowered;
      InnerBevel := bvNone;
    end;

  DrawInfo.Rect := ARect;

  // Draw the bevels
  HgDrawBevel( Canvas , DrawInfo.Rect , OuterBevel , InnerBevel );

  // If this cell is pushed in, adjust the text
  if ( FTrackHeading = -1 ) and ( FTracking ) and ( FDown ) and
    ( FTrackCol = ACol ) and ( FTrackRow = ARow ) then
    begin
      Inc( DrawInfo.Rect.Left , hgPushInMargin );
      Inc( DrawInfo.Rect.Top , hgPushInMargin );
    end;

  DrawCellImage( ACol , ARow , -1 , DrawInfo.Rect , True , Canvas );

  // if it is not a fixed cell , then get the display text
  if not ( gdFixed in AState ) then
    DrawInfo.Text := GetDisplayText( ACol , ARow );

  // Put the temporary font into the canvas
  Canvas.Font := FFont;

  // Draw the text
  HgDrawText( DrawInfo );

  // if specified, draw the focus rectangle
  if ( gdFocused in AState ) and ( hgoptDrawFocusRectangle in HyperOptions ) then
    begin
      Canvas.Brush.Color := FillColor;
      Canvas.Brush.Style := bsSolid;
      Canvas.DrawFocusRect( FullRect );
    end;

  // Fire the user's OnDrawCell event
  if Assigned( OnDrawCell ) then
    OnDrawCell( Self , ACol , ARow , OriginalRect , AState );
end;

//------------------------------------------------------------------------------
//  This is called whenever the user moves a column

procedure THyperGrid.ColumnMoved(FromIndex, ToIndex: Longint);
begin
  if not FInternalMove then
    Columns.Move( VisibleColumns[ FromIndex ].Index , VisibleColumns[ ToIndex ].Index );
  inherited ColumnMoved( FromIndex , ToIndex );
end;

//------------------------------------------------------------------------------
//  Called whenever the user moves a row
//  If we have invisible columns, they maintain their own TStringLists
//  corresponding to their rows, so we must apply the row movement to their
//  lists.

procedure THyperGrid.RowMoved( FromIndex , ToIndex : Longint );
var
  Index : Integer;
begin
  inherited RowMoved( FromIndex , ToIndex );
  for Index := 0 to Pred( FColumns.Count ) do
    if not FColumns[ Index ].Visible then
      FColumns[ Index ].Cols.Move( FromIndex , ToIndex );
end;

//------------------------------------------------------------------------------
//  Returns the column by the given name
//  Raises and exception if such a column is not found

function THyperGrid.GetColByName( Value : string ) :ThgColumn;
var
  Index : Integer;
begin
  Result := nil;
  for Index := 0 to Pred( FColumns.Count ) do
    if CompareText( Value , FColumns[ Index ].Name ) = 0 then
      begin
        Result := FColumns[ Index ];
        Break;
      end;
  if Result = nil then
    raise EhgInvalidColumnName.Create( 'Invalid column name "' + Value + '"' );
end;

//------------------------------------------------------------------------------
//  Public row deletion method
//  Raises an exception if the row is fixed or beyond the last

procedure THyperGrid.DeleteRow( ARow : Longint );
var
  Index : Integer;
begin
  if ( ARow < FixedRows ) or ( ARow >= RowCount ) then
    raise EhgRowIndexOutOfRange.Create( 'Cannot delete row ' + IntToStr( ARow ) );
  HideEditor;
  inherited DeleteRow( ARow );
  try
    for Index := 0 to Pred( FColumns.Count ) do
      if not FColumns[ Index ].Visible then
        FColumns[ Index ].Cols.Delete( Pred( FColumns[ Index ].Cols.Count ) );
  except
  end;
end;

//------------------------------------------------------------------------------
//  Public row insertion method
//  Raises an exception if an attempt is made to insert a row between fixed rows
//  or beyond the last

//  TODO: Change this method to add a blank row and then move that row to its
//  insertion point. It makes row insertion a heck of a lot faster

procedure THyperGrid.InsertRow( const ARow : Longint );
var
  Index : Integer;
begin
  if ( ARow < FixedRows ) or ( ARow >= RowCount ) then
    raise EhgRowIndexOutOfRange.Create( 'Cannot insert row ' + IntToStr( ARow ) );
  HideEditor;
  RowCount := RowCount + 1;
  for Index := Pred( RowCount ) downto ARow + 1 do
    begin
      Rows[ Index ].Assign( Rows[ Index - 1 ] );
      RowHeights[ Index ] := RowHeights[ Index - 1 ];
    end;
  try
    for Index := 0 to Pred( FColumns.Count ) do
      if not FColumns[ Index ].Visible then
        FColumns[ Index ].Cols.Insert( ARow , '' );
  except
  end;
  Rows[ ARow ].Clear;
  RowHeights[ ARow ] := DefaultRowHeight;
end;

//------------------------------------------------------------------------------
//  This procedure is called by DrawCell to draw multi column headings

//  QUESTION : Right now, the heading caption is centered over all of its
//  constituent columns, so when some of them are not visible ( because they
//  are scrolled ) it can get cut off.
//  Maybe it should be centered over all VISIBLE constituent columns!! hmmmm...

procedure THyperGrid.DrawHeading( ACol , ARow : Longint; Column : ThgColumn );
var
  Heading     : ThgHeading;
  StartCol    : Longint;
  EndCol      : Longint;
  StartRect   : TRect;
  DrawInfo    : ThgDrawInfo;
  Index       : Integer;
  W           : Integer;
  H           : Integer;
  Offset      : Integer;
  CR          : TRect;
  GridLine    : Integer;
  BRect       : TRect;
  CellState   : ThgCellStates;
  FillColor   : TColor;
  OuterBevel  : TPanelBevel;
  InnerBevel  : TPanelBevel;
begin
  Heading := Headings[ Column.HeadingIndex ];

  // If goFixedVertLine is turned on, we need to take into account the GridLineWidth
  if ( goFixedVertLine in Options ) or ( goVertLine in Options ) then
    GridLine := GridLineWidth
  else
    GridLine := 0;

  // Find out the first column before this one that has the same heading index
  // Find out the last column after this one that has the same heading index
  StartCol := ACol;
  while( StartCol >= 0 ) and ( VisibleColumns[ StartCol ].HeadingIndex = Column.HeadingIndex ) do
    Dec( StartCol );
  EndCol := ACol;
  while( EndCol < ColCount ) and ( VisibleColumns[ EndCol ].HeadingIndex = Column.HeadingIndex ) do
    Inc( EndCol );

  Inc( StartCol );
  Dec( EndCol );

  // CR is the rectangle of this cell in grid coordinates
  CR := CellRect( ACol , ARow );
  W := 0;

  // Determine how wide the heading will be, by adding up the widths
  // of all the columns that are sharing it
  // Offset is the distance from the first heading of this column
  // Cannot use CellRects because other columns may not be visible ( scrolled )
  // and cellrect returns zero rectangles for invisible cells
  Offset := 0;
  for Index := StartCol to EndCol do
    begin
      if Index = ACol then
        Offset := W;
      Inc( W , ColWidths[ Index ] );
    end;

  // Adjust for grid line widths
  Inc( W , GridLine * ( EndCol - StartCol ) + 1);
  Inc( Offset , GridLine * ( ACol - StartCol ) );

  // H is the height of the fixed cell rectangle, divided in two to
  // accomodate the heading as well as the title
  H := RowHeights[ ARow ] div 2;

  // Make our decisions about all cell attributes
  GetCellAttributes( ACol , ARow , Heading , [ gdFixed ] , CellState , FillColor ,
    FFont , DrawInfo , OuterBevel , InnerBevel );

  // Prepare off-screen bitmap
    with FHeadingBmp do
    begin
      Width := W;
      Height := H;
      Canvas.Brush := Self.Canvas.Brush;
      Canvas.Font := FFont;
      Canvas.Pen := Self.Canvas.Pen;
      Canvas.Brush.Color := FillColor;
      Canvas.Brush.Style := bsSolid;
    end;

  // Prepare the draw info structure for text drawing
  with DrawInfo do
    begin
      Canvas := FHeadingBmp.Canvas;
      SetRect( Rect , 0 , 0 , FHeadingBmp.Width - 1  , FHeadingBmp.Height - 1 );
      Text := Heading.Caption;
    end;

  // Clear the off-screen bitmap
  FHeadingBmp.Canvas.FillRect( DrawInfo.Rect );

  // Draw the bottom line
  if ( goFixedHorzLine in Options ) then
    begin
      // Temporary rectangle used for drawing borders
      BRect := DrawInfo.Rect;

      FBottomBorder.Style := hgbrdSolid;
      FBottomBorder.Width := GridLineWidth;
      FBottomBorder.Color := clBlack;
      Dec( DrawInfo.Rect.Bottom , hgDrawBorder( FHeadingBmp.Canvas , Point( BRect.Right - 1, BRect.Bottom - 1 ) ,
        Point( BRect.Left - 1 , BRect.Bottom - 1 ) , FBottomBorder , hgbdBottom ) );
    end;

  // Assign the column's borders to the temp borders to give the user a
  // chance to change them for this individual cell
  FTopBorder.Assign( Heading.TopBorder );
  FRightBorder.Assign( Heading.RightBorder );
  FBottomBorder.Assign( Heading.BottomBorder );
  FLeftBorder.Assign( Heading.LeftBorder );


  // Fire the event
  if Assigned( FOnChangeCellBorders ) then
    FOnChangeCellBorders( Self , -1 , -1 , Heading , [ hgcsHeading ] , FTopBorder , FRightBorder ,
      FBottomBorder , FLeftBorder );

  // Draw borders
  HgDrawBorders( FHeadingBmp.Canvas , DrawInfo.Rect , FTopBorder , FRightBorder ,
    FBottomBorder , FLeftBorder );

  // If this heading is pushed-in then adjust bevels
  if ( FTrackHeading = Heading.Index ) and ( FTracking ) and ( FDown ) and
    ( FTrackCol in [ StartCol..EndCol ] ) then
    begin
      OuterBevel := bvLowered;
      InnerBevel := bvNone;
    end;

  // Draw bevels
  HgDrawBevel( FHeadingBmp.Canvas , DrawInfo.Rect , OuterBevel , InnerBevel );

  // if this heading is pushed-in, adjust text
  if ( FTrackHeading = Heading.Index ) and ( FTracking ) and ( FDown ) and
    ( FTrackCol in [ StartCol..EndCol ] ) then
    begin
      Inc( DrawInfo.Rect.Left , hgPushInMargin );
      Inc( DrawInfo.Rect.Top , hgPushInMargin );
    end;

  DrawCellImage( ACol , ARow , Heading.Index , DrawInfo.Rect , True , FHeadingBmp.Canvas );

  // Draw the text
  HgDrawText( DrawInfo );

  // Start rect is the rectangle we will copy from the off screen bitmap
  StartRect := Rect( Offset , 0 , Offset + RectWidth( CR ) - 1 , H - 1 );

  // If this is at least the second sub column for the heading and it is not
  // the first visible column, decrease the left side of both rectangles
  // to overlap and remove the grid line
  if ( ACol > StartCol ) and ( ACol > LeftCol ) then
    begin
      Dec( StartRect.Left , GridLine );
      Dec( CR.Left , GridLine );
    end;

  // If this is not the last sub-column for the heading and is not the last
  // visible, then increase the right side of both rectangles to overlap
  // and remove the grid line
  if ( ACol < EndCol ) and ( ACol < ( LeftCol + VisibleColCount ) ) and ( ACol < ColCount ) then
    begin
      Inc( StartRect.Right , GridLine );
      Inc( Cr.Right , GridLine );
    end;

  // Adjust the destination bitmap's height
  CR.Bottom := CR.Top + H - 1;

  // Copy the bitmap to the screen
  Canvas.CopyMode := cmSrcCopy;
  Canvas.CopyRect( CR , FHeadingBmp.Canvas , StartRect );
end;

//------------------------------------------------------------------------------
//  This procedure retrieves the text that will be displayed
//  It is used for format conversions
//  It fires the user OnGetDisplayText event
//  It also fires the OnConversionError event if a cell's text
//  raises an EConvertError during conversion ( either in this method or in
//  the user's handler for OnGetDisplayText )

function THyperGrid.GetDisplayText( ACol , ARow : Longint ) : string;
var
  Column      : ThgColumn;
  FloatValue  : Extended;
  DateTime    : TDateTime;
  Format      : string;
  Index       : Integer;
  Convert     : Boolean;
begin
  Result := SolveFormula( Cells[ ACol , ARow ] );
  Column := VisibleColumns[ ACol ];
  Convert := True;

  try
    if Assigned( FOnGetDisplayText ) then
      FOnGetDisplayText( Self , ACol , ARow , Column , Result , Convert );

    if Length( Result ) = 0 then
      Exit;

    if Convert then
      begin

        case Column.FormatType of

          hgfmtNumeric :
            begin
              FloatValue := StrToFloat( Result );

              Format := '"' + Column.Prefix + '"';
              Format := Format + '#';
              if Column.ThousandsSeparator then
                Format := Format + ',';
              Format := Format + '##0';
              if Column.Decimals > 0 then
                begin
                  Format := Format + '.';
                  for Index := 1 to Column.Decimals do
                    Format := Format + '0';
                end;
              if Column.NegativeParenthesis then
                Format := Format + ';(' + Format + ')';
              Result := FormatFloat( Format , FloatValue );
            end;

          hgfmtScientific :
            begin
              FloatValue := StrToFloat( Result );

              Format := '0';
              if Column.Decimals > 0 then
                begin
                  Format := Format + '.';
                  for Index := 1 to Column.Decimals do
                    Format := Format + '0';
                end;
              Format := Format + 'E+00';
              Result := FormatFloat( Format , FloatValue );
            end;

          hgfmtDateTime :
            begin
              if ( Column.DateFormat >= 0 ) and ( Column.TimeFormat >= 0 ) then
                begin
                  DateTime := StrToDateTime( Result );
                  Format := hgDateFormats[ hgDateOrder , Column.DateFormat ] +
                    ' ' + hgTimeFormats[ Column.TimeFormat ];
                end
              else if Column.DateFormat >= 0 then
                begin
                  DateTime := StrToDate( Result );
                  Format := hgDateFormats[ hgDateOrder , Column.DateFormat ];
                end
              else if Column.TimeFormat >= 0 then
                begin
                  DateTime := StrToTime( Result );
                  Format := hgTimeFormats[ Column.TimeFormat ];
                end
              else
                Exit;
              Result := FormatDateTime( Format , DateTime );
            end;
        end;
    end;
  except
    on EConvertError do
      if Assigned( FOnConversionError ) then
        FOnConversionError( Self , ACol , ARow , Column , Result );
  end;
end;

//------------------------------------------------------------------------------
//  The following methods are used to achieve the pushing-in of fixed cells

//  This method determines whether the mouse coordinates passed are actually
//  on the heading portion of a fixed cell. If so, the heading index is returned
//  otherwise it returns a - 1

function THyperGrid.MouseOnHeading( X , Y : Integer ) : Integer;
var
  Coord : TGridCoord;
  ARect : TRect;
begin
  Result := -1;
  Coord := HgMouseCoord( X , Y );
  if ( Coord.Y <> 0 ) or not IsFixedCell( Coord ) then
    Exit;

  ARect := CellRect( Coord.X , Coord.Y );
  try
    if VisibleColumns[ Coord.X ].HeadingIndex >= 0 then
      begin
        ARect.Bottom := ARect.Top + ( RowHeights[ Coord.Y ] div 2 ) - 2 ;
        if ptInRect( ARect , Point( X , Y ) ) then
          Result := VisibleColumns[ Coord.X ].HeadingIndex;
      end;
  except
    on EhgColumnIndexOutOfRange do
  end;
end;

procedure THyperGrid.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Coord : TGridCoord;
  R : TRect;
  XMargin , YMargin : Integer;
begin
  if FColumnClick then
    begin
      Coord := HgMouseCoord( X , Y );
      R := CellRect( Coord.X , Coord.Y );
      if ( Button = mbLeft ) then
        begin
// New for version 1.5      
          XMargin := 0;
          YMargin := 0;
          if IsFixedCell( Coord ) then
            begin
              if ( Coord.X >= FixedCols ) then
                begin
                  if goColMoving in Options then
                    YMargin := 4;
                  if goColSizing in Options then
                    XMargin := 4;
                end
              else if ( Coord.Y >= FixedRows ) then
                begin
                  if goRowMoving in Options then
                    XMargin := 4;
                  if goRowSizing in Options then
                    YMargin := 4;
                end;
            end;
          InflateRect( R , - XMargin , - YMargin );
//          InflateRect( R , -( GridLIneWidth + 4 ) , -( GridLineWidth + 6 ) );

        end;
      if IsFixedCell( Coord ) and PtInRect( R , Point( X , Y ) ) then
        begin
          FTracking := True;
          FTrackCol := Coord.X;
          FTrackRow := Coord.Y;
          FTrackHeading := MouseOnHeading( X , Y );
          FButtonDown := Button;
          MouseCapture := True;
          TrackButton( X , Y );
        end
      else
        inherited MouseDown( Button , Shift , X , Y );
    end
  else
    inherited MouseDown( Button , Shift , X , Y );
end;

procedure THyperGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ExecuteInherited : Boolean;
  Coord : TGridCoord;
begin
  ExecuteInherited := True;
  if FColumnClick and FTracking then
    begin
      Coord := HgMouseCoord( X , Y );
      if ( FInsideOriginal ) and ( Button = FButtonDown ) then
        begin
          ExecuteInherited := False;
          if Assigned( FOnFixedCellClick ) then
            FOnFixedCellClick( Self , Coord.X , Coord.Y , FTrackHeading , Button , Shift , X , Y );
        end;
      FTracking := False;
      TrackButton( -1 , -1 );
      FDown := False;
      MouseCapture := False;
    end;
  if ExecuteInherited then
    inherited MouseUp( Button , Shift , X , Y );
end;

//------------------------------------------------------------------------------
//  This method basically redraws all cells that belong to a heading at FTrackCol.
//  Very sloppy, because it invalidates all the rectangles of the subcolumns
//  of the heading.... which in turn serves to redraw the entire heading.

procedure THyperGrid.RefreshTrackingHeading;
var
  StartCol  : Longint;
  EndCol    : Longint;
  R         : TRect;
  SR , ER   : TRect;
begin
  // Find out the first column before this one that has the same heading index
  // Find out the last column after this one that has the same heading index
  StartCol := FTrackCol;
  while( StartCol >= 0 ) and ( VisibleColumns[ StartCol ].HeadingIndex = FTrackHeading )
    and ( ( StartCol >= LeftCol ) or ( StartCol <= FixedCols ) ) do
    Dec( StartCol );
  EndCol := FTrackCol;
  while( EndCol < ColCount ) and ( VisibleColumns[ EndCol ].HeadingIndex = FTrackHeading )
    and ( EndCol <= ( LeftCol + VisibleColCount ) ) do
    Inc( EndCol );
  Inc( StartCol );
  Dec( EndCol );

  SR := CellRect( StartCol , FTrackRow );
  ER := CellRect( EndCol , FTrackRow );
  SetRect( R , Sr.Left , SR.Top , ER.Right ,
    SR.Top + ( RowHeights[ FTrackRow ] div 2 ) - 2 );

  InvalidateRect( Handle , @R , False );
end;

//  Used to determine if the mouse is still inside the rectangle that was
//  originally clicked

procedure THyperGrid.TrackButton( X , Y : Integer );
var
  Coord : TGridCoord;
  OldFDown : Boolean;
  R : TRect;
begin
  Coord := HgMouseCoord( X , Y );
  OldFDown := FDown;
  FDown := ( ( FTrackHeading = -1) and ( Coord.X = FTrackCol ) and ( Coord.Y = FTrackRow )
    and  ( MouseOnHeading( X , Y ) = -1 ) )
    or ( ( FTrackHeading > -1 ) and ( MouseOnHeading( X , Y ) = FTrackHeading ) );
  FInsideOriginal := FDown;
  FDown := FDown and ( FButtonDown = mbLeft );
  if FDown <> OldFDown then
    begin
      R := CellRect( FTrackCol , FTrackRow );
      if FTrackHeading = -1 then
        InvalidateRect( Handle , @R , False )
      else
        RefreshTrackingHeading;
    end;
end;

procedure THyperGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
//  HintMouseMove( X , Y );
  if FTracking and FColumnClick then
    TrackButton( X , Y );
  inherited MouseMove( Shift , X , Y );
end;

//------------------------------------------------------------------------------
//  This is used by internal changes to column count

procedure THyperGrid.SetColCount( const C : Longint );
begin
  FInternalMove := True;
  ColCount := C;
  FInternalMove := False;
end;

//------------------------------------------------------------------------------
// Selects the row specified in ARow

procedure THyperGrid.SelectEntireRow( const ARow : Longint );
var
  Rect : TGridRect;
begin
  if goEditing in Options then
    Exit;
  Rect.Left := FixedCols;
  Rect.Top := ARow;
  Rect.Right := Pred( ColCount );
  Rect.Bottom := ARow;
  Selection := Rect;
end;

//------------------------------------------------------------------------------
// Selects the column specified in ACol

procedure THyperGrid.SelectEntireColumn( const ACol : Longint );
var
  Rect : TGridRect;
begin
  if goEditing in Options then
    Exit;
  Rect.Left := ACol;
  Rect.Top := FixedRows;
  Rect.Right := ACol;
  Rect.Bottom := Pred( RowCount );
  Selection := Rect;
end;

//------------------------------------------------------------------------------
// Invalidates the specified row so that it will be repainted

procedure THyperGrid.InvalidateRow( const ARow : Longint );
var
  R : TRect;
begin
  R := BoxRect( 0 , ARow , Pred( ColCount ) , ARow );
  InvalidateRect( Handle , @R , False );
end;

//------------------------------------------------------------------------------
// Invalidates the given column

procedure THyperGrid.InvalidateColumn( const ACol : Longint );
var
  R : TRect;
begin
  R := BoxRect( ACol , 0 , ACol , Pred( RowCount ) );
  InvalidateRect( Handle , @R , False );
end;

//------------------------------------------------------------------------------

procedure THyperGrid.DrawCellImage( ACol , ARow , HeadingIndex : Longint;
  var ARect : TRect; DrawIt : Boolean; ACanvas : TCanvas );
var
  PictureOrImageList : TObject;
  ImageIndex : Integer;
  HAlign : TAlignment;
  VAlign : ThgVAlignment;
  Margin : Integer;
  Position : ThgImagePosition;
  Pic     : TPicture;
  ImgList : TImageList;

  ImageWidth , ImageHeight : Integer;
  DRect  : TRect;
begin
  if Assigned( FOnGetCellImage ) then
    begin
      // Initialize variables that will be used to call user event
      PictureOrImageList := nil;
      ImageIndex := -1;
      Position := hgipLeft;
      HAlign := taCenter;
      VAlign := hgvaCenter;
      Margin := 2;

      // Initialize temporaries to get rid of compiler warnings
      Pic := nil;
      ImgList := nil;

      // Call user event
      FOnGetCellImage( Self , ACol , ARow , HeadingIndex , PictureOrImageList ,
        ImageIndex , Position , HAlign , VAlign , Margin );

      // Make sure the pointer returned is not nil and is of the right type
      // If so, get image width and height
      if PictureOrImageList = nil then
        Exit
      else if PictureOrImageList is TPicture then
        begin
          Pic := PictureOrImageList as TPicture;
          ImageWidth := Pic.Width;
          ImageHeight := Pic.Height;
        end
      else if PictureOrImageList is TImageList then
        begin
          ImgList := PictureOrImageList as TImageList;
          ImageWidth := ImgList.Width;
          ImageHeight := ImgList.Height
        end
      else
        Exit;

      // Save rectangle
      DRect := ARect;

      // Modify rectangle passed in to make room for image
      // And modify DRect to draw the image
      case Position of
        hgipLeft:
          begin
            Inc( ARect.Left , ( Margin * 2 ) + ImageWidth );
            DRect.Right := Pred( ARect.Left );
          end;
        hgipRight:
          begin
            Dec( ARect.Right , ( Margin * 2 ) + ImageWidth );
            DRect.Left := Succ( Arect.Right );
          end;
        hgipTop:
          begin
            Inc( ARect.Top , ( Margin * 2 ) + ImageHeight );
            DRect.Bottom := Pred( ARect.Top );
          end;
        hgipBottom:
          begin
            Dec( ARect.Bottom , ( Margin * 2 ) + ImageHeight );
            DRect.Top := Succ( ARect.Bottom );
          end;
      end;

      // If we do not have to actually draw the image, exit
      if not DrawIt then
        Exit;

      // If the image will be at the top or bottom, we use the HAlign,
      // Otherwise, we use the VAlign
      if Position in [ hgipTop , hgipBottom ] then
        begin
          Inc( DRect.Top , Margin );
          case HAlign of
            taLeftJustify   : Inc( DRect.Left , Margin );
            taRightJustify  : DRect.Left := DRect.Right - ImageWidth - Margin;
            taCenter        : Inc( DRect.Left , ( RectWidth( DRect ) - ImageWidth ) div 2 );
          end;
        end
      else
        begin
          Inc( DRect.Left , Margin );
          case VAlign of
            hgvaTop         : Inc( DRect.Top , Margin );
            hgvaCenter      : Inc( DRect.Top , ( RectHeight( DRect ) - ImageHeight ) div 2 );
            hgvaBottom      : DRect.Top := DRect.Bottom - ImageHeight - Margin;
          end;
        end;

      // Now, let's draw the image
      if PictureOrImageList is TPicture then
        ACanvas.Draw( DRect.Left , DRect.Top , Pic.Graphic )
      else
        ImgList.Draw( ACanvas , DRect.Left , DRect.Top , ImageIndex );
    end;
end;


//------------------------------------------------------------------------------
// Version 1.3

function THyperGrid.GridColumnForColumnObject( Column : ThgColumn ) : Longint;
var
  Index : Longint;
begin
  if ( Column = nil ) or ( not Column.Visible ) then
    begin
      Result := -1;
      Exit;
    end;

  Result := 0;
  for Index := 0 to Pred( Columns.Count ) do
    begin
      if Columns[ Index ].Visible then
        Inc( Result );
      if Column = Columns[ Index ] then
        begin
          Dec( Result );
          break;
        end;
    end;
  if Result >= ColCount then
    Result := -1;
end;

//------------------------------------------------------------------------------
// Version 1.3

procedure THyperGrid.SaveColumnWidthsToRegistry( const Key : string );
var
  Reg : TRegistry;
  Index : Longint;
begin
  if Length( Trim( Key ) ) > 0 then
    begin
      Reg := TRegistry.Create;
      try
        if Reg.OpenKey( Key , True ) then
          for Index := 0 to Pred( ColCount ) do
            try
              Reg.WriteInteger( VisibleColumns[ Index ].Name , ColWidths[ index ] );
            except
            end;
      finally
        Reg.Free;
      end;
    end;
end;

//------------------------------------------------------------------------------
// Version 1.3

procedure THyperGrid.LoadColumnWidthsFromRegistry( const Key : string );
var
  Reg : TRegistry;
  Index : Longint;
  ColumnNames : TStringList;
  Column : ThgColumn;
  Value : Integer;
  ColIndex : Integer;
begin
  if Length( Trim( Key ) ) > 0 then
    begin
      Reg := TRegistry.Create;
      try
        if Reg.OpenKey( Key , False ) then
          begin
            ColumnNames := TStringList.Create;
            try
              Reg.GetValueNames( ColumnNames );
              for Index := 0 to Pred( ColumnNames.Count ) do
                begin
                  try
                    Column := ColumnByName[ ColumnNames[ Index ] ];
                    Value := Reg.ReadInteger( ColumnNames[ Index ] );
                    ColIndex := GridColumnForColumnObject( Column );
                    if ColIndex > -1 then
                      ColWidths[ ColIndex ] := Value;
                  except
                  end;
                end;
            finally
              ColumnNames.Free;
            end;
          end;
      finally
        Reg.Free;
      end;
    end;
end;

//------------------------------------------------------------------------------
// Version 1.3

procedure THyperGrid.DoEnterCell;
begin
  if Assigned( FOnEnterCell ) then
    FOnEnterCell( Self , FLastFocus.X , FLastFocus.Y );

  if not HintFollowsMouse then
    HintCoord := FLastFocus;
end;

//------------------------------------------------------------------------------
// Version 1.3

function THyperGrid.DoExitCell : Boolean;
begin
  Result := True;
  if ( InPlaceEditor <> nil ) and ( FAutoAcceptSuggestion ) then
    ThgInPlaceEdit( InPlaceEditor ).AcceptSuggestion;
  if Assigned( FOnExitCell ) then
    FOnExitCell( Self , FLastFocus.X , FLastFocus.Y , Result );
  if not HintFollowsMouse then
    ShowTheHint( False );
end;

//------------------------------------------------------------------------------
// Version 1.3

function THyperGrid.SelectCell(ACol, ARow: Longint): Boolean;
var
  NewRow : Boolean;
begin
  Result := inherited SelectCell( ACol , ARow );
  if Result then
    if ( ACol <> FLastFocus.X ) or ( ARow <> FLastFocus.Y ) then
      begin
        Result := DoExitCell;

        NewRow := ARow <> FLastFocus.Y;
        if ( NewRow ) then
          Result := DoExitRow;

        if Result then
          begin
            FLastFocus.X := ACol;
            FLastFocus.Y := ARow;
            if ( NewRow ) then
              DoEnterRow;
            DoEnterCell;
          end;
      end;
end;

//------------------------------------------------------------------------------
// Version 1.3

procedure THyperGrid.DoExit;
begin
  DoExitCell;
  DoExitRow;
  inherited;
end;

//------------------------------------------------------------------------------
// Version 1.3

procedure THyperGrid.DoEnter;
begin
  inherited;
  FLastFocus.X := Col;
  FLastFocus.Y := Row;
  DoEnterRow;
  DoEnterCell;
end;

//------------------------------------------------------------------------------
// Version 1.3

procedure THyperGrid.ClearRange( TopLeft , BottomRight : TGridCoord );
var
  ACol , ARow : Integer;
begin
  HideEditor;
  for ACol := TopLeft.X to BottomRight.X do
    for ARow := TopLeft.Y to BottomRight.Y do
      Cells[ ACol , ARow ] := '';
{
  R := BoxRect( TopLeft.X , TopLeft.Y , BottomRight.X , BottomRight.Y );
  InvalidateRect( Handle , @R , False );
}
end;

//------------------------------------------------------------------------------
// Version 1.3

procedure THyperGrid.Clear;
var
  TopLeft , BottomRight : TGridCoord;
  C : Integer;
begin
  TopLeft.X := FixedCols;
  TopLeft.Y := FixedRows;
  BottomRight.X := Pred( ColCount );
  BottomRight.Y := Pred( RowCount );
  ClearRange( TopLeft , BottomRight );
  for C := 0 to Pred( Columns.Count ) do
    Columns[ C ].Cols.Clear;
end;

//------------------------------------------------------------------------------
// Version 1.5

procedure THyperGrid.DoComboSelection( ACol , ARow : Longint );
begin
  if Assigned( FOnComboSelection ) then
    FOnComboSelection( Self , ACol , ARow );
end;

function THyperGrid.IsFixedCell( Coord : TGridCoord ) : Boolean;
begin
  Result := ( ( Coord.X >= 0 ) and ( Coord.X < FixedCols ) ) or ( ( Coord.Y >= 0 ) and ( Coord.Y < FixedRows ) );
end;

//------------------------------------------------------------------------------
// Version 1.60

procedure THyperGrid.LoadFromStream( StartCol , StartRow : Longint; Stream : TStream );

  procedure LoadLine( const Line : string; ToRow : Longint );
  var
    P , P1  : PChar;
    S       : string;
    SCol    : Longint;
  begin
    SCol := StartCol;
    P := PChar(Line);
    while P^ in [#1..' '] do P := CharNext(P);
    while P^ <> #0 do
      begin
        if P^ = '"' then
          S := AnsiExtractQuotedStr(P, '"')
        else
          begin
            P1 := P;
            while (P^ >= ' ') and (P^ <> ',') do P := CharNext(P);
            SetString(S, P1, P - P1);
            S := Trim( S );
          end;
        while ( ToRow >= RowCount ) do RowCount := RowCount + 1;
        while ( SCol >= Columns.Count ) do ColCount := ColCount + 1;

        if Columns[ SCol ].Visible then
          Cells[ GridColumnForColumnObject( Columns[ SCol ] ) , ToRow ] := S
        else
          Columns[ SCol ].Cols[ ToRow ] := s;
        Inc( SCol );

        while P^ in [#1..' '] do P := CharNext(P);
        if P^ = ',' then
          repeat
            P := CharNext(P);
          until not (P^ in [#1..' ']);
      end;
  end;

var
  Lines : TStringList;
  I     : Longint;
begin
  Lines := TStringList.Create;
  try
    Lines.LoadFromStream( Stream );
    for I := 0 to Pred( Lines.Count ) do
      LoadLine( Lines[ I ] , StartRow + I );
  finally
    Lines.Free;
  end;
end;

procedure THyperGrid.SaveToStream( StartCol , StartRow : Longint; Stream : TStream );
var
  Lines : TStringList;
  SCol , SRow : Longint;
  Line , S : string;
begin
  Lines := TStringList.Create;
  try
    for SRow := StartRow to Pred( RowCount ) do
      begin
        Line := '';
        for SCol := StartCol to Pred( Columns.Count ) do
          begin
            if not Columns[ SCol ].Visible then
              S := Columns[ SCol ].Cols[ SRow ]
            else
              S := Cells[ GridColumnForColumnObject( Columns[ SCol ] ) , SRow ];
            if Length( Line ) > 0 then
              Line := Line + ',';
            Line := Line + AnsiQuotedStr( S , '"' );
          end;
        Lines.Add( Line );
      end;
      Lines.SaveToStream( Stream );
  finally
    Lines.Free;
  end;
end;

procedure THyperGrid.LoadFromFile( StartCol , StartRow : Longint; const FileName : string );
var
  Stream : TFileStream;
begin
  Stream := TFileStream.Create( FileName , fmOpenRead );
  try
    LoadFromStream( StartCol , StartRow , Stream );
  finally
    Stream.Free;
  end;
end;

procedure THyperGrid.SaveToFile( StartCol , StartRow : Longint; const FileName : string );
var
  Stream : TFileStream;
begin
  Stream := TFileStream.Create( FileName , fmCreate );
  try
    SaveToStream( StartCol , StartRow , Stream );
  finally
    Stream.Free;
  end;
end;

function THyperGrid.SolveFormula( const Formula : string ) : string;
begin
  Result := Formula;
end;

procedure THyperGrid.DoCellEdited( ACol , ARow : Longint );
begin
  if Assigned( FOnCellEdited ) then
    FOnCellEdited( Self , ACol , ARow );
end;

procedure THyperGrid.LoadFromDataSet( DataSet : TDataSet; LoadFieldNames : Boolean; StartCol , StartRow : Longint );
var
  I , GridCol , ARow : Integer;
begin
  if not DataSet.Active then
    DataSet.Active := True;
  if Columns.Count < ( DataSet.FieldCount + StartCol - 1  ) then
    ColCount := ColCount + ( DataSet.FieldCount + StartCol ) - ColCount;
  ARow := StartRow;
  if LoadFieldNames then
    begin
      if ARow >= RowCount then
        RowCount := RowCount + 1;
      for I := 0 to Pred( DataSet.FieldCount ) do
        begin
          GridCol := GridColumnForColumnObject( Columns[ I + StartCol ] );
          if GridCol = -1 then
            Columns[ I + StartCol ].Rows[ ARow ] := DataSet.FieldDefs[ I ].Name
          else
            begin
              Cells[ GridCol , ARow ] := DataSet.FieldDefs[ I ].Name;
            end;
        end;
      Inc( ARow );
    end;

  while not DataSet.EOF do
    begin
      if ARow >= RowCount then
        RowCount := RowCount + 1;
      for I := 0 to Pred( DataSet.FieldCount ) do
        begin
          GridCol := GridColumnForColumnObject( Columns[ I + StartCol ] );
          if GridCol = -1 then
            Columns[ I + StartCol ].Rows[ ARow ] := DataSet.Fields[ I ].AsString
          else
            begin
              Cells[ GridCol , ARow ] := DataSet.Fields[ I ].AsString;
            end;
        end;
      DataSet.Next;
      Inc( ARow );
    end;
end;

procedure THyperGrid.DoEnterRow;
begin
  if Assigned( FOnEnterRow ) then
    FOnEnterRow( Self , FLastFocus.X , FLastFocus.Y );
  if not HintFollowsMouse then
    HintCoord := FLastFocus;
end;

function THyperGrid.DoExitRow : Boolean;
begin
  Result := True;
  if ( InPlaceEditor <> nil ) and ( FAutoAcceptSuggestion ) then
    ThgInPlaceEdit( InPlaceEditor ).AcceptSuggestion;
  if Assigned( FOnExitRow ) then
    FOnExitRow( Self , FLastFocus.X , FLastFocus.Y , Result );
  if not HintFollowsMouse then
    ShowTheHint( False );
end;

procedure THyperGrid.ClearHeadings;
var
  I : Integer;
begin
  for I := 0 to Pred( Columns.Count ) do
    Columns[ I ].HeadingIndex := -1;
  Headings.Clear;
end;

initialization
  InitSysLocale;

end.

