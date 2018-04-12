unit HgHGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids , ExtCtrls , HgEdit , HgGlobal;

type

  ThgOnShowCellHint = procedure( Sender : TObject; Col , Row : Longint;
		var Hint : string; var TopLeft : TPoint ) of object;

  THgHintGrid = class(TStringGrid)
  private
    FFormsWndProc : Pointer;
    FMyWndProc    : Pointer;
    FMouseInGrid  : Boolean;
    FHintCoord    : TGridCoord;
    FIsHintUp     : Boolean;
    FHintWindow   : ThgHintWindow;
    FHintTimer    : TTimer;
    FHintTicks    : Integer;
    FHooked       : Boolean;
    procedure SetHintCoord( NewCoord : TGridCoord );
    procedure MoveHint;
    function ShouldHintBeUp : Boolean;
    function HintHook( var Message : TMessage ) : Boolean;
    procedure ReplacedWndProc( var Message : TMessage );
    procedure OnHintTimer( Sender : TObject );
  private
		FFollowMouse : Boolean;
		FOnShowCellHint : ThgOnShowCellHint;
	protected
		function HgMouseCoord( X , Y : Integer ) : TGridCoord;
		procedure ShowTheHint( ShowIt : Boolean );
		procedure CMMouseEnter( var Msg : TMessage ); message CM_MouseEnter;
		procedure CMMouseLeave( var Msg : TMessage ); message CM_MouseLeave;
		procedure MouseMove( Shift : TShiftState; X , Y : Integer );override;
    procedure SetParent( AParent : TWinControl ); override;
    procedure DoEnter; override;
		procedure CMCancelMode( var Message : TCmCancelMode ); message CM_CancelMode;
  public
    property HintCoord : TGridCoord read FHintCoord write SetHintCoord;
    constructor Create( AOwner : TComponent );override;
    destructor Destroy; override;
  published
    property HintFollowsMouse : Boolean read FFollowMouse write FFollowMouse default True;
    property OnShowCellHint : ThgOnShowCellHint read FOnShowCellHint write FOnSHowCellHint;
  end;

implementation

constructor ThgHintGrid.Create( AOwner : TComponent );
begin
  inherited Create( AOwner );
  FHintTimer := TTimer.Create( Self );
  with FHintTimer do
    begin
      Enabled := False;
      Interval := hgHintTimerTickInterval;
      OnTimer := OnHintTimer;
    end;
  FHintTicks := hgTicksToShowHint;
  FMouseInGrid := False;
	FIsHintUp := False;
  FHintCoord.X := -1;
  FHintCoord.Y := -1;
	FMyWndProc := Forms.MakeObjectInstance( ReplacedWndProc );
  FFormsWndProc := nil;
  FHooked := False;
  if ComponentState = [] then
		begin
      FHooked := True;
      FHintWindow := ThgHintWindow.Create( Application );
      Application.HookMainWindow( HintHook );
    end;
  FFollowMouse := True;
end;

destructor ThgHintGrid.Destroy;
begin
  if FHooked then
    Application.UnhookMainWindow( HintHook );
{
  if ( FFormsWndProc <> nil ) and ( GetParentForm( Self ) <> nil ) then
    SetWindowLong( ValidParentForm( Self ).Handle , GWL_WNDPROC , Longint( FFormsWndProc ) );
}
  Forms.FreeObjectInstance( FMyWndProc );
  inherited Destroy;
end;

procedure ThgHintGrid.SetParent( AParent : TWinControl );
begin
  inherited SetParent( AParent );
{
	if not ( csDesigning in ComponentState ) and ( GetParentForm( Self ) <> nil ) and ( FFormsWndProc = nil ) then
    begin
      FFormsWndProc := Pointer( GetWindowLong( ValidParentForm( Self ).Handle , GWL_WNDPROC ) );
      SetWindowLong( ValidParentForm( Self ).Handle , GWL_WNDPROC , Longint( FMyWndProc ) );
    end;
}
end;

//------------------------------------------------------------------------------
//  TCustomGrid.MouseCoord returns (0,0) if X or Y are negative, this function
//  wraps it to return negative ccordinates

function ThgHintGrid.HgMouseCoord( X , Y : Integer ) : TGridCoord;
begin
  if ( X < 0 ) or ( Y < 0 ) then
    begin
      Result.X := -1;
      Result.Y := -1;
    end
  else
    Result := MouseCoord( X , Y );
