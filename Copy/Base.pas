unit Base;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Menus, ToolWin, ImgList, Grids, StdCtrls,
  CheckLst,ATCheckedComboBox, ShellApi, ExtActns, ActnList, StdActns, XMLDoc,
  XMLIntf, OleServer, Word2000, TeeProcs, TeEngine, Chart, Series;

type
  TPara_Normal = class(TForm)
    Panel1: TPanel;
    tsInputData: TTabSheet;
    tsTable: TTabSheet;
    tsShema: TTabSheet;
    mMenu: TMainMenu;
    pumInputData: TPopupMenu;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    StatusBar: TStatusBar;
    mmFile: TMenuItem;
    mmNew: TMenuItem;
    mmOpen: TMenuItem;
    mmSave: TMenuItem;
    mmSaveAs: TMenuItem;
    N6: TMenuItem;
    mmPrint: TMenuItem;
    mmPrintPreSee: TMenuItem;
    N9: TMenuItem;
    mmExit: TMenuItem;
    mmEdit: TMenuItem;
    mmView: TMenuItem;
    mmOther: TMenuItem;
    mmUndo: TMenuItem;
    N16: TMenuItem;
    mmCut: TMenuItem;
    mmCopy: TMenuItem;
    mmPaste: TMenuItem;
    mmDelete: TMenuItem;
    mmSelectAll: TMenuItem;
    N22: TMenuItem;
    mmSearch: TMenuItem;
    mmSearchNext: TMenuItem;
    mmReplase: TMenuItem;
    N26: TMenuItem;
    mmOptions: TMenuItem;
    mmHelp: TMenuItem;
    N28: TMenuItem;
    mmAbout: TMenuItem;
    mmGidro: TMenuItem;
    mmRun: TMenuItem;
    mmResutRun: TMenuItem;
    mmReport: TMenuItem;
    N35: TMenuItem;
    mmExcel: TMenuItem;
    tsShotData: TTabSheet;
    tsProfile: TTabSheet;
    tbNew: TToolButton;
    tbOpen: TToolButton;
    tbSave: TToolButton;
    ToolButton4: TToolButton;
    tbPrint: TToolButton;
    ToolButton6: TToolButton;
    tbSearh: TToolButton;
    ToolButton8: TToolButton;
    tbCut: TToolButton;
    tbCopy: TToolButton;
    tbPaste: TToolButton;
    tbUndo: TToolButton;
    ToolButton13: TToolButton;
    tbOptions: TToolButton;
    ToolButton15: TToolButton;
    tbRun: TToolButton;
    tbExcel: TToolButton;
    ToolButton18: TToolButton;
    tbHelp: TToolButton;
    tbAbout: TToolButton;
    ImageList1: TImageList;
    sgInputData: TStringGrid;
    tbShema: TToolButton;
    tbProfile: TToolButton;
    tbWord: TToolButton;
    ToolButton27: TToolButton;
    tbCalculator: TToolButton;
    ToolButton29: TToolButton;
    mmWord: TMenuItem;
    mmShema: TMenuItem;
    mmProfile: TMenuItem;
    N40: TMenuItem;
    tbReport: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    tsGraphic: TTabSheet;
    dOpen: TOpenDialog;
    dSave: TSaveDialog;
    pcBase: TPageControl;
    TypeBox: TComboBox;
    tbNotepad: TToolButton;
    tbPaint: TToolButton;
    tbExplorer: TToolButton;
    mmWindows: TMenuItem;
    mmNotepad: TMenuItem;
    mmCalc: TMenuItem;
    mmPaint: TMenuItem;
    mmExplorer: TMenuItem;
    mmPrintOption: TMenuItem;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    pumClear_InputData: TMenuItem;
    N2: TMenuItem;
    pumInsertRow_InputData: TMenuItem;
    pumAddRow_InputData: TMenuItem;
    pumDeleteRow_InputData: TMenuItem;
    N7: TMenuItem;
    pumPrint_InputData: TMenuItem;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    fd_InputData: TFindDialog;
    rd_InputData: TReplaceDialog;
    pInputOnceData: TPanel;
    Bevel1: TBevel;
    eStartPressure: TEdit;
    eBeforePressure: TEdit;
    eStartTemperature: TEdit;
    eLength: TEdit;
    lbStartPressure: TLabel;
    lbBeforePressure: TLabel;
    lbStartTemperature: TLabel;
    lbLength: TLabel;
    lbTemperatureOS: TLabel;
    reTabResult: TRichEdit;
    cbTemperatureOS: TComboBox;
    eTOSReal: TEdit;
    Label1: TLabel;
    sgOutputData: TStringGrid;
    Splitter1: TSplitter;
    sgShotOutputData: TStringGrid;
    ToolButton1: TToolButton;
    tbParol: TToolButton;
    iAllShema: TImage;
    ChartPARA: TChart;
    Series1: TLineSeries;
    procedure FormCreate(Sender: TObject);
    procedure sgInputDataKeyPress(Sender: TObject; var Key: Char);
    procedure sgInputDataDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgInputDataSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure TypeBoxKeyPress(Sender: TObject; var Key: Char);
    {����� �� ���������� ������ ���� �������� �����}
    procedure ncBoxAtExit(Sender:TObject);
    {���������� ������ �����, ������� �� �������� �������}
    procedure ncBoxKeyPress(Sender: TObject; var Key: Char);
    procedure TypeBoxChange(Sender: TObject);
    procedure tbNotepadClick(Sender: TObject);
    procedure tbCalculatorClick(Sender: TObject);
    procedure tbPaintClick(Sender: TObject);
    procedure tbExplorerClick(Sender: TObject);
    procedure pumClear_InputDataClick(Sender: TObject);
    procedure pumAddRow_InputDataClick(Sender: TObject);
    procedure pumInsertRow_InputDataClick(Sender: TObject);
    procedure pumDeleteRow_InputDataClick(Sender: TObject);
    procedure mmSearchClick(Sender: TObject);
    procedure fd_InputDataFind(Sender: TObject);
    procedure mmReplaseClick(Sender: TObject);
    procedure rd_InputDataFind(Sender: TObject);
    procedure rd_InputDataReplace(Sender: TObject);
    function  InitXML(const XMLName: string): TXMLDocument;
    procedure tbOpenClick(Sender: TObject);
    procedure mmSaveAsClick(Sender: TObject);
    procedure tbNewClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    Procedure PAR_OpenFileFromXML(const XMLName: string; sg: TStringGrid);
    Procedure PAR_OpenFileFromXML_EditText(const XMLName: string; sg: TEdit);
    {��������� ��� ���������� ����� XML ��������� ���� ����������}
    Procedure PAR_OpenFileFromXML_ComboBox(const XMLName: string; sg: TComboBox);
    {������ ��������}
    procedure ButtonEnaledFalse;
    procedure tbOptionsClick(Sender: TObject);
    procedure pcBaseChange(Sender: TObject);
    procedure tbAboutClick(Sender: TObject);
    procedure cbTemperatureOSChange(Sender: TObject);
    procedure tbRunClick(Sender: TObject);
    procedure tbTableClick(Sender: TObject);
    procedure mmSaveClick(Sender: TObject);
    procedure tbParolClick(Sender: TObject);
    procedure pmChartPreSeeClick(Sender: TObject);
    procedure tbWordClick(Sender: TObject);
    procedure tbExcelClick(Sender: TObject);
    procedure tbReportClick(Sender: TObject);
    procedure mmPrintPreSeeClick(Sender: TObject);
    procedure tbShemaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Const
  fbReal = 0;    {ĳ��� �����}
  fbInteger = 1; {ֳ� �����}
  DecimalSeparator = '.';{��������� ���� � ������� ������� - ������}  

