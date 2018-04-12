unit HgEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids , StdCtrls ;

type

  ThgEditStyle = ( esEllipsis, esPickList );
  ThgEditStyles = set of ThgEditStyle;
  TPopupListbox = class;

  ThgHintWindow = class( THintWindow )
  protected
    procedure CMTextChanged( var Message : TMessage ); message CM_TextChanged;
    procedure WMNCPaint(var Message: TMessage);message WM_NCPaint;
    procedure Paint; override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    procedure SetHint( const AHint : string );
    procedure HideWindow;
    constructor Create( AOwner : TComponent ); override;
  end;

  THgInplaceEdit = class(TInplaceEdit)
  private
    FEllipsisWidth  : Integer;
    FButtonWidth: Integer;
    FDataList: TListBox;
    FPickList: TPopupListbox;
    FActiveList: TWinControl;
    FEditStyle: ThgEditStyles;
    FListVisible: Boolean;
    FTracking: Boolean;
    FHintWindow       : ThgHintWindow;
    FEllipsisPressed  : Boolean;
    FComboPressed     : Boolean;

    FEditRect     : TRect;
    FEllipsisRect : TRect;
    FComboRect    : TRect;
    FFullRect     : TRect;
    FCanvas       : TCanvas;

    FCoords       : TGridCoord;
    FInitialText  : string;

    procedure ListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetEditStyle(Value: ThgEditStyles);
    procedure StopTracking;
    procedure TrackButton(X,Y: Integer);
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CancelMode;
    procedure WMCancelMode(var Message: TMessage); message WM_CancelMode;
    procedure WMKillFocus(var Message: TMessage); message WM_KillFocus;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message wm_LButtonDblClk;
    procedure WMPaint(var Message: TWMPaint); message wm_Paint;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SetCursor;
    procedure ShowHintWindow( const AHint : string );
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure BoundsChanged; override;
    procedure CloseUp(Accept: Boolean);
    procedure DoDropDownKeys(var Key: Word; Shift: TShiftState);
    procedure DropDown;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PaintWindow(DC: HDC); override;
    procedure UpdateContents; override;
    procedure WndProc(var Message: TMessage); override;
    property  EditStyle: ThgEditStyles read FEditStyle write SetEditStyle;
    property  ActiveList: TWinControl read FActiveList write FActiveList;
    property  DataList: TListBox read FDataList;
    property  PickList: TPopupListbox read FPickList;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure TextChange;
    function IsAutoSuggestionUp : Boolean;
    procedure AcceptSuggestion;
  end;

{ TPopupListbox }

  TPopupListbox = class(TCustomListbox)
  private
    FSearchText: String;
    FSearchTickCount: Longint;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  end;

implementation

uses HgColumn , HgGrid , HgGlobal , ExtCtrls , HgHGrid;

//------------------------------------------------------------------------------
//  ThgHintWIndow

procedure ThgHintWindow.WMNCPaint(var Message: TMessage);
begin
  inherited;
end;

procedure ThgHintWIndow.CMTextChanged( var Message : TMessage );
var
  R : TRect;
  H : Integer;
begin
  inherited;
  Width := Canvas.TextWidth(Caption) + 8;

  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 2);
  H := DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK or DT_CALCRECT );
  Height := H + 6;

  ShowWindow( Handle , SW_HIDE );
  ShowWindow( Handle , SW_SHOWNOACTIVATE );
end;

procedure ThgHintWindow.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 2);
  Canvas.Font.Color := clInfoText;
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK );
end;

procedure ThgHintWIndow.ActivateHint(Rect: TRect; const AHint: string);
var
  H : Integer;
  R : TRect;
