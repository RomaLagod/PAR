unit New_Open_Save_Edit;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ComCtrls, ExtCtrls, ToolWin, Grids, ImgList, Dialogs, ExtDlgs,
      XMLDoc,XMLIntf,base,ATCheckedComboBox;

     {����� ϳ���������}
     Procedure Load_Grids;
     procedure Load_OutGrids;
     procedure Create_OutGrids(OutRowCount:integer);
     //������ ���������� �� ������� ����������
     Procedure AddResult(OCol,ORow:integer;OResult:String);
     Procedure AddShotResult(OutputData:TStringGrid);
     //������ ���������� �� reTabResult
     Procedure AddAlgoritm(Name:String;Attribute:string;LineColor:Tcolor);
     procedure DoneXML(xml: TXMLDocument);
     Procedure PAR_FileSaveToXML(xml: TXMLDocument; sg: TStringGrid);
     Procedure PAR_FileSaveToXML_From_DAta(xml: TXMLDocument;HowMany:integer);
     Procedure PAR_FileSaveToXML_EditText(xml: TXMLDocument; sg: TEdit);
     //���������� ��������� ���� ����������
     Procedure PAR_FileSaveToXML_ComboBox(xml: TXMLDocument; sg: TComboBox);
     Procedure New_File_InputData;
     Procedure SGDeleteRow(SG:TStringGrid; RowToDelete:Integer);
     procedure SGInsertRow(SG:TStringGrid; RowWhereInsert:Integer);
    // Function Cells_Scaner(DlyaHoo:Integer):Boolean;
     Procedure FileNameToCaption(CaptionName:String);
     procedure sgFindText(Grid: TStringGrid; const Text: String;
               FindOptions: TFindOptions);
     Procedure Load_MResistance(CheckedBox:TATCheckedComboBox);


implementation

//���� ����� �������� ������� ������� ���� � �������� ����
Procedure Load_Grids;
Begin
 with Para_Normal.sgInputData do
  Begin
   cells[0,0]:= '����� ������';
   cells[1,0]:= '������� ����, �/���';
   cells[2,0]:= '����. ������� ��., �';
   cells[3,0]:= '��� �������� �����';
   cells[4,0]:= '�-��';
   cells[5,0]:= '��� ������';
  end;{with}
end; {Load_Grids}

//���� ����� �������� ������� ���������� � �������� ����
procedure Load_OutGrids;
Begin
//��������� ������ ����� ������� ����������
    with Para_Normal.sgOutputData do
  Begin
   cells[0,0]:= '� ������';
   cells[1,0]:= '������� ���� G, �/���';
   cells[2,0]:= '���� P���, ��';
   cells[3,0]:= '����������� t, *�';
   cells[4,0]:= '������ ���� ���� y���, ��/�3';
   cells[5,0]:= '�������� ������ ����� �`, ��';
   cells[6,0]:= '��������� ���� �� ���� ������ ��`, ��';
   cells[7,0]:= '�������� ���-�� �� ���� ������ t�`,*�';
   cells[8,0]:= '�������� ���.���� ���� �� ���� ������ y�`, ��/�3';
   cells[9,0]:= '�������� ������� ���.���� y`mid, ��/�3';
   cells[10,0]:= '������ ������ ����� dh ����`, ��/�';
   cells[11,0]:= 'ĳ����� d, ��';
   cells[12,0]:= 'ĳ����� :)';
   cells[13,0]:= '����������� ������� L�, �';
   cells[14,0]:= '����. ������ ������� L ���, �';
   cells[15,0]:= '����������� ������� L�, �';
   cells[16,0]:= '������������ ������� Lp, �';
   cells[17,0]:= '��� �������� ����� � �� [�-��]';
   cells[18,0]:= '���� ����.������� ����� Sum [z]';
   cells[19,0]:= '������ ������ ����� dh ����, ��/�';
   cells[20,0]:= '�������� V ����, �/�';
   cells[21,0]:= '������ ������ ����� dh ���� ��� y` mid, ��/�';
   cells[22,0]:= '�������� V ���� ��� y` mid, �/�';
   cells[23,0]:= '������ ����� d� ��� y` mid, ��';
   cells[24,0]:= '�������� ���������� %';
   cells[25,0]:= '����� ������ ����� ��-�� dq, ��/�*�';
   cells[26,0]:= '����������� ���� C�, ��/��*C';
   cells[27,0]:= '������� ���-�� t���,*�';
   cells[28,0]:= '������ ����� �� ������ dQ, ��';
   cells[29,0]:= '������� ���-�� �� ������ dt, *�';
   cells[30,0]:= '���� �� ���� ������ P�, ��';
   cells[31,0]:= '���-�� �� ���� ������ t�, *�';
   cells[32,0]:= '���.���� ���� �� ���� ������ y�, ��/�3';
   cells[33,0]:= '������� ������ ���� y���, ��/�3';
   cells[34,0]:= '���`���� %';
  end;{with}
