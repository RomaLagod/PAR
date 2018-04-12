{ $Header: /Delphi/Components/THyperGrid/Hgcolumn.pas 9     1/13/97 9:27a Ppissan $ }
unit HgColumn;

interface

uses Classes , HgGlobal , Graphics , ExtCtrls;

type

  //----------------------------------------------------------------------------
  // Forward reference

	ThgColumns = class;
  ThgColumn  = class;
	ThgHeading = class;

	//----------------------------------------------------------------------------

  ThgProperty =( hgpropVisible , hgpropRefresh );
  ThgOnPropertyChange = procedure( Column : ThgHeading; Prop : ThgProperty ) of object;

  //----------------------------------------------------------------------------

  ThgHeading = class( TCollectionItem )
  private
    FCaption          : string;
		FName             : string;
		procedure SetName( Value : string );
  private
    // Title
    FTVAlignment      : ThgVAlignment;
		FTHAlignment      : TAlignment;
    FTColor           : TColor;
    FTFont            : TFont;
		FTParentFont      : Boolean;
		FTClip            : ThgClipStyle;
		FTInnerBevel      : TPanelBevel;
		FTOuterBevel      : TPanelBevel;
		function ShouldStoreTitleFont : Boolean;
	protected
		procedure FontChanged( Sender : TObject ); virtual;
	private
		// Borders
		FTopBorder        : ThgBorder;
		FBotBorder        : ThgBorder;
		FLeftBorder       : ThgBorder;
		FRightBorder      : ThgBorder;
		function ShouldStoreTopBorder : Boolean;
		function ShouldStoreBottomBorder : Boolean;
		function ShouldStoreLeftBorder : Boolean;
		function ShoudlStoreRightBorder : Boolean;
	private
		procedure SetCaption( Value : string );
		procedure SetTitleHAlignment( Value : TAlignment );
		procedure SetTitleVAlignment( Value : ThgVAlignment );
		procedure SetTitleColor( Value : TColor );
		procedure SetTitleFont( Value : TFont );
		procedure SetTitleParentFont( Value : Boolean );
		procedure SetTitleClipStyle( Value : ThgClipStyle );
		procedure SetTitleInnerBevel( Value : TPanelBevel );
		procedure SetTitleOuterBevel( Value : TPanelBevel );
		procedure SetTopBorder( Value : ThgBorder );
		procedure SetBottomBorder( Value : ThgBorder );
    procedure SetLeftBorder( Value : ThgBorder );
    procedure SetRightBorder( Value : ThgBorder );
  protected
    procedure DoRefreshEvent;
  public
    procedure Assign( Source : TPersistent ); override;
    constructor Create( ACollection : TCollection ); override;
    destructor Destroy; override;
  published
    property Caption            : string read FCaption write SetCaption;
    property Name               : string read FName write SetName;
    // Title
    property TitleHAlignment    : TAlignment read FTHAlignment write SetTitleHAlignment default hgDefaultTitleHAlignment;
		property TitleVAlignment    : ThgVAlignment read FTVAlignment write SetTitleVAlignment default hgDefaultTitleVAlignment;
    property TitleColor         : TColor read FTColor write SetTitleColor default hgDefaultTitleColor;
    property TitleFont          : TFont read FTFont write SetTitleFont stored ShouldStoreTitleFont;
    property TitleParentFont    : Boolean read FTParentFont write SetTitleParentFont default True;
		property TitleClipStyle     : ThgClipStyle read FTClip write SetTitleClipStyle default hgDefaultTitleClipStyle;
		property TitleInnerBevel    : TPanelBevel read FTInnerBevel write SetTitleInnerBevel default hgDefaultTitleInnerBevel;
    property TitleOuterBevel    : TPanelBevel read FTOuterBevel write SetTitleOuterBevel default hgDefaultTitleOuterBevel;
    // Borders
		property TopBorder          : ThgBorder read FTopBorder write SetTopBorder stored ShouldStoreTopBorder;
    property BottomBorder       : ThgBorder read FBotBorder write SetBottomBorder stored ShouldStoreBottomBorder;
    property LeftBorder         : ThgBorder read FLeftBorder write SetLeftBorder stored ShouldStoreLeftBorder;
    property RightBorder        : ThgBorder read FRightBorder write SetRightBorder stored ShoudlStoreRightBorder;
	end;

  //----------------------------------------------------------------------------
  // ThgColumn

	ThgColumn = class( ThgHeading )
  private
    // General
    FWidth            : integer;
    FVisible          : Boolean;
    FCols             : TStrings;
    FReadOnly         : Boolean;
    FMaxTextLength    : Integer;
    procedure SetVisible( const NewValue : Boolean );
    procedure SetCols( Source : TStrings );
  private
    // Columns
    FCVAlignment      : ThgVAlignment;
    FCHAlignment      : TAlignment;
		FCColor           : TColor;
		FCFont            : TFont;
    FCParentFont      : Boolean;
    FCClip            : ThgClipStyle;
    FCInnerBevel      : TPanelBevel;
    FCOuterBevel      : TPanelBevel;
    function ShouldStoreColumnFont : Boolean;
	protected
		procedure FontChanged( Sender : TObject ); override;
	private
		// Control stuff
		FControlType      : ThgControlTypes;
	private
		// start Tsoyran Check box stuff
		FCheckStyle			: ThgBooleanType;
		FStrAsTrue			: String;
		FStrAsFalse			: String;
		function ShouldStoreCheckStuff : Boolean;

		// end Tsoyran
	private
		// Combo box control stuff
		FItems          : TStrings;
		FAutoSuggest    : Boolean;
		FComboMaxWidth  : Boolean;
		FDropDownCount  : Integer;
		FDropDownList   : Boolean;
		function ShouldStoreComboItems : Boolean;
		procedure SetItems( Source : TStrings );
	private
		// Button stuff
		FButtonStyle      : ThgButtonStyle;
		FButtonPicture    : TPicture;
		FDrawButtonFace   : Boolean;
		FButtonVAlignment : ThgVAlignment;
		function ShouldStoreButtonStuff : Boolean;
		function ShouldStoreButtonPicture : Boolean;
	private
		// Heading
		FHeadingIndex   : Integer;
	private
		// Formatting options
		FFormatType     : ThgFormatType;
		FDecimals       : Integer;
		FPrefix         : string;
		FThousands      : Boolean;
		FParenNegative  : Boolean;
		FDateFormat     : Integer;
		FTimeFormat     : Integer;
		// start Tsoyran
		FFormatText			: ThgFormatTextType;
		procedure	SetFormatText(value : ThgFormatTextType);
		// end Tsoyran
		function ShouldStoreFormatting : Boolean;
		function ShouldStoreDateFormatting : Boolean;
		procedure SetFormatType( Value : ThgFormatType );
		procedure SetDecimals( Value : Integer );
		procedure SetPrefix( Value : string );
		procedure SetThousands( Value : Boolean );
		procedure SetParenNegative( Value : Boolean );
		procedure SetDateFormat( Value : Integer );
		procedure SetTimeFormat( Value : Integer );
	private
		procedure SetControlType( Value : ThgControlTypes );
		procedure SetReadOnly( Value : Boolean );
		procedure SetMaxTextLength( Value : Integer );
		procedure SetColumnHAlignment( Value : TAlignment );
		procedure SetColumnVAlignment( Value : ThgVAlignment );
		procedure SetColumnColor( Value : TColor );
		procedure SetColumnFont( Value : TFont );
		procedure SetColumnParentFont( Value : Boolean );
		procedure SetColumnClipStyle( Value : ThgClipStyle );
		procedure SetColumnInnerBevel( Value : TPanelBevel );
		procedure SetColumnOuterBevel( Value : TPanelBevel );
		procedure SetComboMaxWidth( Value : Boolean );