var
  Para_Normal: TPara_Normal;
 {���� �� ��������� �����}
  Path_File:string;
  ncbox :TATCheckedComboBox;
  FileProportion:TFileName;
  FileCP:TFileName;

implementation

{$R *.dfm}

uses New_Open_Save_Edit, Calculation, Options, About,MSWord_Exel,Para_REPORT,
  formAddShema;

{��������� �����}
procedure TPara_Normal.FormCreate(Sender: TObject);
begin
{��������� ����� ���� ������� �������� �����}
New_File_InputData;
{�������� ���� ������}
ButtonEnaledFalse;
{���������� ����� ������� �������� �����}
Load_Grids;
{���������� ����� ������� ��������� �����}
Load_OutGrids;
FileNameToCaption('���� ������');
{������ � combobox �� ��������� ����������, ������� �� �����}
{��������� ������ � ����� ��� ������ combobox!}
 sgInputData.DefaultRowHeight := TypeBox.Height;
 {�������� combobox}
 typeBox.Visible := False;
 //��������� ����� ���������-�����
  ncbox :=TATCheckedComboBox.Create(self);
  ncbox.Parent 	:= Self;
  ncbox.Top 		:= 0;
  ncbox.Left		:= 0;
  ncbox.Width		:= 220;
  ncBox.Height:=21;
  ncBox.DropDownCount:=15;
  //ncBox.OnCheckClick := AtCheckClick;
  ncBox.OnExit:=ncBoxAtExit;
 //ncBox.OnCheckClick:=BoxAtClick;
  ncBox.OnKeyPress:=ncBoxKeyPress;
 {�������� combobox}
  ncBox.Visible := False;
 {������ � combobox �� ��������� ����������, ������� �� �����}
 {��������� ������ � ����� ��� ������ combobox!}
  sgInputData.DefaultRowHeight := ncBox.Height;
  ///����� ���������
  //��������� �������� ����������� ������� ����� � ������������
  Load_MResistance(ncbox);
  //����� �� ����� �������
  FileProportion:=GetCurrentDir+'\DataTables\proportion.txt';
  FileCP:=GetCurrentDir+'\DataTables\cp.txt';
end;{TPara_Normal.FormCreate}

{�������� ���� ������ �� ������� ������������ �����}
procedure Tpara_Normal.ButtonEnaledFalse;
Begin
 {�������� ���� ������ ��� ������� ��������}
 tbSave.Enabled:=False;
 mmSave.Enabled:=False;
 //tbTable.Enabled:=False;
// mmAllData.Enabled:=False;
// tbShotData.Enabled:=False;
 //mmShotData.Enabled:=False;
 tbShema.Enabled:=False;
 mmShema.Enabled:=False;
 tbProfile.Enabled:=False;
 mmProfile.Enabled:=False;
// tbGraphic.Enabled:=False;
// mmGraphic.Enabled:=False;
 tbReport.Enabled:=False;
 mmReport.Enabled:=False;
 tbWord.Enabled:=False;
 mmWord.Enabled:=False;
 tbExcel.Enabled:=False;
 mmExcel.Enabled:=False; 
end; {Tpara_Normal.ButtonEnaledFals}

{����������� ��� ���� ��������� ����� ������ � sgInputData}
procedure TPara_Normal.sgInputDataKeyPress(Sender: TObject; var Key: Char);
begin
Case Key of  //�������� ������� ��� ��������
 #8,'0'..'9':
  Begin
  {������� ��������� ��� 4 �������}
 if ((Sender as TStringGrid).Col = 3) or ((Sender as TStringGrid).Col = 4) or((Sender as TStringGrid).Col = 5)
  then key:=chr(0);

  end;
 '-':
     {̳��� ����������� ��� 1,2,3,4,5 �������}
 if ((Sender as TStringGrid).Col = 1) or ((Sender as TStringGrid).Col = 2)
  or ((Sender as TStringGrid).Col = 3) or ((Sender as TStringGrid).Col = 4)
  or ((Sender as TStringGrid).Col = 5)
  then key:=chr(0);
 '.',',':    //��������� ���� � ������� �������
          Begin
           if Key <> DecimalSeparator then Key:=DecimalSeparator;
           if Pos((Sender as TStringGrid).Cells[(Sender as TStringGrid).Col,0],
                                                  DecimalSeparator)<>0
           then Key:=Chr(0);
           {��������� ����������� ��� 0,2,3,5,6 �������}
           if ((Sender as TStringGrid).Col = 5)or
           ((Sender as TStringGrid).Col = 2) or ((Sender as TStringGrid).Col = 3)or
           ((Sender as TStringGrid).Col = 0)
           then key:=chr(0);
         end; {case}
 
 #13,#32:
     Begin   //������ Enter
 {��������� � ������� �� ����� �����, ���� ������ �����������
                      � ������� �������  � ���������� �����}
      if ((Sender as TStringGrid).row = (Sender as TStringGrid).rowcount-1)
       and ((Sender as TStringGrid).col = (Sender as TStringGrid).ColCount-1)
        then Begin
          if (Sender as TStringGrid).cells[5,(Sender as TStringGrid).row]=''
           then (Sender as TStringGrid).cells[5,(Sender as TStringGrid).row]:=TypeBox.text;
         (Sender as TStringGrid).RowCount:= (Sender as TStringGrid).RowCount+1;
         (Sender as TStringGrid).Rows[(Sender as TStringGrid).Rowcount-1].Clear;
         (Sender as TStringGrid).Row:=(Sender as TStringGrid).Row+1;
         (Sender as TStringGrid).Col:=(Sender as TStringGrid).Col-(Sender as TStringGrid).ColCount+1;//-2
        end{if}
     else Begin
    {������� �� ����� ����� ���� ������ ����.
                   � ������� ������� �� ���������� �����}
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
end; {TPara_Normal.sgInputDataKeyPress}