//��������� ������ ����� ������� ����������
  with Para_Normal.sgOutputData do
  Begin
   cells[0,1]:= '1';
   cells[1,1]:= '2';
   cells[2,1]:= '3';
   cells[3,1]:= '4';
   cells[4,1]:= '5';
   cells[5,1]:= '6';
   cells[6,1]:= '7';
   cells[7,1]:= '8';
   cells[8,1]:= '9';
   cells[9,1]:= '10';
   cells[10,1]:= '11';
   cells[11,1]:= '12';
   cells[12,1]:= '13';
   cells[13,1]:= '14';
   cells[14,1]:= '15';
   cells[15,1]:= '16';
   cells[16,1]:= '17';
   cells[17,1]:= '18';
   cells[18,1]:= '19';
   cells[19,1]:= '20';
   cells[20,1]:= '21';
   cells[21,1]:= '22';
   cells[22,1]:= '23';
   cells[23,1]:= '24';
   cells[24,1]:= '25';
   cells[25,1]:= '26';
   cells[26,1]:= '27';
   cells[27,1]:= '28';
   cells[28,1]:= '29';
   cells[29,1]:= '30';
   cells[30,1]:= '31';
   cells[31,1]:= '32';
   cells[32,1]:= '33';
   cells[33,1]:= '34';
   cells[34,1]:= '34';
  end;{with}
end;{Load_OutGrids}

//�����, ���� ���������� ������� ��� ���������� ������ ����������
procedure Create_OutGrids(OutRowCount:integer);
var i:integer;
Begin
  with Para_Normal.sgOutputData do
  Begin
    for i:=2 to rowcount-1 do
     Begin
       rows[i].Clear;
     end;{for}
    RowCount:=outRowCount;
  end;{with}
end;{Create_OutGrids}