begin
  Caption := AHint;
  Rect.Right := Rect.Left + Canvas.TextWidth( AHint ) + 8;

  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 2);

  H := DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK or DT_CALCRECT );
  Rect.Bottom := Rect.Top + H + 6;
  if RectWidth( R ) > RectWidth( Rect ) then
    Rect.Right := Rect.Left + RectWidth( R );

  BoundsRect := Rect;

  if Rect.Top + Height > Screen.Height then
    Rect.Top := Screen.Height - Height;
  if Rect.Left + Width > Screen.Width then
    Rect.Left := Screen.Width - Width;
  if Rect.Left < 0 then Rect.Left := 0;
  if Rect.Bottom < 0 then Rect.Bottom := 0;

  SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, 0,
    0, SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
end;

procedure ThgHintWindow.SetHint( const AHint : string );
begin
  Caption := AHint;
end;

procedure ThghintWindow.HideWindow;
begin
  if IsWindowVisible( Handle ) then
    ShowWindow( Handle , sw_Hide );
end;

constructor ThgHintWindow.Create( AOwner : TComponent );
begin
  inherited Create( AOwner );
  Color := clInfoBk;
end;

//------------------------------------------------------------------------------
//  TPopupListBox

procedure TPopupListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TPopupListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, wm_SetFocus, 0, 0);
end;

procedure TPopupListbox.Keypress(var Key: Char);
var
  TickCount: Integer;
begin
  case Key of
    #8, #27: FSearchText := '';
    #32..#255:
      begin
        TickCount := GetTickCount;
        if TickCount - FSearchTickCount > 2000 then FSearchText := '';
        FSearchTickCount := TickCount;
        if Length(FSearchText) < 32 then FSearchText := FSearchText + Key;
        SendMessage(Handle, LB_SelectString, WORD(-1), Longint(PChar(FSearchText)));
        Key := #0;
      end;
  end;
  inherited Keypress(Key);
end;

procedure TPopupListbox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  ThgInPlaceEdit(Owner).CloseUp((X >= 0) and (Y >= 0) and
      (X < Width) and (Y < Height));
end;

//------------------------------------------------------------------------------
//  ThgInPlaceEdit

constructor ThgInPlaceEdit.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FCanvas := TCanvas.Create;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  FEllipsisWidth := FButtonWidth;
  FEditStyle := [];
  FHintWindow := ThgHintWindow.Create( Application );
end;

destructor ThgInPlaceEdit.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

procedure ThgInPlaceEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams( Params );
  Params.Style := Params.Style or ES_WANTRETURN or ES_AUTOVSCROLL ;
end;

procedure ThgInPlaceEdit.BoundsChanged;
var
  Column : ThgColumn;
  IsReadOnly : Boolean;
  // bunch of dummy variables used to call GetCellAttributes
  CellState : ThgCellStates;
  DrawInfo : ThgDrawInfo;
  OuterBevel , InnerBevel : TPanelBevel;
  AColor : TColor;
  TextRect : TRect;
begin
  SetRect( FEditRect, 2, 2, Width - 2, Height);
  FFullRect := ClientRect;
  with THyperGrid( Grid ) do
    begin
      Column := VisibleColumns[ Col ];
      GetCellAttributes( Col , Row , Column , [ ] , CellState ,
        AColor , Self.Font , DrawInfo , OuterBevel , InnerBevel );
      DrawCellImage( Col , Row , -1 , FEditRect , False , nil );
      FCoords.X := Col;
      FCoords.Y := Row;
    end;
  Color := AColor;