end;

function ThgHintGrid.ShouldHintBeUp : Boolean;
begin
  Result :=
    ( Parent <> nil ) and
    ( ValidParentForm( Self ).Active ) and
    ( FHintCoord.X >= 0 ) and ( FHintCoord.X < ColCount ) and
    ( FHintCoord.Y >= 0 ) and ( FHintCoord.Y < RowCount ) and
    ( ComponentState = [] );

  if not HintFollowsMouse then
    Result := Result and ( Focused or InPlaceEditor.Focused )
  else
    Result := Result and FMouseInGrid;
end;

procedure ThgHintGrid.ShowTheHint( ShowIt : Boolean );
begin
  if not ( ComponentState = [] ) then
    Exit;

  if ShowIt and ShouldHintBeUp then
    begin
      FHintTicks := hgTicksToShowHint;
      FHintTimer.Enabled := True;
    end
  else
    begin
      FHintWindow.HideWindow;
      FIsHintUp := False;
      FHintTimer.Enabled := False;
    end;
end;

procedure ThgHintGrid.MoveHint;
begin
  ShowTheHint( False );
  ShowTheHint( True );
end;

procedure ThgHintGrid.SetHintCoord( NewCoord : TGridCoord );
begin
  if ( NewCoord.X <> FHintCoord.X ) or ( NewCoord.Y <> FHintCoord.Y ) then
    begin
      FHintCoord := NewCoord;
      MoveHint;
    end;
end;

procedure ThgHintGrid.CMMouseEnter( var Msg : TMessage );
begin
  inherited;
  FMouseInGrid := True;
  ShowTheHint( True );
end;

procedure ThgHintGrid.CMMouseLeave( var Msg : TMessage );
var
   P : TPoint;
begin
  inherited;
  // In case the mouse leaves the grid , but goes to a component that is on top
  // of the grid, we check to make sure it is still within the grid's client
  // rectangle
  GetCursorPos( P );
  P := ScreenToClient( P );
  FMouseInGrid := PtInRect( ClientRect , P );
  if not FMouseInGrid and HintFollowsMouse then
    ShowTheHint( False );
end;

procedure ThgHintGrid.MouseMove( Shift : TShiftState; X , Y : Integer );
begin
  inherited MouseMove( Shift , X , Y );
  if HintFollowsMouse then
    HintCoord := hgMouseCoord( X , Y );
end;

procedure ThgHintGrid.DoEnter;
begin
  inherited;
  if not HintFollowsMouse then
    ShowTheHint( True );
end;

function ThgHintGrid.HintHook( var Message : TMessage ) : Boolean;
begin
  Result := False;
  case Message.Msg of
    CM_Deactivate : ShowTheHint( False );
    CM_Activate   : ShowTheHint( True );
  end;
end;

procedure ThgHintGrid.ReplacedWndProc( var Message : TMessage );
begin
  with Message do
    begin
      case Msg of
        WM_EnterMenuLoop  : ShowThehint( False );
        WM_ExitMenuLoop   : ShowTheHint( True );
      end;
			Result := CallWindowProc( FFormsWndProc, Handle , Msg, WParam, LParam);
    end;
end;

procedure ThgHintGrid.OnHintTimer( Sender : TObject );
var
  R : TRect;
	P : TPoint;
	Hint : string;
begin
	Dec( FHintTicks );
	if FHintTicks = 0 then
		begin
			R := CellRect( HintCoord.X , HintCoord.Y );
			P := Point( R.Right , R.Top - RectHeight( R ) );
			P := ClientToScreen( P );
			if Assigned( FOnShowCellHint ) then
				begin
					Inc( P.Y , 4 );
					FOnShowCellHint( Self , HintCoord.X , HintCoord.Y , Hint , P );
					if Length( Trim( Hint ) ) > 0 then
						begin
							FHintWindow.Activatehint( Rect( P.X , P.Y , 0 , 0 ) , Hint );
							FIsHintUp := True;
							FHintTimer.Enabled := False;
						end;
				end;
		end;
end;

procedure ThgHintGrid.CMCancelMode( var Message : TCmCancelMode );
begin
	inherited;
	with Message do
		if ( Sender <> Self  ) and ( Sender <> InPlaceEditor ) and not HintFollowsMouse and FIsHintUp then
			ShowTheHint( False );
end;

end.