Procedure AddShotResult(OutputData:TStringGrid);
var i:integer;
Begin
  with Para_Normal.sgShotOutputData do
  Begin
    for i:=2 to rowcount-1 do
     Begin
       rows[i].Clear;
     end;{for}
    RowCount:=OutputData.RowCount;
  end;{with}
  //��������� ������ ����� ������� ����������
    with Para_Normal.sgShotOutputData do
  Begin
   cells[0,0]:= '� ������';
   cells[1,0]:= '������� ���� G, �/���';
   cells[2,0]:= '���� P���, ��';
   cells[3,0]:= '����������� t, *�';
   cells[4,0]:= 'ĳ����� d, ��';
   cells[5,0]:= '����������� ������� L�, �';
   cells[6,0]:= '������������ ������� Lp, �';
   cells[7,0]:= '�������� V ���� ��� y` mid, �/�';
   cells[8,0]:= '������ ����� d� ��� y` mid, ��';
   cells[9,0]:= '�������� ���������� %';
   cells[10,0]:= '���� �� ���� ������ P�, ��';
   cells[11,0]:= '���-�� �� ���� ������ t�, *�';
   cells[12,0]:= '���`���� %';
  end;{with}
 //��������� ������ ����� ������� ����������
  with Para_Normal.sgShotOutputData do
  Begin
   cells[0,1]:= '1';
   cells[1,1]:= '2';
   cells[2,1]:= '3';
   cells[3,1]:= '4';
   cells[4,1]:= '5';
   cells[5,1]:= '6';
   cells[6,1]:= '7';
   cells[7,1]:= '8';
   cells[8,1]:= '9';
   cells[9,1]:= '10';
   cells[10,1]:= '11';
   cells[11,1]:= '12';
   cells[12,1]:= '13';
  end;{with}
 //��������� ���� ���������� ���������� �������
   with Para_Normal.sgShotOutputData do
  Begin
   For i:=2 to Para_Normal.sgShotOutputData.RowCount do
    Begin
   cells[0,i]:= OutputData.Cells[0,i];
   cells[1,i]:= OutputData.Cells[1,i];
   cells[2,i]:= OutputData.Cells[2,i];
   cells[3,i]:= OutputData.Cells[3,i];
   cells[4,i]:= OutputData.Cells[11,i];
   cells[5,i]:= OutputData.Cells[13,i];
   cells[6,i]:= OutputData.Cells[16,i];
   cells[7,i]:= OutputData.Cells[22,i];
   cells[8,i]:= OutputData.Cells[23,i];
   cells[9,i]:= OutputData.Cells[24,i];
   cells[10,i]:= OutputData.Cells[30,i];
   cells[11,i]:= OutputData.Cells[31,i];
   cells[12,i]:= OutputData.Cells[34,i];
    end;{for}
    Visible:=True;
  end;{with}

end;{AddShotResult}

//������ ���������� �� ������� ����������
Procedure AddResult(OCol,ORow:integer;OResult:String);
Begin
   with Para_Normal.sgOutputData do
  Begin
    Cells[OCol,ORow]:=OResult;
  end;{with}
end;{AddResult}

//������ ���������� �� reTabResult
Procedure AddAlgoritm(Name:String;Attribute:string;LineColor:Tcolor);
Begin
        Para_Normal.reTabResult.SelAttributes.Color:=LineColor;
        Para_Normal.reTabResult.Lines.Add(Name+'[ '+Attribute+' ]');
end;{AddAlgoritm}

//���������� ���������� � ����
procedure DoneXML(xml: TXMLDocument);
begin
  xml.SaveToFile(xml.FileName);
  xml.Free;
end;{DoneXML(xml: TXMLDocument)}

//���������� ��������� ����
Procedure PAR_FileSaveToXML_EditText(xml: TXMLDocument; sg: TEdit);
var 
    Node: IXMLNode;
begin
  Node := xml.ChildNodes['ComStore'].AddChild(sg.Name);
  Node.AddChild('Tag').NodeValue := sg.tag;
  Node := Node.AddChild('Values');
      if (sg.Text = '') or (sg.Text = ' ') then
       Node.AddChild('value').NodeValue:= '*EMPTY*'
      else
      Node.AddChild('value').NodeValue := sg.Text;
end;

//���������� ��������� ���� ����������
Procedure PAR_FileSaveToXML_ComboBox(xml: TXMLDocument; sg: TComboBox);
var 
    Node: IXMLNode;
begin
  Node := xml.ChildNodes['ComStore'].AddChild(sg.Name);
  Node.AddChild('Tag').NodeValue := sg.tag;
  Node := Node.AddChild('Values');
      if (sg.Text = '') or (sg.Text = ' ') then
       Node.AddChild('value').NodeValue:= '*EMPTY*'
      else
      Node.AddChild('value').NodeValue := sg.Text;
end;

//���������� � ���� ���� �������
Procedure PAR_FileSaveToXML(xml: TXMLDocument; sg: TStringGrid);
var i, j: Integer;
    Node: IXMLNode;
