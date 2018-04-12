unit Unit2;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, CheckLst;

type
	TForm1 = class(TForm)
		Label1: TLabel;
    Label2: TLabel;
    btaddItem: TButton;
		BtgetText: TButton;
		btGetCount: TButton;
		RadioButton1: TRadioButton;
		RadioButton2: TRadioButton;
		RadioButton3: TRadioButton;
		Edit1: TEdit;
		CheckBox1: TCheckBox;
		Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
		procedure FormCreate(Sender: TObject);
		procedure btaddItemClick(Sender: TObject);
		procedure BtgetTextClick(Sender: TObject);
		procedure btGetCountClick(Sender: TObject);
		procedure RadioButton1Click(Sender: TObject);
		procedure AtCheckClick(Sender:TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	Form1: TForm1;

implementation
	uses ATCheckedComboBox;
var
	ncbox: TATCheckedComboBox;
{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
	ncbox					:= TATCheckedComboBox.Create(self);
	ncbox.Parent 	:= Self;
	ncbox.Top 		:= 32;
	ncbox.Left		:= 32;
	ncbox.Width		:= 220;
	ncbox.AddChecked('Aaaa',true);
	ncbox.AddChecked('Bbbb',TRUE);
	ncbox.AddChecked('Ccccc',false);
	ncbox.AddChecked('Ddddd',TRUE);
	ncBox.OnCheckClick := AtCheckClick;
	Label6.Caption := ncbox.Version;
end;

procedure TForm1.btaddItemClick(Sender: TObject);
begin
	if length(Edit1.Text)>0 then
		ncbox.AddChecked(Edit1.Text,CheckBox1.Checked);
end;

procedure TForm1.BtgetTextClick(Sender: TObject);
begin
	Label2.Caption := ncbox.Text;
end;

procedure TForm1.btGetCountClick(Sender: TObject);
begin
	Label1.Caption := IntToStr(ncbox.CheckedCount);
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
	case  (Sender as TRadioButton).Tag of
		0: ncbox.QuoteStyle := qsNone;
		1: ncbox.QuoteStyle := qsSingle;
		2: ncbox.QuoteStyle := qsDouble;
	end;
end;

procedure TForm1.AtCheckClick(Sender: TObject);
begin
	label3.Caption := IntToSTr(ncBox.CheckedCount)
end;

end.
