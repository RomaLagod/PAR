unit UnDemoChBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtCtrls, CheckCombo, StdCtrls, CheckLst, Spin;

type
	TForm1 = class(TForm)
		CheckedComboBox1: TCheckedComboBox;
    Edit1: TEdit;
    RadioButton1: TRadioButton;
    Label1: TLabel;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Button1: TButton;
    btSetChecked: TButton;
    sedToCheck: TSpinEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label2: TLabel;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    Button2: TButton;
    Button3: TButton;
    Label5: TLabel;
    Button4: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Bevel3: TBevel;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btSetCheckedClick(Sender: TObject);
    procedure CheckedComboBox1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button5Click(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if RadioButton1.Checked then
    CheckedComboBox1.QuoteStyle := qsNone
  else if RadioButton2.Checked then
    CheckedComboBox1.QuoteStyle := qsDouble
  else
    CheckedComboBox1.QuoteStyle := qsSingle;

  Edit1.Text := CheckedComboBox1.GetText;
end;

procedure TForm1.btSetCheckedClick(Sender: TObject);
begin
  if sedToCheck.Value<CheckedComboBox1.Items.count then
    CheckedComboBox1.Checked[sedToCheck.Value] := true;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if sedToCheck.Value<CheckedComboBox1.Items.count then
    CheckedComboBox1.Checked[sedToCheck.Value] := false;
end;

procedure TForm1.CheckedComboBox1Change(Sender: TObject);
begin
  label2.Caption := IntToStr(CheckedComboBox1.CheckedCount);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  CheckedComboBox1.SortDisplay := CheckBox1.Checked;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  CheckedComboBox1.SetCheckedAll(self);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  CheckedComboBox1.SetUnCheckedAll(self);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Label9.Caption := CheckedComboBox1.Version;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  close
end;

end.