begin
  Node := xml.ChildNodes['ComStore'].AddChild(sg.Name);
  Node.AddChild('ColCount').NodeValue := sg.ColCount;
  Node.AddChild('RowCount').NodeValue := sg.RowCount;
  Node := Node.AddChild('Values');
  for i := 1 to sg.RowCount-1 do
    for j := 0 to sg.ColCount-1 do
     begin
      if (sg.Cells[j, i] = '') or (sg.Cells[j, i] = ' ') then
       Node.AddChild('value').NodeValue:= '*EMPTY*'
      else
      Node.AddChild('value').NodeValue := sg.Cells[j, i];
     end{for};
end;{Pop_FileSave}

//���������� � ���� ������� �� �������� ����
Procedure PAR_FileSaveToXML_From_DAta(xml: TXMLDocument;HowMany:integer);
var
   ii, jj: integer;
   i, j: Integer;
   Node: IXMLNode;
begin
 If HowMany >= 3 then
  Begin
   For ii:=0 to Para_Normal.pcBase.PageCount-1  do
    For jj:=Para_Normal.pcBase.Pages[ii].ComponentCount-1 downto 0 do
    Begin
      with Para_Normal.pcBase.Pages[ii] do
      Begin
      if (Components[jj] is TStringGrid) then Begin
    Node := xml.ChildNodes['ComStore'].AddChild((Components[jj] as TStringGrid).Name);
    Node.AddChild('ColCount').NodeValue := (Components[jj] as TStringGrid).ColCount;
    Node.AddChild('RowCount').NodeValue := (Components[jj] as TStringGrid).RowCount;
    Node := Node.AddChild('Values');
    for i := 1 to (Components[jj] as TStringGrid).RowCount-1 do
     for j := 0 to (Components[jj] as TStringGrid).ColCount-1 do
      begin
       if ((Components[jj] as TStringGrid).Cells[j, i] = '') or
             ((Components[jj] as TStringGrid).Cells[j, i] = ' ') then
        Node.AddChild('value').NodeValue:= '*EMPTY*'
       else
       Node.AddChild('value').NodeValue := (Components[jj] as TStringGrid).Cells[j, i];
      end;{for}
     end;{if}
     end;{with}
     end;{for}
   end;{if}
end;{Pop_FileSaveToXML_From_DAta(xml: TXMLDocument;HowMany:integer)}

//����� �� ���� ����� ������� ����� ���� ��� ������� �������� �����
Procedure New_File_InputData;
var
   wah:integer;
Begin
     with Para_Normal do
       Begin
         if sgInputData.RowCount <> 2 then
            Begin
              for wah:=sgInputData.RowCount downto  3 do
                 sgInputData.RowCount:=sgInputData.RowCount-1;
            end;{if}
           sgInputData.rows[sgInputData.rowcount-1].Clear;
           sgOutputData.RowCount:=3;
           sgOutputData.rows[sgOutputData.rowcount-1].Clear;
           sgShotOutputData.RowCount:=3;
           sgShotOutputData.rows[sgShotOutputData.rowcount-1].Clear;
           reTabResult.Clear;
           eStartPressure.Text:='';
           eBeforePressure.Text:='';
           eStartTemperature.Text:='';
           eLength.Text:='';
           cbTemperatureOS.Text:='';
           eTOSReal.Text:='';
           Para_Normal.tbShema.Enabled:=False;
         end;{with}
end;{New_File}

//��������� ��������� ����� �� �������
Procedure SGDeleteRow(SG:TStringGrid; RowToDelete:Integer);
var i: Integer;
begin
 with SG do
 begin
   if (RowToDelete <= 1) and (RowCount <= 2) then
        rows[rowcount-1].Clear;
   if (RowToDelete >= 1) and (RowToDelete<RowCount) and (RowCount <> 2) then
    begin
     for i:=RowToDelete to RowCount-1 do
        Rows[i].Assign(Rows[i+1]);
        RowCount:= RowCount-1;
        Para_Normal.TypeBox.Visible:=false; // �������� ��������� ���� �� ����
    end;{if}
 end;{with}
