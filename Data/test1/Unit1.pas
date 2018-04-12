unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ComCtrls;

type
  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    CheckListBox1: TCheckListBox;
    Memo1: TMemo;
    ComboBox2: TComboBox;
    CheckBox1: TCheckBox;
    ComboBox3: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
{Высоту у combobox не получится установить, поэтому мы будем}
 {подгонять размер у грида под размер combobox!}
  Combobox1.Height := CheckListBox1.Height;
 {Скрываем combobox}
  CheckListBox1.Visible := False;
end;

procedure TForm1.CheckListBox1ClickCheck(Sender: TObject);
begin
{Получаем выбранный элемент из ComboBox и помещаем его в грид}
  //sgInputData.Cells[6,sgInputData.Row] :=
 // TypeBox.Items[TypeBox.ItemIndex];
  memo1.Lines.Add(Checklistbox1.Items.Text);
 // cheklistbox1.Visible := False;
  memo1.SetFocus;
end;

procedure TForm1.ComboBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
 R: TRect;
   Code: Integer;
  vReal: Real;
  vInteger: Integer;
 //DecimalPos: Integer; {Позиція десяткової крапки}
  EditText: string;
  MsgStr: string;
begin
  //if ((ACol = 6) AND
  //    (ARow <> 0)) then begin
   {Размер и расположение combobox подгоняем под ячейку}
      R :=combobox1.Canvas.ClipRect;

    R.Left := R.Left + combobox1.Left;
    R.Right := R.Right + combobox1.Left;
    R.Top := R.Top + combobox1.Top;
    R.Bottom := R.Bottom + combobox1.Top;
   checklistbox1.Left := R.Left + 1;
    checklistbox1.Top := R.Top + 1;
    checklistbox1.Width := (R.Right + 1) - R.Left;
    checklistbox1.Height := (R.Bottom + 1) - R.Top;
   {Показываем combobox}
    checklistbox1.Visible := True;
   checklistbox1.SetFocus;
   //CanSelect := True;


end;

procedure TForm1.ComboBox2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
r:Trect;
begin
(* Заполняем прямоугольник *)
  combobox2.canvas.fillrect(rect);

  (* Рисуем сам битмап *)
  //Checkbox1(comboBox2.Canvas,rect.left,rect.top);
   ///////////////
   with combobox2.Canvas do
    begin
        R :=rect;

    R.Left := R.Left + rect.Left;
    R.Right := R.Right + rect.Left;
    R.Top := R.Top + rect.Top;
    R.Bottom := R.Bottom + rect.Top;
   checkbox1.Left := R.Left + 1;
    checkbox1.Top := R.Top + 1;
    checkbox1.Width := (R.Right + 1) - R.Left;
    checkbox1.Height := (R.Bottom + 1) - R.Top;
   {Показываем combobox}
    checkbox1.Visible := True;
   checkbox1.SetFocus;
   end;{with}
   //////////////////
  (* Пишем текст после картинки *)
  combobox2.canvas.textout(rect.left+checkbox1.width+2,rect.top,
                          combobox2.items[index]);

end;

end.