{����� ���� �� ���� ������ ������ ��
 ���������� ����� �� ����� ����� ���� � ����� ��
 �������� ����� �� ������ ������}
procedure TPara_Normal.sgInputDataDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
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
end; {TPara_Normal.sgInputDataDrawCell}

{���� ������� ����� ������ ��:
 -������� ����� ���������, ���� ���������;
 -������� ������ ���������;
 -���������� �������� ����� � ���������� �������}
procedure TPara_Normal.sgInputDataSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  R,R2: TRect;
  Code: Integer;
  vReal: Real;
  vInteger: Integer;
  EditText: string;
  MsgStr: string;
begin
//�������� ��������� � 5 �������� �������
  if ((ACol = 5) AND
      (ARow <> 0)) then begin
   {������ � ������������ combobox ��������� ��� ������}
    R := sgInputData.CellRect(ACol, ARow);
    R.Left := R.Left + sgInputData.Left;
    R.Right := R.Right + sgInputData.Left;
    R.Top := R.Top + sgInputData.Top;
    R.Bottom := R.Bottom + sgInputData.Top;
    TypeBox.Left := R.Left + 3;
    TypeBox.Top := R.Top + 3;
    TypeBox.Width := (R.Right + 1) - R.Left;
    TypeBox.Height := (R.Bottom + 1) - R.Top;
   {���������� combobox}
    TypeBox.Visible := True;
    CanSelect := True;
    //typebox.Focused;
    end;{if}