{
  DrawCheckBox( nil , R , Column.ColumnVAlignment , THyperGrid( Grid ).FOrgCheckBoxBmp , True );
}
  if ( Column.ButtonStyle = hgbstCustom ) and ( Column.ButtonPicture.Graphic <> nil )
    and ( not Column.ButtonPicture.Graphic.Empty ) then
      FEllipsisWidth := Column.ButtonPicture.Width + 4
  else
    FEllipsisWidth := FButtonWidth;

  // Determine the rectangles for the buttons
  if ( esEllipsis in EditStyle ) then
    begin
      FEllipsisRect := FEditRect;
      Dec( FEllipsisRect.Top , 2 );
      Inc( FEllipsisRect.Right , 2 );
      FEllipsisRect.Left := FEllipsisRect.Right - FEllipsisWidth;
    end;
  if ( esPickList in EditStyle ) then
    begin
      FComboRect := FEditRect;
      Dec( FComboRect.Top , 2 );
      Inc( FComboRect.Right , 2 );
      if ( esEllipsis in EditStyle ) then
        FComboRect.Right := FEllipsisRect.Left;
      FComboRect.Left := FComboRect.Right - FButtonWidth;
    end;

  TextRect := FEditRect;
  if esEllipsis in FEditStyle then
    Dec(TextRect.Right, FEllipsisWidth);
  if esPickList in FEditStyle then
    Dec(TextRect.Right, FButtonWidth);

  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@TextRect));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);

  IsReadOnly := Column.ReadOnly;
  if Assigned( THyperGrid( Grid ).OnGetReadOnly ) then
    THyperGrid( Grid).OnGetReadonly( Grid , THyperGrid(Grid).Col ,
      THyperGrid(Grid).Row , IsReadOnly );

  if IsReadOnly then
    SendMessage( Handle , EM_SETREADONLY , 1 , 0 )
  else if ( HgGlobal.hgctlComboBox in Column.ControlType ) and Column.DropDownList then
    SendMessage( Handle , EM_SETREADONLY , 1 , 0 )
  else
    SendMessage( Handle , EM_SETREADONLY , 0 , 0 );
  SendMessage( Handle , EM_SETLIMITTEXT , Column.MaxTextLength , 0 );

{
  if Grid is THyperGrid then
    with Grid as ThyperGrid do
      if not HintFollowsMouse then
        begin
          Coord.X := Col;
          Coord.Y := Row;
          HintCoord := Coord;
        end;
}
end;

procedure ThgInPlaceEdit.CloseUp(Accept: Boolean);
var
  Value : string;
  Column : ThgColumn;
begin
  FHintWindow.HideWindow;
  if FListVisible then
  begin
    if GetCapture <> 0 then
      SendMessage(GetCapture, WM_CANCELMODE, 0, 0);

    if FPickList.ItemIndex <> -1 then
      Value := FPickList.Items[ FPicklist.ItemIndex ]
    else
      Value := '';

    SetWindowPos(FActiveList.Handle, 0, 0, 0, 0, 0,
      SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);

    FListVisible := False;

    Invalidate;

    with THyperGrid( Grid ) do
      Column := VisibleColumns[ Col ];

    if Accept then
      if EditCanModify and ( not Column.ReadOnly ) then
        with THyperGrid(Grid) do
          begin
            Cells[ Col , Row ] := Value;
            DoComboSelection( Col , Row );
          end;
  end;
end;

