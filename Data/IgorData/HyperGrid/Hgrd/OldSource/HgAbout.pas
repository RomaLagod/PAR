unit HgAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons;

type

  TfrmHgAbout = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    lblVersion: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure HandleNCHitTest( var msg : TWMNCHitTest ); message wm_NCHitTest;
  end;


implementation

{$R *.DFM}

procedure TfrmHgAbout.FormCreate(Sender: TObject);
var
  R : HRGN;
begin
  R := CreateRoundRectRgn( 0 , 0 , Width , Height , 50, 50 );
  SetWindowRgn( Handle , R , True );
end;

procedure TfrmHgAbout.HandleNCHitTest( var msg : TWMNCHitTest );
begin
  msg.Result := htCaption;
end;

procedure TfrmHgAbout.Panel1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmHgAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