// Start Tsoyran
		procedure SetStringAsYes( Value : String );
		procedure SetStringAsNo( Value : String );
// End Tsoyran

		procedure SetDropDownCount( Value : Integer );
		procedure SetButtonStyle( Value : ThgButtonStyle );
		procedure SetButtonPicture( Value : TPicture );
		procedure SetDrawButtonface( Value : Boolean );
		procedure SetButtonVAlignment( Value : ThgVAlignment );
		procedure SetHeadingIndex( Value : Integer );
	public
		procedure Assign( Source : TPersistent ); override;
		constructor Create( ACollection : TCollection ); override;
		destructor Destroy; override;
	public
		// Run time only properties
		property Width  : Integer read FWidth write FWidth;
		property Cols   : TStrings read FCols write SetCols;
		property Rows   : TSTrings read FCols write SetCols;
	published
		// General

//  BC++Builder does not like the constant empty set
//    property ControlType        : ThgControlTypes read FControlType write SetControlType default hgDefaultControlType;

    property ControlType        : ThgControlTypes read FControlType write SetControlType default [];
    property Visible            : Boolean read FVisible write SetVisible default hgDefaultVisible;
		property ReadOnly           : Boolean read FReadOnly write SetReadOnly default hgDefaultReadOnly;
		property MaxTextLength      : Integer read FMaxTextLength write SetMaxTextLength default hgDefaultMaxTextLength;
		// Column
		property ColumnHAlignment   : TAlignment read FCHAlignment write SetColumnHAlignment default hgDefaultColumnHAlignment;
		property ColumnVAlignment   : ThgVAlignment read FCVAlignment write SetColumnVAlignment default hgDefaultColumnVAlignment;
		property ColumnColor        : TColor read FCColor write SetColumnColor default hgDefaultColumnColor;
		property ColumnFont         : TFont read FCFont write SetColumnFont stored ShouldStoreColumnFont;
		property ColumnParentFont   : Boolean read FCParentFont write SetColumnParentFont default True;
		property ColumnClipStyle    : ThgClipStyle read FCClip write SetColumnClipStyle default hgDefaultColumnClipStyle;
		property ColumnInnerBevel   : TPanelBevel read FCInnerBevel write SetColumnInnerBevel default hgDefaultColumnInnerBevel;
		property ColumnOuterBevel   : TPanelBevel read FCOuterBevel write SetColumnOuterBevel default hgDefaultColumnOuterBevel;