procedure ThgInPlaceEdit.DoDropDownKeys(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_UP, VK_DOWN:
      if ssAlt in Shift then
      begin
        if FListVisible then CloseUp(True) else DropDown;
        Key := 0;
      end;
    VK_RETURN, VK_ESCAPE:
      if FListVisible and not (ssAlt in Shift) then
      begin
        CloseUp(Key = VK_RETURN);
        Key := 0;
      end;
  end;
end;

procedure ThgInPlaceEdit.ShowHintWindow( const AHint : string );
var
  P : TPoint;
begin
  if Length( Trim( AHint ) ) = 0 then
    FHintWindow.HideWindow
  else
    begin
      if not IsWindowVisible( FHintWindow.Handle ) then
        begin
          P := Point( FEditRect.Left + 4 , FEditRect.Top - ( FHintWindow.Canvas.TextHeight( 'Wg' ) + 8 ) );
          P := ClientToScreen( P );
          FHintWindow.ActivateHint( Rect( P.X , P.Y , 0 , 0 ) , AHint );
        end
      else
        begin
          FHintWIndow.Caption := AHint;
          FHintWindow.Refresh;
        end;
    end;
end;

procedure ThgInPlaceEdit.DropDown;
var
  P: TPoint;
  Y: Integer;
  Column: ThgColumn;
  Value : string;
  Index : Integer;
  MaxWidth : Integer;
begin
  FHintWindow.HideWindow;
  if not FListVisible and Assigned(FActiveList) then
  begin

    with THyperGrid( Grid ) do
      begin
        Column := VisibleColumns[ Col ];
        Value := Trim( Cells[ Col , Row ] );
      end;

    FPickList.Color := Color;
    FPickList.Font := Font ;
    FPickList.Canvas.Font := Font;
    FPickList.Items := Column.Items;

    MaxWidth := RectWidth( FEditRect );
    if esEllipsis in FEditStyle then
      Dec( MaxWidth , FEllipsisWidth );

    if Column.ComboMaxWidth then
      for Index := 0 to Pred( FPickList.Items.Count ) do
        if FpickList.Canvas.TextWidth( FPickList.Items[ Index ] ) > MaxWidth then
          MaxWidth := FPickList.Canvas.TextWidth( FPickList.Items[ Index ] );

    if FPickList.Items.Count >= Column.DropDownCount then
      begin
        FPickList.Height := Column.DropDownCount * FPickList.ItemHeight + 4;
        if Column.ComboMaxwidth then
          Inc( MaxWidth , 16 );
      end
    else
      FPickList.Height := FPickList.Items.Count * FPickList.ItemHeight + 4;

    if ( Column.ComboMaxWidth ) and ( MaxWidth > Width ) then
      Inc( MaxWidth , 4 );
    FActiveList.Width := MaxWidth;

    FPickList.ItemIndex := FPickList.Items.IndexOf( Value );

    P := ClientToScreen(Point( FEditRect.Left , FEditRect.Top ) );
    Y := P.Y + RectHeight( FEditRect );
    if Y + FActiveList.Height > Screen.Height then
      Y := P.Y - FActiveList.Height;
    SetWindowPos(FActiveList.Handle, HWND_TOP, P.X, Y, 0, 0,
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    FListVisible := True;
    Invalidate;
    Windows.SetFocus(Handle);
  end;
end;

procedure ThgInPlaceEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  Msg: TMsg;
begin
  if ( Key = VK_RETURN ) and not ( ssCtrl in Shift )
    and IsWindowVisible( FHintWindow.Handle ) then
    begin
      AcceptSuggestion;
      FHintWindow.HideWindow;
    end;

  if (esEllipsis in EditStyle ) and (Key = VK_RETURN) and (Shift = [ssShift]) then
    begin
      Key := 0;
      if Assigned( THyperGrid(Grid).OnButtonClick ) then
        THyperGrid( Grid ).OnButtonClick( Grid , THyperGrid( Grid ).Col , THyperGrid( Grid ).Row );
      PeekMessage(Msg, Handle, WM_CHAR, WM_CHAR, PM_REMOVE);
    end
  else
    inherited KeyDown(Key, Shift);
end;

procedure ThgInPlaceEdit.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseUp(PtInRect(FActiveList.ClientRect, Point(X, Y)));
end;

procedure ThgInPlaceEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  OnButton : Boolean;
  OnComboButton : Boolean;
begin
  OnButton := False;
  OnComboButton := False;
  if (Button = mbLeft) then
    begin
      if esEllipsis in EditStyle then
        OnButton := PtInRect( FEllipsisRect , Point( X , Y ) );
      if ( esPickList in EditStyle ) and ( not OnButton ) then
        begin
          OnButton := PtInRect( FComboRect , Point( X , Y ) );
          OnComboButton := OnButton;
        end;
    end;

  if OnButton then
    begin
      if FListVisible then
        CloseUp(False)
      else
        begin
          MouseCapture := True;
          FTracking := True;
          TrackButton(X, Y);
          if Assigned(FActiveList) and OnComboButton then
            DropDown;
        end;
    end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure ThgInPlaceEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ListPos: TPoint;
  MousePos: TSmallPoint;
  Coords : TGridCoord;
begin
  if FTracking then
    begin
      TrackButton(X, Y);
      if FListVisible then
        begin
          ListPos := FActiveList.ScreenToClient(ClientToScreen(Point(X, Y)));
          if PtInRect(FActiveList.ClientRect, ListPos) then
            begin
              StopTracking;
              MousePos := PointToSmallPoint(ListPos);
              SendMessage(FActiveList.Handle, WM_LBUTTONDOWN, 0, Integer(MousePos));
              Exit;
            end;
        end;
    end;
  inherited MouseMove(Shift, X, Y);

// Version 1.3 Hint stuff

  if Grid is ThgHintGrid then
    with Grid as ThgHintGrid do
      begin
        if HintFollowsMouse then
          begin
            Coords.X := Col;
            Coords.Y := Row;
            HintCoord := Coords;
          end;
      end;
end;

procedure ThgInPlaceEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  WasPressed: Boolean;
begin
  WasPressed := FEllipsisPressed;
  StopTracking;

  if (Button = mbLeft) and ( esEllipsis in FEditStyle ) and WasPressed then
      if Assigned( THyperGrid(Grid).OnButtonClick ) then
        THyperGrid( Grid ).OnButtonClick( Grid , ThyperGrid( Grid ).Col , ThyperGrid( Grid ).Row );

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure ThgInPlaceEdit.PaintWindow(DC: HDC);
var
  R         : TRect;
//  TR        : TRect;
  Flags     : Integer;
  Column    : ThgColumn;
  VC        : Integer;
  HC        : Integer;
  GHandle   : THandle;
  SaveIndex : Integer;
begin

  SaveIndex := SaveDC( DC );
  FCanvas.Handle := DC;
  with THyperGrid( Grid ) do
    begin
      R := FFullRect;
      Column := VisibleColumns[ Col ];
      DrawCellImage( Col , Row , -1 , R , True , FCanvas );
    end;
  RestoreDC( DC , SaveIndex );

  if FEditStyle <> [] then
    begin
      R := FEllipsisRect;
      Flags := 0;
      if esEllipsis in FEditStyle then
        begin
          case Column.ButtonStyle of
            hgbstEllipsis :
              begin
                if FEllipsisPressed then
                  Flags := BF_FLAT;
                DrawEdge(DC, R, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
                HC := R.Left + ( RectWidth( R ) shr 1 ) - 1 + Ord(FEllipsisPressed);
                VC := R.Top + ( RectHeight( R ) shr 1 ) - 1 + Ord(FEllipsisPressed);
                PatBlt(DC, HC , VC, 2, 2, BLACKNESS);
                PatBlt(DC, HC - 4, VC, 2, 2, BLACKNESS);
                PatBlt(DC, HC + 4, VC, 2, 2, BLACKNESS);
              end;
            hgbstDropDown :
              begin
                if FEllipsisPressed then
                  Flags := DFCS_FLAT or DFCS_PUSHED;
                DrawFrameControl(DC, R, DFC_SCROLL, Flags or DFCS_SCROLLCOMBOBOX);
              end;
            hgbstCustom :
              begin
                if Column.DrawButtonFace then
                  begin
                    if FEllipsisPressed then
                      Flags := BF_FLAT;
                    DrawEdge(DC, R, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
                  end
                else
                  begin
                    ThyperGrid( Grid ).Canvas.Brush.Style := bsSolid;
                    ThyperGrid( Grid ).Canvas.Brush.Color := Self.Color;
                    Windows.FillRect( DC , R , ThyperGrid( Grid ).Canvas.Brush.Handle );
                  end;

                if  ( Column.ButtonPicture.Graphic <> nil ) and ( not Column.ButtonPicture.Graphic.Empty ) then
                  begin
                    case Column.ButtonVAlignment of
                      hgvaTop    : VC := R.Top + Ord(FEllipsisPressed) + 2;
                      hgvaCenter : VC := R.Top  + ( ( RectHeight( R ) - Column.ButtonPicture.Graphic.Height ) div 2 ) + 2 + Ord(FEllipsisPressed);
                      hgvaBottom : VC := R.Bottom - 2 - Column.ButtonPicture.Graphic.Height + Ord(FEllipsisPressed);
                      else
                        VC := 0;
                    end;
                    if Column.ButtonPicture.Graphic is TIcon then
                      begin
                        Flags := DST_ICON;
                        GHandle := Column.ButtonPicture.Icon.Handle
                      end
                    else
                      begin
                        Flags := DST_BITMAP;
                        GHandle := Column.ButtonPicture.Bitmap.Handle;
                      end;
                    DrawState( DC , 0 , nil , GHandle , 0 ,
                      R.Left + Ord(FEllipsisPressed) + 2 , VC , 0 , 0 , Flags or DSS_NORMAL );
                  end;
              end;
          end;
        end;

      // Draw combo button
      if esPickList in FEditSTyle then
        begin
          Flags := 0;
          if FActiveList = nil then
            Flags := DFCS_INACTIVE
          else if FComboPressed then
            Flags := DFCS_FLAT or DFCS_PUSHED;
          DrawFrameControl(DC, FComboRect , DFC_SCROLL, Flags or DFCS_SCROLLCOMBOBOX);
        end;

      // Tell the edit to exclude this rectangle from its clipping rectangle
      if esEllipsis in EditStyle then
        R := FEllipsisRect;
      if esPickList in FEditStyle then
        begin
          if esEllipsis in EditStyle then
            R.Left := FComboRect.Left
          else
            R := FComboRect;
        end;
      ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);

    end;
  inherited PaintWindow(DC);
end;

procedure ThgInPlaceEdit.SetEditStyle( Value : ThgEditStyles );
begin
  if Value = FEditStyle
    then Exit;

  FEditStyle := Value;

  if esPickList in FEditStyle then
    begin
      if FPickList = nil then
        begin
          FPickList := TPopupListbox.Create(Self);
          FPickList.Visible := False;
          FPickList.Parent := Self;
          FPickList.OnMouseUp := ListMouseUp;
          FPickList.IntegralHeight := True;
          FPickList.ItemHeight := 11;
        end;
      FActiveList := FPickList;
    end
  else
    FActiveList := nil;
  Repaint;
end;

procedure ThgInPlaceEdit.StopTracking;
begin
  if FTracking then
    begin
      TrackButton(-1, -1);
      FTracking := False;
      MouseCapture := False;
    end;
end;

procedure ThgInPlaceEdit.TrackButton(X,Y: Integer);
var
  NewState: Boolean;
//  R: TRect;
begin
  if ( esEllipsis in FEditStyle ) then
    begin
      NewState := PtInRect( FEllipsisRect , Point( X , Y ) );
      if FEllipsisPressed <> NewState then
        begin
          FEllipsisPressed := NewState;
          InvalidateRect( Handle , @FEllipsisRect , False );
        end;
    end;

  if ( esPickList in FEditStyle ) then
    begin
      NewState := PtInRect( FComboRect , Point( X , Y ) );
      if FComboPressed <> NewState then
        begin
          FComboPressed := NewState;
          InvalidateRect( Handle , @FComboRect , False );
        end;
    end;
end;

procedure ThgInPlaceEdit.UpdateContents;
var
  Column: THgColumn;
begin
  with THyperGrid(Grid) do
    Column := VisibleColumns[ Col ];

  EditStyle := [];
  if hgctlButton in Column.ControlType then
    EditStyle := [ esEllipsis ];
  if hgctlComboBox in Column.ControlType then
    EditStyle := EditStyle + [ esPickList ];

  inherited UpdateContents;
  FInitialText := Text;
end;

procedure ThgInPlaceEdit.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FActiveList) then
    begin
      AcceptSuggestion;
      CloseUp(False);
    end;
end;

procedure ThgInPlaceEdit.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure ThgInPlaceEdit.WMKillFocus(var Message: TMessage);
begin
  with THyperGrid( Grid ) do
    begin
      if Text <> FInitialText then
        DoCellEdited( FCoords.X , FCoords.Y );
    end;
  inherited;
  CloseUp(False);
end;

procedure ThgInPlaceEdit.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  with Message do
    begin
      if ( esEllipsis in FEditStyle ) then
        begin
          if PtInRect( FEllipsisRect ,Point( Xpos , YPos ) ) then
            Exit;
  {
          if PtInRect( Rect( Width - FEllipsisWidth , 0 , Width , Height ) , Point( Xpos , YPos ) ) then
            Exit;
          if esPickList in FEditStyle then
            if PtInRect( Rect( Width - FEllipsisWidth - FButtonWidth , 0 , Width , Height ) , Point( Xpos , YPos ) ) then
              Exit;
  }
        end;
      if esPickList in FEditStyle then
        begin
          if PtInRect( FComboRect , Point( Xpos , YPos ) ) then
            Exit;
  {
          if PtInRect( Rect( Width - FButtonWidth , 0 , Width , Height ) , Point( Xpos , YPos ) ) then
            Exit;
  }
        end;
    end;
  inherited;
end;

procedure ThgInPlaceEdit.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure ThgInPlaceEdit.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
  ArrowCursor : Boolean;
begin
  GetCursorPos(P);
  ArrowCursor := False;
  if ( esEllipsis in FEditStyle ) then
    ArrowCursor := PtInRect( FEllipsisRect , ScreenToClient(P) );
  if not ArrowCursor and ( esPickList in EditStyle ) then
    ArrowCursor := PtInRect( FComboRect , ScreenToClient(P) );
  if not ArrowCursor then
    ArrowCursor := not PtInRect( FEditRect , ScreenToClient(P) );
  if ArrowCursor then
    Windows.SetCursor(LoadCursor(0, idc_Arrow))
  else
    inherited;
end;

procedure ThgInPlaceEdit.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    wm_KeyDown, wm_SysKeyDown, wm_Char:
      begin
        if esPickList in EditStyle then
          with TWMKey(Message) do
            begin
              DoDropDownKeys(CharCode, KeyDataToShiftState(KeyData));
              if (CharCode <> 0) and FListVisible then
                begin
                  with TMessage(Message) do
                    SendMessage(FActiveList.Handle, Msg, WParam, LParam);
                  Exit;
                end;
            end;
      end;
  end;
  inherited;
end;

procedure ThgInPlaceEdit.TextChange;
var
  Index : Integer;
  Column : ThgColumn;
  Value : string;
  EText : string;
  HyperGrid : THyperGrid;
  Suggestion : string;
begin
  HyperGrid := Grid as THyperGrid;
  Column := HyperGrid.VisibleColumns[ HyperGrid.Col ];
  if ( esPickList in EditStyle ) and ( Column.AutoSuggest ) then
    begin
      EText := UpperCase( Trim( Text ) );
      Value := '';

      if Length( EText ) > 0 then
        begin
          for Index := 0 to Pred( Column.Items.Count ) do
            if StringBeginsWith( EText , UpperCase( Column.Items[ Index ] ) )then
              begin
                Value := Column.Items[ Index ];
                Break;
              end;
        end;
      if ( Length( Value ) > 0 ) and ( Value <> Text ) then
        ShowHintWindow( Value )
      else
        FHintWindow.HideWindow;
    end
  else if Assigned( HyperGrid.OnGetSuggestion ) then
    begin
      Suggestion := '';
      HyperGrid.OnGetSuggestion( HyperGrid , HyperGrid.Col , HyperGrid.Row , Text ,
        Suggestion );
      if Length( Suggestion ) > 0 then
        ShowHintWindow( Suggestion )
      else
        FHintWindow.HideWindow;
    end;

end;

function ThgInPlaceEdit.IsAutoSuggestionUp : Boolean;
begin
  if FHintWIndow = nil then
    Result := False
  else
    Result := IsWindowVisible( FHintWindow.Handle );
end;

procedure ThgInPlaceEdit.AcceptSuggestion;
begin
  if IsAutoSuggestionUp then
    begin
      Text := FHintWindow.Caption;
      with THyperGrid( Grid ) do
        begin
          Cells[ Col , Row ] := Text;
          if ( esPickList in EditStyle ) then
            DoComboSelection( Col , Row );
        end;
    end;
end;


end.

