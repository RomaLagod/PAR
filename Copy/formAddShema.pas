unit formAddShema;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, Graphika;

type
  TfaShema = class(TForm)
    sgShema: TStringGrid;
    Panel1: TPanel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure sgShemaDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgShemaKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  faShema: TfaShema;

implementation

uses Base;

{$R *.dfm}

procedure TfaShema.FormCreate(Sender: TObject);
begin
sgShema.Cells[0,0]:='� �����';
sgShema.Cells[1,0]:='X';
sgShema.Cells[2,0]:='Y';
sgShema.Cells[3,0]:='������� ����, �/���';
sgShema.Cells[4,0]:='����������� �������, �';
sgShema.Cells[5,0]:='ĳ�����';
sgShema.Cells[6,0]:='����';
end;

procedure TfaShema.sgShemaDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
 var s:string;
 Flag: Cardinal;
 H: integer;
begin
 if gdFocused in State then begin
  (Sender as TStringGrid).canvas.Brush.Color:=clMoneyGreen;
  (Sender as TStringGrid).canvas.FillRect(rect);
  (Sender as TStringGrid).canvas.Font.Color:=clblack;
  (Sender as TStringGrid).canvas.Font.size:=10;
  (Sender as TStringGrid).canvas.font.style:=[fsbold];
  (Sender as TStringGrid).canvas.TextOut(rect.Left,rect.Top,(Sender as TStringGrid).cells[(Sender as TStringGrid).col,(Sender as TStringGrid).row]);
 end;{begin1}
//����������� � ��������� ������ �� ������
begin
 (Sender as TStringGrid).Canvas.FillRect(Rect);
 s := (Sender as TStringGrid).Cells[ACol,ARow];
 Flag:=DT_Center;
 Flag := Flag or DT_WORDBREAK;
 H := DrawText((Sender as TStringGrid).Canvas.Handle,PChar(s),length(s),Rect,Flag);
 if H > (Sender as TStringGrid).RowHeights[ARow] then
    (Sender as TStringGrid).RowHeights[ARow] := H;  //�����������
 end;{Begin2}
end;

procedure TfaShema.sgShemaKeyPress(Sender: TObject; var Key: Char);
begin
Case Key of  //�������� ������� ��� ��������
 #8,'0'..'9':
  Begin
  {������� ���������� ��� 4 �������}
 if ((Sender as TStringGrid).Col = 3) or ((Sender as TStringGrid).Col = 4) or((Sender as TStringGrid).Col = 5)
  then key:=chr(0);

  end;
 {'-':
     {̳��� ����������� ��� 1,2,3,4,5 �������}
 {if ((Sender as TStringGrid).Col = 1) or ((Sender as TStringGrid).Col = 2)
  or ((Sender as TStringGrid).Col = 3) or ((Sender as TStringGrid).Col = 4)
  or ((Sender as TStringGrid).Col = 5)
  then key:=chr(0); }
 '.',',':    //��������� ���� � ������� �������
          Begin
           if Key <> DecimalSeparator then Key:=DecimalSeparator;
           if Pos((Sender as TStringGrid).Cells[(Sender as TStringGrid).Col,0],
                                                  DecimalSeparator)<>0
           then Key:=Chr(0);
           {��������� ����������� ��� 0,2,3,5,6 �������}
           {if ((Sender as TStringGrid).Col = 5)or
           ((Sender as TStringGrid).Col = 2) or ((Sender as TStringGrid).Col = 3)or
           ((Sender as TStringGrid).Col = 0)
           then key:=chr(0); }
         end; {case}
 
 #13,#32:
     Begin   //������ Enter
 {��������� � ������� �� ����� �����, ���� ������ �����������
                      � �������� �������  � ���������� �����}
      if ((Sender as TStringGrid).row = (Sender as TStringGrid).rowcount-1)
       and ((Sender as TStringGrid).col = (Sender as TStringGrid).ColCount-1)
        then Begin
         { if (Sender as TStringGrid).cells[5,(Sender as TStringGrid).row]=''
           then (Sender as TStringGrid).cells[5,(Sender as TStringGrid).row]:=TypeBox.text; }
         (Sender as TStringGrid).RowCount:= (Sender as TStringGrid).RowCount+1;
         (Sender as TStringGrid).Rows[(Sender as TStringGrid).Rowcount-1].Clear;
         (Sender as TStringGrid).Row:=(Sender as TStringGrid).Row+1;
         (Sender as TStringGrid).Col:=(Sender as TStringGrid).Col-(Sender as TStringGrid).ColCount+1;//-2
        end{if}
     else Begin
    {������� �� ����� ����� ���� ������ ����.
                   � �������� ������� �� ���������� �����}
           if  ((Sender as TStringGrid).col = (Sender as TStringGrid).ColCount-1)
            and ((Sender as TStringGrid).Row <> (Sender as TStringGrid).RowCount - 1)
            then  Begin
             (Sender as TStringGrid).Row:=(Sender as TStringGrid).Row+1;
             (Sender as TStringGrid).Col:=(Sender as TStringGrid).Col-(Sender as TStringGrid).ColCount+1;
            end{if}
           else
    {������� �� ���� ������� ���� ������� �� � ���������}
           if (Sender as TStringGrid).Col < (Sender as TStringGrid).ColCount - 1
           then Begin
              (Sender as TStringGrid).Col:=(Sender as TStringGrid).Col+1;
           end; {if}
         end;{else}
end {#13}
else  key:=chr(0) ;
end;{case}
end;

procedure TfaShema.Button1Click(Sender: TObject);
begin
DrawMagistral(sgShema,Para_Normal.iAllShema);
end;

end.