{start Tsoyran}
		// Check box stuff
		property BooleanStyle				: ThgBooleanType Read FCheckStyle Write FCheckStyle default hgDefaultCheckStyle;
		property StringAsTrue      	: string Read FStrAsTrue Write SetStringAsYes stored ShouldStoreCheckStuff;
		property StringAsFalse			: string Read FStrAsFalse  Write SetStringAsNo  stored ShouldStoreCheckStuff;
{end Tsoyran}

		// Combo box stuff
		property Items              : TStrings read FItems write SetItems stored ShouldStoreComboItems;
		property AutoSuggest        : Boolean read FAutoSuggest write FAutoSuggest stored ShouldStoreComboItems;
		property ComboMaxWidth      : Boolean read FComboMaxWidth write SetComboMaxWidth stored ShouldStoreComboItems;
		property DropDownCount      : Integer read FDropDownCount write SetDropDownCount stored ShouldStoreComboItems;
		property DropDownList       : Boolean read FDropDownList write FDropDownList stored ShouldStoreComboItems;
		// Button stuff
		property ButtonStyle        : ThgButtonStyle read FButtonStyle write SetButtonStyle stored ShouldStoreButtonStuff;
		property ButtonPicture      : TPicture read FButtonPicture write SetButtonPicture stored ShouldStoreButtonPicture;
		property DrawButtonface     : Boolean read FDrawButtonFace write SetDrawButtonFace stored ShouldStoreButtonPicture;
		property ButtonVAlignment   : ThgVAlignment read FButtonVAlignment write SetButtonVAlignment stored ShouldStoreButtonPicture;
		// Headings
		property HeadingIndex       : Integer read FHeadingIndex write SetHeadingIndex default hgDefaultHeadingIndex;
		// Formating
		property FormatType         : ThgFormatType read FFormatType write SetFormatType default hgDefaultFormatType;

