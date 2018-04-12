unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ExtCtrls, OleCtrls, Chartfx3;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    Memo1: TMemo;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    N8: TMenuItem;
    N9: TMenuItem;
    PopupMenu2: TPopupMenu;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    CheckBox4: TCheckBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    Edit4: TEdit;
    GroupBox3: TGroupBox;
    Edit5: TEdit;
    GroupBox4: TGroupBox;
    Edit6: TEdit;
    Chartfx1: TChartfx;
    Button1: TButton;
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.N4Click(Sender: TObject);
begin
Memo1.Clear
end;

procedure TForm1.N6Click(Sender: TObject);
begin
Close
end;

procedure TForm1.N7Click(Sender: TObject);
begin
Memo1.Clear
end;

procedure TForm1.N3Click(Sender: TObject);
Var x,y,y1,h,a,b:real;
    str1,str2,str3:string;
    kkt,lich,pofx:integer;
    max,min:real;
    masiv: array [0..100] of real;
begin
 If CheckBox4.Checked then
   Memo1.Lines.Add('     X          F(X)      F`(X)')
 else
   Memo1.Lines.Add('     X          F(X)');
 a:=StrToFloat(Edit1.Text);
 b:=StrToFloat(Edit2.Text);
 h:=StrToFloat(Edit3.Text);
  x:=a; kkt:=0; max:=-0; min:=-0; lich:=0;
  pofx:=trunc((b-a)/h)+1;
  ChartFx1.OpenDataEx(Cod_Values,0,pofx);
   while x<=b{+h/2} do
    Begin
     y:=sin(x)+1;
     y1:=cos(x);
     ChartFx1.Value[lich]:=y;
     if max = -0 then max:=y;
     if min = -0 then min:=y;
     If (y>0.5) and (y<1) then kkt:=kkt+1;
     if y > max then max:=y;
     if y < min then min:=y;
      if CheckBox4.Checked then
       begin
        Str(x:8:2,str1);
        Str(y:8:3,str2);
        Str(y1:8:2,str3);
        str3:=str1 + str2 + str3;
       end
      else Begin
            Str(x:8:2,str1);
            Str(y:8:3,str2);
            Str3:=Str1+Str2;
           end;
      If CheckBox1.Checked then
         Memo1.Lines.Add(str3);
      if CheckBox3.Checked then
         Masiv[Lich]:=y;
      x:=x+h;
      lich:=lich+1;
     end;
    ChartFx1.CloseData(Cod_Values);
    Edit4.Text:=IntToStr(kkt);
    Edit5.Text:=FloatToStrF(max,ffFixed,8,3);
    Edit6.Text:=FloatToStrF(min,ffFixed,8,3);
end;

procedure TForm1.N9Click(Sender: TObject);
begin
Close
end;

procedure TForm1.N10Click(Sender: TObject);
begin
 CheckBox1.Checked:=False;
 CheckBox2.Checked:=False;
 CheckBox3.Checked:=False;
 CheckBox4.Checked:=False;
end;

procedure TForm1.N11Click(Sender: TObject);
begin
 CheckBox1.Checked:=True;
 CheckBox2.Checked:=True;
 CheckBox3.Checked:=True;
 CheckBox4.Checked:=True;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
CheckBox1.Checked:=True;
CheckBox3.Checked:=True;
end;

procedure TForm1.Panel2Click(Sender: TObject);
var i: integer;
begin
      Panel3.Visible:=True;
      for i:=1 to 470-Panel2.Width do
      Panel1.Width:=Panel1.Width+1;
      Panel2.Visible:=False;
end;
procedure TForm1.Panel3Click(Sender: TObject);
var i: integer;
begin
      Panel2.Visible:=True;
     for i:=1 to 470-Panel3.Width do
      Panel1.Width:=Panel1.Width-1;
      Panel3.Visible:=False;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 ChartFX1.Visible:=true
end;

end.