end; {SGDeleteRow(SG:TStringGrid; RowToDelete:Integer)}

//�������� ����� � �������� �������
procedure SGInsertRow(SG:TStringGrid; RowWhereInsert:Integer);
var i: Integer;
begin
 with SG do
 begin
  if (RowWhereInsert>=1) and (RowWhereInsert<RowCount) then
   begin
     RowCount:= RowCount+1;
     rows[rowcount-1].Clear;
    for i:=RowCount downto RowWhereInsert+1 do
        Rows[i].Assign(Rows[i-1]);
        Rows[RowWhereInsert].Clear;
  end;{if}
 end;{with}
end; {SGInsertRow(SG:TStringGrid; RowWhereInsert:Integer)}

//����� � ����� ���
procedure sgFindText(Grid: TStringGrid; const Text: String;
  FindOptions: TFindOptions);
var What, Where: String;
    ER, EC, NC, NR, I, J: Integer;
    Ok: Boolean;
begin
  Ok:=False;
  if frMatchCase in FindOptions then
    What := Text
  else
    What := AnsiUpperCase(Text);
  with Grid do
  begin
    if frDown in FindOptions then
    begin
      NR := 1;
      NC := 1;
      ER := RowCount;
      EC := ColCount;
      if Col >= EC - 1 then
      begin
        I:=Row + 1;
        J:=FixedCols;
      end else
      begin
        I:=Row;
        J:=Col + 1;
      end;
    end else
    begin
      NR := -1;
      NC := -1;
      ER := -1;
      EC := -1;
      if Col <= EC + 1 then
      begin
        I:=Row - 1;
        J:=ColCount - 1;
      end else
      begin
        I:=Row;
        J:=Col - 1;
      end;
    end;
    while (I <> ER) and (not Ok) do
    begin
      while J <> EC do
      begin
        Where := Cells[J, I];
        if not (frMatchCase in FindOptions) then
          Where := AnsiUpperCase(Where);
        if frWholeWord in FindOptions then
        begin
          if What = Where then
          begin
            Row:=I; Col:=J;
            Ok:=True;
            Break;
          end;
        end
        else
          if Pos(What, Where) <> 0 then
          begin
            Row:=I; Col:=J;
            Ok:=True;
            Break;
          end;
        J:=J + NC;
      end;{while J}
      I:=I + NR;
      if EC = -1 then
        J:=ColCount - 1
      else
        J:=FixedCols;
    end; {while}
  end; {with}
end;{sgFindText}

//������� ����� ����� � ��������� ���� �����
Procedure FileNameToCaption(CaptionName:String);
Begin
Para_Normal.Caption:='���������� �������� �����������  '+
                      '[ '+ExtractFileName(CaptionName)+' ]';
end; {FileNameToCaption(CaptionName:String)}

//��������� �������� ����������� ������� ����� � ������������
Procedure Load_MResistance(CheckedBox:TATCheckedComboBox);
type MResistance=Record
        Name:string;
        koef:real;
     end;
var LMR:Text; LMR_nk:MResistance;
    Parametr:String;
    LMR_Name:String;
    LMR_koef:real;
    i:integer;
    k:integer;
Begin
  LMR_koef:=0;
  i:=0;
  k:=1;
  assign(LMR,GetCurrentDir+'\Load\local_support.txt');
  reset(LMR);
  {������������ ����� � ��� ��� �������}
  while not eof(LMR) do
   with LMR_nk do
    Begin
     readln(LMR,Parametr);
     //Parametr:=Name+FloatToStr(koef);
     if i=1 then
      Begin
      CheckedBox.AddChecked({'['+IntToStr(k)+']'+}Parametr,False);
      inc(k);
      end;{if}
     i:=1;
    end;{with}
end;{Load_MResistance}



end.{end UNIT New_Open_Save_Edit}