{start Tsoyran}
		// Text format type
		property FormatText					: ThgFormatTextType  read FFormatText write SetFormatText default hgDefaultFormatText;
{end Tsoyran}
		property Decimals           : Integer read FDecimals write SetDecimals stored ShouldStoreFormatting;
		property Prefix             : string read FPrefix write SetPrefix stored ShouldStoreFormatting;
		property ThousandsSeparator : Boolean read FThousands write SetThousands stored ShouldStoreFormatting;
		property NegativeParenthesis: Boolean read FParenNegative write SetParenNegative stored ShouldStoreFormatting;
		property DateFormat         : Integer read FDateFormat write SetDateFormat stored ShouldStoreDateFormatting;
		property TimeFormat         : Integer read FTimeFormat write SetTimeFormat stored ShouldStoreDateFormatting;
	end;

	//----------------------------------------------------------------------------

  ThgHeadings = class( TCollection )
  private
    FOnColumnsAssigned : TNotifyEvent;
		FOnPropertyChange : ThgOnPropertyChange;
		function GetColumn( Index : Integer ) : ThgHeading;
    procedure SetColumn( Index : Integer; Value : ThgHeading );
  public
    constructor Create( ItemClass : TCollectionItemClass );
    function Add : ThgHeading;
		procedure Assign( Source : TPersistent ); override;
    function ColumnNameExists( const S : string ) : boolean;
    function NextColumnName : string;
		property OnPropertyChange : ThgOnPropertyChange
			read FOnPropertyChange write FOnPropertyChange;
    property OnColumnsAssigned : TNotifyEvent read FOnColumnsAssigned write FOnColumnsAssigned;
		procedure Move( Source , Dest : Longint );
  public
    property Items[ Index : Integer ] : ThgHeading
      read GetColumn write SetColumn; default;
  end;

  //----------------------------------------------------------------------------
	// ThgColumns

  ThgColumns = class( ThgHeadings )
	private
    function GetColumn( Index : Integer ) : ThgColumn;
    procedure SetColumn( Index : Integer; Value : ThgColumn );
  public
    procedure Assign( Source : TPersistent ); override;
		constructor Create;
		destructor Destroy; override;
    function Add : ThgColumn;
  public
		property Items[ Index : Integer ] : ThgColumn
      read GetColumn write SetColumn; default;
	end;

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------
//  ThgHeading

constructor ThgHeading.Create( ACollection : TCollection );
begin
  inherited Create( ACollection );
  FCaption := '';
  FTHAlignment := hgDefaultTitleHAlignment;
  FTVAlignment := hgDefaultTitleVAlignment;
	FTColor := hgDefaultTitleColor;
	FTFont := TFont.Create;
  FTFont.OnChange := FontChanged;
  FTParentFont := True;
  
  FTClip := hgDefaultTitleClipStyle;
	FTInnerBevel := hgDefaultTitleInnerBevel;
  FTOuterBevel := hgDefaultTitleOuterBevel;

	FTopBorder := ThgBorder.Create;
  FBotBorder := ThgBorder.Create;
	FLeftBorder := ThgBorder.Create;
  FRightBorder := ThgBorder.Create;
end;

destructor ThgHeading.Destroy;
begin
	FTFont.Free;
  FTopBorder.Free;
  FBotBorder.Free;
  FLeftBorder.Free;
  FRightBorder.Free;
  inherited Destroy;
end;

procedure ThgHeading.Assign( Source : TPersistent );
begin
	if Source is ThgHeading then
    with Source as ThgHeading do
      begin
        Self.FCaption := FCaption;
        Self.FName := FName;
        Self.FTHAlignment := FTHAlignment;
				Self.FTVAlignment := FTVAlignment;
        Self.FTColor := FTColor;
        Self.FTFont.Assign( FTFont );
        Self.FTClip := FTClip;
        Self.FTInnerBevel := FTInnerBevel;
				Self.FTOuterBevel := FTOuterBevel;

				Self.FTopBorder.Assign( FTopBorder );
				Self.FBotBorder.Assign( FBotBorder );
				Self.FLeftBorder.Assign( FLeftBorder );
        Self.FRightBorder.Assign( FRightBorder );
			end
  else
    inherited Assign( Source );
end;

function ThgHeading.ShouldStoreTitleFont : Boolean;
begin
  Result := not FTParentFont;
end;

function ThgHeading.ShouldStoreTopBorder : Boolean;
begin
  Result := TopBorder.Style <> hgbrdNone;
