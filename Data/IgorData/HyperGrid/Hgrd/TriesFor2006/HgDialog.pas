{ $Header: /Delphi/Components/THyperGrid/HgDialog.pas 8     1/13/97 9:27a Ppissan $}
unit HgDialog;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	HgProp, StdCtrls, Buttons, ExtCtrls , HgGrid, ComCtrls,
  HgColumn , HgGlobal, Mask, Grids, HgColors;


type

	TfrmhgColumnsEditor = class(TForm)
    Panel1: TPanel;
		Panel2: TPanel;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    btnNewColumn: TSpeedButton;
    btnApply: TBitBtn;
    Panel6: TPanel;
    PageControl: TPageControl;
    tbsGeneral: TTabSheet;
    Label1: TLabel;
    sbnHLeft: TSpeedButton;
    sbnHCenter: TSpeedButton;
    sbnHRight: TSpeedButton;
    sbnVTop: TSpeedButton;
    sbnVCenter: TSpeedButton;
    sbnVBottom: TSpeedButton;
    memCaption: TMemo;
		tbsControl: TTabSheet;
    sbnComboBox: TSpeedButton;
    sbnButton: TSpeedButton;
    pgcControlInfo: TPageControl;
    tbsButton: TTabSheet;
    tbsComboBox: TTabSheet;
    Label3: TLabel;
		memComboBoxItems: TMemo;
    Label4: TLabel;
    cbxVisible: TCheckBox;
    FontDialog: TFontDialog;
    sbnTitleColor: TSpeedButton;
    sbnTitleFont: TSpeedButton;
    sbnClip: TSpeedButton;
    sbnEllipsis: TSpeedButton;
    sbnWrap: TSpeedButton;
    sbnCHLeft: TSpeedButton;
    sbnCHCenter: TSpeedButton;
    sbnCHRight: TSpeedButton;
		sbnCVTop: TSpeedButton;
    sbnCVCenter: TSpeedButton;
    sbnCVBottom: TSpeedButton;
    Label5: TLabel;
    sbnCColor: TSpeedButton;
    sbnCFont: TSpeedButton;
    sbnCClip: TSpeedButton;
    sbnCEllipsis: TSpeedButton;
    sbnCWrap: TSpeedButton;
    sbnTInnerRaised: TSpeedButton;
    sbnTInnerLowered: TSpeedButton;
    sbnTOuterRaised: TSpeedButton;
    sbnTOuterLowered: TSpeedButton;
    sbnCInnerRaised: TSpeedButton;
    sbnCInnerLowered: TSpeedButton;
    sbnCOuterRaised: TSpeedButton;
    sbnCOuterLowered: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
		Label8: TLabel;
    Label9: TLabel;
		cbxAutoSuggest: TCheckBox;
    cbxComboMaxWidth: TCheckBox;
    Label11: TLabel;
    edtDropDownCount: TEdit;
    tbsBorders: TTabSheet;
    cmbTopBorder: TComboBox;
    Label12: TLabel;
    cmbLeftBorder: TComboBox;
    cmbBottomBorder: TComboBox;
    cmbRightBorder: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    sbnLeftBorderColor: TSpeedButton;
    sbnBottomBorderColor: TSpeedButton;
    sbnTopBorderColor: TSpeedButton;
    sbnRightBorderColor: TSpeedButton;
		edtTopBorderWidth: TEdit;
    udTopBorderWidth: TUpDown;
    edtBottomBorderWidth: TEdit;
    udBottomBorderWidth: TUpDown;
    edtLeftBorderWidth: TEdit;
    udLeftBorderWidth: TUpDown;
    edtRightBorderWidth: TEdit;
    udRightBorderWidth: TUpDown;
    cmbHeadings: TComboBox;
    tbsHeadings: TTabSheet;
    lbxHeadings: TListBox;
    btnNewHeading: TButton;
    pnlHeadingProperties: TPanel;
    memHDCaption: TMemo;
    Label16: TLabel;
    sbnHHleft: TSpeedButton;
		sbnHHcenter: TSpeedButton;
    sbnHHRight: TSpeedButton;
    sbnHVTop: TSpeedButton;
		sbnHVCenter: TSpeedButton;
    sbnHVBottom: TSpeedButton;
    sbnHColor: TSpeedButton;
    sbnHFont: TSpeedButton;
    sbnHClip: TSpeedButton;
    sbnHEllipsis: TSpeedButton;
    sbnHWrap: TSpeedButton;
    sbnHInnerRaised: TSpeedButton;
    sbnHInnerLowered: TSpeedButton;
    sbnHOuterRaised: TSpeedButton;
    sbnHOuterLowered: TSpeedButton;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    sbnEllipsisButton: TSpeedButton;
    sbnCustomButton: TSpeedButton;
    sbnDropDownButton: TSpeedButton;
    pnlButtonProperties: TPanel;
    Label20: TLabel;
		Panel7: TPanel;
    imgButtonImage: TImage;
    Label21: TLabel;
    sbnLoadImage: TSpeedButton;
    sbnClearImage: TSpeedButton;
    OpenDialog: TOpenDialog;
    cbxDrawButtonFace: TCheckBox;
    sbnButtonVTop: TSpeedButton;
    sbnButtonVCenter: TSpeedButton;
    sbnButtonVBottom: TSpeedButton;
    Label10: TLabel;
		edtMaxTextLength: TEdit;
    Heading: TLabel;
    sbnDeleteHeading: TButton;
    tbsRows: TTabSheet;
    cmbRows: TComboBox;
    Label22: TLabel;
    tbrRowHeight: TTrackBar;
    sbnDeleteColumn: TSpeedButton;
		tbsFormat: TTabSheet;
    pgcFormats: TPageControl;
    tbsNone: TTabSheet;
    tbsNumeric: TTabSheet;
    Label23: TLabel;
    Label24: TLabel;
    edtDigits: TEdit;
    udDigits: TUpDown;
    edtPrefix: TEdit;
    cbxThousands: TCheckBox;
    cbxNegative: TCheckBox;
    Label25: TLabel;
    cmbFormats: TComboBox;
    Label26: TLabel;
    tbsScientific: TTabSheet;
    Label27: TLabel;
    edtScientificDecimals: TEdit;
    udScientificDecimals: TUpDown;
    Label28: TLabel;
		tbsDateTime: TTabSheet;
    Label29: TLabel;
    lbxDateFormats: TListBox;
    lbxTimeFormats: TListBox;
    Label30: TLabel;
    Label31: TLabel;
		Label32: TLabel;
    tbrWidth: TTrackBar;
    Label34: TLabel;
    Label35: TLabel;
    edtRowHeight: TEdit;
    lsvColumns: TListView;
    btnDuplicateColumn: TSpeedButton;
    edtColumnWidth: TEdit;
    cbxReadOnly: TCheckBox;
    cbxComboDropDownList: TCheckBox;
    sbnCheckBox: TSpeedButton;
    tbsCheckBox: TTabSheet;
		Label37: TLabel;
		rdbAsCheckBox: TRadioButton;
		rdbAsRadioB: TRadioButton;
		rdbAsUDString: TRadioButton;
		Label40: TLabel;
		pnlCheckStrings: TPanel;
		edtStrCheckYes: TEdit;
		edtStrCheckNo: TEdit;
		Label38: TLabel;
		Label39: TLabel;
		rbAsEntered: TRadioButton;
		rbAsLowered: TRadioButton;
		rbAllUpcase: TRadioButton;
		rbAllButFirst: TRadioButton;
		procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnNewColumnClick(Sender: TObject);
    procedure memCaptionChange(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
		procedure AlignmentButtonClick(Sender: TObject);
    procedure sbnComboBoxClick(Sender: TObject);
    procedure memComboBoxItemsExit(Sender: TObject);
    procedure cbxVisibleClick(Sender: TObject);
    procedure sbnTitleColorClick(Sender: TObject);
    procedure sbnTitleFontClick(Sender: TObject);
    procedure sbnClipClick(Sender: TObject);
		procedure sbnTInnerRaisedClick(Sender: TObject);
    procedure cbxReadOnlyClick(Sender: TObject);
    procedure edtMaxTextLengthExit(Sender: TObject);
    procedure cbxAutoSuggestClick(Sender: TObject);
    procedure cbxComboMaxWidthClick(Sender: TObject);
    procedure edtDropDownCountExit(Sender: TObject);
    procedure cmbTopBorderDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure edtTopBorderWidthChange(Sender: TObject);
    procedure cmbTopBorderChange(Sender: TObject);
    procedure sbnLeftBorderColorClick(Sender: TObject);
    procedure cmbHeadingsChange(Sender: TObject);
    procedure btnNewHeadingClick(Sender: TObject);
    procedure memHDCaptionExit(Sender: TObject);
    procedure lbxHeadingsClick(Sender: TObject);
    procedure sbnHHleftClick(Sender: TObject);
		procedure sbnHVTopClick(Sender: TObject);
    procedure sbnHClipClick(Sender: TObject);
    procedure sbnHColorClick(Sender: TObject);
		procedure sbnHFontClick(Sender: TObject);
		procedure sbnHInnerRaisedClick(Sender: TObject);
    procedure sbnEllipsisButtonClick(Sender: TObject);
    procedure sbnLoadImageClick(Sender: TObject);
    procedure sbnClearImageClick(Sender: TObject);
    procedure cbxDrawButtonFaceClick(Sender: TObject);
    procedure sbnButtonVTopClick(Sender: TObject);
    procedure sbnDeleteHeadingClick(Sender: TObject);
		procedure cmbRowsChange(Sender: TObject);
    procedure tbrRowHeightChange(Sender: TObject);
    procedure sbnDeleteColumnClick(Sender: TObject);
    procedure cmbFormatsChange(Sender: TObject);
    procedure edtPrefixChange(Sender: TObject);
    procedure cbxThousandsClick(Sender: TObject);
    procedure cbxNegativeClick(Sender: TObject);
    procedure edtDigitsChange(Sender: TObject);
    procedure lbxDateFormatsClick(Sender: TObject);
    procedure lbxTimeFormatsClick(Sender: TObject);
		procedure tbrWidthChange(Sender: TObject);
    procedure memHDCaptionChange(Sender: TObject);
		procedure edtRowHeightKeyPress(Sender: TObject; var Key: Char);
    procedure lsvColumnsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lsvColumnsEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure lsvColumnsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lsvColumnsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnDuplicateColumnClick(Sender: TObject);
    procedure edtColumnWidthKeyPress(Sender: TObject; var Key: Char);
    procedure cbxComboDropDownListClick(Sender: TObject);
		procedure rdbAsCheckBoxClick(Sender: TObject);
    procedure rdbAsRadioBClick(Sender: TObject);
    procedure rdbAsUDStringClick(Sender: TObject);
    procedure edtStrCheckYesExit(Sender: TObject);
    procedure edtStrCheckNoExit(Sender: TObject);
		procedure rbAsEnteredClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
	private
    procedure ColumnsToListBox;
    procedure AdjustWidthTrackBar;
		procedure ShowColumn( Column : ThgColumn );
    procedure ShowHeading;
    function CurrentColumn : ThgColumn;
    function CurrentHeading : ThgHeading;
    function CurrentGridColumn : Longint;
		function ColumnsBackToGrid : Boolean;
    procedure RefreshHeadingNames;
  private
    PropertyEditor  : TObject;
    Grid            : THyperGrid;
    GridColumns     : ThgColumns;
    GridHeadings    : ThgHeadings;
		ColorDialog 		: ThgColorDialog;
	public
    EditingHeadings : Boolean;
    constructor CreateColumnsEditor( AOwner : TComponent; APropertyEditor : TObject );
    destructor Destroy; override;
  end;

implementation

{$R *.DFM}

uses DesignIntf, DesignEditors;

//------------------------------------------------------------------------------

procedure TfrmhgColumnsEditor.ColumnsToListBox;
var
  Index : Integer;
begin
  for Index := 0 to Pred( GridColumns.Count ) do
    begin
      with lsvColumns.Items.Add do
        begin
          Caption := GridColumns[ Index ].Name;
          Data := GridColumns[ Index ];
        end;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmhgColumnsEditor.AdjustWidthTrackBar;
var
  ColIndex : Longint;
begin
  ColIndex := CurrentGridColumn;
  if ColIndex = -1 then
		begin
      tbrWidth.Position := 0;
      tbrWidth.Enabled := False;
      edtColumnWidth.Enabled := False;
      edtColumnWidth.Text := '';
    end
  else
    begin
      tbrWidth.Position := Grid.ColWidths[ ColIndex ];
      tbrWidth.Enabled := True;
      edtColumnWidth.Enabled := True;
			edtColumnWidth.Text := IntToStr( tbrWidth.Position );
    end;
end;

procedure TfrmHGColumnsEditor.tbrWidthChange(Sender: TObject);
var
  ColIndex : Longint;
begin
  ColIndex := CurrentGridColumn;
  if ( ColIndex > -1 ) and ( ColIndex < Grid.ColCount ) then
    begin
      Grid.ColWidths[ ColIndex ] := tbrWidth.Position;
      edtColumnWidth.Text := IntToStr( tbrWidth.Position );
    end;
end;

function TfrmhgColumnsEditor.CurrentGridColumn : Longint;
var
  Column    : ThgColumn;
	Index     : Integer;
begin
  Column := CurrentColumn;
	Result := -1;
  if Column <> nil then
		begin
      try
        // This stmt can raise and exception if the col is not found
        Column := Grid.ColumnByName[ Column.Name ];
        if Column.Visible then
          begin
            Result := 0;
            for Index := 0 to Pred( Grid.Columns.Count ) do
              begin
                if Grid.Columns[ Index ].Visible then
                  Inc( Result );
                if Column = Grid.Columns[ Index ] then
									begin
                    Dec( Result );
										break;
                  end;
							end;
          end;
      except
			end;
    end;
end;

//------------------------------------------------------------------------------
// This procedure displays the properties of a column on the dialog's controls

procedure TfrmhgColumnsEditor.ShowColumn( Column : ThgColumn );
begin
	tbsGeneral.Enabled := Column <> nil;
	tbsControl.Enabled := Column <> nil;
	tbsFormat.Enabled  := Column <> nil;
	sbnDeleteColumn.Enabled := CurrentColumn <> nil;
	btnDuplicateColumn.Enabled := CurrentColumn <> nil;

	AdjustWidthTrackbar;

	if Column = nil then
		begin
			memCaption.Text := '';
			tbsComboBox.Visible := False;
			tbsComboBox.TabVisible := False;
			tbsCheckBox.Visible := False;
			tbsCheckBox.TabVisible := False;
			tbsButton.Visible := False;
			tbsButton.TabVisible := False;
			cmbFormats.ItemIndex := 0;
			cmbFormatsChange( Self );
		end
	else
		begin
			memCaption.Text := Column.Caption;

			sbnCombobox.Down 	:= hgctlCombobox in Column.ControlType ;
			sbnButton.Down 		:= hgctlButton in Column.ControlType;
			sbnCheckBox.Down 	:= hgctlCheckBox in Column.ControlType;

			if hgctlCombobox in Column.ControlType then
				begin
					memComboBoxItems.Lines.Assign( Column.Items );
					cbxAutoSuggest.Checked := Column.AutoSuggest;
					cbxComboMaxWidth.Checked := Column.ComboMaxWidth;
					cbxComboDropDownList.Checked := Column.DropDownList;
					edtDropDownCount.Text := IntToStr( Column.DropDownCount );
				end;
// start by Tsoyran
			if hgctlCheckBox in Column.ControlType then
				begin
					case Column.BooleanStyle of
						hgcbtCheckBox	: rdbAsCheckBox.Checked := true;
						hgcbtRadio 		:	rdbAsRadioB.Checked 	:= true;
						else
							begin
								rdbAsUDString.Checked 	:= true;
								edtStrCheckYes.Text 		:= Column.StringAsTrue;
								edtStrCheckNo.Text  		:= Column.StringAsFalse;
								pnlCheckStrings.Visible := true;
							end;
					end;
					pnlCheckStrings.Visible := rdbAsUDString.Checked;
				end;
// end by Tsoyran

			tbsComboBox.Visible 		:= hgctlCombobox in Column.ControlType;
			tbsComboBox.TabVisible 	:= hgctlCombobox in Column.ControlType;
			tbsCheckBox.Visible			:= hgctlCheckBox in Column.ControlType;
			tbsCheckBox.TabVisible	:= hgctlCheckBox in Column.ControlType;
			tbsButton.Visible 			:= hgctlButton   in Column.ControlType;
			tbsButton.TabVisible 		:= hgctlButton   in Column.ControlType;
			if pgcControlInfo.ActivePage <> nil then
				if not pgcControlInfo.ActivePage.TabVisible then
					pgcControlInfo.SelectNextPage( True );

			cbxVisible.Checked := Column.Visible;
			cbxReadOnly.Checked := Column.ReadOnly;

			edtMaxTextLength.Text := IntToStr( Column.MaxTextLength );

			cmbTopBorder.ItemIndex := Ord( Column.TopBorder.Style );
			cmbBottomBorder.ItemIndex := Ord( Column.BottomBorder.Style );
			cmbLeftBorder.ItemIndex := Ord( Column.LeftBorder.Style );
			cmbRightBorder.ItemIndex := Ord( Column.RightBorder.Style );

			edtTopBorderWidth.Text := IntToStr( Column.TopBorder.Width );
			edtBottomBorderWidth.Text := IntToStr( Column.BottomBorder.Width );
			edtLeftBorderWidth.Text := IntToStr( Column.LeftBorder.Width );
			edtRightBorderWidth.Text := IntToStr( Column.RightBorder.Width );

			// title

			sbnHLeft.Down    := Column.TitleHAlignment = taLeftJustify;
			sbnHCenter.Down  := Column.TitleHAlignment = taCenter;
			sbnHRight.Down   := Column.TitleHAlignment = taRightJustify;

			sbnVTop.Down     := Column.TitleVAlignment = hgvaTop;
			sbnVCenter.Down  := Column.TitleVAlignment = hgvaCenter;
			sbnVBottom.Down  := Column.TitleVAlignment = hgvaBottom;

			sbnClip.Down     := Column.TitleClipStyle = hgclpClip;
			sbnEllipsis.Down := Column.TitleClipStyle = hgclpEllipsis;
			sbnWrap.Down     := Column.TitleClipStyle = hgclpWrap;

			sbnTInnerRaised.Down := Column.TitleInnerBevel = bvRaised;
			sbnTInnerLowered.Down := Column.TitleInnerBevel = bvLowered;
			sbnTOuterRaised.Down := Column.TitleOuterBevel = bvRaised;
			sbnTOuterLowered.Down := Column.TitleOuterBevel = bvLowered;

			// column

			sbnCHLeft.Down := Column.ColumnHAlignment = taLeftJustify;
			sbnCHCenter.Down := Column.ColumnHAlignment = taCenter;
			sbnCHRight.Down := Column.ColumnHAlignment = taRightJustify;

			sbnCVTop.Down := Column.ColumnVAlignment = hgvaTop;
			sbnCVCenter.Down := Column.ColumnVAlignment = hgvaCenter;
			sbnCVBottom.Down := Column.ColumnVAlignment = hgvaBottom;

			sbnCClip.Down := Column.ColumnClipStyle = hgclpClip;
			sbnCEllipsis.Down := Column.ColumnClipStyle = hgclpEllipsis;
			sbnCWrap.Down := Column.ColumnClipStyle = hgclpWrap;

			sbnCInnerRaised.Down 	:= Column.ColumnInnerBevel = bvRaised;
			sbnCInnerLowered.Down := Column.ColumnInnerBevel = bvLowered;
			sbnCOuterRaised.Down 	:= Column.ColumnOuterBevel = bvRaised;
			sbnCOuterLowered.Down := Column.ColumnOuterBevel = bvLowered;

			cmbHeadings.ItemIndex   := Column.HeadingIndex + 1;

			sbnEllipsisButton.Down 	:= Column.ButtonStyle = hgbstEllipsis;
			sbnDropDownButton.Down 	:= Column.ButtonStyle = hgbstDropDown;
			sbnCustomButton.Down    := Column.ButtonStyle 		= hgbstCustom;
			pnlButtonProperties.Visible := sbnCustomButton.Down;
			imgButtonImage.Picture.Assign( CurrentColumn.ButtonPicture );
			cbxDrawButtonFace.Checked := Column.DrawButtonFace;

			sbnButtonVTop.Down 		:= Column.ButtonVAlignment = hgvaTop;
			sbnButtonVCenter.Down := Column.ButtonVAlignment = hgvaCenter;
			sbnButtonVBottom.Down := Column.ButtonVAlignment = hgvaBottom;

			cmbFormats.ItemIndex 	:= Ord( Column.FormatType );
			cmbFormatsChange( Self );
			udDigits.Position 		:= Column.Decimals;
			udScientificDecimals.Position := Column.Decimals;
			edtPrefix.Text 				:= Column.Prefix;
			cbxThousands.Checked := Column.ThousandsSeparator;
			cbxNegative.Checked  := Column.NegativeParenthesis;
			// tsoyran
			if column.FormatType = hgfmtNone then
			begin
				rbAsEntered.Checked 	:= column.FormatText = hgfmtAsEntered;
				rbAsLowered.Checked 	:= column.FormatText = hgfmtAsLowered;
				rbAllUpcase.Checked 	:= column.FormatText = hgfmtAsUpcase;
				rbAllButFirst.Checked := column.FormatText = hgfmtAsName;
			end;
			// end tsoyran
			lbxDateFormats.ItemIndex := Column.DateFormat + 1;
			lbxTimeFormats.ItemIndex := Column.TimeFormat + 1;

		end;
end;

//------------------------------------------------------------------------------

function TfrmhgColumnsEditor.CurrentColumn : ThgColumn;
begin
	Result := nil;
	if ( lsvColumns.Selected <> nil ) and ( lsvColumns.Selected.Data <> nil ) then
		 Result := ThgColumn( lsvColumns.Selected.Data );
end;

//------------------------------------------------------------------------------

constructor TfrmhgColumnsEditor.CreateColumnsEditor( AOwner : TComponent; APropertyEditor : TObject );
var
	VisibleCols : Integer;
	Index : Integer;
begin
	inherited Create( AOwner );
	GridColumns := ThgColumns.Create;
	PropertyEditor := APropertyEditor;
	if PropertyEditor is TPropertyEditor then
		Grid := TPropertyEditor( PropertyEditor ).GetComponent( 0 ) as THyperGrid
	else if PropertyEditor is TComponentEditor then
		Grid := TComponentEditor( PropertyEditor ).Component as THyperGrid
	else if PropertyEditor is THyperGrid then
		Grid := THyperGrid( PropertyEditor );

	GridColumns.Assign( Grid.Columns );
	GridHeadings := ThgHeadings.Create( ThgHeading );
	GridHeadings.Assign( Grid.Headings );

	VisibleCols := 0;
	for Index := 0 to Pred( GridColumns.Count ) do
		if GridColumns[ Index ].Visible then
			Inc( VisibleCols );
	while VisibleCols > Grid.ColCount do
		begin
			GridColumns[ Pred( GridColumns.Count )  ].Free;
			Dec( VisibleCols );
		end;
end;

//------------------------------------------------------------------------------

destructor TfrmhgColumnsEditor.Destroy;
begin
	GridColumns.Free;
	GridHeadings.Free;
	inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TfrmhgColumnsEditor.btnCancelClick(Sender: TObject);
begin
	ModalResult := mrCancel;
end;

//------------------------------------------------------------------------------

procedure TfrmhgColumnsEditor.btnOkClick(Sender: TObject);
begin
	if ColumnsBackToGrid then
		ModalResult := mrOk;
end;

//------------------------------------------------------------------------------

procedure TfrmhgColumnsEditor.FormClose(Sender: TObject;
	var Action: TCloseAction);
begin
	lsvColumns.OnChange := nil;
	Action := caFree;
end;

//------------------------------------------------------------------------------

procedure TfrmhgColumnsEditor.FormShow(Sender: TObject);
var
  Index : Integer;
  SampleDT : TDateTime;
begin
  tbrWidth.ThumbLength := 12;
  tbrRowHeight.ThumbLength := 12;

  if EditingHeadings then
    PageControl.ActivePage := tbsHeadings
  else
		PageControl.ActivePage := tbsGeneral;

  lsvColumns.Columns[ 0 ].Width := ColumnHeaderWidth;

  Caption := Caption + Grid.Name;
  ColumnsToListBox;
	if lsvColumns.Items.Count > 0 then
    begin
      lsvColumns.Selected := lsvColumns.Items[ 0 ];
      lsvColumns.SetFocus;
    end;

  cmbTopBorder.ItemIndex := 0;

  SampleDT := EncodeDate( 1997 , 7 , 6 );
  lbxDateFormats.Items.Add( '< None >' );
  for Index := Low( hgDateFormats[ hgDateOrder ] ) to ( High( hgDateFormats[ hgDateOrder ] ) ) do
    begin
      lbxDateFormats.Items.Add( FormatDateTime( hgDateFormats[ hgDateOrder , Index ] , SampleDT ) );
    end;

  SampleDT := EncodeTime( 16 , 20 , 42 , 0 );
  lbxTimeFormats.Items.Add( '< None >' );
  for Index := Low( hgTimeFormats ) to High( hgTimeFormats ) do
    lbxTimeFormats.Items.Add( FormatDateTime( hgTimeFormats[ Index ] , SampleDT ) );

  cmbHeadings.Items.Add( '< None >' );
	for Index := 0 to Pred( GridHeadings.Count ) do
    begin
      cmbHeadings.Items.Add( GridHeadings[ Index ].Caption );
      lbxHeadings.Items.AddObject( GridHeadings[ Index ].Caption ,
        GridHeadings[ Index ] );
    end;

  if lbxHeadings.Items.Count = 0 then
    lbxHeadings.ItemIndex := -1
  else
    lbxHeadings.ItemIndex := 0;
  cmbFormats.ItemIndex := 0;
	ShowColumn( CurrentColumn );
  ShowHeading;

  tbrRowHeight.Max := Screen.Height;
  for Index := 0 to Pred( Grid.RowCount ) do
		cmbRows.Items.Add( IntToStr( Index ) );
  cmbRows.ItemIndex := 0;
  cmbRowsChange( cmbRows );

  tbrWidth.Max := Screen.Width;
end;

//------------------------------------------------------------------------------

procedure TfrmhgColumnsEditor.btnNewColumnClick(Sender: TObject);
var
  NewColumn : ThgColumn;
begin
  NewColumn := GridColumns.Add;
  with lsvColumns.Items.Add do
    begin
      Caption := NewColumn.Name;
      Data := NewColumn;
      EditCaption; 
		end;
	ShowColumn( NewColumn );
end;

//------------------------------------------------------------------------------

procedure TfrmhgColumnsEditor.memCaptionChange(Sender: TObject);
begin
  if CurrentColumn = nil then
		Exit;
  CurrentColumn.Caption := memCaption.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmhgColumnsEditor.btnApplyClick(Sender: TObject);
begin
	if ColumnsBackToGrid then
		begin
			if PropertyEditor is TPropertyEditor then
				TPropertyEditor( PropertyEditor ).Designer.Modified
      else if PropertyEditor is TComponentEditor then
        TComponentEditor( PropertyEditor ).Designer.Modified;
      ShowColumn( CurrentColumn );
    end;
end;

procedure TfrmhgColumnsEditor.AlignmentButtonClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;

  if sbnHLeft.Down then
    CurrentColumn.TitleHAlignment := taLeftJustify
  else if sbnHCenter.Down then
    CurrentColumn.TitleHAlignment := taCenter
  else if sbnHRight.Down then
    CurrentColumn.TitleHAlignment := taRightJustify;

	if sbnVTop.Down then
    CurrentColumn.TitleVAlignment := hgvaTop
  else if sbnVCenter.Down then
		CurrentColumn.TitleVAlignment := hgvaCenter
  else if sbnVBottom.Down then
    CurrentColumn.TitleVAlignment := hgvaBottom;

  if sbnCHLeft.Down then
    CurrentColumn.ColumnHAlignment := taLeftJustify
  else if sbnCHCenter.Down then
    CurrentColumn.ColumnHAlignment := taCenter
  else if sbnCHRight.Down then
    CurrentColumn.ColumnHAlignment := taRightJustify;

  if sbnCVTop.Down then
    CurrentColumn.ColumnVAlignment := hgvaTop
  else if sbnCVCenter.Down then
    CurrentColumn.ColumnVAlignment := hgvaCenter
  else if sbnCVBottom.Down then
		CurrentColumn.ColumnVAlignment := hgvaBottom

end;

procedure TfrmHGColumnsEditor.sbnComboBoxClick(Sender: TObject);
begin
	if sbnCombobox.Down then
		begin
			CurrentColumn.ControlType := CurrentColumn.ControlType + [ hgctlComboBox ];
		end
	else
		CurrentColumn.ControlType := CurrentColumn.ControlType - [ hgctlComboBox ];

	if sbnCheckBox.Down then
		begin
			CurrentColumn.ControlType := CurrentColumn.ControlType + [ hgctlCheckBox ];
		end
	else
		CurrentColumn.ControlType := CurrentColumn.ControlType - [ hgctlCheckBox ];

	if sbnButton.Down then
		CurrentColumn.ControlType := CurrentColumn.ControlType + [ hgctlButton ]
	else
		CurrentColumn.ControlType := CurrentColumn.ControlType - [ hgctlButton ];
	ShowColumn( CurrentColumn );
end;

procedure TfrmHGColumnsEditor.memComboBoxItemsExit(Sender: TObject);
begin
	if CurrentColumn = nil then
    Exit;
  CurrentColumn.Items.Assign( memComboBoxItems.Lines );
end;

function TfrmHGColumnsEditor.ColumnsBackToGrid : Boolean;

	function ChecksForOk : Boolean;
	var
		Index :Integer;
		Visibles :Integer;
	begin
		Result := False;
		if GridColumns.Count = 0 then
			MessageDlg( 'Please define at least one column' , mtError , [ mbOk ] , 0 )
		else
			begin
				Visibles := GridColumns.Count;
				for Index := 0 to Pred( GridColumns.Count ) do
					if not GridColumns[ Index ].Visible then
						Dec( Visibles );
				if Visibles = 0 then
					MessageDlg( 'Please make at least one column visible' , mtError , [ mbOk ] , 0 )
				else
					Result := True;
			end;
	end;

begin
	Result := ChecksForOK;

	if Result then
		begin
			Grid.Headings.Assign( GridHeadings );
			Grid.Columns.Assign( GridColumns );

		//  Grid.ColCount := Grid.VisibleColumnCount;
			Grid.SetColCount( Grid.VisibleColumnCount );
			Grid.Refresh;
		end;
end;
procedure TfrmHGColumnsEditor.cbxVisibleClick(Sender: TObject);
begin
	if CurrentColumn = nil then
		Exit;
	CurrentColumn.Visible := cbxVisible.Checked;
end;

procedure TfrmHGColumnsEditor.sbnTitleColorClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
  if Sender = sbnTitleColor then
		begin
			ColorDialog.Title := 'Please select title column color';
			ColorDialog.Color := CurrentColumn.TitleColor;
			if ColorDialog.Execute then
				CurrentColumn.TitleColor := ColorDialog.Color;
		end
	else if Sender = sbnCColor then
		begin
			ColorDialog.Title := 'Please select column color';
			ColorDialog.Color := CurrentColumn.ColumnColor;
			if ColorDialog.Execute then
				CurrentColumn.ColumnColor := ColorDialog.Color;
		end;
end;

procedure TfrmHGColumnsEditor.sbnTitleFontClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
	if Sender = sbnTitleFont then
    begin
      FontDialog.Font.Assign( CurrentColumn.TitleFont );
      if FontDialog.Execute then
        CurrentColumn.TitleFont.Assign( FontDialog.Font );
    end
  else if Sender = sbnCFont then
    begin
      FontDialog.Font.Assign( CurrentColumn.ColumnFont );
      if FontDialog.Execute then
        CurrentColumn.ColumnFont.Assign( FontDialog.Font );
		end;
end;

procedure TfrmHGColumnsEditor.sbnClipClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;

	if sbnClip.Down then
    CurrentColumn.TitleClipStyle := hgclpClip
  else if sbnEllipsis.Down then
    CurrentColumn.TitleClipStyle := hgclpEllipsis
  else if sbnWrap.Down then
    CurrentColumn.TitleClipStyle := hgclpWrap;

  if sbnCClip.Down then
    CurrentColumn.ColumnClipStyle := hgclpClip
  else if sbnCEllipsis.Down then
    CurrentColumn.ColumnClipStyle := hgclpEllipsis
	else if sbnCWrap.Down then
    CurrentColumn.ColumnClipStyle := hgclpWrap;
end;

procedure TfrmHGColumnsEditor.sbnTInnerRaisedClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;

  if sbnTInnerRaised.Down then
    CurrentColumn.TitleInnerBevel := bvRaised
  else if sbnTInnerLowered.Down then
    CurrentColumn.TitleInnerbevel := bvLowered
  else
    CurrentColumn.TitleInnerBevel := bvNone;

	if sbnTOuterRaised.Down then
    CurrentColumn.TitleOuterBevel := bvRaised
	else if sbnTOuterLowered.Down then
		CurrentColumn.TitleOuterBevel := bvLowered
  else
    CurrentColumn.TitleOuterBevel := bvNone;

  if sbnCInnerRaised.Down then
    CurrentColumn.ColumnInnerBevel := bvRaised
  else if sbnCInnerLowered.Down then
    CurrentColumn.ColumnInnerbevel := bvLowered
	else
    CurrentColumn.ColumnInnerBevel := bvNone;

  if sbnCOuterRaised.Down then
    CurrentColumn.ColumnOuterBevel := bvRaised
  else if sbnCOuterLowered.Down then
    CurrentColumn.ColumnOuterBevel := bvLowered
  else
    CurrentColumn.ColumnOuterBevel := bvNone;
end;

procedure TfrmHGColumnsEditor.cbxReadOnlyClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
  CurrentColumn.ReadOnly := cbxReadonly.Checked;
end;

procedure TfrmHGColumnsEditor.edtMaxTextLengthExit(Sender: TObject);
var
	Value : Integer;
begin
	if CurrentColumn = nil then
		Exit;
	try
		Value := StrToInt( edtMaxTextLength.Text );
		if Value < 0 then
			raise EConvertError.Create( '' );
		CurrentColumn.MaxTextLength := Value;
	except
		MessageDlg( 'Please enter an integer greater than or equal to 0.' ,
			mtError , [ mbOk ] , 0 );
		edtMaxTextLength.SetFocus;
	end;
end;

procedure TfrmHGColumnsEditor.cbxAutoSuggestClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
  CurrentColumn.AutoSuggest := cbxAutoSuggest.Checked;
end;

procedure TfrmHGColumnsEditor.cbxComboMaxWidthClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
  CurrentColumn.ComboMaxWidth := cbxComboMaxWidth.Checked;
end;

procedure TfrmHGColumnsEditor.edtDropDownCountExit(Sender: TObject);
var
	Value : Integer;
begin
	if CurrentColumn = nil then
		Exit;
	try
		Value := StrToInt( edtDropDownCount.Text );
		if Value < 0 then
			raise EConvertError.Create( '' );
		CurrentColumn.DropDownCount := Value;
	except
		MessageDlg( 'Please enter an integer greater than or equal to 0.' ,
			mtError , [ mbOk ] , 0 );
		edtDropDownCount.SetFocus;
	end;
end;

procedure TfrmHGColumnsEditor.cmbTopBorderDrawItem(Control: TWinControl;
	Index: Integer; Rect: TRect; State: TOwnerDrawState);
const
	Margin = 4;
var
	Border  : ThgBorder;
	FromPt  : TPoint;
	ToPt    : TPoint;
begin
	Border := ThgBorder.Create;
	try
		with Border do
			begin
				Style := ThgBorderStyle( Index );
				Width := 2;
				Color := clBlack;
			end;
    FromPt := Point( Rect.Left + Margin , Rect.Top + RectHeight( Rect ) div 2 );
    ToPt := Point( Rect.Right - Margin , FromPt.Y );
    if Border.Style = hgbrdDouble then
      begin
        Dec( FromPt.Y , 2 );
				Dec( ToPt.Y , 2 );
      end;
    with Control as TComboBox do
      begin
        Canvas.Brush.Color := clWindow;
        Canvas.FillRect( Rect );
        hgDrawBorder( Canvas , FromPt , ToPt , Border , hgbdTop );
			end;
  finally
    Border.Free;
  end;
end;

procedure TfrmHGColumnsEditor.edtTopBorderWidthChange(Sender: TObject);
var
  Value : Integer;
begin
  if CurrentColumn = nil then
    Exit;
  if not ( Sender is TEdit ) then
    Exit;
  try
    with Sender as TEdit do
      Value := StrToInt( Text );
    if Sender = edtTopBorderWidth then
      CurrentColumn.TopBorder.Width := Value
    else if Sender = edtBottomBorderWidth then
      CurrentColumn.BottomBorder.Width := Value
    else if Sender = edtLeftBorderWidth then
      CurrentColumn.LeftBorder.Width := Value
    else if Sender = edtRightBorderWidth then
      CurrentColumn.RightBorder.Width := Value;
	except
	end;
end;

procedure TfrmHGColumnsEditor.cmbTopBorderChange(Sender: TObject);
var
  Border : ThgBorder;
begin
  if CurrentColumn = nil then
    Exit;
  if Sender = cmbTopBorder then
    Border := CurrentColumn.TopBorder
  else if Sender = cmbBottomBorder then
    Border := CurrentColumn.BottomBorder
  else if Sender = cmbLeftBorder then
    Border := CurrentColumn.LeftBorder
  else
		Border := CurrentColumn.RightBorder;

	with Sender as TComboBox do
    Border.Style := ThgBorderStyle( ItemIndex );
end;

procedure TfrmHGColumnsEditor.sbnLeftBorderColorClick(Sender: TObject);
var
  Border : ThgBorder;
begin
  if CurrentColumn = nil then
    Exit;
	if Sender = sbnTopBorderColor then
		Border := CurrentColumn.TopBorder
	else if Sender = sbnBottomBorderColor then
		Border := CurrentColumn.BottomBorder
	else if Sender = sbnLeftBorderColor then
		Border := CurrentColumn.LeftBorder
	else
		Border := CurrentColumn.RightBorder;

	ColorDialog.Title := 'Select border color';
	ColorDialog.Color := Border.Color;
	if ColorDialog.Execute then
		Border.Color := ColorDialog.Color;

end;

procedure TfrmHGColumnsEditor.cmbHeadingsChange(Sender: TObject);
begin
	if CurrentColumn = nil then
		Exit;
	CurrentColumn.HeadingIndex := cmbHeadings.ItemIndex - 1;
end;


{
procedure TfrmHGColumnsEditor.grdBordersDrawCell(Sender: TObject; Col,
	Row: Integer; Rect: TRect; State: TGridDrawState);
const
	Margin = 4;
var
	Border  : ThgBorder;
	FromPt  : TPoint;
	ToPt    : TPoint;
	W       : Integer;
begin
	Border := ThgBorder.Create;
	try
		with Border do
			begin
				Style := ThgBorderStyle( Row );
				Width := udBorderWidth.Position;
				Color := clBlack;
			end;
		W := udBorderWidth.Position;
		if Border.Style = hgbrdDouble then
			Inc( W , 2 );

		FromPt := Point( Rect.Left + Margin , Rect.Top + RectHeight( Rect ) div 2 - W div 2 );
		ToPt := Point( Rect.Right - Margin , FromPt.Y );
		with Sender as TDrawGrid do
			begin
				Canvas.Brush.Color := clWindow;
				Canvas.FillRect( Rect );
				hgDrawBorder( Canvas , FromPt , ToPt , Border , hgbdTop );
				if gdSelected in State then
					begin
						InflateRect( Rect , -2 , -2 );
						Canvas.DrawFocusRect( Rect );
					end;
			end;
	finally
		Border.Free;
	end;
end;
}

function TfrmHGColumnsEditor.CurrentHeading : ThgHeading;
begin
  if ( lbxHeadings.ItemIndex < 0 ) or ( lbxHeadings.ItemIndex >= lbxHeadings.Items.Count ) then
    Result := nil
  else
		Result := lbxHeadings.Items.Objects[ lbxHeadings.ItemIndex ] as ThgHeading;
end;

procedure TfrmHGColumnsEditor.RefreshHeadingNames;
var
  Index : Integer;
  ItemIndex :Integer;
begin
  ItemIndex := cmbHeadings.ItemIndex;
  for Index := 0 to Pred( GridHeadings.Count ) do
		begin
      lbxHeadings.Items[ Index ] := GridHeadings[ Index ].Caption;
      cmbHeadings.Items[ Index + 1 ] := GridHeadings[ Index ].Caption; 
    end;
	cmbHeadings.ItemIndex := ItemIndex;
end;


procedure TfrmHGColumnsEditor.btnNewHeadingClick(Sender: TObject);
var
  NewHeading : ThgHeading;
  Index     : Integer;
begin
  NewHeading := GridHeadings.Add;
  NewHeading.Caption := 'New heading';

  Index := lbxHeadings.Items.AddObject( NewHeading.Caption , NewHeading );
	lbxHeadings.ItemIndex := Index;
  cmbHeadings.Items.Add( NewHeading.Caption );
  ShowHeading;
end;

procedure TfrmHGColumnsEditor.ShowHeading;
begin
  sbnDeleteHeading.Enabled := CurrentHeading <> nil;
  pnlHeadingProperties.Enabled := CurrentHeading <> nil;
  if CurrentHeading = nil then
		memHDCaption.Lines.Clear
  else
    begin
      memHDcaption.Text := CurrentHeading.Caption;
      // title

      sbnHHLeft.Down := CurrentHeading.TitleHAlignment = taLeftJustify;
      sbnHHCenter.Down := CurrentHeading.TitleHAlignment = taCenter;
      sbnHHRight.Down := CurrentHeading.TitleHAlignment = taRightJustify;

      sbnHVTop.Down := CurrentHeading.TitleVAlignment = hgvaTop;
      sbnHVCenter.Down := CurrentHeading.TitleVAlignment = hgvaCenter;
			sbnHVBottom.Down := CurrentHeading.TitleVAlignment = hgvaBottom;

      sbnHClip.Down := CurrentHeading.TitleClipStyle = hgclpClip;
			sbnHEllipsis.Down := CurrentHeading.TitleClipStyle = hgclpEllipsis;
      sbnHWrap.Down := CurrentHeading.TitleClipStyle = hgclpWrap;

      sbnHInnerRaised.Down := CurrentHeading.TitleInnerBevel = bvRaised;
      sbnHInnerLowered.Down := CurrentHeading.TitleInnerBevel = bvLowered;
      sbnHOuterRaised.Down := CurrentHeading.TitleOuterBevel = bvRaised;
      sbnHOuterLowered.Down := CurrentHeading.TitleOuterBevel = bvLowered;

		end;
end;

procedure TfrmHGColumnsEditor.memHDCaptionExit(Sender: TObject);
begin
  if CurrentHeading = nil then
		Exit;
  CurrentHeading.Caption := memHDCaption.Text;
  RefreshHeadingNames;
end;

procedure TfrmHGColumnsEditor.lbxHeadingsClick(Sender: TObject);
begin
  ShowHeading;
end;

procedure TfrmHGColumnsEditor.sbnHHleftClick(Sender: TObject);
begin
  if CurrentHeading = nil then
    Exit;
  if sbnHHLeft.Down then
    CurrentHeading.TitleHAlignment := taLeftJustify
	else if sbnHHCenter.Down then
    CurrentHeading.TitleHAlignment := taCenter
  else
    CurrentHeading.TitleHAlignment := taRightJustify;
end;

procedure TfrmHGColumnsEditor.sbnHVTopClick(Sender: TObject);
begin
	if CurrentHeading = nil then
		Exit;
  if sbnHVTop.Down then
		CurrentHeading.TitleVAlignment := hgvaTop
  else if sbnHVCenter.Down then
    CurrentHeading.TitleVAlignment := hgvaCenter
  else
    CurrentHeading.TitleVAlignment := hgvaBottom;
end;

procedure TfrmHGColumnsEditor.sbnHClipClick(Sender: TObject);
begin
  if CurrentHeading = nil then
    Exit;
  if sbnHClip.Down then
    CurrentHeading.TitleClipStyle := hgclpClip
  else if sbnHEllipsis.Down then
    CurrentHeading.TitleClipStyle := hgclpEllipsis
  else
		CurrentHeading.TitleClipStyle := hgclpWrap;
end;

procedure TfrmHGColumnsEditor.sbnHColorClick(Sender: TObject);
begin
  if CurrentHeading = nil then
		Exit;

	ColorDialog.Title := 'Please select heading color';
	ColorDialog.Color := CurrentHeading.TitleColor;
	if ColorDialog.Execute then
		CurrentHeading.TitleColor := ColorDialog.Color;

end;

procedure TfrmHGColumnsEditor.sbnHFontClick(Sender: TObject);
begin
	if CurrentHeading = nil then
    Exit;
	FontDialog.Font.Assign( CurrentHeading.TitleFont );
  if FontDialog.Execute then
    CurrentHeading.TitleFont.Assign( FontDialog.Font );
end;

procedure TfrmHGColumnsEditor.sbnHInnerRaisedClick(Sender: TObject);
begin
  if CurrentHeading = nil then
    Exit;
  if sbnHInnerRaised.Down then
    CurrentHeading.TitleInnerBevel := bvRaised
  else if sbnHInnerLowered.Down then
    CurrentHeading.TitleInnerBevel := bvLowered
  else
    CurrentHeading.TitleInnerBevel := bvNone;

  if sbnHOuterRaised.Down then
		CurrentHeading.TitleOuterBevel := bvRaised
  else if sbnHOuterLowered.Down then
		CurrentHeading.TitleOuterBevel := bvLowered
	else
    CurrentHeading.TitleOuterBevel := bvNone;
end;

procedure TfrmHGColumnsEditor.sbnEllipsisButtonClick(Sender: TObject);
begin
	if CurrentColumn = nil then
    Exit;
  if sbnEllipsisButton.Down then
    CurrentColumn.ButtonStyle := hgbstEllipsis
  else if sbnDropDownButton.Down then
    CurrentColumn.ButtonStyle := hgbstDropDown
  else
    CurrentColumn.ButtonStyle := hgbstCustom;
  pnlButtonProperties.Visible := sbnCustomButton.Down;
end;

procedure TfrmHGColumnsEditor.sbnLoadImageClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
  if OpenDialog.Execute then
    begin
      try
				imgButtonImage.Picture.LoadFromFile( OpenDialog.FileName );
        CurrentColumn.ButtonPicture.Assign( imgButtonImage.Picture );
      except
        MessageDlg( 'Unable to load image from "' + OpenDialog.FileName + '"' ,
          mtError , [ mbOk ] , 0 );
      end;
    end;
end;

procedure TfrmHGColumnsEditor.sbnClearImageClick(Sender: TObject);
var
  TempPicture : TPicture;
begin
	if CurrentColumn = nil then
    Exit;

  TempPicture := TPicture.Create;
  CurrentColumn.ButtonPicture := TempPicture;
  TempPicture.Free;
  imgButtonImage.Picture.Assign( CurrentColumn.ButtonPicture );
end;

procedure TfrmHGColumnsEditor.cbxDrawButtonFaceClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
	CurrentColumn.DrawButtonFace := cbxDrawButtonFace.Checked;
end;


procedure TfrmHGColumnsEditor.sbnButtonVTopClick(Sender: TObject);
begin
	if CurrentColumn = nil then
    Exit;
  if sbnButtonVTop.Down then
    CurrentColumn.ButtonVAlignment := hgvaTop
  else if sbnButtonVCenter.Down then
    CurrentColumn.ButtonVAlignment := hgvaCenter
  else
    CurrentColumn.ButtonVAlignment := hgvaBottom;
end;


procedure TfrmHGColumnsEditor.sbnDeleteHeadingClick(Sender: TObject);
var
  Index : Integer;
  Hdg   : ThgHeading;
begin
	Hdg := CurrentHeading;
  if Hdg = nil then
    Exit;

  for Index := 0 to Pred( GridColumns.Count ) do
    if GridColumns[ Index ].HeadingIndex = Hdg.Index then
			begin
        GridColumns[ Index ].HeadingIndex := -1;
        if GridColumns[ Index ] = CurrentColumn then
          ShowColumn( CurrentColumn );
      end;

  lbxHeadings.Items.Delete( lbxHeadings.ItemIndex );
  if lbxHeadings.Items.Count = 0 then
    lbxHeadings.ItemIndex := -1
  else if Hdg.Index >= lbxHeadings.Items.Count then
    lbxHeadings.ItemIndex := Hdg.Index - 1
  else
    lbxHeadings.ItemIndex := Hdg.Index;
  ShowHeading;

  cmbHeadings.Items.Delete( hdg.Index + 1 );
	Hdg.Free;
end;

procedure TfrmHGColumnsEditor.cmbRowsChange(Sender: TObject);
begin
	tbrRowHeight.Position := Grid.RowHeights[ cmbRows.ItemIndex ];
  edtRowHeight.Text := IntToStr( Grid.RowHeights[ cmbRows.ItemIndex ] );
end;

procedure TfrmHGColumnsEditor.tbrRowHeightChange(Sender: TObject);
begin
	Grid.RowHeights[ cmbRows.ItemIndex ] := tbrRowheight.Position;
  edtRowHeight.Text := IntToStr( Grid.RowHeights[ cmbRows.ItemIndex ] );
end;


procedure TfrmHGColumnsEditor.sbnDeleteColumnClick(Sender: TObject);
var
  Col : ThgColumn;
begin
  Col := CurrentColumn;
  if Col = nil then
		Exit;
  lsvColumns.Items.Delete( lsvColumns.Selected.Index );

  if lsvColumns.Items.Count > 0 then
    if Col.Index >= lsvColumns.Items.Count then
      lsvColumns.Selected := lsvColumns.Items[ Col.Index - 1 ]
    else
      lsvColumns.Selected := lsvColumns.Items[ Col.Index ];

  ShowColumn( CurrentColumn );

  Col.Free;
end;

procedure TfrmHGColumnsEditor.cmbFormatsChange(Sender: TObject);
begin
	case ThgFormatType( cmbFormats.ItemIndex ) of
    hgfmtNone : pgcFormats.ActivePage := tbsNone;
    hgfmtNumeric : pgcFormats.ActivePage := tbsNumeric;
    hgfmtScientific : pgcFormats.ActivePage := tbsScientific;
    hgfmtDateTime : pgcFormats.ActivePage := tbsDateTime;
  end;
	if CurrentColumn = nil then
    Exit;
  CurrentColumn.FormatType := ThgFormatType( cmbFormats.ItemIndex );
end;

procedure TfrmHGColumnsEditor.edtPrefixChange(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
  CurrentColumn.Prefix := edtPrefix.Text;
end;

procedure TfrmHGColumnsEditor.cbxThousandsClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
  CurrentColumn.ThousandsSeparator := cbxThousands.Checked;
end;

procedure TfrmHGColumnsEditor.cbxNegativeClick(Sender: TObject);
begin
	if CurrentColumn = nil then
    Exit;
  CurrentColumn.NegativeParenthesis := cbxNegative.Checked;
end;

procedure TfrmHGColumnsEditor.edtDigitsChange(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
  if not ( Sender is TEdit ) then
    Exit;
	try
		CurrentColumn.Decimals := StrToInt( TEdit( Sender ).Text );
  except
  end;
end;

procedure TfrmHGColumnsEditor.lbxDateFormatsClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
  CurrentColumn.DateFormat := lbxDateFormats.ItemIndex - 1;
end;

procedure TfrmHGColumnsEditor.lbxTimeFormatsClick(Sender: TObject);
begin
  if CurrentColumn = nil then
		Exit;
  CurrentColumn.TimeFormat := lbxTimeFormats.ItemIndex - 1;
end;

procedure TfrmHGColumnsEditor.memHDCaptionChange(Sender: TObject);
begin
{
  if CurrentHeading = nil then
    Exit;
  CurrentHeading.Caption := memHDCaption.Text;
  RefreshHeadingNames;
}
end;

procedure TfrmHGColumnsEditor.edtRowHeightKeyPress(Sender: TObject; var Key: Char);
var
  H : Integer;
begin
	if Ord( Key ) = VK_Return then
    begin
      try
        H := StrToInt( edtRowHeight.Text );
				if H < 0 then
          raise EConvertError.Create( 'Invalid row height' );
        Key := #0;
        Grid.RowHeights[ cmbRows.ItemIndex ] := H;
        tbrRowHeight.Position := H;
				edtRowHeight.SelStart := 0;
        edtRowHeight.SelLength := Length( edtRowHeight.Text );
			except
      end;
    end;
end;


procedure TfrmHGColumnsEditor.lsvColumnsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
	if Change = ctState then
		ShowColumn( CurrentColumn );
end;

procedure TfrmHGColumnsEditor.lsvColumnsEdited(Sender: TObject;Item: TListItem; var S: String);
var
  Col : ThgColumn;
begin
  Col := CurrentColumn;
  if Col = nil then
    Exit;
  try
    Col.Name := S;
	except
    on EhgColumnNameExists do
      begin
				MessageDlg( 'A column by that name already exists.' , mtError , [ mbOk ] , 0 );
        S := Col.Name;
      end;
  end;
end;

procedure TfrmHGColumnsEditor.lsvColumnsDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Source = lbxHeadings then
    Accept := ( lbxHeadings.ItemIndex > -1 )
  else if Source = lsvColumns then
    Accept := True;
end;

procedure TfrmHGColumnsEditor.lsvColumnsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  TargetCol : ThgColumn;

  TargetItem  : TListItem;
  SourceItem  : TListItem;
begin
  if ( Source = lbxHeadings ) then
    begin
			TargetItem := lsvColumns.DropTarget;
      if TargetItem <> nil then
        begin
					TargetCol := ThgColumn( TargetItem.Data );
          TargetCol.HeadingIndex := lbxHeadings.ItemIndex;
          if TargetCol = CurrentColumn then
						ShowColumn( TargetCol );
        end;
    end
  else if Source = lsvColumns then
    begin
      TargetItem := lsvColumns.DropTarget;
      SourceItem := lsvColumns.Selected;

      if ( SourceItem = TargetItem ) or ( SourceItem = nil ) or ( targetItem = nil ) then
        Exit;

			GridColumns.Move( SourceItem.Index , TargetItem.Index );
      TargetCol := ThgColumn( SourceItem.Data );

      lsvColumns.Items.Delete( SourceItem.Index );
      if lsvColumns.GetItemAt( X , Y ) = nil then
        with lsvColumns.Items.Add do
          begin
            Caption := TargetCol.Name;
            Data := TargetCol;
            Selected := True;
          end
      else
        with lsvColumns.Items.Insert( TargetItem.Index ) do
					begin
            Caption := TargetCol.Name;
            Data := TargetCol;
						Selected := True;
          end;
    end;
end;


procedure TfrmHGColumnsEditor.btnDuplicateColumnClick(Sender: TObject);
var
  NewColumn   : ThgColumn;
  SourceCol   : ThgColumn;
  NewName     : string;
begin
  SourceCol := ThgColumn( lsvColumns.Selected.Data );
  NewColumn := GridColumns.Add;
  NewName := NewColumn.Name;
  NewColumn.Assign( SourceCol );
  NewColumn.Name := NewName;
	with lsvColumns.Items.Add do
    begin
      Caption := NewColumn.Name;
      Data := NewColumn;
    end;
end;

procedure TfrmHGColumnsEditor.edtColumnWidthKeyPress(Sender: TObject; var Key: Char);
var
  W : Integer;
  ColIndex : Longint;
begin
  if Ord( Key ) = VK_Return then
    begin
      try
        W := StrToInt( edtColumnWidth.Text );
				Key := #0;
        ColIndex := CurrentGridColumn;
        if ( ColIndex > -1 ) and ( ColIndex < Grid.ColCount ) then
          begin
            Grid.ColWidths[ ColIndex ] := W;
            tbrWidth.Position := W;
					end;
      except
      end;
			edtColumnWidth.SelStart := 0;
			edtColumnWidth.SelLength := Length( edtColumnWidth.Text );
		end;
end;

procedure TfrmHGColumnsEditor.cbxComboDropDownListClick(Sender: TObject);
begin
	if CurrentColumn = nil then
		Exit;
	CurrentColumn.DropDownList := cbxComboDropDownList.Checked;
end;
procedure TfrmhgColumnsEditor.rdbAsCheckBoxClick(Sender: TObject);
begin
	if CurrentColumn = nil then
		Exit;
	CurrentColumn.BooleanStyle	:= hgcbtCheckBox;
	pnlCheckStrings.Visible 		:= false;
end;

procedure TfrmhgColumnsEditor.rdbAsRadioBClick(Sender: TObject);
begin
	if CurrentColumn = nil then
		Exit;
	CurrentColumn.BooleanStyle	:= hgcbtRadio;
	pnlCheckStrings.Visible			:= false;
end;

procedure TfrmhgColumnsEditor.rdbAsUDStringClick(Sender: TObject);
begin
	if CurrentColumn = nil then
		Exit;
	CurrentColumn.BooleanStyle	:= hgcbtString;
	edtStrCheckYes.Text 				:= CurrentColumn.StringAsTrue;
	edtStrCheckNo.Text					:= CurrentColumn.StringAsFalse;
	pnlCheckStrings.Visible 		:= true;
end;

procedure TfrmhgColumnsEditor.edtStrCheckYesExit(Sender: TObject);
var
	Value : String;
begin
	if CurrentColumn = nil then
		Exit;
	try
		Value := edtStrCheckYes.Text;
		if (length(Value) < 1) or (Value= CurrentColumn.StringAsFalse) then
			raise EConvertError.Create( '' );
		CurrentColumn.StringAsTrue := Value;
	except
		MessageDlg(
			'Please enter a String with length greater than or equal to 1'+#13+#10+
			'and different from the UnCheck String',
			mtError , [ mbOk ] , 0 );
		edtStrCheckYes.SetFocus;
	end;
end;

procedure TfrmhgColumnsEditor.edtStrCheckNoExit(Sender: TObject);
var
	Value : String;
begin
	if CurrentColumn = nil then
		Exit;
	try
		Value := edtStrCheckNo.Text;
		if (length(Value) < 1) or (Value= CurrentColumn.StringAsTrue) then
			raise EConvertError.Create( '' );
		CurrentColumn.StringAsFalse := Value;
	except
		MessageDlg(
			'Please enter a String with length greater than or equal to 1'+#13+#10+
			'and different from the Check String',
			mtError , [ mbOk ] , 0 );
		edtStrCheckNo.SetFocus;
	end;
end;

procedure TfrmhgColumnsEditor.rbAsEnteredClick(Sender: TObject);
begin
  if CurrentColumn = nil then
    Exit;
  CurrentColumn.FormatText := ThgFormatTextType((Sender as TRadioButton).tag);
end;

procedure TfrmhgColumnsEditor.FormCreate(Sender: TObject);
begin
	ColorDialog := ThgColorDialog.Create(Self);
end;

end.