//�������� ��������� � 3 �������
   if ((ACol = 3) AND
      (ARow <> 0)) then begin
   {������ � ������������ combobox2 � ����������� ��������� ��� ������}
    R2 := sgInputData.CellRect(ACol, ARow);
    R2.Left := R2.Left + sgInputData.Left;
    R2.Right := R2.Right + sgInputData.Left;
    R2.Top := R2.Top + sgInputData.Top;
    R2.Bottom := R2.Bottom + sgInputData.Top;
    ncBox.Left := R2.Left + 10;
    ncBox.Top := R2.Top + 15+sgInputData.DefaultRowHeight;
    ncBox.Width := (R2.Right + 1) - R2.Left;
    ncBox.Height := (R2.Bottom + 1) - R2.Top;
   {���������� combobox}
    ncBox.Visible := True;
    CanSelect := True;
    ncBox.SetFocus;
    end;{if}

    {�������� ���������� �������� �������� ������� � ��������� ��
 �������� Tag}
 {������� ��������� �������� ���������� ����� � �����}
      if ((Sender as TStringGrid).Col <> 0) and ((Sender as TStringGrid).Col <3 )  then
      Begin
      EditText:=(Sender as TStringGrid).Cells[(Sender as TStringGrid).col,
                                          (Sender as TStringGrid).row];
       if EditText='' then EditText:='0';
       if (Sender as TWinControl).Tag=fbReal then
         Val(EditText, vReal, Code)
       else
         Val(EditText, vInteger, Code);
       if Code <> 0 then begin
         MsgStr:='������� ����������� ���� � ������� '+IntToStr(Code)+#13;
         MsgStr:=MsgStr+'���������� ������ - '''+Copy(EditText, Code, 1)+'''';
         MessageDlg(MsgStr, mtError, [mbOk], 0);
         CanSelect := false;
         exit;
       end {if}
       else begin
        if (Sender as TWinControl).Tag=fbReal then begin
        vReal:=Round(vReal*1000)/1000; {���������� �� ����� ����� ���� ����}
        Str(vReal:1:3, EditText);
        (Sender as TStringGrid).Cells[(Sender as TStringGrid).col,
                                   (Sender as TStringGrid).row]:=EditText;
       end;{if}  
       end; {if}
      end; {else}
 {���������� ��������� �������� ���������� ����� ���� }
end; {TPara_Normal.sgInputDataSelectCell}

{��� ��������� ������ ����� �� ���������� ��������� ���������� �� ����� �����}
procedure TPara_Normal.TypeBoxKeyPress(Sender: TObject; var Key: Char);
begin
case key of
#13:
Begin
   {��������� � ������� �� ����� �����, ���� ������ �����������
                      � ������� �������  � ���������� �����}
      if (sgInputData.row = sgInputData.rowcount-1)
       and (sgInputData.col = sgInputData.ColCount-1)
        then Begin
         sgInputData.RowCount:= sgInputData.RowCount+1;
         sgInputData.Rows[sgInputData.Rowcount-1].Clear;
         sgInputData.Row:=sgInputData.Row+1;
         sgInputData.Col:=sgInputData.Col-sgInputData.ColCount+1;//-2;
        end{if}
     else Begin
    {������� �� ����� ����� ���� ������ ����.
                  � ������� ������� �� ���������� �����}
           if  (sgInputData.col = sgInputData.ColCount-1)
            and (sgInputData.Row <> sgInputData.RowCount - 1)
            then  Begin
             sgInputData.Row:=sgInputData.Row+1;
             sgInputData.Col:=sgInputData.Col-sgInputData.ColCount+1;
           end{if}
     end;{else}
   end{#13}
else   key:=chr(0);
end;{case}
sgInputData.setFocus;
TypeBox.Visible := False;
end; {TPara_Normal.TypeBoxKeyPress}

{���� �������� � �������� ���������� �������� ���� ������ ��
 ������� ������� ���� � ��������� �������� ���������( ��������� �������) �
 ���������� �������� ����, �������� �������� ����}
procedure TPara_Normal.ncBoxAtExit(Sender: TObject);
label
     Label_ss1,label_ss2,label_ss3;
var
   i:integer;
   ss:string;
   ss_chislo:real;
begin
      kompensator:='';
      sgInputData.Cells[4,sgInputData.Row] :='';
      sgInputData.Cells[3,sgInputData.Row] :=
      ncBox.text;
      ncBox.Visible:=FAlse;
      sgInputData.setFocus;
      for i:=0 to ncBox.Items.Count do
       Begin
        if ncbox.IsChecked(i)=true then
         If (ncbox.Items[i]=' ����������� ����������� (0.3)') or
            (ncbox.Items[i]=' ����������� �-������� � �������� �������� (1.7)') or
            (ncbox.Items[i]=' ����������� �-������� � ����� �������� �������� (2.4)') or
            (ncbox.Items[i]=' ����������� �-������� � �������� �������� (2.8)')  then
         Begin
                        if kompensator='' then Kompensator:= ncbox.Items[i]
              else
              case MessageDLG('������� [1218] - ����� ������� ����� ���� ����������� ��� ������.'+#13+'�������� �������� �����.',mtError,[mbOK],0)of
                 idOK: Begin
                           sgInputData.Cells[4,sgInputData.Row] :='';
                           sgInputData.Cells[3,sgInputData.Row] :='';
                           sgInputData.row:=1;
                           sgInputData.col:=0;
                           kompensator:='';
                         goto label_ss3;
                        end;{idOK}
              end;{case}
              if sgInputData.Cells[4,sgInputData.Row] <>'' then
                 sgInputData.Cells[4,sgInputData.Row] :=sgInputData.Cells[4,sgInputData.Row]+' ,'+'0';
              if sgInputData.Cells[4,sgInputData.Row]='' then
                 sgInputData.Cells[4,sgInputData.Row] :='0';
             end{if}
        else Begin
         if sgInputData.Cells[4,sgInputData.Row] <>'' then
          Begin
           ss:=InputBox('������ ������� ���� ���:',ncBox.Items[i],'1');
label_ss2: if ss_chislo<0 then
           case MessageDLG('������ ������� �������.',mtError,[mbOK],0)of
                 idOK: Begin
                         ss:=InputBox('������ ������� ���� ���:',ncBox.Items[i],'1');
                         goto label_ss2;
                        end;{idOK}
           end{case}
           else
            sgInputData.Cells[4,sgInputData.Row] :=sgInputData.Cells[4,sgInputData.Row]+' ,'+ss;
          end;{if}
         if sgInputData.Cells[4,sgInputData.Row]='' then
          Begin
           ss:=InputBox('������ ������� ���� ���:',ncBox.Items[i],'1');
label_ss1: if ss_chislo<0 then
           case MessageDLG('������ ������� �������.',mtError,[mbOK],0)of
                 idOK: Begin
                         ss:=InputBox('������ ������� ���� ���:',ncBox.Items[i],'1');
                         goto label_ss1;
                        end;{idOK}
           end{case}
           else sgInputData.Cells[4,sgInputData.Row] :=ss;
          end;
        end;{else}
       end;{for}
label_ss3:
  //	label3.Caption := IntToSTr(ncBox.CheckedCount)
end; {TPara_Normal.ncBoxAtExit}

{���������� � �������� ������ ���
��������� ������ ����� �� ���������� �������}
procedure TPara_Normal.ncBoxKeyPress(Sender: TObject; var Key: Char);
begin
case key of
#13:
Begin
       {������� �� ���� ������� ���� ������� �� � ���������}
           if sgInputData.Col < sgInputData.ColCount - 1
           then Begin
              sgInputData.Col:=sgInputData.Col+1;
              sgInputData.setFocus;
           end;{if}
end{#13}
else   key:=chr(0);
end{case}
end; {TPara_Normal.ncBoxKeyPress}

{��� ��� ���������� ������� ������� ��� � ���� �� ���}
procedure TPara_Normal.TypeBoxChange(Sender: TObject);
begin
{�������� ��������� ������� �� ComboBox � �������� ��� � ����}
  sgInputData.Cells[5,sgInputData.Row] :=
  TypeBox.Items[TypeBox.ItemIndex];
  TypeBox.Visible := False;
end; {TPara_Normal.TypeBoxChange}

{³�������� ������� Windows}
procedure TPara_Normal.tbNotepadClick(Sender: TObject);
begin
ShellExecute(Handle, 'open', 'c:\Windows\notepad.exe', nil, nil, SW_SHOWNORMAL) ;
end; {TPara_Normal.tbNotepadClick}

{³�������� ����������� Windows}
procedure TPara_Normal.tbCalculatorClick(Sender: TObject);
begin
ShellExecute(Handle, 'open', 'c:\Windows\system32\calc.exe', nil, nil, SW_SHOWNORMAL) ; 
end; {TPara_Normal.tbCalculatorClick}

{³�������� Paint Windows}
procedure TPara_Normal.tbPaintClick(Sender: TObject);
begin
ShellExecute(Handle, 'open', 'c:\Windows\system32\mspaint.exe', nil, nil, SW_SHOWNORMAL) ; 
end; {TPara_Normal.tbPaintClick}

{³�������� �������� Windows}
procedure TPara_Normal.tbExplorerClick(Sender: TObject);
begin
ShellExecute(Handle, 'open', 'c:\Windows\explorer.exe', nil, nil, SW_SHOWNORMAL) ; 
end; {TPara_Normal.tbExplorerClick}

{���������� ����. ����� ������� �������� �����}
procedure TPara_Normal.pumClear_InputDataClick(Sender: TObject);
begin
New_File_InputData;
end; {TPara_Normal.pumClear_InputDataClick}

{���������� ����. ����� ����� ����� � ����� ������� �������� �����}
procedure TPara_Normal.pumAddRow_InputDataClick(Sender: TObject);
begin
   With Para_Normal.sgInputData do
       begin
         rowCount:=rowcount+1;
         rows[rowcount-1].Clear;
       end;{with}
end; {TPara_Normal.pumAddRow_InputDataClick}

{���������� ����. ���������� ����� ����� ���� ������� � �������� �������� �����}
procedure TPara_Normal.pumInsertRow_InputDataClick(Sender: TObject);
begin
 SGInsertRow(sgInputData,sgInputData.Row);
end; {TPara_Normal.pumInsertRow_InputDataClick}

{���������� ����. ��������� �������� ����� � ������� �������� �����}
procedure TPara_Normal.pumDeleteRow_InputDataClick(Sender: TObject);
begin
   SGDeleteRow(sgInputData,sgInputData.Row);
end; {TPara_Normal.pumDeleteRow_InputDataClick}

{³�������� ���� ��� ������ ����� � ������� �������� �����}
procedure TPara_Normal.mmSearchClick(Sender: TObject);
begin
fd_InputData.Execute;
end; {TPara_Normal.mmSearchClick}

{��������� ����� �� ������� �������� �����}
procedure TPara_Normal.fd_InputDataFind(Sender: TObject);
begin
sgFindText(sgInputData,fd_InputData.FindText,fd_inputData.Options);
end; {TPara_Normal.fd_InputDataFind}

{³�������� ���� ��� ������ �� ������ � ������� �������� �����}
procedure TPara_Normal.mmReplaseClick(Sender: TObject);
begin
rd_InputData.Execute;
end; {TPara_Normal.mmReplaseClick}

{��������� ����� �� ������� �������� �����}
procedure TPara_Normal.rd_InputDataFind(Sender: TObject);
begin
sgFindText(sgInputData,rd_InputData.FindText,rd_inputData.Options);
end; {TPara_Normal.rd_InputDataFind}

{��������� ����� ������ � ������� �������� �����}
procedure TPara_Normal.rd_InputDataReplace(Sender: TObject);
begin
 sgFindText(sgInputData,rd_InputData.FindText,rd_inputData.Options);
 sgInputData.Cells[sgInputData.Col,sgInputData.Row] := rd_inputData.ReplaceText;
end; {TPara_Normal.rd_InputDataReplace}

{����������� ����� XML �������}
function TPara_Normal.InitXML(const XMLName: string): TXMLDocument;
var s: TStringList;
begin
  s := TStringList.Create;
  s.Add('<ComStore>');
  s.Add('</ComStore>');
  s.SaveToFile(XMLName);
  s.Free;

  Result := TXMLDocument.Create(Self);
  Result.Options := [doNodeAutoIndent, doAttrNull];
  Result.LoadFromFile(XMLName);
end; {TPara_Normal.InitXML}

{��������� ��� ���������� ����� XML ��������� ����}
Procedure TPara_Normal.PAR_OpenFileFromXML_EditText(const XMLName: string; sg: TEdit);
var xml: TXMLDocument;
    Root: IXMLNode;
    i, j, k: Integer;
begin
  xml := TXMLDocument.Create(Self);
  try
    xml.LoadFromFile(XMLName);
    if xml.ChildNodes['ComStore'] <> nil then
    begin
      Root := xml.ChildNodes['ComStore'].ChildNodes[sg.Name];
      sg.tag := Root.ChildNodes['Tag'].NodeValue;
      k := 0;
      with Root.ChildNodes['Values'].ChildNodes do
        begin
          if Nodes[k].NodeValue = '*EMPTY*' then
          sg.Text :=''
          else
          sg.Text := Nodes[k].NodeValue;
        end{for};
    end;
  finally
    xml.Free;
  end;
end;      {TPara_Normal.PAR_OpenFileFromXML_EditText} //          TMemoryStream

{��������� ��� ���������� ����� XML ��������� ���� ����������}
Procedure TPara_Normal.PAR_OpenFileFromXML_ComboBox(const XMLName: string; sg: TComboBox);
var xml: TXMLDocument;
    Root: IXMLNode;
    i, j, k: Integer;
begin
  xml := TXMLDocument.Create(Self);
  try
    xml.LoadFromFile(XMLName);
    if xml.ChildNodes['ComStore'] <> nil then
    begin
      Root := xml.ChildNodes['ComStore'].ChildNodes[sg.Name];
      sg.tag := Root.ChildNodes['Tag'].NodeValue;
      k := 0;
      with Root.ChildNodes['Values'].ChildNodes do
        begin
          if Nodes[k].NodeValue = '*EMPTY*' then
          sg.Text :=''
          else
          sg.Text := Nodes[k].NodeValue;
        end{for};
    end;
  finally
    xml.Free;
  end;
end;      {TPara_Normal.PAR_OpenFileFromXML_EditText} //          TMemoryStream

{��������� ��� ���������� ����� XML �������}
Procedure TPara_Normal.PAR_OpenFileFromXML(const XMLName: string; sg: TStringGrid);
var xml: TXMLDocument;
    Root: IXMLNode;
    i, j, k: Integer;
begin
  xml := TXMLDocument.Create(Self);
  try
    xml.LoadFromFile(XMLName);
    if xml.ChildNodes['ComStore'] <> nil then
    begin
      Root := xml.ChildNodes['ComStore'].ChildNodes[sg.Name];
      sg.ColCount := Root.ChildNodes['ColCount'].NodeValue;
      sg.RowCount := Root.ChildNodes['RowCount'].NodeValue;

      k := 0;
      with Root.ChildNodes['Values'].ChildNodes do
      for i := 1 to sg.RowCount-1 do
        for j := 0 to sg.ColCount-1 do
        begin
          if Nodes[k].NodeValue = '*EMPTY*' then
          sg.Cells[j, i] :=''
          else
          sg.Cells[j, i] := Nodes[k].NodeValue;
          Inc(k);
        end{for};
    end;
  finally
    xml.Free;
  end;
end;      {TPara_Normal.PAR_OpenFileFromXML} //          TMemoryStream

{��������� ���������� ����� ��..}
procedure TPara_Normal.mmSaveAsClick(Sender: TObject);
var
   xml: TXMLDocument;
Label verx,en3;
begin
verx:if dSave.Execute then
        Begin
          PAth_File:=dSave.FileName;
          if FileExists(PAth_File) then
             Begin
               Case MessageDLG('���� '+ExtractFileName(PAth_File)+' ��� ����.'+#13+'������� ����?',mtWarning,[mbYes,mbNo,mbCancel],0) of
                    idYes: begin
                            xml := InitXML(PAth_File);
                            PAR_FileSaveToXML(xml,sgInputData);
                            PAR_FileSaveToXML_EditText(xml,eStartPressure);
                            PAR_FileSaveToXML_EditText(xml,eBeforePressure);
                            PAR_FileSaveToXML_EditText(xml,eStartTemperature);
                            PAR_FileSaveToXML_EditText(xml,eLength);
                            PAR_FileSaveToXML_ComboBox(xml,cbTemperatureOS);
                            PAR_FileSaveToXML_EditText(xml,eTOSReal);
                            //Pop_FileSaveToXML(xml,Hid_Grid);
                            //Pop_FileSaveToXML(xml,Result_Form.PVRH_Grid);
                           // Pop_FileSaveToXML(xml,Result_Form.RNM_Grid);
                            //Pop_FileSaveToXML(xml,Result_Form.NevP_Grid);
                            //Pop_FileSaveToXML_From_DAta(xml,hid_grid.RowCount);
                            DoneXML(xml);
                            tbSave.Enabled:=true;
                            mmSave.Enabled:=true;
                            FileNameToCaption(Path_File);
                           end;{idYEs}
                    idNo:    goto verx;
                    idCancel:goto en3;
               end;{Case}
             end{if}
          else Begin
                  PAth_File:=PAth_File+'.par';
                  xml := InitXML(PAth_File);
                  PAR_FileSaveToXML(xml,sgInputData);
                  PAR_FileSaveToXML_EditText(xml,eStartPressure);
                  PAR_FileSaveToXML_EditText(xml,eBeforePressure);
                  PAR_FileSaveToXML_EditText(xml,eStartTemperature);
                  PAR_FileSaveToXML_EditText(xml,eLength);
                  PAR_FileSaveToXML_ComboBox(xml,cbTemperatureOS);
                  PAR_FileSaveToXML_EditText(xml,eTOSReal);
                  //Pop_FileSaveToXML(xml,Hid_Grid);
                  //Pop_FileSaveToXML(xml,Result_Form.PVRH_Grid);
                  //Pop_FileSaveToXML(xml,Result_Form.RNM_Grid);
                  //Pop_FileSaveToXML(xml,Result_Form.NevP_Grid);
                  //Pop_FileSaveToXML_From_DAta(xml,hid_grid.RowCount);
                  DoneXML(xml);
                  tbSave.Enabled:=true;
                  mmSave.Enabled:=true;
                  TypeBox.Visible:=False;
                  FileNameToCaption(Path_File);
                end;{else}
       end;{if}

en3:
end;{TPara_Normal.mmSaveAsClick}

{��������� �������� �����}
procedure TPara_Normal.tbOpenClick(Sender: TObject);
Var
    i,ii,jj:integer;
begin
 Case MessageDLG('�������� ����?',mtWarning,[mbYes,mbNo,mbCancel],0) of
  idYes:   mmSaveAsClick(Sender);
  idNo:
  begin
   New_File_InputData;
   tbSAve.Enabled:=False;
  If dOpen.Execute then
   Begin
    PAR_OpenFileFromXML(dOpen.FileName, sgInputData);
    PAR_OpenFileFromXML_EditText(dOpen.FileName, eStartPressure);
    PAR_OpenFileFromXML_EditText(dOpen.FileName, eBeforePressure);
    PAR_OpenFileFromXML_EditText(dOpen.FileName, eStartTemperature);
    PAR_OpenFileFromXML_EditText(dOpen.FileName, eLength);
    PAR_OpenFileFromXML_ComboBox(dOpen.FileName, cbTemperatureOS);
    PAR_OpenFileFromXML_EditText(dOpen.FileName, eTOSReal);
    //Pop_OpenFileFromXML(OpenDialog1.FileName, Hid_Grid);
    //Pop_OpenFileFromXML(OpenDialog1.FileName, Result_Form.PVRH_Grid);
    //Pop_OpenFileFromXML(OpenDialog1.FileName, Result_Form.RNM_Grid);
    //Pop_OpenFileFromXML(OpenDialog1.FileName, Result_Form.NevP_Grid);
   { for i:=1 to Hid_Grid.RowCount-2 do
      NewHid_Data(IntToStr(i),Hid_Grid.cells[0,i],
                              Hid_Grid.cells[1,i]);
    For ii:=pdstartData.DataControl.PageCount-1 downto 0 do
     For jj:=pdstartData.DataControl.Pages[ii].ComponentCount-1 downto 0 do
       Begin
        with pdstartData.DataControl.Pages[ii] do
         Pop_OpenFileFromXML(OpenDialog1.FileName, (Components[jj] as TStringGrid));
       end;}{for}
      tbSave.Enabled:=true;
      mmSave.Enabled:=true;
      TypeBox.Visible:=False;
      Path_File:=dOpen.FileName;
      FileNameToCaption(Path_File);
    end;{if}
   end;{idNo} 
  idCancel: exit;
  end;{CAse}
end; {TPara_Normal.tbOpenClick}

{��������� ������ �������}
procedure TPara_Normal.tbNewClick(Sender: TObject);
Label en2;
begin
 Case MessageDLG('�������� ����?',mtWarning,[mbYes,mbNo,mbCancel],0) of
                    idYes:   mmSaveAsClick(Sender);
                    idNo:   begin
                             New_File_InputData;
                             tbSAve.Enabled:=False;
                             mmSAve.Enabled:=False;
                             TypeBox.Visible:=False;
                             FileNameToCaption('���� ������');
                            end; 
                    idCancel:goto en2;
 end;{Case}
en2:

end;{TPara_Normal.tbNewClick}


procedure TPara_Normal.tbSaveClick(Sender: TObject);
begin
end;

{����� �� ��������� ��� ����� ������� ������}
procedure TPara_Normal.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
label en3;
begin
 Case MessageDlg('�� ������ �������� ����?',mtConfirmation,[mbYes,mbNo,mbCancel],0) of
     idYes:mmSaveAsClick(sender);
     idNo: goto en3;
     idCancel: CanClose:=FAlse;
 end;
en3:

end; {TPara_Normal.FormCloseQuery}

procedure TPara_Normal.tbOptionsClick(Sender: TObject);
begin
OptionForm.ShowModal;
end;

//���� ������ �������� ��� ������ ��������� ������
procedure TPara_Normal.pcBaseChange(Sender: TObject);
begin
//���� ������� �������� ������ ���
if pcBase.ActivePageIndex=0 then
 Begin
   tbNew.Enabled:=True;
   mmNew.Enabled:=True;
   tbOpen.Enabled:=True;
   mmOpen.Enabled:=True;
   tbSave.Enabled:=True;
   mmSave.Enabled:=True;
   mmSaveAs.Enabled:=True;
   mmPrintPreSee.Enabled:=True;
   mmPrintOption.Enabled:=True;
   mmPrint.Enabled:=True;
   tbPrint.Enabled:=True;
   mmUndo.Enabled:=True;
   tbUndo.Enabled:=True;
   mmCut.Enabled:=True;
   tbCut.Enabled:=True;
   mmCopy.Enabled:=True;
   tbCopy.Enabled:=True;
   mmPaste.Enabled:=True;
   tbPaste.Enabled:=True;
   mmDelete.Enabled:=True;
   mmSelectAll.Enabled:=True;
   mmSearch.Enabled:=True;
   tbSearh.Enabled:=True;
   mmSearchNext.Enabled:=True;
   mmReplase.Enabled:=True;
   mmRun.Enabled:=True;
   tbRun.Enabled:=True;
   tbWord.Enabled:=True;
   mmWord.Enabled:=True;
   tbExcel.Enabled:=True;
   mmExcel.Enabled:=True;
   TbReport.Enabled:=True;
   mmReport.Enabled:=True;
 end;{if}
 //���� ������� �������� ������� ����������
if pcBase.ActivePageIndex=1 then
 Begin
   tbNew.Enabled:=False;
   mmNew.Enabled:=False;
   tbOpen.Enabled:=False;
   mmOpen.Enabled:=False;
   tbSave.Enabled:=False;
   mmSave.Enabled:=False;
   mmSaveAs.Enabled:=False;
   mmPrintPreSee.Enabled:=True;
   mmPrintOption.Enabled:=True;
   mmPrint.Enabled:=True;
   tbPrint.Enabled:=True;
   mmUndo.Enabled:=False;
   tbUndo.Enabled:=False;
   mmCut.Enabled:=False;
   tbCut.Enabled:=False;
   mmCopy.Enabled:=False;
   tbCopy.Enabled:=False;
   mmPaste.Enabled:=False;
   tbPaste.Enabled:=False;
   mmDelete.Enabled:=False;
   mmSelectAll.Enabled:=True;
   mmSearch.Enabled:=False;
   tbSearh.Enabled:=False;
   mmSearchNext.Enabled:=False;
   mmReplase.Enabled:=False;
   mmRun.Enabled:=False;
   tbRun.Enabled:=False;
   tbWord.Enabled:=True;
   mmWord.Enabled:=True;
   tbExcel.Enabled:=True;
   mmExcel.Enabled:=True;
   TbReport.Enabled:=True;
   mmReport.Enabled:=True;
 end;{if}
 //���� ������� �������� �������� ����� �����
if pcBase.ActivePageIndex=2 then
 Begin
    tbNew.Enabled:=False;
   mmNew.Enabled:=False;
   tbOpen.Enabled:=False;
   mmOpen.Enabled:=False;
   tbSave.Enabled:=False;
   mmSave.Enabled:=False;
   mmSaveAs.Enabled:=False;
   mmPrintPreSee.Enabled:=True;
   mmPrintOption.Enabled:=True;
   mmPrint.Enabled:=True;
   tbPrint.Enabled:=True;
   mmUndo.Enabled:=False;
   tbUndo.Enabled:=False;
   mmCut.Enabled:=False;
   tbCut.Enabled:=False;
   mmCopy.Enabled:=False;
   tbCopy.Enabled:=False;
   mmPaste.Enabled:=False;
   tbPaste.Enabled:=False;
   mmDelete.Enabled:=False;
   mmSelectAll.Enabled:=True;
   mmSearch.Enabled:=False;
   tbSearh.Enabled:=False;
   mmSearchNext.Enabled:=False;
   mmReplase.Enabled:=False;
   mmRun.Enabled:=False;
   tbRun.Enabled:=False;
   tbWord.Enabled:=True;
   mmWord.Enabled:=True;
   tbExcel.Enabled:=True;
   mmExcel.Enabled:=True;
   TbReport.Enabled:=True;
   mmReport.Enabled:=True;
 end;{if}
 //���� ������� �������� �������������� �����
if pcBase.ActivePageIndex=3 then
 Begin
   tbNew.Enabled:=False;
   mmNew.Enabled:=False;
   tbOpen.Enabled:=False;
   mmOpen.Enabled:=False;
   tbSave.Enabled:=False;
   mmSave.Enabled:=False;
   mmSaveAs.Enabled:=False;
   mmPrintPreSee.Enabled:=True;
   mmPrintOption.Enabled:=True;
   mmPrint.Enabled:=True;
   tbPrint.Enabled:=True;
   mmUndo.Enabled:=False;
   tbUndo.Enabled:=False;
   mmCut.Enabled:=False;
   tbCut.Enabled:=False;
   mmCopy.Enabled:=False;
   tbCopy.Enabled:=False;
   mmPaste.Enabled:=False;
   tbPaste.Enabled:=False;
   mmDelete.Enabled:=False;
   mmSelectAll.Enabled:=True;
   mmSearch.Enabled:=False;
   tbSearh.Enabled:=False;
   mmSearchNext.Enabled:=False;
   mmReplase.Enabled:=False;
   mmRun.Enabled:=False;
   tbRun.Enabled:=False;
   tbWord.Enabled:=True;
   mmWord.Enabled:=True;
   tbExcel.Enabled:=True;
   mmExcel.Enabled:=True;
   TbReport.Enabled:=True;
   mmReport.Enabled:=True;
 end;{if}
 //���� ������� �������� �������
if pcBase.ActivePageIndex=4 then
 Begin
    tbNew.Enabled:=False;
   mmNew.Enabled:=False;
   tbOpen.Enabled:=False;
   mmOpen.Enabled:=False;
   tbSave.Enabled:=False;
   mmSave.Enabled:=False;
   mmSaveAs.Enabled:=False;
   mmPrintPreSee.Enabled:=True;
   mmPrintOption.Enabled:=True;
   mmPrint.Enabled:=True;
   tbPrint.Enabled:=True;
   mmUndo.Enabled:=False;
   tbUndo.Enabled:=False;
   mmCut.Enabled:=False;
   tbCut.Enabled:=False;
   mmCopy.Enabled:=False;
   tbCopy.Enabled:=False;
   mmPaste.Enabled:=False;
   tbPaste.Enabled:=False;
   mmDelete.Enabled:=False;
   mmSelectAll.Enabled:=True;
   mmSearch.Enabled:=False;
   tbSearh.Enabled:=False;
   mmSearchNext.Enabled:=False;
   mmReplase.Enabled:=False;
   mmRun.Enabled:=False;
   tbRun.Enabled:=False;
   tbWord.Enabled:=True;
   mmWord.Enabled:=True;
   tbExcel.Enabled:=True;
   mmExcel.Enabled:=True;
   TbReport.Enabled:=True;
   mmReport.Enabled:=True;
 end;{if}
 //���� ������� �������� ������
if pcBase.ActivePageIndex=4 then
 Begin
    tbNew.Enabled:=False;
   mmNew.Enabled:=False;
   tbOpen.Enabled:=False;
   mmOpen.Enabled:=False;
   tbSave.Enabled:=False;
   mmSave.Enabled:=False;
   mmSaveAs.Enabled:=False;
   mmPrintPreSee.Enabled:=True;
   mmPrintOption.Enabled:=True;
   mmPrint.Enabled:=True;
   tbPrint.Enabled:=True;
   mmUndo.Enabled:=False;
   tbUndo.Enabled:=False;
   mmCut.Enabled:=False;
   tbCut.Enabled:=False;
   mmCopy.Enabled:=False;
   tbCopy.Enabled:=False;
   mmPaste.Enabled:=False;
   tbPaste.Enabled:=False;
   mmDelete.Enabled:=False;
   mmSelectAll.Enabled:=True;
   mmSearch.Enabled:=False;
   tbSearh.Enabled:=False;
   mmSearchNext.Enabled:=False;
   mmReplase.Enabled:=False;
   mmRun.Enabled:=False;
   tbRun.Enabled:=False;
   tbWord.Enabled:=True;
   mmWord.Enabled:=True;
   tbExcel.Enabled:=True;
   mmExcel.Enabled:=True;
   TbReport.Enabled:=True;
   mmReport.Enabled:=True;   
 end;{if}
end;{TPara_Normal.pcBaseChange}

procedure TPara_Normal.tbAboutClick(Sender: TObject);
begin
AboutBox.ShowModal;
end;

procedure TPara_Normal.cbTemperatureOSChange(Sender: TObject);
begin
 if cbTemperatureOS.ItemIndex = 0 then
  Begin
  eTOSReal.Text:= InputBox('������ ����������� ���������� ����������:','��� ����������� �����: �������� = ','0');
  end;{if}
 if cbTemperatureOS.ItemIndex = 1 then
  Begin
  eTOSReal.Text:='+5';
  end;{if}
 if cbTemperatureOS.ItemIndex = 2 then
  Begin
  eTOSReal.Text:='+40';
  end;{if}
end;

procedure TPara_Normal.tbRunClick(Sender: TObject);
begin
reTabResult.Clear;
//Checked_Multiplication(sgInputData)
//��������� ����� ������� ����������
Create_OutGrids(sgInputData.RowCount+2);
//��������� ���������
RUN_Prg(sgInputData,sgOutputData,
    eStartPressure,eBeforePressure,eStartTemperature,eLength,eTOSReal,cbTemperatureOS,
    FileProportion,FileProportion,FileCP);
end;

procedure TPara_Normal.tbTableClick(Sender: TObject);
begin

end;

{��������� ���������� ����� ���� ������ ����}
procedure TPara_Normal.mmSaveClick(Sender: TObject);
var
   xml: TXMLDocument;
begin
if PAth_File <> '' then
               Begin
                  xml := InitXML(PAth_File);
                  PAR_FileSaveToXML(xml,sgInputData);
                            PAR_FileSaveToXML_EditText(xml,eStartPressure);
                            PAR_FileSaveToXML_EditText(xml,eBeforePressure);
                            PAR_FileSaveToXML_EditText(xml,eStartTemperature);
                            PAR_FileSaveToXML_EditText(xml,eLength);
                            PAR_FileSaveToXML_ComboBox(xml,cbTemperatureOS);
                            PAR_FileSaveToXML_EditText(xml,eTOSReal);                  
                  //Pop_FileSaveToXML(xml,Hid_Grid);
                  //Pop_FileSaveToXML(xml,Result_Form.PVRH_Grid);
                  //Pop_FileSaveToXML(xml,Result_Form.RNM_Grid);
                  //Pop_FileSaveToXML(xml,Result_Form.NevP_Grid);
                  //Pop_FileSaveToXML_From_DAta(xml,hid_grid.RowCount);
                  DoneXML(xml);
                  tbSave.Enabled:=true;
                  mmSave.Enabled:=true;
                  TypeBox.Visible:=False;
                  FileNameToCaption(Path_File);
                end;{if}

 {TPara_Normal.tbSaveClick}
end;

procedure TPara_Normal.tbParolClick(Sender: TObject);
var Password:String;
begin
 Password:=InputBox('³������� ���������� ��������� ���������.','������ ������:','');
 If password = 'pipe' then Begin
  reTabResult.Visible:=True;
  Splitter1.Visible:=True;
  end
 else MessageDlg('Error - 119114'+#13+'������ �������!',mtError,[mbOK],0); 
end;

procedure TPara_Normal.pmChartPreSeeClick(Sender: TObject);
begin
ChartPARA.Print;
end;

procedure TPara_Normal.tbWordClick(Sender: TObject);
begin
DataToWord(sgInputData);
//DataToWord(sgOutputData);
//DataToWord(sgShotOutputData);
end;

procedure TPara_Normal.tbExcelClick(Sender: TObject);
begin
DataToExel(sgInputData,sgShotOutputData,sgOutputData);
end;

procedure TPara_Normal.tbReportClick(Sender: TObject);
begin
ReportPar.QuickRep1.PreviewModal;
end;

procedure TPara_Normal.mmPrintPreSeeClick(Sender: TObject);
begin
ReportPar.QuickRep1.PreviewModal;
//ReportPar.Chart1:=ChartPara;
end;

procedure TPara_Normal.tbShemaClick(Sender: TObject);
begin
faShema.ShowModal;
end;

end. {End Unit Base}