end;

function ThgHeading.ShouldStoreBottomBorder : Boolean;
begin
  Result := BottomBorder.Style <> hgbrdNone;
end;

function ThgHeading.ShouldStoreLeftBorder : Boolean;
begin
  Result := LeftBorder.Style <> hgbrdNone;
end;

function ThgHeading.ShoudlStoreRightBorder : Boolean;
begin
	Result := RightBorder.Style <> hgbrdNone;
end;

procedure ThgHeading.SetName( Value : string );
begin
  if Value = FName then
    Exit;
{
  if ThgHeadings( Collection ).ColumnNameExists( Value ) then
    raise EhgColumnNameExists.Create( 'A column named "' + Value + '" already exists' );
}
  FName := Value;
end;

procedure ThgHeading.DoRefreshEvent;
begin
	if Collection <> nil then
    if Assigned( ThgHeadings( Collection ).FonPropertyChange ) then
      ThgHeadings( Collection ).FonPropertyChange( Self , hgpropRefresh );
end;

procedure ThgHeading.SetCaption( Value : string );
begin
  if FCaption = Value then Exit;
	FCaption := Value;
	DoRefreshEvent;
end;

procedure ThgHeading.SetTitleParentFont( Value : Boolean );
begin
  if Value = FTParentFont then Exit;
	FTParentFont := Value;
  DoRefreshEvent;
end;

procedure ThgHeading.SetTitleHAlignment( Value : TAlignment );
begin
	if FTHAlignment = Value then Exit;
  FTHAlignment := Value;
  DoRefreshEvent;
end;

procedure ThgHeading.SetTitleVAlignment( Value : ThgVAlignment );
begin
  if FTVAlignment = Value then Exit;
  FTVAlignment := Value;
  DoRefreshEvent;
end;

procedure ThgHeading.SetTitleColor( Value : TColor );
begin
	if FTColor = Value then Exit;
	FTColor := Value;
  DoRefreshEvent;
end;

procedure ThgHeading.SetTitleFont( Value : TFont );
begin
  FTFont.Assign( Value );
  DoRefreshEvent;
end;

procedure ThgHeading.SetTitleClipStyle( Value : ThgClipStyle );
begin
	if FTClip = Value then Exit;
  FTClip := Value;
	DoRefreshEvent;
end;

procedure ThgHeading.SetTitleInnerBevel( Value : TPanelBevel );
begin
  if FTInnerBevel = Value then Exit;
  FTInnerBevel := Value;
  DoRefreshEvent;
end;

procedure ThgHeading.SetTitleOuterBevel( Value : TPanelBevel );
begin
	if FTOuterBevel = Value then Exit;
	FTOuterBevel := Value;
  DoRefreshEvent;
end;

procedure ThgHeading.SetTopBorder( Value : ThgBorder );
begin
  FTopBorder.Assign( Value );
  DoRefreshEvent;
end;

procedure ThgHeading.SetBottomBorder( Value : ThgBorder );
begin
	FBotBorder.Assign( Value );
  DoRefreshEvent;
end;

procedure ThgHeading.SetLeftBorder( Value : ThgBorder );
begin
	FLeftBorder.Assign( Value );
  DoRefreshEvent;
end;

procedure ThgHeading.SetRightBorder( Value : ThgBorder );
begin
  FRightBorder.Assign( Value );
  DoRefreshEvent;
end;

procedure ThgHeading.FontChanged( Sender : TObject );
begin
  if ( Sender is TFont ) and ( TFont( Sender ) = FTFont ) then
    FTParentFont := False;  
end;


//------------------------------------------------------------------------------
//  ThgColumn

constructor ThgColumn.Create( ACollection : TCollection );
begin
  inherited Create( ACollection );
  FWidth := hgDefaultColumnWidth;

  FCHAlignment := hgDefaultColumnHAlignment;
  FCVAlignment := hgDefaultColumnVAlignment;
	FCColor := hgDefaultColumnColor;

  FCFont := TFont.Create;
  FCFont.OnChange := FontChanged;
	FCParentFont := True;

  FCClip := hgDefaultColumnClipStyle;
  FCInnerBevel := hgDefaultColumnInnerBevel;
	FCOuterBevel := hgDefaultColumnOuterBevel;

