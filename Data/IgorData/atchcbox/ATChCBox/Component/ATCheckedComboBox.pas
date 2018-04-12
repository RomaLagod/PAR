unit ATCheckedComboBox;

interface
{
  History
  7/10/2004 Corrected to work also for delphi 6 and 7
}


{$ifdef VER130}
   {$define DELPHI_4_UP}
{$endif}

{$ifdef VER150}
   {$define DELPHI_4_UP}
   {$define DELPHI_5_UP}
{$endif}

{$ifdef VER140}
  {$define DELPHI_4_UP}
  {$define DELPHI_5_UP}
{$endif}

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls;
type

	TATCBQuoteStyle   = (qsNone,qsSingle,qsDouble);

	TATCheckedComboBox = class(TCustomComboBox)
	private
		{ Private declarations }
		FListInstance	: Pointer;
		FDefListProc	: Pointer;
		FListHandle 	: HWnd;
		FQuoteStyle		: TATCBQuoteStyle;
		FColorNotFocus: TColor;
		FCheckedCount : integer;
		FTextAsHint 	: boolean;
		FOnCheckClick : TNotifyEvent; // ver 1.1
		FVersion  		: String;					// ver 1.1
		procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
		procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
		procedure CMExit(var Message: TCMExit); message CM_EXIT;
		procedure ListWndProc(var Message: TMessage);
		procedure SetColorNotFocus(value:TColor);
		procedure SetVersion(value:String);	// version 1.1;
	protected
		{ Protected declarations }
		m_strText 			: string;
		m_bTextUpdated	: boolean;
		procedure WndProc(var Message: TMessage);override;
		procedure RecalcText;
		function GetText: string;
		function GetCheckedCount:integer;
	public
		{ Public declarations }
		constructor Create(AOwner: TComponent);override;
		destructor 	Destroy; override;
		procedure 	SetCheck(nIndex:integer;checked:boolean);
		function	 	AddChecked(value:string;checked:boolean):integer;
		function 		IsChecked(nIndex: integer):boolean;
		procedure 	CheckAll(checked:boolean);
		property 		Text:string read GetText;
		property		CheckedCount :integer read GetCheckedCount;
	published
		{ Published declarations }
		property Anchors;
		property BiDiMode;
		property Color;
		property ColorNotFocus : TColor	read FColorNotFocus write SetColorNotFocus;
		property Constraints;
		property Ctl3D;
		property DragCursor;
		property DragKind;
		property DragMode;
		property DropDownCount;
		property Enabled;
		property Font;
		property ImeMode;
		property ImeName;
		property ItemHeight;
		property Items;
		property MaxLength;
		property ParentBiDiMode;
		property ParentColor;
		property ParentCtl3D;
		property ParentFont;
		property ParentShowHint;
		property PopupMenu;
		property QuoteStyle	: TATCBQuoteStyle read FQuoteStyle	write FQuoteStyle default qsNone;
		property ShowHint;
		property ShowTextAsHint : Boolean read FTextAsHint write FTextAsHint default true;
		property Sorted;
		property TabOrder;
		property TabStop;
		property Visible;
		property Version :string read FVersion write SetVersion; // ver 1.1
		property OnChange;
		property OnCheckClick: TNotifyEvent read FOnCheckClick write FOnCheckClick;
		property OnClick;
		property OnDblClick;
		property OnDragDrop;
		property OnDragOver;
		property OnDropDown;
		property OnEndDock;
		property OnEndDrag;
		property OnEnter;
		property OnExit;
		property OnKeyDown;
		property OnKeyPress;
		property OnKeyUp;
		property OnStartDock;
		property OnStartDrag;
	end;

procedure Register;

implementation

{ TATCheckedComboBox }
procedure Register;
begin
	RegisterComponents('Samples', [TATCheckedComboBox]);
end;

var
	FCheckWidth, FCheckHeight: Integer;

procedure GetCheckSize;
begin
	with TBitmap.Create do
		try
			Handle := LoadBitmap(0, PChar(32759));
			FCheckWidth := Width div 4;
			FCheckHeight := Height div 3;
		finally
			Free;
		end;
end;

procedure TATCheckedComboBox.SetVersion(value: String);
begin
	// read only
end;

procedure TATCheckedComboBox.SetCheck(nIndex:integer;checked:boolean);
begin
	if (nIndex>-1) and (nIndex<Items.count) then
	begin
		Items.Objects[nIndex] := TObject(checked);
		m_bTextUpdated := FALSE;
		Invalidate;
		if Assigned(FOnCheckClick) then
			OnCheckClick(self)
	end;
end;

function TATCheckedComboBox.AddChecked(value:string;checked:boolean):integer;
begin
	result := Items.AddObject(value, TObject(checked));
	if result>=0 then
	begin
		m_bTextUpdated := FALSE;
		Invalidate;
	end;