// Borland C++ Builder does not like the const definition
// of an empty set.
//  FControlType := hgDefaultControlType;
  FControlType := [];

  FVisible := hgDefaultVisible;
  FItems := TStringList.Create;
  FCols := TStringList.Create;
  FReadOnly := hgDefaultReadOnly;
  FMaxTextLength := hgDefaultMaxTextLength;
  FAutoSuggest := hgDefaultAutoSuggest;
	FComboMaxWidth := hgDefaultComboMaxWidth;
  FDropDownCount := hgDefaultDropDownCount;
	FDropDownList := False;

	FHeadingIndex := hgDefaultHeadingIndex;

	FButtonStyle := hgDefaultButtonStyle;
	FButtonPicture := TPicture.Create;
	FDrawButtonFace := hgDefaultDrawButtonFace;
	FButtonVAlignment := hgDefaultButtonVAlignment;

	// start Tsoyran
	FCheckStyle 		:= hgDefaultCheckStyle;
	FStrAsTrue			:= hgDefaultYesString;
	FStrAsFalse 		:= hgDefaultNoString;
	FFormatText			:= hgDefaultFormatText;
	// end Tsoyran

	FFormatType 		:= hgDefaultFormatType;
	FDecimals 			:= hgDefaultDecimals;
	FPrefix 				:= hgDefaultPrefix;
	FThousands 			:= hgDefaultUseThousands;
	FParenNegative 	:= hgDefaultNegativeParenthesis;

	FDateFormat := hgDefaultDateFormatIndex;
	FTimeFormat := hgDefaultTimeFormatIndex;
end;

destructor ThgColumn.Destroy;
begin
  FItems.Free;
  FCols.Free;
  FCFont.Free;
  FButtonPicture.Free;
  inherited Destroy;
end;

procedure ThgColumn.Assign( Source : TPersistent );
begin
	if Source is ThgColumn then
		with Source as ThgColumn do
      begin
        inherited Assign( Source );
				Self.FWidth := FWidth;
				Self.FCHAlignment := FCHAlignment;
        Self.FCVAlignment := FCVAlignment;
        Self.FCColor := FCColor;
				Self.FCFont.Assign( FCFont );
        Self.FCClip := FCClip;
        Self.FCInnerBevel := FCInnerBevel;
        Self.FCOuterBevel := FCOuterBevel;

        Self.FControlType := FControlType;
        Self.FItems.Assign( FItems );
				Self.FVisible := FVisible;
        Self.FCols.Assign( FCols );
        Self.FReadOnly := FReadOnly;
        Self.FMaxTextLength := FMaxTextLength;
        Self.FAutoSuggest := FAutoSuggest;
        Self.FComboMaxWidth := FComboMaxWidth;
				Self.FDropDownCount := FDropDownCount;
				Self.FDropDownList := FDropDownList;

        Self.FHeadingIndex := FHeadingIndex;

				Self.FButtonStyle := FButtonStyle;
				Self.FButtonPicture.Assign( FButtonPicture );
				Self.FDrawButtonFace := FDrawButtonFace;
				Self.FButtonVAlignment := FButtonVAlignment;

// start tsoyran
				Self.FCheckStyle 	:= FCheckStyle;
				Self.FStrAsTrue		:= FStrAsTrue;
				Self.FStrAsFalse 	:= FStrAsFalse;
				Self.FFormatText	:= FFormatText;
// end tsoyran

				Self.FFormatType 		:= FFormatType;
				Self.FDecimals 			:= FDecimals;
				Self.FPrefix 				:= FPrefix;
				Self.FThousands 		:= FThousands;
				Self.FParenNegative := FParenNegative;
				Self.FDateFormat 		:= FDateFormat;
				Self.FTimeFormat 		:= FTimeFormat;
			end
	else
		inherited Assign( Source );
end;

procedure ThgColumn.FontChanged( Sender : TObject );
begin
  inherited FontChanged( Sender );
  if ( Sender is TFont ) and ( TFont( Sender ) = FCFont ) then
    FCParentFont := False;
end;


function ThgColumn.ShouldStoreComboItems : Boolean;
begin
	Result := hgctlCombobox in FControlType;
end;

procedure ThgColumn.SetVisible( const NewValue : Boolean );
begin
  if NewValue <> FVisible then
    begin
      FVisible := NewValue;
      if Assigned( ThgColumns( Collection ).FOnPropertyChange ) then
        ThgColumns( Collection ).FOnPropertyChange( Self , hgpropVisible );
    end;
end;

procedure ThgColumn.SetColumnParentFont( Value : Boolean );
begin
  if Value = FCParentFont then Exit;
  FCParentFont := Value;
	DoRefreshEvent;
end;

function ThgColumn.ShouldStoreButtonStuff : Boolean;
begin
  Result := hgctlButton in FControlType;
end;

function ThgColumn.ShouldStoreButtonPicture : Boolean;
begin
	Result := ShouldStoreButtonStuff and( FButtonStyle = hgbstCustom );
end;

function ThgColumn.ShouldStoreColumnFont : Boolean;
begin
  Result := not FCParentFont;
end;

procedure ThgColumn.SetItems( Source : TStrings );
begin
  FItems.Assign( Source );
end;

procedure ThgColumn.SetCols( Source : TStrings );
begin
  FCols.Assign( Source );
end;

procedure ThgColumn.SetControlType( Value : ThgControlTypes );
begin
  if FControlType = Value then Exit;
	FControlType := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetReadOnly( Value : Boolean );
begin
	if FReadOnly = Value then Exit;
  FReadOnly := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetMaxTextLength( Value : Integer );
begin
  if FMaxTextLength = Value then Exit;
  FMaxTextLength := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetColumnHAlignment( Value : TAlignment );
begin
  if FCHAlignment = Value then Exit;
  FCHAlignment := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetColumnVAlignment( Value : ThgVAlignment );
begin
  if FCVAlignment = Value then Exit;
	FCVAlignment := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetColumnColor( Value : TColor );
begin
  if FCColor = Value then Exit;
  FCColor := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetColumnFont( Value : TFont );
begin
  FCFont.Assign( Value );
  DoRefreshEvent;
end;

procedure ThgColumn.SetColumnClipStyle( Value : ThgClipStyle );
begin
	if FCClip = Value then Exit;
  FCClip := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetColumnInnerBevel( Value : TPanelBevel );
begin
	if FCInnerBevel = Value then Exit;
	FCInnerBevel := Value;
	DoRefreshEvent;
end;

procedure ThgColumn.SetColumnOuterBevel( Value : TPanelBevel );
begin
	if FCOuterBevel = Value then Exit;
	FCOuterBevel := Value;
	DoRefreshEvent;
end;
// start tsoyran
procedure ThgColumn.SetStringAsYes( Value : String );
begin
	if FStrAsTrue = Value then Exit;
	FStrAsTrue := Value;
	DoRefreshEvent;
end;

procedure ThgColumn.SetStringAsNo( Value : String );
begin
	if FStrAsFalse = Value then Exit;
	FStrAsFalse := Value;
	DoRefreshEvent;
end;

function ThgColumn.ShouldStoreCheckStuff : Boolean;
begin
	Result := FCheckStyle = hgcbtString;
end;
// end Tsoyran

procedure ThgColumn.SetComboMaxWidth( Value : Boolean );
begin
	if FComboMaxWidth = Value then Exit;
	FComboMaxWidth := Value;
	DoRefreshEvent;
end;

procedure ThgColumn.SetDropDownCount( Value : Integer );
begin
	if FDropDownCount = Value then Exit;
	FDropDownCount := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetButtonStyle( Value : ThgButtonStyle );
begin
  if FButtonStyle = Value then Exit;
	FButtonStyle := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetButtonPicture( Value : TPicture );
begin
	FButtonPicture.Assign( Value );
	DoRefreshEvent;
end;

procedure ThgColumn.SetDrawButtonface( Value : Boolean );
begin
  if FDrawButtonFace = Value then Exit;
	FDrawButtonFace := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetButtonVAlignment( Value : ThgVAlignment );