end;

function TATCheckedComboBox.IsChecked(nIndex: integer):boolean;
begin
	result := false;
	if (nIndex>-1) and (nIndex<Items.count) then
		result := Items.Objects[nIndex] = TObject(TRUE)
end;

procedure TATCheckedComboBox.CheckAll(checked:boolean);
var i:integer;
begin
	for i:= 0 to Items.count-1 do
		Items.Objects[i] := TObject(checked);
end;

//=========================================
function GetFormatedText(kind:TATCBQuoteStyle;str:string):string;
var s : string;
begin
	result := str;
	if length(str)>0 then
	begin
		s := str;
		case kind of
			qsSingle	: result :=
					''''+
					StringReplace(S, ',', ''',''',[rfReplaceAll])+
					'''';
			qsDouble 	: result :=
					'"'+
					StringReplace(S, ',', '","',[rfReplaceAll])+
					'"';
		end;
	end;
end;

function TATCheckedComboBox.GetText: string;
begin
	RecalcText;
	if FQuoteStyle = qsNone then
		result := m_strText
	else
		result := GetFormatedText(FQuoteStyle,m_strText);
end;

function TATCheckedComboBox.GetCheckedCount:integer;
begin
	RecalcText;
	result := FCheckedCount;
end;

//
// This routine steps through all the items and builds
// a string containing the checked items
//
procedure TATCheckedComboBox.RecalcText;
var
		nCount,i 	: integer;
		strItem,
		strText,
		strSeparator : string;
begin
	if (not m_bTextUpdated) then
	begin
		FCheckedCount	:= 0;
		nCount    		:= items.count;
		strSeparator 	:= ',';
		strText 			:= '';
		for i := 0 to nCount - 1 do
			if IsChecked(i) then
			begin
				inc(FCheckedCount);
				strItem := items[i];
				if (strText<>'') then
					strText := strText + strSeparator;
				strText := strText + strItem;
			end;
		// Set the text
		m_strText 			:= strText;
		if FTextAsHint then
			Hint := m_strText;
		m_bTextUpdated 	:= TRUE;
	end;
end;

procedure TATCheckedComboBox.SetColorNotFocus(value:TColor);
begin
	if FColorNotFocus <> Value then
		FColorNotFocus := Value;
	Invalidate
end;

procedure TATCheckedComboBox.CMEnter(var Message: TCMEnter);
begin
	Self.Color		:= clWhite;
	if Assigned(OnEnter) then OnEnter(Self);
end;

procedure TATCheckedComboBox.CMExit(var Message: TCMExit);
begin
	Self.Color		 := FColorNotFocus;
	if Assigned(OnExit) then OnExit(Self);
end;

//========================
procedure TATCheckedComboBox.CNDrawItem(var Message: TWMDrawItem);
var
	State						: TOwnerDrawState;
	rcBitmap,rcText	: Trect;
	nCheck					: integer; // 0 - No check, 1 - Empty check, 2 - Checked
	nState 					: integer;
	strText 				: string;
	ItId						: Integer;
	dc							: HDC;
begin
	with Message.DrawItemStruct^ do
	begin
{$IFDEF DELPHI_4_UP}  // Delphi 5,6,7
		State 		:= TOwnerDrawState(LongRec(itemState).Lo);
{$ELSE}
		State 		:= TOwnerDrawState(WordRec(LongRec(itemState).Lo).Lo);
{$ENDIF}
		dc 				:= hDC;
		rcBitmap	:= rcItem;
		rcText  	:= rcItem;
		ItId			:= itemID;
	end;
	// Check if we are drawing the static portion of the combobox
	if (itID < 0) then
	begin
		RecalcText();
		strText := m_strText;
		nCheck  := 0;
	end
	else
	begin
		strtext 				:= Items[ItId];
		rcBitmap.Left 	:= 2;
		rcBitmap.Top 		:= rcText.Top + (rcText.Bottom - rcText.Top - FCheckWidth) div 2;
		rcBitmap.Right 	:= rcBitmap.Left + FCheckWidth;
		rcBitmap.Bottom := rcBitmap.Top + FCheckHeight;

		rcText.left := rcBitmap.right;
		nCheck := 1;
		if IsChecked(ItId) then
			inc(nCheck);
	end;
	if (nCheck > 0) then
	begin
		SetBkColor(dc, GetSysColor(COLOR_WINDOW));
		SetTextColor(dc, GetSysColor(COLOR_WINDOWTEXT));
		nState := DFCS_BUTTONCHECK;
		if (nCheck > 1) then
			nState := nState or DFCS_CHECKED;
		DrawFrameControl(dc, rcBitmap, DFC_BUTTON, nState);
	end;
	if (odSelected in State) then
	begin
		SetBkColor(dc, GetSysColor(COLOR_HIGHLIGHT));
		SetTextColor(dc, GetSysColor(COLOR_HIGHLIGHTTEXT));
	end
	else
	begin
		if (nCheck=0) then
		begin
			SetTextColor(dc, ColorToRGB(Font.Color));
			SetBkColor(dc, ColorToRGB(FColorNotFocus));
		end
		else
		begin
			SetTextColor(dc, ColorToRGB(Font.Color));
			SetBkColor(dc, 	 ColorToRGB(Brush.Color));
		end;
	end;
	if itID >= 0 then
		strText := ' ' + strtext;
	ExtTextOut(dc, 0, 0, ETO_OPAQUE, @rcText, Nil, 0, Nil);
	DrawText(dc, pchar(strText), Length(strText), rcText, DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS);
	if odFocused in State then DrawFocusRect(dc, rcText);
end;

 //DefWindowProc
procedure TATCheckedComboBox.ListWndProc(var Message: TMessage);
var
	nItemHeight, nTopIndex, nIndex: Integer;
	rcItem,rcClient: TRect;
	pt 				 : TPoint;
begin
	case Message.Msg of
		LB_GETCURSEL : // this is for to not draw the selected in the text area
			begin
				Message.result := -1;
				exit;
			end;
		WM_CHAR: // pressing space toggles the checked 
			begin
				if (TWMKey(Message).CharCode = VK_SPACE) then
				begin
					// Get the current selection
					nIndex := CallWindowProcA(FDefListProc, FListHandle, LB_GETCURSEL,Message.wParam, Message.lParam);
					SendMessage(FListHandle, LB_GETITEMRECT, nIndex, LongInt(@rcItem));
					InvalidateRect(FListHandle, @rcItem, FALSE);
					SetCheck(nIndex, not IsChecked(nIndex));
					SendMessage(WM_COMMAND, handle, CBN_SELCHANGE,handle);
					Message.result := 0;
					exit;
				end
			end;
		WM_LBUTTONDOWN:
			begin
				Windows.GetClientRect(FListHandle, rcClient);
				pt.x := TWMMouse(Message).XPos; //LOWORD(Message.lParam);
				pt.y := TWMMouse(Message).YPos; //HIWORD(Message.lParam);
				if (PtInRect(rcClient, pt)) then
				begin
					nItemHeight := SendMessage(FListHandle, LB_GETITEMHEIGHT, 0, 0);
					nTopIndex   := SendMessage(FListHandle, LB_GETTOPINDEX, 0, 0);
					// Compute which index to check/uncheck
					nIndex := trunc(nTopIndex + pt.y / nItemHeight);
					SendMessage(FListHandle, LB_GETITEMRECT, nIndex, LongInt(@rcItem));
					if (PtInRect(rcItem, pt)) then
					begin
						InvalidateRect(FListHandle, @rcItem, FALSE);
						SetCheck(nIndex, not IsChecked(nIndex));
						SendMessage(WM_COMMAND, handle, CBN_SELCHANGE,handle);
					end
				end
			end;
		WM_LBUTTONUP:
			begin
				Message.result := 0;
				exit;
			end;
	end;
	ComboWndProc(Message, FListHandle, FDefListProc);
end;

constructor TATCheckedComboBox.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	ShowHint				:= true;
	Fversion				:= '1.2';
	FTextAsHint 		:= true;
	ParentShowHint  := False;
	FListHandle 		:= 0;
	FQuoteStyle 		:= qsNone;
	FColorNotFocus	:= clInfoBk;
	Style 					:= csOwnerDrawVariable;
	m_bTextUpdated  := FALSE;
	FListInstance 	:= MakeObjectInstance(ListWndProc);
end;

destructor TATCheckedComboBox.Destroy;
begin
	FreeObjectInstance(FListInstance);
	inherited Destroy;
end;

procedure TATCheckedComboBox.WndProc(var Message: TMessage);
var lWnd :  HWND;
begin
	if message.Msg = WM_CTLCOLORLISTBOX then
	begin
		// If the listbox hasn't been subclassed yet, do so...
		if (FListHandle = 0) then
		begin
			lwnd := message.LParam;
   {$ifdef DELPHI_5_UP}
			if (lWnd <> 0) and (lWnd <> FDropHandle) then
   {$else}
			if (lWnd <> 0) and (lWnd <> GetComboControl) then
   {$endif}
			begin
				// Save the listbox handle
				FListHandle := lWnd;
				FDefListProc := Pointer(GetWindowLong(FListHandle, GWL_WNDPROC));
				SetWindowLong(FListHandle, GWL_WNDPROC, Longint(FListInstance));
			end;
		end;
	end;
	inherited;
end;

initialization
	GetCheckSize;

end.