begin
  if FButtonVAlignment = Value then Exit;
  FButtonVAlignment := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetHeadingIndex( Value : Integer );
begin
	if FHeadingIndex = Value then Exit;
  FHeadingIndex := Value;
  DoRefreshEvent;
end;

function ThgColumn.ShouldStoreFormatting : Boolean;
begin
	Result := FFormatType <> hgfmtNone;
end;

procedure ThgColumn.SetFormatType( Value : ThgFormatType );
begin
	if Value = FFormatType then Exit;
	FFormatType := Value;
	DoRefreshEvent;
end;

procedure ThgColumn.SetDecimals( Value : Integer );
begin
	if Value = FDecimals then Exit;
  FDecimals := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetPrefix( Value : string );
begin
  if Value = FPrefix then Exit;
	FPrefix := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetThousands( Value : Boolean );
begin
  if Value = FThousands then Exit;
  FThousands := Value;
  DoRefreshEvent;
end;

procedure ThgColumn.SetParenNegative( Value : Boolean );
begin
  if Value = FParenNegative then Exit;
	FParenNegative := Value;
  DoRefreshEvent;
end;

function ThgColumn.ShouldStoreDateFormatting : Boolean;
begin
  Result := FFormatType = hgfmtDateTime;
end;

procedure ThgColumn.SetDateFormat( Value : Integer );
begin
	if Value = FDateFormat then Exit;
	FDateFormat := Value;
	DoRefreshEvent;
end;

procedure ThgColumn.SetTimeFormat( Value : Integer );
begin
	if Value = FTimeFormat then Exit;
	FTimeFormat := Value;
	DoRefreshEvent;
end;

//------------------------------------------------------------------------------
// tsoyran
procedure ThgColumn.SetFormatText(value: ThgFormatTextType);
begin
	if Value = FFormatText then Exit;
	FFormatText := Value;
	DoRefreshEvent;
end;
// end tsoyran

// ThgHeadings

constructor ThgHeadings.Create( ItemClass : TCollectionItemClass );
begin
  inherited Create( ItemClass );
end;

function ThgHeadings.Add : ThgHeading;
begin
  Result := inherited Add as ThgHeading;
  Result.FName := NextColumnName;
end;

function ThgHeadings.GetColumn( Index : Integer ) : ThgHeading;
begin
  Result := inherited Items[ Index ] as ThgHeading;
end;

procedure ThgHeadings.SetColumn( Index : Integer; Value : ThgHeading );
begin
  inherited Items[ Index ] := Value;
end;

procedure ThgHeadings.Assign( Source : TPersistent );
begin
  inherited Assign( Source );
  if Assigned( FOnColumnsAssigned ) then
    FOnColumnsAssigned( Self );
end;

function ThgHeadings.ColumnNameExists( const S : string ) : boolean;
var
  Index : integer;
begin
  Result := False;
  for Index := 0 to Pred( Count ) do
    if Items[ Index ].Name = S then
      begin
				Result := True;
        Exit;
      end;
end;

function ThgHeadings.NextColumnName : string;
var
  NextColumnNo : Integer;
begin
  NextColumnNo := 1;
  repeat
		Result := 'Column ' + IntToStr( NextColumnNo );
    Inc( NextColumnNo );
  until not ColumnNameExists( Result );
end;

procedure ThgHeadings.Move( Source , Dest : Longint );
begin
  inherited Items[ Source ].Index := Dest;
end;

//------------------------------------------------------------------------------
// ThgColumns

constructor ThgColumns.Create;
begin
	inherited Create( ThgColumn );
end;

destructor ThgColumns.Destroy;
begin
	inherited destroy;
end;

function ThgColumns.Add : ThgColumn;
begin
	Result := inherited Add as ThgColumn;
end;

function ThgColumns.GetColumn( Index : Integer ) : ThgColumn;
begin
  Result := inherited Items[ Index ] as ThgColumn;
end;

procedure ThgColumns.SetColumn( Index : Integer; Value : ThgColumn );
begin
	inherited Items[ Index ] := Value;
end;

procedure ThgColumns.Assign( Source : TPersistent );
begin
  inherited Assign( Source );
end;

end.







