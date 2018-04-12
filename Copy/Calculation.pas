unit Calculation;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
     Buttons, ComCtrls, ExtCtrls, ToolWin, Grids, ImgList, Dialogs, ExtDlgs,
      XMLDoc,XMLIntf,base,ATCheckedComboBox, Variants,  ShellApi,math,New_Open_Save_Edit,ChartPAR,
      Graphika,formAddShema;

     //Перевірка наявності введених даних
     function IsData(sg1:TStringGrid;eSP,eBP,eST,eL,eTOSRR:TEdit;cbTOS:TComboBox):Boolean;
     //Загальна процедура розрахунку
     Procedure RUN_Prg(InputData,OutputData:TStringGrid;eSP,eBP,eST,eL,eTOSRR:TEdit;cbTOS:TComboBox;
                   Local_suport,Proportion,cp:TFileName);
     //Виведення шапки ресультатів в поле Para_Normal.reTabResult
     Procedure Shapka_Result;
     //визначення суми добутків видів місцевого опору на їх кількість
     procedure Checked_Multiplication(STGrid:TStringGrid;NewMult2:real);
     //інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion)
     function Interpolated_Proportion(Start_P:real;Start_T:real;ProportionalFile:TFileName):Real;
     //інтерполювання теплоємності перегрітої водяної пари в таблиці (cp)
     function Interpolated_CP(Start_P:real;Start_T:real;CPFile:TFileName):Real;
     //обчислення орієнтовних втрат тиску на першій ділянці
     Function Orient_loos_P(input_Table:TstringGrid;Start_P:real;User_P:real;Len_magistral:real):Real;
     //обчислення орієнтовних втрат тиску на всых дылянках магыстралы крім 1 та останньої
     Function Orient_loos_P_other(input_Table:TstringGrid;i:integer;Start_P:real;User_P:real;Len_Sector,Len_magistral:real):Real;
     //обчислення орієнтовних втрат тиску на останній ділянці
     Function Orient_loos_P_last(Start_P:real;User_P:real):Real;
     //Орієнтовний тиск і температура на кінці ділянки
     Procedure Orient_PT_endMagistral(input_Table:TstringGrid;i:integer;Start_P:real;OrientLoosP:real;Start_t:real;var Orient_P,Orient_T:real);
     //Обчислення питомої втрат тиску
     Function Pitoma_loos_P(input_Table:TstringGrid;i:integer;OLP:real;IPG:real):real;
     //Діаметри
     Function Diametr(Loos_par:real;PLP:real;IPIP0:real; var TD_03,DH,Speed,RealSpeed:real; var TD_02:string):real;
     //Обрахунок кількості крмпенсаторів відповідно до обраного
     Function HowManyKompensators(sGrid:TStringGrid;i:integer;OurDiametr,len_sector:real):real;
     //Обрахунок еквівалентної довжини,розрахункової довжини
     Procedure EkRoz_len(CM,TD_03,len_sector:real; var EkLen,RozLen:real);
     //Питома втрата тиску при ГАММА
     function PLP2(DH,IPIP0:real):real;
     //Обрахунок втрати тиску
     Function loosP(RozLen,PLP:real):real;
     //Оцінка точності
     Function Ocurency(OLP,LSP:real):real;//:Boolean;
     //Зведення точності
     Function CastingOcurency(InputData:TstringGrid; i:integer;
                         SP,ST,LSP,IP0,DH,Speed,RozLen,OKUR:real;
                         ProportionalFile:TFileName;
                         var Orient_P,Orient_T,IP,IPIP0,PLP,RealSpeed,PLP_2,LSP2,OKUR2:real):boolean;
    //Питомі втрати тепла трубопроводів
     Function Dq(Diametr:real;Type_prok:string;TOS_prok:real):real;
     //Визначення середньо температури на ділянці
     Function TMID(Start_T,Orient_t:real):real;
     //Втрати тепла на ділянці
     Function LoosTeplo(tmid1,TOSP,DqReal,Roz_len:real):real;
     //Перепад температури на ділянці
     Function Dt(LTeplo,LP,IP0CP:real):real;
     //Реальний тиск на кінці ділянки
     Function Real_PP(Start_P,LSP2:real):real;
     //Реальна температура на кінці ділянки
     Function Real_TT(Start_T,Dt1:real):real;
     //Збільшення діаметру при умові коли LSP>OLP
     Function YakasLaga (InputData:TStringGrid;i:integer;
                    Diam1,Diam,Len_Sector,IPIP0,OLP,SP,ST:real;
                    Real_IP0,LP:real;
                    Proportion:TFileName;
                    var DiamNew,DH,TD_03,HMK,CM,EkLen,RozLen,PLP_2,LSP,Speed,RealSpeed:real;
                    var NumD:integer;
                    var TD_02:string):real;



var
     //рядки із сумою добутків виду місцевого опору
     sLIST:TStringList;
     Kompensator:string;

implementation


//Загальна процедура розрахунку
Procedure RUN_Prg(InputData,OutputData:TStringGrid;eSP,eBP,eST,eL,eTOSRR:TEdit;cbTOS:TComboBox;
              Local_suport,Proportion,cp:TFileName);
var
SP,BP,LM,ST,OP,OT,LP,TD_03,DH,CM:real;
cod,i,j:integer;
OLP,OPTeM,IP,IP0,IPIP0,PLP,diam,diam1,HMK,LSP,PLP_2:real;
LastMag:integer;
len_sector:real;
EkLen,RozLen:real;
LSP2,OKUR,OKUR2:real;Speed,RealSpeed,DqReal:real;
TOSP:real;
IP0Cp1,TMID1,LTeplo,Dt1,Real_PP1,Real_TT1,Real_IP0,Real_IPIP0:Real;
DiamNew:real;
NumD:integer;  TD_02:string;
SumLSP:real; ss,vidgalyg:integer;
Diafragma,CM_New,Nevazka,nevazka1:real;
Connect,fc:integer;connectV:string;
Begin
 //Перевірка наявності введених вихідних даних
 if IsData(InputData,eSP,eBP,eST,eL,eTOSRR,cbTOS) then
  Begin
   with Para_Normal do
       Begin
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
       end;{with}
   AddAlgoritm('Перевірка наявності вхідних даних пройшла успішно.','OK',clGray);
 InputData.Enabled:=False;
 //Знаходимо останній рядок який є магістраллю
 For i:=1 to InputData.RowCount-1 do
  Begin
   if InputData.Cells[5,i]='Магістраль' then
    LastMag:=i;
  end;{for}
  AddAlgoritm('Знайдено останній рідок магістралі. [ ОК ] LastMag = ',IntToStr(LastMag),clGray);
 //Обчислення в залежності від рядків
 For i:=1 to InputData.ColCount-1 do
  Begin
   AddAlgoritm('Запуск алгоритму почакту обчислень здійснено успішно.','OK',clPurple);
   //Обчислення першого рядка магістралі
   If i=1 then
    Begin
    //-----------------------------------------------------------------------
      with Para_Normal do
       Begin
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
       end;{with}
    AddAlgoritm('ОПРАЦЮВАННЯ 1-ї ДІЛЯНКИ','OK',clGreen);
    AddAlgoritm('Ділянка №',InputData.cells[0,1],clRed);
      with Para_Normal do
       Begin
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
       end;{with}
     //-----------------------------------------------------------------------
     val(InputData.cells[2,1],len_sector,cod);
     val(InputData.cells[1,1],LP,cod);
     val(eSP.Text,SP,cod);
     val(eBP.Text,BP,cod);
     val(el.Text,LM,cod);
     val(eST.Text,ST,cod);
     //інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion)
     IP0:=Interpolated_Proportion(SP,ST,Proportion);
     AddAlgoritm('Інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion) IP0 = ',FloatTostr(IP0),clBlack);
    //обчислення орієнтовних втрат тиску
     OLP:=Orient_loos_P(InputData,SP,BP,LM);
     AddAlgoritm('Обчислення орієнтовних втрат тиску OLP = ',FloatTostr(OLP),clBlack);
    //Орієнтовний тиск і температура на кінці ділянки
     Orient_PT_endMagistral(InputData,i,SP,OLP,ST,OP,OT);
     AddAlgoritm('Орієнтовний тиск на кінці ділянки OP = ',FloatTostr(OP),clBlack);
     AddAlgoritm('Орієнтовна температура на кінці ділянки OP = ',FloatTostr(OP),clBlack);
    //інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion)
    //за новими значеннями тиску і температури
     IP:=Interpolated_Proportion(OP,OT,Proportion);
     AddAlgoritm('Iнтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion) за новими значеннями тиску і температури IP = ',FloatTostr(IP),clBlack);
    //Середнє арифметичне значення між двома (Гамма)
     IPIP0:=(IP+IP0)/2;
     AddAlgoritm('Середнє арифметичне значення між двома (Гамма) IPIP0 = ',FloatTostr(IPIP0),clBlack);
    //Обчислення питомої втрат тиску
     PLP:=Pitoma_loos_P(InputData,i,OLP,IPIP0);
     AddAlgoritm('Обчислення питомих втрат тиску PLP = ',FloatTostr(PLP),clBlack);
    //Підбір діаметрів
     Diam:=Diametr(LP,PLP,IPIP0,TD_03,DH,Speed,RealSpeed,TD_02);
     AddAlgoritm('Результат підбору діаметрів Diam = ',FloatTostr(Diam),clBlack);
     AddAlgoritm('Результат підбору діаметрів TD_03 = ',FloatTostr(TD_03),clBlack);
     AddAlgoritm('DH = ',FloatTostr(DH),clBlack);
     AddAlgoritm('Швидкість Speed = ',FloatTostr(Speed),clBlack);
     AddAlgoritm('Реальна швидкість RealSpeed = ',FloatTostr(RealSpeed),clBlack);
     AddAlgoritm('TD_02 = ',TD_02,clBlack);
     //Обрахунок кількості крмпенсаторів відповідно до обраного
     HMK:=HowManyKompensators(InputData,i,Diam,len_sector);
     AddAlgoritm('Обрахунок кількості кoмпенсаторів відповідно до обраного HMK = ',FloatTostr(HMK),clBlack);
     //визначення суми добутків видів місцевого опору на їх кількість
     Checked_Multiplication(InputData,HMK);
      val(sList.Strings[0],CM,cod);
      AddAlgoritm('Bизначення суми добутків видів місцевого опору на їх кількість CM = ',FloatTostr(CM),clBlack);
     //Обрахунок еквівалентної довжини,розрахункової довжини
     EkRoz_len(CM,TD_03,len_sector,EkLen,RozLen);
     AddAlgoritm('Обрахунок еквівалентної довжини EkLen = ',FloatTostr(EkLen),clBlack);
     AddAlgoritm('Обрахунок розрахункової довжини EkLen = ',FloatTostr(RozLen),clBlack);
     //Питома втрата тиску при ГАММА
     PLP_2:=PLP2(DH,IPIP0);
     AddAlgoritm('Питома втрата тиску при ГАММА PLP_2 = ',FloatTostr(PLP_2),clBlack);
     //Обрахунок втрати тиску
     LSP:=loosP(RozLen,PLP_2);
     AddAlgoritm('Обрахунок втрати тиску LSP = ',FloatTostr(LSP),clBlack);
     //Оцінка точності
     OKUR:=Ocurency(OLP,LSP);
     AddAlgoritm('Оцінка точності OKUR = ',FloatTostr(OKUR),clBlack);
     //Зведення точності
      CastingOcurency(InputData,i,
                      SP,ST,LSP,IP0,DH,Speed,RozLen,OKUR,
                      Proportion,
                      OP,OT,IP,IPIP0,PLP,RealSpeed,PLP_2,LSP2,OKUR2);
   //Питомі втрати тепла трубопроводів
    VAl(eTOSRR.Text,TOSP,cod);
    DqReal:=Dq(Diam,cbTOS.Text,OT);
    AddAlgoritm('Питомі втрати тепла трубопроводів DqReal = ',FloatTostr(DqReal),clBlack);
   //інтерполювання теплоємності перегрітої водяної пари в таблиці (cp)
    IP0CP1:= Interpolated_CP(SP,ST,cp);
    AddAlgoritm('Iнтерполювання теплоємності перегрітої водяної пари в таблиці (cp) IP0CP1 = ',FloatTostr(IP0CP1),clBlack);
   //Визначення середньо температури на ділянці
    TMID1:=TMID(ST,OT);
    AddAlgoritm('Визначення середньо температури на ділянці TMID1 = ',FloatTostr(TMID1),clBlack);
   //Втрати тепла на ділянці
    LTeplo:=LoosTeplo(tmid1,TOSP,DqReal,Rozlen);
    AddAlgoritm('Втрати тепла на ділянці LTeplo = ',FloatTostr(LTeplo),clBlack);
   //Перепад температури на ділянці
    Dt1:= Dt(LTeplo,LP,IP0CP1);
    AddAlgoritm('Перепад температури на ділянці Dt1 = ',FloatTostr(Dt1),clBlack);
   //Реальний тиск на кінці ділянки
    Real_PP1:=Real_PP(SP,LSP2);
    AddAlgoritm('Реальний тиск на кінці ділянки Real_PP1 = ',FloatTostr(Real_PP1),clBlack);
   //Реальна температура на кінці ділянки
    REal_TT1:= Real_TT(ST,Dt1);
    AddAlgoritm('Реальна температура на кінці ділянки Real_TT1 = ',FloatTostr(Real_TT1),clBlack);
   //Реальна питома вага пари на кінці ділянки
    Real_IP0:=Interpolated_Proportion(Real_PP1,Real_TT1,Proportion);
    AddAlgoritm('Реальна питома вага пари на кінці ділянки Real_IP0 = ',FloatTostr(Real_IP0),clBlack);
   //Реальна середня питома вага пари
    Real_IPIP0:=(IP0+Real_IP0)/2;
    AddAlgoritm('Реальна середня питома вага пари Real_IPIP0 = ',FloatTostr(Real_IPIP0),clBlack);
     {Виведеня результатів в таблицю sgOutputData}
      AddResult(0,2,InputData.cells[0,1]);
      AddResult(1,2,InputData.cells[1,1]);
      AddResult(2,2,eSP.Text);
      AddResult(3,2,eST.Text);
      AddResult(4,2,FloatToSTRF(IP0,ffFixed,10,3));
      AddResult(5,2,FloatToStrF(LSP2,ffFixed,10,0));
      AddResult(6,2,FloatToStrF(OP,ffFixed,10,0));
      AddResult(7,2,FloatToStrF(OT,ffFixed,10,2));
      AddResult(8,2,FloatToStrF(IP,ffFixed,10,3));
      AddResult(9,2,FloatToStrF(IPIP0,ffFixed,10,3));
      AddResult(10,2,FloatToStrF(PLP,ffFixed,10,2));
      AddResult(11,2,TD_02);
      AddResult(12,2,FloatToStr(Diam));
      AddResult(13,2,FloatToStr(Len_Sector));
      AddResult(14,2,FloatToStr(TD_03));
      AddResult(15,2,FloatToStrF(EkLen,ffFixed,10,2));
      AddResult(16,2,FloatToStrF(RozLen,ffFixed,10,2));
      AddResult(17,2,InputData.cells[3,1]+', к-ть= ['+InputData.cells[4,1]+']');
      AddResult(18,2,FloatToStr(CM));
      AddResult(19,2,FloatToStrF(Dh,ffFixed,10,2));
      AddResult(20,2,FloatToStrF(Speed,ffFixed,10,2));
      AddResult(21,2,FloatToStrF(PLP_2,ffFixed,10,2));
      AddResult(22,2,FloatToStrF(RealSpeed,ffFixed,10,2));
      AddResult(23,2,FloatToStrF(LSP2,ffFixed,10,0));
      AddResult(24,2,FloatToStrF(OKUR2,ffFixed,10,3));
      AddResult(25,2,FloatToStr(DqReal));
      AddResult(26,2,FloatToStrF(IP0cp1,ffFixed,10,2));
      AddResult(27,2,FloatToStrF(TMID1,ffFixed,10,2));
      AddResult(28,2,FloatToStrF(LTeplo,ffFixed,10,0));
      AddResult(29,2,FloatToStrF(Dt1,ffFixed,10,2));
      AddResult(30,2,FloatToStrF(Real_PP1,ffFixed,10,0));
      AddResult(31,2,FloatToStrF(Real_TT1,ffFixed,10,2));
      AddResult(32,2,FloatToStrF(Real_IP0,ffFixed,10,3));
      AddResult(33,2,FloatToStrF(Real_IPIP0,ffFixed,10,3));
      AddResult(34,2,'--');
      {Кінець виведення даних до таблиці sgOutputData}
   end;{if}

     //Обчислення Всіх рядків магістралі крім 1-го та останнього рядка магістралі
     if (i>1) and (i<LastMag) and(InputData.Cells[5,i]='Магістраль') then
      Begin
     //-----------------------------------------------------------------------
      with Para_Normal do
       Begin
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
       end;{with}
    AddAlgoritm('ОПРАЦЮВАННЯ ВСІХ ДІЛЯНОК КРІМ 1-ї та ОСТАННЬОЇ','OK',clGreen);
    AddAlgoritm('Ділянка №',InputData.cells[0,i],clRed);
      with Para_Normal do
       Begin
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
       end;{with}
     //-----------------------------------------------------------------------
     //інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion)
     IP0:=Real_IP0;
     AddAlgoritm('Інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion) IP0 = ',FloatTostr(IP0),clBlack);
    //обчислення орієнтовних втрат тиску
     OLP:=Orient_loos_P_other(InputData,i,SP{Real_PP1},BP,Len_Sector,LM);
     AddAlgoritm('Обчислення орієнтовних втрат тиску OLP = ',FloatTostr(OLP),clBlack);
     val(InputData.cells[2,i],len_sector,cod);
     val(InputData.cells[1,i],LP,cod);
    //Орієнтовний тиск і температура на кінці ділянки
     Orient_PT_endMagistral(InputData,i,Real_PP1,OLP,Real_TT1,OP,OT);
     AddAlgoritm('Орієнтовний тиск на кінці ділянки OP = ',FloatTostr(OP),clBlack);
     AddAlgoritm('Орієнтовна температура на кінці ділянки OP = ',FloatTostr(OP),clBlack);
    //інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion)
    //за новими значеннями тиску і температури
     IP:=Interpolated_Proportion(OP,OT,Proportion);
     AddAlgoritm('Iнтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion) за новими значеннями тиску і температури IP = ',FloatTostr(IP),clBlack);
    //Середнє арифметичне значення між двома (Гамма)
     IPIP0:=(IP+IP0)/2;
     AddAlgoritm('Середнє арифметичне значення між двома (Гамма) IPIP0 = ',FloatTostr(IPIP0),clBlack);
    //Обчислення питомої втрат тиску
     PLP:=Pitoma_loos_P(InputData,i,OLP,IPIP0);
     AddAlgoritm('Обчислення питомих втрат тиску PLP = ',FloatTostr(PLP),clBlack);
    //Підбір діаметрів
     Diam1:=Diametr(LP,PLP,IPIP0,TD_03,DH,Speed,RealSpeed,TD_02);
     AddAlgoritm('Результат підбору діаметрів Diam = ',FloatTostr(Diam1),clBlack);
     AddAlgoritm('Результат підбору діаметрів TD_03 = ',FloatTostr(TD_03),clBlack);
     AddAlgoritm('DH = ',FloatTostr(DH),clBlack);
     AddAlgoritm('Швидкість Speed = ',FloatTostr(Speed),clBlack);
     AddAlgoritm('Реальна швидкість RealSpeed = ',FloatTostr(RealSpeed),clBlack);
     AddAlgoritm('TD_02 = ',TD_02,clBlack);
     //Обрахунок кількості крмпенсаторів відповідно до обраного
     HMK:=HowManyKompensators(InputData,i,Diam1,len_sector);
     AddAlgoritm('Обрахунок кількості кoмпенсаторів відповідно до обраного HMK = ',FloatTostr(HMK),clBlack);
     //визначення суми добутків видів місцевого опору на їх кількість
     Checked_Multiplication(InputData,HMK);
      val(sList.Strings[i-1],CM,cod);
      AddAlgoritm('Bизначення суми добутків видів місцевого опору на їх кількість CM = ',FloatTostr(CM),clBlack);
      If diam1<diam then
        Begin
        diam:=diam1;
        CM:=CM+0.5;
        InputData.cells[3,i]:=InputData.cells[3,i]+', Звуження (0.5)';
        InputData.cells[4,i]:=InputData.cells[4,i]+' ,1';
        AddAlgoritm('Звуження (0.5) встановлено успішно = ','ОК',clBlue);
        end;{if}
     //Обрахунок еквівалентної довжини,розрахункової довжини
     EkRoz_len(CM,TD_03,len_sector,EkLen,RozLen);
     AddAlgoritm('Обрахунок еквівалентної довжини EkLen = ',FloatTostr(EkLen),clBlack);
     AddAlgoritm('Обрахунок розрахункової довжини EkLen = ',FloatTostr(RozLen),clBlack);
     //Питома втрата тиску при ГАММА
     PLP_2:=PLP2(DH,IPIP0);
     AddAlgoritm('Питома втрата тиску при ГАММА PLP_2 = ',FloatTostr(PLP_2),clBlack);
     //Обрахунок втрати тиску
     LSP:=loosP(RozLen,PLP_2);
     AddAlgoritm('Обрахунок втрати тиску LSP = ',FloatTostr(LSP),clBlack);
     //Оцінка точності
     OKUR:=Ocurency(OLP,LSP);
     AddAlgoritm('Оцінка точності OKUR = ',FloatTostr(OKUR),clBlack);
    //Зведення точності
      CastingOcurency(InputData,i,
                      Real_PP1,Real_TT1,LSP,Real_IP0,DH,Speed,RozLen,OKUR,
                      Proportion,
                      OP,OT,IP,IPIP0,PLP,RealSpeed,PLP_2,LSP2,OKUR2);
     {Виведеня результатів в таблицю sgOutputData}
      AddResult(0,i+1,InputData.cells[0,i]);
      AddResult(1,i+1,InputData.cells[1,i]);
      AddResult(2,i+1,FloatToSTRF(Real_PP1,ffFixed,10,0));
      AddResult(3,i+1,FloatToSTRF(Real_TT1,ffFixed,10,2));
      AddResult(4,i+1,FloatToSTRF(Real_IP0,ffFixed,10,3));
      AddResult(5,i+1,FloatToStrF(LSP2,ffFixed,10,0));
      AddResult(6,i+1,FloatToStrF(OP,ffFixed,10,0));
      AddResult(7,i+1,FloatToStrF(OT,ffFixed,10,2));
      AddResult(8,i+1,FloatToStrF(IP,ffFixed,10,3));
      AddResult(9,i+1,FloatToStrF(IPIP0,ffFixed,10,3));
      AddResult(10,i+1,FloatToStrF(PLP,ffFixed,10,2));
      AddResult(11,i+1,TD_02);
      AddResult(12,i+1,FloatToStr(Diam1));
      AddResult(13,i+1,FloatToStr(Len_Sector));
      AddResult(14,i+1,FloatToStr(TD_03));
      AddResult(15,i+1,FloatToStrF(EkLen,ffFixed,10,2));
      AddResult(16,i+1,FloatToStrF(RozLen,ffFixed,10,2));
      AddResult(17,i+1,InputData.cells[3,i]+', к-ть= ['+InputData.cells[4,i]+']');
      AddResult(18,i+1,FloatToStr(CM));
      AddResult(19,i+1,FloatToStrF(Dh,ffFixed,10,2));
      AddResult(20,i+1,FloatToStrF(Speed,ffFixed,10,2));
      AddResult(21,i+1,FloatToStrF(PLP_2,ffFixed,10,2));
      AddResult(22,i+1,FloatToStrF(RealSpeed,ffFixed,10,2));
      AddResult(23,i+1,FloatToStrF(LSP2,ffFixed,10,0));
      AddResult(24,i+1,FloatToStrF(OKUR2,ffFixed,10,3));
      {Кінець виведення даних до таблиці sgOutputData}

   //Питомі втрати тепла трубопроводів
    VAl(eTOSRR.Text,TOSP,cod);
    DqReal:=Dq(Diam,cbTOS.Text,OT);
    AddAlgoritm('Питомі втрати тепла трубопроводів DqReal = ',FloatTostr(DqReal),clBlack);
   //інтерполювання теплоємності перегрітої водяної пари в таблиці (cp)
    IP0CP1:= Interpolated_CP(Real_PP1,Real_TT1,cp);
    AddAlgoritm('Iнтерполювання теплоємності перегрітої водяної пари в таблиці (cp) IP0CP1 = ',FloatTostr(IP0CP1),clBlack);
   //Визначення середньо температури на ділянці
    TMID1:=TMID(Real_TT1,OT);
    AddAlgoritm('Визначення середньо температури на ділянці TMID1 = ',FloatTostr(TMID1),clBlack);
  //Втрати тепла на ділянці
    LTeplo:=LoosTeplo(tmid1,TOSP,DqReal,Rozlen);
    AddAlgoritm('Втрати тепла на ділянці LTeplo = ',FloatTostr(LTeplo),clBlack);
  //Перепад температури на ділянці
    Dt1:= Dt(LTeplo,LP,IP0CP1);
    AddAlgoritm('Перепад температури на ділянці Dt1 = ',FloatTostr(Dt1),clBlack);
  //Реальний тиск на кінці ділянки
    Real_PP1:=Real_PP(Real_pp1,LSP2);
    AddAlgoritm('Реальний тиск на кінці ділянки Real_PP1 = ',FloatTostr(Real_PP1),clBlack);
  //Реальна температура на кінці ділянки
    REal_TT1:= Real_TT(Real_TT1,Dt1);
    AddAlgoritm('Реальна температура на кінці ділянки Real_TT1 = ',FloatTostr(Real_TT1),clBlack);
  //Реальна питома вага пари на кінці ділянки
    Real_IP0:=Interpolated_Proportion(Real_PP1,Real_TT1,Proportion);
    AddAlgoritm('Реальна питома вага пари на кінці ділянки Real_IP0 = ',FloatTostr(Real_IP0),clBlack);
  //Реальна середня питома вага пари
    Real_IPIP0:=(IP0+Real_IP0)/2;
    AddAlgoritm('Реальна середня питома вага пари Real_IPIP0 = ',FloatTostr(Real_IPIP0),clBlack);
      {Виведеня результатів в таблицю sgOutputData}
      AddResult(25,i+1,FloatToStr(DqReal));
      AddResult(26,i+1,FloatToStrF(IP0cp1,ffFixed,10,2));
      AddResult(27,i+1,FloatToStrF(TMID1,ffFixed,10,2));
      AddResult(28,i+1,FloatToStrF(LTeplo,ffFixed,10,0));
      AddResult(29,i+1,FloatToStrF(Dt1,ffFixed,10,2));
      AddResult(30,i+1,FloatToStrF(Real_PP1,ffFixed,10,0));
      AddResult(31,i+1,FloatToStrF(Real_TT1,ffFixed,10,2));
      AddResult(32,i+1,FloatToStrF(Real_IP0,ffFixed,10,3));
      AddResult(33,i+1,FloatToStrF(Real_IPIP0,ffFixed,10,3));
      AddResult(34,i+1,'--');
      {Кінець виведення даних до таблиці sgOutputData}
   end;{if}
     //Обчислення останнього рядка магістралі
     if i=LastMag then
      Begin
     //-----------------------------------------------------------------------
      with Para_Normal do
       Begin
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
       end;{with}
    AddAlgoritm('ОПРАЦЮВАННЯ ОСТАННЬОЇ ДІЛЯНКИ МАГІСТРАЛІ','OK',clGreen);
    AddAlgoritm('Ділянка №',InputData.cells[0,i],clRed);
      with Para_Normal do
       Begin
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
       end;{with}
     //-----------------------------------------------------------------------
      //інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion)
     IP0:=Real_IP0;
     AddAlgoritm('Інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion) IP0 = ',FloatTostr(IP0),clBlack);
     //обчислення орієнтовних втрат тиску
     OLP:=Orient_loos_P_last(Real_PP1,BP);
     AddAlgoritm('Обчислення орієнтовних втрат тиску OLP = ',FloatTostr(OLP),clBlack);
     val(InputData.cells[2,i],len_sector,cod);
     val(InputData.cells[1,i],LP,cod);
    //Орієнтовний тиск і температура на кінці ділянки
     Orient_PT_endMagistral(InputData,i,Real_PP1,OLP,Real_TT1,OP,OT);
     OP:=BP;
     AddAlgoritm('Орієнтовний тиск на кінці ділянки OP = ',FloatTostr(OP),clBlack);
     AddAlgoritm('Орієнтовна температура на кінці ділянки OP = ',FloatTostr(OP),clBlack);
    //інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion)
    //за новими значеннями тиску і температури
     IP:=Interpolated_Proportion(OP,OT,Proportion);
     AddAlgoritm('Iнтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion) за новими значеннями тиску і температури IP = ',FloatTostr(IP),clBlack);
    //Середнє арифметичне значення між двома (Гамма)
     IPIP0:=(IP+Real_IP0)/2;
     AddAlgoritm('Середнє арифметичне значення між двома (Гамма) IPIP0 = ',FloatTostr(IPIP0),clBlack);
    //Обчислення питомої втрат тиску
     PLP:=Pitoma_loos_P(InputData,i,OLP,IPIP0);
     AddAlgoritm('Обчислення питомих втрат тиску PLP = ',FloatTostr(PLP),clBlack);
    //Підбір діаметрів
     Diam1:=Diametr(LP,PLP,IPIP0,TD_03,DH,Speed,RealSpeed,TD_02);
     AddAlgoritm('Результат підбору діаметрів Diam = ',FloatTostr(Diam1),clBlack);
     AddAlgoritm('Результат підбору діаметрів TD_03 = ',FloatTostr(TD_03),clBlack);
     AddAlgoritm('DH = ',FloatTostr(DH),clBlack);
     AddAlgoritm('Швидкість Speed = ',FloatTostr(Speed),clBlack);
     AddAlgoritm('Реальна швидкість RealSpeed = ',FloatTostr(RealSpeed),clBlack);
     AddAlgoritm('TD_02 = ',TD_02,clBlack);
     //Обрахунок кількості крмпенсаторів відповідно до обраного
     HMK:=HowManyKompensators(InputData,i,Diam1,len_sector);
     AddAlgoritm('Обрахунок кількості кoмпенсаторів відповідно до обраного HMK = ',FloatTostr(HMK),clBlack);
     //визначення суми добутків видів місцевого опору на їх кількість
     Checked_Multiplication(InputData,HMK);
      val(sList.Strings[i-1],CM,cod);
      AddAlgoritm('Bизначення суми добутків видів місцевого опору на їх кількість CM = ',FloatTostr(CM),clBlack);
      If diam1<diam then
        Begin
        //diam:=diam1;
        CM:=CM+0.5;
        //InputData.cells[3,i]:=InputData.cells[3,i]+', Звуження (0.5)';
        //InputData.cells[4,i]:=InputData.cells[4,i]+' ,1'
        end;{if}
     //Обрахунок еквівалентної довжини,розрахункової довжини
     EkRoz_len(CM,TD_03,len_sector,EkLen,RozLen);
     AddAlgoritm('Обрахунок еквівалентної довжини EkLen = ',FloatTostr(EkLen),clBlack);
     AddAlgoritm('Обрахунок розрахункової довжини EkLen = ',FloatTostr(RozLen),clBlack);
     //Питома втрата тиску при ГАММА
     PLP_2:=PLP2(DH,IPIP0);
     AddAlgoritm('Питома втрата тиску при ГАММА PLP_2 = ',FloatTostr(PLP_2),clBlack);
     //Обрахунок втрати тиску
     LSP:=loosP(RozLen,PLP_2);
     AddAlgoritm('Обрахунок втрати тиску LSP = ',FloatTostr(LSP),clBlack);
     if LSP>OLP then
      Begin
       While LSP>OLP do
        Begin
         //Збільшення діаметру при умові коли LSP>OLP
         YakasLaga(InputData,i,
                    Diam1,Diam,Len_Sector,IPIP0,OLP,SP,ST,
                    Real_IP0,LP,
                    Proportion,
                    DiamNew,DH,TD_03,HMK,CM,EkLen,RozLen,PLP_2,LSP,Speed,RealSpeed,
                    NumD,
                    TD_02);
          diam1:=DiamNew;
        end;{while}
        AddAlgoritm('Збільшення діаметру завершено успішно ','OK',clBlue);
      end{if}
      else
       Begin
       AddAlgoritm('Збільшення діаметру при умові коли LSP>OLP НЕВИКОНАНО','No',clBlue);
       end;{else}
      If DiamNew<diam then
        Begin
        diam:=diamNew;
       // CM:=CM+0.5;
        InputData.cells[3,i]:=InputData.cells[3,i]+', Звуження (0.5)';
        InputData.cells[4,i]:=InputData.cells[4,i]+' ,1';
        AddAlgoritm('Звуження (0.5) встановлено успішно = ','ОК',clBlue);
        end;{if}
      //Встановлення діафрагми
      SumLSP:=LSP;
      CM_New:=CM;
      for ss:=2 to lastmag do
       Begin
        SumLSP:=SumLSP+StrToFloat(OutputData.Cells[22,ss])
       end;{for}
       AddAlgoritm('SumLSP = ',FloatTostr(SumLSP),clBlack);
      if SumLSP <= ((SP-BP){*0.9}) then
       Begin
        LSP:=OLP;
        LSP2:=LSP;
        RozLen:=LSP/PLP_2;
        EkLen:=RozLen-Len_Sector;
        CM_new:=EkLen/TD_03;
        Diafragma:=CM_new-CM;
        InputData.cells[3,i]:=InputData.cells[3,i]+', Діафрагма ('+FloatToStrF(Diafragma,ffFixed,10,0)+')';
        InputData.cells[4,i]:=InputData.cells[4,i]+' ,1';
        OKUR2:=((OLP-LSP)/OLP)*100;
         //-----------------------------------------------------------------------
         AddAlgoritm('Умова SumLSP <= (SP-BP) ВИКОНАНА = ','OK',clRed);
         AddAlgoritm('Обрахунок втрати тиску LSP = ',FloatTostr(LSP),clBlack);
         AddAlgoritm('Обрахунок еквівалентної довжини EkLen = ',FloatTostr(EkLen),clBlack);
         AddAlgoritm('Обрахунок розрахункової довжини EkLen = ',FloatTostr(RozLen),clBlack);
         AddAlgoritm('Bизначення суми добутків видів місцевого опору на їх кількість CM_New = ',FloatTostr(CM_New),clBlack);
         AddAlgoritm('Значання діафрагми Diafragma = ',FloatTostr(Diafragma),clBlack);
         AddAlgoritm('Оцінка точності OKUR2 = ',FloatTostr(OKUR2),clBlack);
         //-----------------------------------------------------------------------
       end;{if}
      if SumLSP > ((SP-BP)*0.9) then Begin
       AddAlgoritm('Умова SumLSP <= (SP-BP) НЕВИКОНАНА = ','No',clRed);
     //Оцінка точності
     OKUR:=Ocurency(OLP,LSP);
     AddAlgoritm('Оцінка точності OKUR = ',FloatTostr(OKUR),clBlack);
     //Зведення точності
      CastingOcurency(InputData,i,
                      Real_PP1,Real_TT1,LSP,Real_IP0,DH,Speed,RozLen,OKUR,
                      Proportion,
                      OP,OT,IP,IPIP0,PLP,RealSpeed,PLP_2,LSP2,OKUR2);
      end;{else}
          {Виведеня результатів в таблицю sgOutputData}
      AddResult(0,i+1,InputData.cells[0,i]);
      AddResult(1,i+1,InputData.cells[1,i]);
      AddResult(2,i+1,FloatToSTRF(Real_PP1,ffFixed,10,0));
      AddResult(3,i+1,FloatToSTRF(Real_TT1,ffFixed,10,2));
      AddResult(4,i+1,FloatToSTRF(Real_IP0,ffFixed,10,3));
      AddResult(5,i+1,FloatToStrF(LSP2,ffFixed,10,0));
      AddResult(6,i+1,FloatToStrF(OP,ffFixed,10,0));
      AddResult(7,i+1,FloatToStrF(OT,ffFixed,10,2));
      AddResult(8,i+1,FloatToStrF(IP,ffFixed,10,3));
      AddResult(9,i+1,FloatToStrF(IPIP0,ffFixed,10,3));
      AddResult(10,i+1,FloatToStrF(PLP,ffFixed,10,2));
      AddResult(11,i+1,TD_02);
      AddResult(12,i+1,FloatToStr(Diam1));
      AddResult(13,i+1,FloatToStr(Len_Sector));
      AddResult(14,i+1,FloatToStr(TD_03));
      AddResult(15,i+1,FloatToStrF(EkLen,ffFixed,10,2));
      AddResult(16,i+1,FloatToStrF(RozLen,ffFixed,10,2));
      AddResult(17,i+1,InputData.cells[3,i]+', к-ть= ['+InputData.cells[4,i]+']');
      AddResult(18,i+1,FloatToStrF(CM_New,ffFixed,10,2));
      AddResult(19,i+1,FloatToStrF(Dh,ffFixed,10,2));
      AddResult(20,i+1,FloatToStrF(Speed,ffFixed,10,2));
      AddResult(21,i+1,FloatToStrF(PLP_2,ffFixed,10,2));
      AddResult(22,i+1,FloatToStrF(RealSpeed,ffFixed,10,2));
      AddResult(23,i+1,FloatToStrF(LSP2,ffFixed,10,0));
      AddResult(24,i+1,FloatToStrF(OKUR2,ffFixed,10,3));
      {Кінець виведення даних до таблиці sgOutputData}
   //Питомі втрати тепла трубопроводів
    VAl(eTOSRR.Text,TOSP,cod);
    DqReal:=Dq(Diam,cbTOS.Text,OT);
    AddAlgoritm('Питомі втрати тепла трубопроводів DqReal = ',FloatTostr(DqReal),clBlack);
   //інтерполювання теплоємності перегрітої водяної пари в таблиці (cp)
    IP0CP1:= Interpolated_CP(Real_PP1,Real_TT1,cp);
    AddAlgoritm('Iнтерполювання теплоємності перегрітої водяної пари в таблиці (cp) IP0CP1 = ',FloatTostr(IP0CP1),clBlack);
   //Визначення середньо температури на ділянці
    TMID1:=TMID(Real_TT1,OT);
    AddAlgoritm('Визначення середньо температури на ділянці TMID1 = ',FloatTostr(TMID1),clBlack);
   //Втрати тепла на ділянці
    LTeplo:=LoosTeplo(tmid1,TOSP,DqReal,Rozlen);
    AddAlgoritm('Втрати тепла на ділянці LTeplo = ',FloatTostr(LTeplo),clBlack);
   //Перепад температури на ділянці
    Dt1:= Dt(LTeplo,LP,IP0CP1);
    AddAlgoritm('Перепад температури на ділянці Dt1 = ',FloatTostr(Dt1),clBlack);
   //Реальний тиск на кінці ділянки
    Real_PP1:=Real_PP(Real_pp1,LSP2);
    AddAlgoritm('Реальний тиск на кінці ділянки Real_PP1 = ',FloatTostr(Real_PP1),clBlack);
   //Реальна температура на кінці ділянки
    REal_TT1:= Real_TT(Real_TT1,Dt1);
    AddAlgoritm('Реальна температура на кінці ділянки Real_TT1 = ',FloatTostr(Real_TT1),clBlack);
  //Реальна питома вага пари на кінці ділянки
    Real_IP0:=Interpolated_Proportion(Real_PP1,Real_TT1,Proportion);
    AddAlgoritm('Реальна питома вага пари на кінці ділянки Real_IP0 = ',FloatTostr(Real_IP0),clBlack);
  //Реальна середня питома вага пари
    Real_IPIP0:=(IP0+Real_IP0)/2;
    AddAlgoritm('Реальна середня питома вага пари Real_IPIP0 = ',FloatTostr(Real_IPIP0),clBlack);
      {Виведеня результатів в таблицю sgOutputData}
      AddResult(25,i+1,FloatToStr(DqReal));
      AddResult(26,i+1,FloatToStrF(IP0cp1,ffFixed,10,2));
      AddResult(27,i+1,FloatToStrF(TMID1,ffFixed,10,2));
      AddResult(28,i+1,FloatToStrF(LTeplo,ffFixed,10,0));
      AddResult(29,i+1,FloatToStrF(Dt1,ffFixed,10,2));
      AddResult(30,i+1,FloatToStrF(Real_PP1,ffFixed,10,0));
      AddResult(31,i+1,FloatToStrF(Real_TT1,ffFixed,10,2));
      AddResult(32,i+1,FloatToStrF(Real_IP0,ffFixed,10,3));
      AddResult(33,i+1,FloatToStrF(Real_IPIP0,ffFixed,10,3));
      AddResult(34,i+1,'--');
      {Кінець виведення даних до таблиці sgOutputData}
      end;{if}
   end;{for}

    //Обчислення напису (відгалуження)
     vidgalyg:=0;
     For i:=1 to InputData.ColCount-1 do
     if (InputData.Cells[5,i]='Відгалуження') then
     vidgalyg:=vidgalyg+1;
     if vidgalyg>=1 then Begin
      AddResult(0,lastmag+2,'Відгалуження');
      AddAlgoritm('Ініціалізація відгалужень пройшла успішно ','OK',clPurple);
      AddAlgoritm('Напис відгалуження встановлено успішно ','OK',clPurple);
      end;

   //Обчислення відгалужень
     For i:=1 to InputData.ColCount-1 do
  Begin
   //Обчислення відгалужень
     if (InputData.Cells[5,i]='Відгалуження') then
      Begin
      connectV:=Copy(InputData.Cells[0,i],1,pos('-',InputData.Cells[0,i])-1);
     // showmessage(connectV);
       For fc:=1 to InputData.ColCount-1 do
        Begin
      if pos('-'+connectV,InputData.Cells[0,fc])<>0 then
       Begin
        connect:=fc+1;
        AddAlgoritm('Зв"язок відгалуження із магістраллю встановлено ','OK',clRed);

        //Початок обчислення відгалуження
      //-----------------------------------------------------------------------
      with Para_Normal do
       Begin
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
       end;{with}
    AddAlgoritm('ОПРАЦЮВАННЯ ВІДГАЛУЖЕНЬ','OK',clGreen);
    AddAlgoritm('Ділянка №',InputData.cells[0,i],clRed);
      with Para_Normal do
       Begin
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
        reTabResult.Lines.Add('-----------------------------------------------------------------------');
       end;{with}
     //-----------------------------------------------------------------------
      //інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion)
     IP0:=StrToFloat(OutputData.cells[4,connect+1]);
     AddAlgoritm('Інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion) IP0 = ',FloatTostr(IP0),clBlack);
     //обчислення орієнтовних втрат тиску
     OLP:=Orient_loos_P_last(StrToFloat(OutputData.Cells[30,connect]),BP);
     AddAlgoritm('Обчислення орієнтовних втрат тиску OLP = ',FloatTostr(OLP),clBlack);
     val(InputData.cells[2,i],len_sector,cod);
     val(InputData.cells[1,i],LP,cod);
    //Орієнтовний тиск і температура на кінці ділянки
     Orient_PT_endMagistral(InputData,i,StrToFloat(OutputData.Cells[30,connect]),OLP,StrToFloat(OutputData.Cells[31,connect]),OP,OT);
     OP:=BP;
     AddAlgoritm('Орієнтовний тиск на кінці ділянки OP = ',FloatTostr(OP),clBlack);
     AddAlgoritm('Орієнтовна температура на кінці ділянки OP = ',FloatTostr(OP),clBlack);
    //інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion)
    //за новими значеннями тиску і температури
     IP:=Interpolated_Proportion(OP,OT,Proportion);
     AddAlgoritm('Iнтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion) за новими значеннями тиску і температури IP = ',FloatTostr(IP),clBlack);
    //Середнє арифметичне значення між двома (Гамма)
     IPIP0:=(IP+StrToFloat(OutputData.cells[4,connect+1]))/2;
     AddAlgoritm('Середнє арифметичне значення між двома (Гамма) IPIP0 = ',FloatTostr(IPIP0),clBlack);
    //Обчислення питомої втрат тиску
     PLP:=Pitoma_loos_P(InputData,i,OLP,IPIP0);
     AddAlgoritm('Обчислення питомих втрат тиску PLP = ',FloatTostr(PLP),clBlack);
    //Підбір діаметрів
     Diam1:=Diametr(LP,PLP,IPIP0,TD_03,DH,Speed,RealSpeed,TD_02);
     AddAlgoritm('Результат підбору діаметрів Diam = ',FloatTostr(Diam1),clBlack);
     AddAlgoritm('Результат підбору діаметрів TD_03 = ',FloatTostr(TD_03),clBlack);
     AddAlgoritm('DH = ',FloatTostr(DH),clBlack);
     AddAlgoritm('Швидкість Speed = ',FloatTostr(Speed),clBlack);
     AddAlgoritm('Реальна швидкість RealSpeed = ',FloatTostr(RealSpeed),clBlack);
     AddAlgoritm('TD_02 = ',TD_02,clBlack);
     Diam:=StrToFloat(OutputData.cells[12,connect+1]);
     //Обрахунок кількості крмпенсаторів відповідно до обраного
     HMK:=HowManyKompensators(InputData,i,Diam1,len_sector);
     AddAlgoritm('Обрахунок кількості кoмпенсаторів відповідно до обраного HMK = ',FloatTostr(HMK),clBlack);
     //визначення суми добутків видів місцевого опору на їх кількість
     Checked_Multiplication(InputData,HMK);
      val(sList.Strings[i-1],CM,cod);
      AddAlgoritm('Bизначення суми добутків видів місцевого опору на їх кількість CM = ',FloatTostr(CM),clBlack);
      If diam1<diam then
        Begin
      //  diam:=diam1;
        CM:=CM+0.5;
        //InputData.cells[3,i]:=InputData.cells[3,i]+', Звуження (0.5)';
      //  InputData.cells[4,i]:=InputData.cells[4,i]+' ,1'
        end;{if}
         //Обрахунок еквівалентної довжини,розрахункової довжини
     EkRoz_len(CM,TD_03,len_sector,EkLen,RozLen);
     AddAlgoritm('Обрахунок еквівалентної довжини EkLen = ',FloatTostr(EkLen),clBlack);
     AddAlgoritm('Обрахунок розрахункової довжини EkLen = ',FloatTostr(RozLen),clBlack);
     //Питома втрата тиску при ГАММА
     PLP_2:=PLP2(DH,IPIP0);
     AddAlgoritm('Питома втрата тиску при ГАММА PLP_2 = ',FloatTostr(PLP_2),clBlack);
     //Обрахунок втрати тиску
     LSP:=loosP(RozLen,PLP_2);
     AddAlgoritm('Обрахунок втрати тиску LSP = ',FloatTostr(LSP),clBlack);
     if LSP>OLP then
      Begin
       While LSP>OLP do
        Begin
         //Збільшення діаметру при умові коли LSP>OLP
         YakasLaga(InputData,i,
                    Diam1,Diam,Len_Sector,IPIP0,OLP,SP,ST,
                    StrToFloat(OutputData.Cells[32,connect]),LP,
                    Proportion,
                    DiamNew,DH,TD_03,HMK,CM,EkLen,RozLen,PLP_2,LSP,Speed,RealSpeed,
                    NumD,
                    TD_02);
          diam1:=DiamNew;
        end;{while}
        AddAlgoritm('Збільшення діаметру завершено успішно ','OK',clBlue);
      end{if}
      else
       Begin
       AddAlgoritm('Збільшення діаметру при умові коли LSP>OLP НЕВИКОНАНО','No',clBlue);
       end;{else}
      If DiamNew<diam then
        Begin
        diam:=diamNew;
       // CM:=CM+0.5;
        InputData.cells[3,i]:=InputData.cells[3,i]+', Звуження (0.5)';
        InputData.cells[4,i]:=InputData.cells[4,i]+' ,1';
        AddAlgoritm('Звуження (0.5) встановлено успішно = ','ОК',clBlue);
        end;{if}
      //
      //
      SumLSP:=0;
      CM_New:=CM;
      for ss:=2 to lastmag+1 do
       Begin
        SumLSP:=SumLSP+StrToFloat(OutputData.Cells[23,ss])
       end;{for}
      Nevazka:=((SumLSP-((SP-StrToFloat(OutputData.Cells[2,connect+1]))+LSP))/SumLSP)*100;
      Nevazka1:=Nevazka;
      AddAlgoritm('SumLSP = ',FloatTostr(SumLSP),clBlack);
      AddAlgoritm('Невязка до виконання умови abs(Nevazka) > 0.01 Nevazka = ',FloatTostr(Nevazka),clBlack);
      if abs(Nevazka) > 0.01  then
       Begin
        LSP:=OLP;
        LSP2:=LSP;
        RozLen:=LSP/PLP_2;
        EkLen:=RozLen-Len_Sector;
        CM_new:=EkLen/TD_03;
        Diafragma:=CM_new-CM;
        InputData.cells[3,i]:=InputData.cells[3,i]+', Діафрагма ('+FloatToStrF(Diafragma,ffFixed,10,0)+')';
        InputData.cells[4,i]:=InputData.cells[4,i]+' ,1';
        OKUR2:=((OLP-LSP)/OLP)*100;
        Nevazka:=((SumLSP-((SP-StrToFloat(OutputData.Cells[2,connect+1]))+LSP2))/SumLSP)*100;
        //-----------------------------------------------------------------------
         AddAlgoritm('Умова abs(Nevazka) > 0.01 ВИКОНАНА = ','OK',clRed);
         AddAlgoritm('Обрахунок втрати тиску LSP = ',FloatTostr(LSP),clBlack);
         AddAlgoritm('Обрахунок еквівалентної довжини EkLen = ',FloatTostr(EkLen),clBlack);
         AddAlgoritm('Обрахунок розрахункової довжини EkLen = ',FloatTostr(RozLen),clBlack);
         AddAlgoritm('Bизначення суми добутків видів місцевого опору на їх кількість CM_New = ',FloatTostr(CM_New),clBlack);
         AddAlgoritm('Значання діафрагми Diafragma = ',FloatTostr(Diafragma),clBlack);
         AddAlgoritm('Оцінка точності OKUR2 = ',FloatTostr(OKUR2),clBlack);
         AddAlgoritm('Невязка Nevazka = ',FloatTostr(Nevazka),clBlack);
         //-----------------------------------------------------------------------
       end;{if}
      if abs(Nevazka1)<0.01 then Begin
       AddAlgoritm('Умова abs(Nevazka1)<0.01  НЕВИКОНАНА = ','No',clRed);
     //Оцінка точності
     OKUR:=Ocurency(OLP,LSP);
     AddAlgoritm('Оцінка точності OKUR = ',FloatTostr(OKUR),clBlack);
     //Зведення точності
      CastingOcurency(InputData,i,
                      StrToFloat(OutputData.Cells[30,connect]),StrToFloat(OutputData.Cells[31,connect]),LSP,StrToFloat(OutputData.Cells[32,connect]),DH,Speed,RozLen,OKUR,
                      Proportion,
                      OP,OT,IP,IPIP0,PLP,RealSpeed,PLP_2,LSP2,OKUR2);
       end;{else}
          {Виведеня результатів в таблицю sgOutputData}
      AddResult(0,i+2,InputData.cells[0,i]);
      AddResult(1,i+2,InputData.cells[1,i]);
      AddResult(2,i+2,FloatToSTRF(StrToFloat(OutputData.Cells[30,connect]),ffFixed,10,0));
      AddResult(3,i+2,FloatToSTRF(StrToFloat(OutputData.Cells[31,connect]),ffFixed,10,2));
      AddResult(4,i+2,FloatToSTRF(StrToFloat(OutputData.Cells[32,connect]),ffFixed,10,3));
      AddResult(5,i+2,FloatToStrF(LSP2,ffFixed,10,0));
      AddResult(6,i+2,FloatToStrF(OP,ffFixed,10,0));
      AddResult(7,i+2,FloatToStrF(OT,ffFixed,10,2));
      AddResult(8,i+2,FloatToStrF(IP,ffFixed,10,3));
      AddResult(9,i+2,FloatToStrF(IPIP0,ffFixed,10,3));
      AddResult(10,i+2,FloatToStrF(PLP,ffFixed,10,2));
      AddResult(11,i+2,TD_02);
      AddResult(12,i+2,FloatToStr(Diam1));
      AddResult(13,i+2,FloatToStr(Len_Sector));
      AddResult(14,i+2,FloatToStr(TD_03));
      AddResult(15,i+2,FloatToStrF(EkLen,ffFixed,10,2));
      AddResult(16,i+2,FloatToStrF(RozLen,ffFixed,10,2));
      AddResult(17,i+2,InputData.cells[3,i]+', к-ть= ['+InputData.cells[4,i]+']');
      AddResult(18,i+2,FloatToStrF(CM_New,ffFixed,10,2));
      AddResult(19,i+2,FloatToStrF(Dh,ffFixed,10,2));
      AddResult(20,i+2,FloatToStrF(Speed,ffFixed,10,2));
      AddResult(21,i+2,FloatToStrF(PLP_2,ffFixed,10,2));
      AddResult(22,i+2,FloatToStrF(RealSpeed,ffFixed,10,2));
      AddResult(23,i+2,FloatToStrF(LSP2,ffFixed,10,0));
      AddResult(24,i+2,FloatToStrF(OKUR2,ffFixed,10,3));
      {Кінець виведення даних до таблиці sgOutputData}
   //Питомі втрати тепла трубопроводів
    VAl(eTOSRR.Text,TOSP,cod);
    DqReal:=Dq(Diam,cbTOS.Text,OT);
    AddAlgoritm('Питомі втрати тепла трубопроводів DqReal = ',FloatTostr(DqReal),clBlack);
  //інтерполювання теплоємності перегрітої водяної пари в таблиці (cp)
    IP0CP1:= Interpolated_CP(StrToFloat(OutputData.Cells[30,connect]),StrToFloat(OutputData.Cells[31,connect]),cp);
    AddAlgoritm('Iнтерполювання теплоємності перегрітої водяної пари в таблиці (cp) IP0CP1 = ',FloatTostr(IP0CP1),clBlack);
  //Визначення середньо температури на ділянці
    TMID1:=TMID(StrToFloat(OutputData.Cells[31,connect]),OT);
    AddAlgoritm('Визначення середньо температури на ділянці TMID1 = ',FloatTostr(TMID1),clBlack);
  //Втрати тепла на ділянці
    LTeplo:=LoosTeplo(tmid1,TOSP,DqReal,Rozlen);
    AddAlgoritm('Втрати тепла на ділянці LTeplo = ',FloatTostr(LTeplo),clBlack);
  //Перепад температури на ділянці
    Dt1:= Dt(LTeplo,LP,IP0CP1);
    AddAlgoritm('Перепад температури на ділянці Dt1 = ',FloatTostr(Dt1),clBlack);
  //Реальний тиск на кінці ділянки
    Real_PP1:=Real_PP(StrToFloat(OutputData.Cells[30,connect]),LSP2);
    AddAlgoritm('Реальний тиск на кінці ділянки Real_PP1 = ',FloatTostr(Real_PP1),clBlack);
  //Реальна температура на кінці ділянки
    REal_TT1:= Real_TT(StrToFloat(OutputData.Cells[31,connect]),Dt1);
    AddAlgoritm('Реальна температура на кінці ділянки Real_TT1 = ',FloatTostr(Real_TT1),clBlack);
  //Реальна питома вага пари на кінці ділянки
    Real_IP0:=Interpolated_Proportion(Real_PP1,Real_TT1,Proportion);
    AddAlgoritm('Реальна питома вага пари на кінці ділянки Real_IP0 = ',FloatTostr(Real_IP0),clBlack);
  //Реальна середня питома вага пари
    Real_IPIP0:=(IP0+Real_IP0)/2;
    AddAlgoritm('Реальна середня питома вага пари Real_IPIP0 = ',FloatTostr(Real_IPIP0),clBlack);
      {Виведеня результатів в таблицю sgOutputData}
      AddResult(25,i+2,FloatToStr(DqReal));
      AddResult(26,i+2,FloatToStrF(IP0cp1,ffFixed,10,2));
      AddResult(27,i+2,FloatToStrF(TMID1,ffFixed,10,2));
      AddResult(28,i+2,FloatToStrF(LTeplo,ffFixed,10,0));
      AddResult(29,i+2,FloatToStrF(Dt1,ffFixed,10,2));
      AddResult(30,i+2,FloatToStrF(Real_PP1,ffFixed,10,0));
      AddResult(31,i+2,FloatToStrF(Real_TT1,ffFixed,10,2));
      AddResult(32,i+2,FloatToStrF(Real_IP0,ffFixed,10,3));
      AddResult(33,i+2,FloatToStrF(Real_IPIP0,ffFixed,10,3));
      AddResult(34,i+2,FloatToStrF(Nevazka,ffFixed,10,2));
      {Кінець виведення даних до таблиці sgOutputData}

      end;{if}
     end;{if}
      end;{for}

     end;{for}
      //-----------------------------------------------------------------------
     AddAlgoritm('Завершення всіх обчислень ','OK',clRed);
     //-----------------------------------------------------------------------
   AddShotResult(OutPutData);
  // Додає дані до талиці для побудови схеми}
   AddCulcDataToShema(lastmag,OutputData,faShema.sgShema);
   //Побудова графіка
   BuildChart(Para_normal.Series1,OutputData,LastMag);
   Para_normal.pcBase.ActivePageIndex:=2;
   Para_Normal.sgOutputData.SetFocus;
   InputData.Enabled:=True;
   Para_Normal.tbShema.Enabled:=True;
   end{if}//завершення перевірки наявності введених даних
   else
    Begin
     AddAlgoritm('Хибний результат перевірки наявності введених даних. ','OK',clRed);
    end;{else}
end;{RUN}

//Виведення шапки ресультатів в поле Para_Normal.reTabResult
Procedure Shapka_Result;
Begin
 with Para_Normal do
  Begin
    reTabResult.Clear;
    {}
  end;{with}
end;

//Перевірка наявності введених даних
function IsData(sg1:TStringGrid;eSP,eBP,eST,eL,eTOSRR:TEdit;cbTOS:TComboBox):Boolean;
Label
     reis;
var
   is1,is2,is3:Boolean;
   i,j:integer;
Begin
   if (eSP.Text='') or (eBP.Text='') or (eST.Text='') or (eL.Text='') or (cbTOS.Text='') then
    is1:=False
   else is1:=True;
   if (eSP.Text=' ') or (eBP.Text=' ') or (eST.Text=' ') or (eL.Text=' ') or (cbTOS.Text=' ') then
    is2:=False
   else is2:=True;
   for i:=1 to sg1.ColCount-1 do
    Begin
    for j:=0 to sg1.RowCount-1 do
     Begin
        if (sg1.Cells[i,j]='') or (sg1.Cells[i,j]=' ') then
        Begin
          is3:=False;
          goto reis;
        end{if}
        else
          is3:=True;
     end;{for}
    end;{for}
reis:
      Begin
      if (is1=False) or (is2=False) or (is3=False) then
       Begin
        MessageDLG('Перевірте наявність введених даних.'+#13+'Подальший розрахунок неможливий.',mtError,[mbOK],0);
        IsData:=False;
       end{if}
      else IsData:=True;
      end;{reis}
end;{IsData}

//визначення суми добутків видів місцевого опору на їх кількість
procedure Checked_Multiplication(STGrid:TStringGrid;NewMult2:real);
var i:integer;
 multDOB,multSUM,mult1,mult2:real;
 ryadokVMO:string;
 ryadokHOW:string;
 position_begin:integer;
 position_end:integer;
 posKoma:integer;
 lenghtKOMA:integer;
 lenght_pos:integer;
 Znach:string;
 kt1:string;
 cod:integer;
 multSumString:string;
Begin
    multSUM:=0;
             {створення листа де кожен рядок якого
              відповідає сумі добутків видів місцевого опору в таблиці sgInputData,
              початок з 0 рядка, а в таблиці з 1}
             sLIST:=TStringList.Create;    
    for i:=1 to STGrid.RowCount-1 do
    Begin
       if STGrid.Cells[3,i]<>'' then
         Begin
          ryadokVMO:=STGrid.Cells[3,i];
          ryadokHOW:=STGrid.Cells[4,i];
          while pos('(',ryadokVMO)<> 0 do
           Begin
            {алгоритм визначення коефіцієнтів параметрів}
            position_begin:=pos('(',ryadokVMO)+1;
            position_end:=pos(')',ryadokVMO);
            lenght_pos:=position_end-position_begin;
            Znach:=Copy(ryadokVMO,position_begin,lenght_pos);
            //mult1:=StrToFloat(Znach);
            val(Znach,mult1,cod);
            Delete(ryadokVMO,1,position_end+1);
            {алгоритм визначення кількості штук коефіцієнтів параметрів}
            posKOMA:=pos(',',ryadokHOW);
            lenghtKOMA:=posKOMA-1;
            kt1:=Copy(ryadokHOW,1,lenghtKOMA);
            if (pos(',',ryadokHOW)=0) and (ryadokHOW<>'') then
             Begin
              kt1:=ryadokHOW;
             end;{if}
             Delete(ryadokHOW,1,posKOMA);
             //mult2:=StrToFloat(kt1);
             val(kt1,mult2,cod);
             {Якщо ноль то присвоюэмо розраховану к-ть для компенсатора}
             if mult2=0 then mult2:=NewMult2;
             {множення та сумування значень виду місцевого опору}
             multDOB:=mult1*mult2;
             multSum:=multSum+multDOB;
           end;{while}
             multSum:=Round(multSum*1000)/1000; {Округлення до трьох знаків після коми}
             str(multSum:1:3,multSUMString);
             slist.Add(multsumString);
             multSum:=0;
        end{if}
       else
         Begin
            MessageDLG('Комірка з даними виду місцевого опру порожня!',mtError,[mbOk],0);
         end;{else}
       end;{for}
end;{Checked_Multiplication}

//інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion)
function Interpolated_Proportion(Start_P:real;Start_T:real;ProportionalFile:TFileName):Real;
label end_Interpolation;
type
   kritic= array[0..9,0..19]of real;
var
   arrayProportion:TStringList;
   b,a:integer;
   i,j:integer;
   //xmas:array of array of real;
   xmas:kritic;
   ryadokArray:string;
   pos_b,pos_e:integer;
   mas:string;
   l_pos:integer;
   masReal:real;
   cod:integer;
   super_i:integer;
   num_a,num_b,num_c,num_d:integer;
   inter_a,inter_b,inter_c,inter_d:real;
   min_r,max_r,min_s,max_s:real;
   STP,STT:real;
   pro_ab,pro_cd:real;
   minmaxSS,minmaxRR:real;
   pro_ab_ten,pro_cd_ten:real;
   Chas_p,chas_t:real;
   result_left,result_right:real;
   result_fin:real;
Begin
  //ініціалізація змінних масиву
  i:=1; j:=0;
  masreal:=-1;
  super_i:=0;
  xmas[0,0]:=-1;
  //створення віртуального списку
  arrayProportion:=TStringList.Create;
  //завантаження таблиці у віртуальний список
   arrayProportion.LoadFromFile(ProportionalFile);
  //алгоритм запису даних з файлу (proportion.txt) в масив
   for a:=1 to arrayProportion.Count-1 do
    Begin
       if arrayProportion.Strings[a]<>'' then
         Begin
          ryadokArray:=arrayProportion.strings[a];
          while pos('(',ryadokArray)>0 do
           Begin
            {алгоритм запису даних з файлу в масив}
            pos_b:=pos('(',ryadokArray)+1;
            pos_e:=pos(')',ryadokArray);
            l_pos:=pos_e-pos_b;
            mas:=Copy(ryadokArray,pos_b,l_pos);
            val(mas,masReal,cod);
            masReal:=Round(masReal*1000)/1000; {Округлення до трьох знаків після коми}
            xmas[i,j]:=masReal;
            Delete(ryadokArray,1,pos_e+1);
            i:=i+1;
           end;{while}
           super_i:=i;
          end;{if}
          i:=0;
          j:=j+1;
    end;{for}
    //Знищення завантаженого файлу, тепер він у масиві 10*20
    arrayProportion.Destroy;
  //Зчитуємо дані з таблиці введення (початкова температура, початковий тиск)
  STP:=Start_P;
  STT:=Start_T;
  //val(Start_P.Text,STP,cod);
  //Val(Start_T.Text,STT,cod);
  // Якщо Поч. тиск менше 0,1 присвоюємо значення 0,1
 // if STP<0.1 then STP:=0.1;
  max_r:=xmas[9,0];
  min_r:=xmas[1,0];
  max_s:=xmas[0,19];
  min_s:=xmas[0,1];
  //Знаходимо мін, макс значення поч. тиску по 0-стовпцю
  //та знаходимо номер рядка мінімального і максимального значення по тиску
  for i:=1 to j do
   Begin
    if (xmas[0,i] <= STP) and (xmas[0,i]>=min_s) then
     Begin
      min_s:=xmas[0,i];
      num_a:=i;
     end;{if}
    if (xmas[0,i] >= STP) and (xmas[0,i]<=max_s) then
     Begin
      max_s:=xmas[0,i];
      num_b:=i;
     end;{if}
   end;{for}
  //Знаходимо мін, макс значення поч. температури по 0-рядку
  //та знаходимо номер стовпця мінімального та максимального значення по температурі
  for i:=1 to super_i do
   Begin
     if (xmas[i,0]<=STT) and (xmas[i,0]>=min_r) then
      Begin
       min_r:=xmas[i,0];
       num_c:=i;
      end;{if}
     if (xmas[i,0]>=STT) and (xmas[i,0]<=max_r) then
      Begin
       max_r:=xmas[i,0];
       num_d:=i;
      end;{if}
   end;{for}
   //Зчитуєм дані з масиву, для інтерполяції по 4-х числах
   inter_a:=xmas[num_c,num_a];
   inter_b:=xmas[num_c,num_b];
   inter_c:=xmas[num_d,num_a];
   inter_d:=xmas[num_d,num_b];
    //Якщо хочаб одне значення з 4-х чисел (-1), то помилка
    //(-1) в таблиці значить відсутні дані на такий період, розрахунок не актуальний
    //Якщо температура більша за 400 або менша 120 розрахунок не актуальний
    //Якщо тикс більше 3600000 менше 100000 (Па) розрахунок не актуальний
   If (inter_a = (-1)) or (inter_b = (-1)) or (inter_c = (-1)) or (inter_d = (-1)) or (STP>3600000) or (STT>400) or (STT<120) or (STP<=100000) then
    case messageDLG('При даному тиску і температурі обрахунок питомої ваги перегрітої пари є неактуальним.',mtError,[mbOK],0) of
         idOK:goto end_interpolation;
    end;{case}
    //Інтерполяція коли всі чотири числа різні
   if (min_s  <> max_s)  and (min_r <> max_r ) then
    Begin
      //Знаходи різницю між більшим і меншим числом по 2-х стовпцях
      if inter_a > inter_b then
       pro_ab:=inter_a-inter_b
      else pro_ab:=inter_b-inter_a;
      if inter_c > inter_d then
       pro_cd:=inter_c-inter_d
      else pro_cd:=inter_d-inter_c;
      //Знаходимо різницю між табличними значеннями температури і тиску
      minmaxSS:=(max_s-min_s);
      minmaxRR:=(max_r-min_r);
      pro_ab_ten:=pro_ab/minmaxSS;
      pro_cd_ten:=pro_cd/minmaxSS;
      chas_p:=STP-min_s;
      chas_t:=STT-min_r;
      if inter_a > inter_b then
       result_left:=inter_b+(pro_ab_ten*chas_p)
      else result_left:=inter_a+(pro_ab_ten*chas_p);
      if inter_c > inter_d then
      result_right:=inter_d+(pro_cd_ten*chas_p)
      else  result_right:=inter_c+(pro_cd_ten*chas_p);
      if result_left > result_right then
       result_fin:=result_left-(((result_left-result_right)/minmaxRR)*chas_t)
      else
          result_fin:=result_right-(((result_right-result_left)/minmaxRR)*chas_t);
     //присвоюємо результат фукції
     Interpolated_Proportion:=result_fin;
    end;{else}
    //Інтерполяція коли співпадає введена початкова температура з таблицею
     if (min_s  <> max_s)  and (min_r = max_r ) then
    Begin
      if inter_a > inter_b then
       pro_ab:=inter_a-inter_b
      else pro_ab:=inter_b-inter_a;
      minmaxSS:=(max_s-min_s);
      pro_ab_ten:=pro_ab/minmaxSS;
      chas_p:=STP-min_s;
      if inter_a > inter_b then
       result_left:=inter_b+(pro_ab_ten*chas_p)
      else result_left:=inter_a+(pro_ab_ten*chas_p);
      result_fin:=result_left;
     //присвоюємо результат фукції
     Interpolated_Proportion:=result_fin;
    end;{else}
    //Інтерполяція коли співпадає введений початковий тиск з таблицею
   if (min_s  = max_s)  and (min_r <> max_r ) then
    Begin
       pro_ab:=inter_a;
        if inter_c > inter_d then
       pro_cd:=inter_c-inter_d
      else pro_cd:=inter_d-inter_c;
      minmaxSS:=min_s;
      minmaxRR:=(max_r-min_r);
      pro_ab_ten:=pro_ab/minmaxSS;
      pro_cd_ten:=pro_cd/minmaxSS;
      chas_p:=STP-min_s;
      chas_t:=STT-min_r;
      result_left:=inter_a+(pro_ab_ten*chas_p);
       if inter_c > inter_d then
      result_right:=inter_d+(pro_cd_ten*chas_p)
      else  result_right:=inter_c+(pro_cd_ten*chas_p);
      if result_left > result_right then
       result_fin:=result_left-(((result_left-result_right)/minmaxRR)*chas_t)
      else
          result_fin:=result_right-(((result_right-result_left)/minmaxRR)*chas_t);
     Interpolated_Proportion:=result_fin;
     //присвоюємо результат фукції

    end;{else}
    //Інтерполяція коли співпадає і поч. тиск і поч. температура з таблицею
   if (min_s  = max_s)  and (min_r = max_r ) then
    Begin
       pro_ab:=inter_a;
       pro_cd:=inter_c;
      minmaxSS:=min_s;
      minmaxRR:=min_r;
      pro_ab_ten:=pro_ab/minmaxSS;
      pro_cd_ten:=pro_cd/minmaxSS;
      chas_p:=STP-min_s;
      chas_t:=STT-min_r;
      result_left:=inter_a+(pro_ab_ten*chas_p);
      result_right:=inter_c+(pro_cd_ten*chas_p);
      if result_left > result_right then
       result_fin:=result_left-(((result_left-result_right)/minmaxRR)*chas_t)
      else
     result_fin:=result_right-(((result_right-result_left)/minmaxRR)*chas_t);
     Interpolated_Proportion:=result_fin;
     //присвоюємо результат фукції
    end;{else}
end_interpolation:    
end;{Interpolated_Proportion}


//інтерполювання теплоємності перегрітої водяної пари в таблиці (cp)
function Interpolated_CP(Start_P:real;Start_T:real;CPFile:TFileName):Real;
label end_Interpolation;
type
   kritic= array[0..7,0..5]of real;
var
   arrayProportion:TStringList;
   b,a:integer;
   i,j:integer;
   //xmas:array of array of real;
   xmas:kritic;
   ryadokArray:string;
   pos_b,pos_e:integer;
   mas:string;
   l_pos:integer;
   masReal:real;
   cod:integer;
   super_i:integer;
   num_a,num_b,num_c,num_d:integer;
   inter_a,inter_b,inter_c,inter_d:real;
   min_r,max_r,min_s,max_s:real;
   STP,STT:real;
   pro_ab,pro_cd:real;
   minmaxSS,minmaxRR:real;
   pro_ab_ten,pro_cd_ten:real;
   Chas_p,chas_t:real;
   result_left,result_right:real;
   result_fin:real;
Begin
  //ініціалізація змінних масиву
  i:=1; j:=0;
  masreal:=-1;
  super_i:=0;
  xmas[0,0]:=-1;
  //створення віртуального списку
  arrayProportion:=TStringList.Create;
  //завантаження таблиці у віртуальний список
   arrayProportion.LoadFromFile(CPFile);
  //алгоритм запису даних з файлу (cp.txt) в масив
   for a:=1 to arrayProportion.Count-1 do
    Begin
       if arrayProportion.Strings[a]<>'' then
         Begin
          ryadokArray:=arrayProportion.strings[a];
          while pos('(',ryadokArray)>0 do
           Begin
            {алгоритм запису даних з файлу в масив}
            pos_b:=pos('(',ryadokArray)+1;
            pos_e:=pos(')',ryadokArray);
            l_pos:=pos_e-pos_b;
            mas:=Copy(ryadokArray,pos_b,l_pos);
            val(mas,masReal,cod);
            masReal:=Round(masReal*1000)/1000; {Округлення до трьох знаків після коми}
            xmas[i,j]:=masReal;
            Delete(ryadokArray,1,pos_e+1);
            i:=i+1;
           end;{while}
           super_i:=i;
          end;{if}
          i:=0;
          j:=j+1;
    end;{for}
    //Знищення завантаженого файлу, тепер він у масиві 10*20
    arrayProportion.Destroy;
  //Зчитуємо дані з таблиці введення (початкова температура, початковий тиск)
  STP:=Start_P;
  STT:=Start_T;
  //val(Start_P.Text,STP,cod);
  //Val(Start_T.Text,STT,cod);
  // Якщо Поч. тиск менше 0,1 присвоюємо значення 0,1
 // if STP<0.1 then STP:=0.1;
  max_r:=xmas[7,0];
  min_r:=xmas[1,0];
  max_s:=xmas[0,5];
  min_s:=xmas[0,1];
  //Знаходимо мін, макс значення поч. тиску по 0-стовпцю
  //та знаходимо номер рядка мінімального і максимального значення по тиску
  for i:=1 to j do
   Begin
    if (xmas[0,i] <= STP) and (xmas[0,i]>=min_s) then
     Begin
      min_s:=xmas[0,i];
      num_a:=i;
     end;{if}
    if (xmas[0,i] >= STP) and (xmas[0,i]<=max_s) then
     Begin
      max_s:=xmas[0,i];
      num_b:=i;
     end;{if}
   end;{for}
  //Знаходимо мін, макс значення поч. температури по 0-рядку
  //та знаходимо номер стовпця мінімального та максимального значення по температурі
  for i:=1 to super_i do
   Begin
     if (xmas[i,0]<=STT) and (xmas[i,0]>=min_r) then
      Begin
       min_r:=xmas[i,0];
       num_c:=i;
      end;{if}
     if (xmas[i,0]>=STT) and (xmas[i,0]<=max_r) then
      Begin
       max_r:=xmas[i,0];
       num_d:=i;
      end;{if}
   end;{for}
   //Зчитуєм дані з масиву, для інтерполяції по 4-х числах
   inter_a:=xmas[num_c,num_a];
   inter_b:=xmas[num_c,num_b];
   inter_c:=xmas[num_d,num_a];
   inter_d:=xmas[num_d,num_b];
    //Якщо хочаб одне значення з 4-х чисел (-1), то помилка
    //(-1) в таблиці значить відсутні дані на такий період, розрахунок не актуальний
    //Якщо температура більша за 400 або менша 120 розрахунок не актуальний
    //Якщо тикс більше 3600000 менше 100000 (Па) розрахунок не актуальний
   If (inter_a = (-1)) or (inter_b = (-1)) or (inter_c = (-1)) or (inter_d = (-1)) or (STP>3600000) or (STT>400) or (STT<120) or (STP<100000) then
    case messageDLG('При даному тиску і температурі обрахунок питомої ваги перегрітої пари є неактуальним.',mtError,[mbOK],0) of
         idOK:goto end_interpolation;
    end;{case}
    //Інтерполяція коли всі чотири числа різні
   if (min_s  <> max_s)  and (min_r <> max_r ) then
    Begin
      //Знаходи різницю між більшим і меншим числом по 2-х стовпцях
      if inter_a > inter_b then
       pro_ab:=inter_a-inter_b
      else pro_ab:=inter_b-inter_a;
      if inter_c > inter_d then
       pro_cd:=inter_c-inter_d
      else pro_cd:=inter_d-inter_c;
      //Знаходимо різницю між табличними значеннями температури і тиску
      minmaxSS:=(max_s-min_s);
      minmaxRR:=(max_r-min_r);
      pro_ab_ten:=pro_ab/minmaxSS;
      pro_cd_ten:=pro_cd/minmaxSS;
      chas_p:=STP-min_s;
      chas_t:=STT-min_r;
      if inter_a > inter_b then
       result_left:=inter_b+(pro_ab_ten*chas_p)
      else result_left:=inter_a+(pro_ab_ten*chas_p);
      if inter_c > inter_d then
      result_right:=inter_d+(pro_cd_ten*chas_p)
      else  result_right:=inter_c+(pro_cd_ten*chas_p);
      if result_left > result_right then
       result_fin:=result_left-(((result_left-result_right)/minmaxRR)*chas_t)
      else
          result_fin:=result_right-(((result_right-result_left)/minmaxRR)*chas_t);
     //присвоюємо результат фукції
     Interpolated_CP:=result_fin;
    end;{else}
    //Інтерполяція коли співпадає введена початкова температура з таблицею
     if (min_s  <> max_s)  and (min_r = max_r ) then
    Begin
      if inter_a > inter_b then
       pro_ab:=inter_a-inter_b
      else pro_ab:=inter_b-inter_a;
      minmaxSS:=(max_s-min_s);
      pro_ab_ten:=pro_ab/minmaxSS;
      chas_p:=STP-min_s;
      if inter_a > inter_b then
       result_left:=inter_b+(pro_ab_ten*chas_p)
      else result_left:=inter_a+(pro_ab_ten*chas_p);
      result_fin:=result_left;
     //присвоюємо результат фукції
     Interpolated_CP:=result_fin;
    end;{else}
    //Інтерполяція коли співпадає введений початковий тиск з таблицею
   if (min_s  = max_s)  and (min_r <> max_r ) then
    Begin
       pro_ab:=inter_a;
        if inter_c > inter_d then
       pro_cd:=inter_c-inter_d
      else pro_cd:=inter_d-inter_c;
      minmaxSS:=min_s;
      minmaxRR:=(max_r-min_r);
      pro_ab_ten:=pro_ab/minmaxSS;
      pro_cd_ten:=pro_cd/minmaxSS;
      chas_p:=STP-min_s;
      chas_t:=STT-min_r;
      result_left:=inter_a+(pro_ab_ten*chas_p);
       if inter_c > inter_d then
      result_right:=inter_d+(pro_cd_ten*chas_p)
      else  result_right:=inter_c+(pro_cd_ten*chas_p);
      if result_left > result_right then
       result_fin:=result_left-(((result_left-result_right)/minmaxRR)*chas_t)
      else
          result_fin:=result_right-(((result_right-result_left)/minmaxRR)*chas_t);
     Interpolated_Cp:=result_fin;
     //присвоюємо результат фукції

    end;{else}
    //Інтерполяція коли співпадає і поч. тиск і поч. температура з таблицею
   if (min_s  = max_s)  and (min_r = max_r ) then
    Begin
       pro_ab:=inter_a;
       pro_cd:=inter_c;
      minmaxSS:=min_s;
      minmaxRR:=min_r;
      pro_ab_ten:=pro_ab/minmaxSS;
      pro_cd_ten:=pro_cd/minmaxSS;
      chas_p:=STP-min_s;
      chas_t:=STT-min_r;
      result_left:=inter_a+(pro_ab_ten*chas_p);
      result_right:=inter_c+(pro_cd_ten*chas_p);
      if result_left > result_right then
       result_fin:=result_left-(((result_left-result_right)/minmaxRR)*chas_t)
      else
     result_fin:=result_right-(((result_right-result_left)/minmaxRR)*chas_t);
     Interpolated_CP:=result_fin;
     //присвоюємо результат фукції
    end;{else}
end_interpolation:    
end;{Interpolated_CP}

//обчислення орієнтовних втрат тиску (пока тільки для першої ділянки)
Function Orient_loos_P(input_Table:TstringGrid;Start_P:real;User_P:real;Len_magistral:real):Real;
var
   len_sector:real;
   cod:integer;
   test:real;
Begin
   val(input_Table.cells[2,1],len_sector,cod);
   test:=((Start_p-User_P)*(len_sector/len_magistral))*2;
   Orient_loos_P:=test;
end;{Orient_Loos_P}

//обчислення орієнтовних втрат тиску (для всієї мережі крім 1 та останньої)
Function Orient_loos_P_other(input_Table:TstringGrid;i:integer;Start_P:real;User_P:real;Len_Sector,Len_magistral:real):Real;
var
   cod:integer;
   test:real;
Begin
   val(input_Table.cells[2,i],len_sector,cod);
   test:=((Start_p-User_P)*(len_sector/len_magistral));
   Orient_loos_P_other:=test;
end;{Orient_Loos_P}

//обчислення орієнтовних втрат тиску на останній ділянці
Function Orient_loos_P_last(Start_P:real;User_P:real):Real;
var
   test:real;
Begin
   test:=(Start_p-User_P);
   Orient_loos_P_last:=test;
end;{Orient_loos_P_last}

//Орієнтовний тиск і температура на кінці ділянки
Procedure Orient_PT_endMagistral(input_Table:TstringGrid;i:integer;Start_P:real;OrientLoosP:real;Start_t:real;var Orient_P,Orient_T:real);
var
   len_sector:real;
   cod:integer;
begin
  val(input_Table.cells[2,i],len_sector,cod);
  orient_P:=Start_P-OrientLoosP;
  Orient_T:=Start_T-((2*len_sector)/100);
end;{Orient_PT_endMagistral}

//Обчислення питомої втрат тиску
Function Pitoma_loos_P(input_Table:TstringGrid;i:integer;OLP:real;IPG:real):real;
var
   len_sector:real;
   cod:integer;
   test:real;
Begin
 val(input_Table.cells[2,i],len_sector,cod);
 test:=(OLP*IPG)/(len_sector*1.2);
 Pitoma_loos_P:=test;
end;{Pitoma_loos_P}

     //Діаметри
Function Diametr(Loos_par:real;PLP:real;IPIP0:real; var TD_03,DH,Speed,RealSpeed:real; var TD_02:string):real;
var
    TDiametr:array[0..2,0..37]of string;
    Lambda,nabl1,TD,TD1,TD2,dh1:real;
    i,ii,cod:integer;
Begin
  //ініціалізація масиву діаметрів
   TDiametr[0,0]:='0.04' ;   TDiametr[1,0]:='45x2.5' ;   TDiametr[2,0]:='1.37' ;
   TDiametr[0,1]:='0.05' ;   TDiametr[1,1]:='57x3.5' ;   TDiametr[2,1]:='1.85' ;
   TDiametr[0,2]:='0.069' ;  TDiametr[1,2]:='76x3.5' ;   TDiametr[2,2]:='2.75' ;
   TDiametr[0,3]:='0.081' ;   TDiametr[1,3]:='89x3.5' ;   TDiametr[2,3]:='3.3' ;
   TDiametr[0,4]:='0.1' ;    TDiametr[1,4]:='108x4' ;    TDiametr[2,4]:='4.3' ;
   TDiametr[0,5]:='0.125' ;  TDiametr[1,5]:='133x4' ;    TDiametr[2,5]:='5.68' ;
   TDiametr[0,6]:='0.143' ;  TDiametr[1,6]:='152x4.5' ;  TDiametr[2,6]:='6.2' ;
   TDiametr[0,7]:='0.150' ;  TDiametr[1,7]:='159x4.5' ;  TDiametr[2,7]:='7.1' ;
   TDiametr[0,8]:='0.182' ;  TDiametr[1,8]:='194x6' ;    TDiametr[2,8]:='9.2' ;
   TDiametr[0,9]:='0.184' ;  TDiametr[1,9]:='194x5' ;    TDiametr[2,9]:='9.2' ;
   TDiametr[0,10]:='0.205' ; TDiametr[1,10]:='219x7' ;   TDiametr[2,10]:='10.7' ;
   TDiametr[0,11]:='0.207' ; TDiametr[1,11]:='219x6' ;   TDiametr[2,11]:='10.7' ;
   TDiametr[0,12]:='0.258' ; TDiametr[1,12]:='273x8' ;   TDiametr[2,12]:='14.1' ;
   TDiametr[0,13]:='0.260' ; TDiametr[1,13]:='273x7' ;   TDiametr[2,13]:='14.1' ;
   TDiametr[0,14]:='0.307' ; TDiametr[1,14]:='325x9' ;   TDiametr[2,14]:='17.6' ;
   TDiametr[0,15]:='0.309' ; TDiametr[1,15]:='325x8' ;   TDiametr[2,15]:='17.6' ;
   TDiametr[0,16]:='0.357' ; TDiametr[1,16]:='377x10' ;  TDiametr[2,16]:='21.2' ;
   TDiametr[0,17]:='0.359' ; TDiametr[1,17]:='377x9' ;   TDiametr[2,17]:='21.2' ;
   TDiametr[0,18]:='0.404' ; TDiametr[1,18]:='426x11' ;  TDiametr[2,18]:='24.9' ;
   TDiametr[0,19]:='0.406' ; TDiametr[1,19]:='426x10' ;  TDiametr[2,19]:='24.9' ;
   TDiametr[0,20]:='0.412' ; TDiametr[1,20]:='426x7' ;   TDiametr[2,20]:='25.4' ;
   TDiametr[0,21]:='0.414' ; TDiametr[1,21]:='426x6' ;   TDiametr[2,21]:='25.4' ;
   TDiametr[0,22]:='0.464' ; TDiametr[1,22]:='478x7' ;   TDiametr[2,22]:='29.4' ;
   TDiametr[0,23]:='0.466' ; TDiametr[1,23]:='478x6' ;   TDiametr[2,23]:='29.4' ;
   TDiametr[0,24]:='0.515' ; TDiametr[1,24]:='529x7' ;   TDiametr[2,24]:='33.3' ;
   TDiametr[0,25]:='0.517' ; TDiametr[1,25]:='529x6' ;   TDiametr[2,25]:='33.3' ;
   TDiametr[0,26]:='0.614' ; TDiametr[1,26]:='630x8' ;   TDiametr[2,26]:='41.4' ;
   TDiametr[0,27]:='0.616' ; TDiametr[1,27]:='630x7' ;   TDiametr[2,27]:='41.4' ;
   TDiametr[0,28]:='0.702' ; TDiametr[1,28]:='720x9' ;   TDiametr[2,28]:='48.9' ;
   TDiametr[0,29]:='0.704' ; TDiametr[1,29]:='720x8' ;   TDiametr[2,29]:='48.9' ;
   TDiametr[0,30]:='0.706' ; TDiametr[1,30]:='720x7' ;   TDiametr[2,30]:='48.9' ;
   TDiametr[0,31]:='0.802' ; TDiametr[1,31]:='820x9' ;   TDiametr[2,31]:='57.8' ;
   TDiametr[0,32]:='0.804' ; TDiametr[1,32]:='820x8' ;   TDiametr[2,32]:='57.8' ;
   TDiametr[0,33]:='0.900' ; TDiametr[1,33]:='920x11' ;  TDiametr[2,33]:='66.8' ;
   TDiametr[0,34]:='1.0' ;   TDiametr[1,34]:='1020x12' ; TDiametr[2,34]:='76.1' ;
   TDiametr[0,35]:='1.1' ;   TDiametr[1,35]:='1120x12' ; TDiametr[2,35]:='85.7' ;
   TDiametr[0,36]:='1.192' ; TDiametr[1,36]:='1220x14' ; TDiametr[2,36]:='95.2' ;
   TDiametr[0,37]:='1.392' ; TDiametr[1,37]:='1420x14' ; TDiametr[2,37]:='115.6' ;
   //кінець ініціалізації масиву
   AddAlgoritm('Ініціалізація масиву діаметрів завершена успішно ','OK',clRed);
   AddAlgoritm('ПОЧАТОК ПІДБОРУ ДІАМЕТРІВ ','OK',clRed);
   nabl1:=-1;
   for i:=0 to 37 do
    Begin
      val(TDiametr[0,i],TD,cod);
      Lambda:=1/sqr(1.14+2*log10(TD/0.0002));
      dh1:=(0.00638*Lambda*(sqr(Loos_par)/(sqr(TD)*sqr(TD)*TD)))*10;
   if nabl1=-1 then
    nabl1:=abs(dh1-PLP);
   if abs(dh1-PLP)<=nabl1 then
    Begin
     nabl1:=abs(dh1-PLP);
     Diametr:=TD;
     TD1:=TD;
     TD2:=TD;
     val(TDiametr[2,i],TD_03,cod);
     TD_02:=TDiametr[1,i];
     ii:=i;
     dh:=dh1;
     //------------------------------------------------------
     AddAlgoritm('dh1 = ',FloatTostr(dh1),clBlack);
     AddAlgoritm('Diametr = ',FloatTostr(TD),clBlack);
     //--------------------------------------------------------
    end;{if}
   end;{for}
  Speed:=0.354*(Loos_par/sqr(TD1));
   RealSpeed:=Speed/IPIP0;
   //-----------------------------------------------------------
    AddAlgoritm('realspeed = ',FloatTostr(realspeed),clBlack);
   //-----------------------------------------------------------
  if TD2<0.200 then
   If realspeed > 51.25 then
   while (realspeed >51.25) and (TD2<0.200) do
      Begin
      ii:=ii+1;
      val(TDiametr[0,ii],TD2,cod);
      Lambda:=1/sqr(1.14+2*log10(TD2/0.0002));
      dh1:=(0.00638*Lambda*(sqr(Loos_par)/(sqr(TD2)*sqr(TD2)*TD2)))*10;
      dh:=dh1;
      //----------------------------------
       AddAlgoritm('dh1 = ',FloatTostr(dh1),clBlack);
      //------------------------------------
      val(TDiametr[2,ii],TD_03,cod);
      TD_02:=TDiametr[1,ii];
      Speed:=0.354*(Loos_par/sqr(TD2));
      RealSpeed:=Speed/IPIP0;
      Diametr:=TD2;
      //-------------------------------------------------------------
       AddAlgoritm('realspeed = ',FloatTostr(realspeed),clBlack);
       AddAlgoritm('diametr = ',FloatTostr(TD2),clBlack);
      //-------------------------------------------------------------
   end;{while}
  if TD2>0.200 then
   if realspeed >82 then
  while (realspeed>82) and (TD2>0.200) do
  begin
      ii:=ii+1;
      val(TDiametr[0,ii],TD2,cod);
      Lambda:=1/sqr(1.14+2*log10(TD2/0.0002));
      dh1:=(0.00638*Lambda*(sqr(Loos_par)/(sqr(TD2)*sqr(TD2)*TD2)))*10;
      dh:=dh1;
      //-----------------------------------------------------------------
      AddAlgoritm('dh1 = ',FloatTostr(dh1),clBlack);
      //------------------------------------------------------------------
      val(TDiametr[2,ii],TD_03,cod);
      TD_02:=TDiametr[1,ii];
      Speed:=0.354*(Loos_par/sqr(TD2));
      RealSpeed:=Speed/IPIP0;
      Diametr:=TD2;
      //-------------------------------------------------------------------
       AddAlgoritm('realspeed = ',FloatTostr(realspeed),clBlack);
       AddAlgoritm('diametr = ',FloatTostr(TD2),clBlack);
      //-------------------------------------------------------------------
  end;{while}
  AddAlgoritm('Завершення алгоритму підбору діаметрів пройшло успішно','OK',clRed);
  AddAlgoritm('ЗАВЕРШЕННЯ ПІДБОРУ ДІАМЕТРІВ = ','OK',clRed);
end;{Diametr}

//Обрахунок кількості крмпенсаторів відповідно до обраного
Function HowManyKompensators(sGrid:TStringGrid;i:integer;OurDiametr,len_sector:real):real;
var TDiametrK:array[0..2,0..37]of real;
    ii,a:integer;
    HMK,HMK1:real;
Begin
   //ініціалізація масиву діаметрів-компенсаторів
   TDiametrK[0,0]:=0.04 ;   TDiametrK[1,0]:=60 ;   TDiametrK[2,0]:=0 ;
   TDiametrK[0,1]:=0.05 ;   TDiametrK[1,1]:=60 ;   TDiametrK[2,1]:=0 ;
   TDiametrK[0,2]:=0.069 ;  TDiametrK[1,2]:=70 ;   TDiametrK[2,2]:=0 ;
   TDiametrK[0,3]:=0.81 ;   TDiametrK[1,3]:=80 ;   TDiametrK[2,3]:=0 ;
   TDiametrK[0,4]:=0.1 ;    TDiametrK[1,4]:=80 ;    TDiametrK[2,4]:=70 ;
   TDiametrK[0,5]:=0.125 ;  TDiametrK[1,5]:=90 ;    TDiametrK[2,5]:=70 ;
   TDiametrK[0,6]:=0.143 ;  TDiametrK[1,6]:=90 ;  TDiametrK[2,6]:=70 ;
   TDiametrK[0,7]:=0.150 ;  TDiametrK[1,7]:=100 ;  TDiametrK[2,7]:=70 ;
   TDiametrK[0,8]:=0.182 ;  TDiametrK[1,8]:=100 ;    TDiametrK[2,8]:=80 ;
   TDiametrK[0,9]:=0.184 ;  TDiametrK[1,9]:=100 ;    TDiametrK[2,9]:=80 ;
   TDiametrK[0,10]:=0.205 ; TDiametrK[1,10]:=120 ;   TDiametrK[2,10]:=80 ;
   TDiametrK[0,11]:=0.207 ; TDiametrK[1,11]:=120 ;   TDiametrK[2,11]:=80 ;
   TDiametrK[0,12]:=0.258 ; TDiametrK[1,12]:=120 ;   TDiametrK[2,12]:=100 ;
   TDiametrK[0,13]:=0.260 ; TDiametrK[1,13]:=120 ;   TDiametrK[2,13]:=100 ;
   TDiametrK[0,14]:=0.307 ; TDiametrK[1,14]:=120 ;   TDiametrK[2,14]:=100 ;
   TDiametrK[0,15]:=0.309 ; TDiametrK[1,15]:=120 ;   TDiametrK[2,15]:=100 ;
   TDiametrK[0,16]:=0.357 ; TDiametrK[1,16]:=140 ;  TDiametrK[2,16]:=120 ;
   TDiametrK[0,17]:=0.359 ; TDiametrK[1,17]:=140 ;   TDiametrK[2,17]:=120 ;
   TDiametrK[0,18]:=0.404 ; TDiametrK[1,18]:=160 ;  TDiametrK[2,18]:=140 ;
   TDiametrK[0,19]:=0.406 ; TDiametrK[1,19]:=160 ;  TDiametrK[2,19]:=140 ;
   TDiametrK[0,20]:=0.412 ; TDiametrK[1,20]:=160 ;   TDiametrK[2,20]:=140 ;
   TDiametrK[0,21]:=0.414 ; TDiametrK[1,21]:=160 ;   TDiametrK[2,21]:=140 ;
   TDiametrK[0,22]:=0.464 ; TDiametrK[1,22]:=160 ;   TDiametrK[2,22]:=140 ;
   TDiametrK[0,23]:=0.466 ; TDiametrK[1,23]:=160 ;   TDiametrK[2,23]:=140 ;
   TDiametrK[0,24]:=0.515 ; TDiametrK[1,24]:=180 ;   TDiametrK[2,24]:=140 ;
   TDiametrK[0,25]:=0.517 ; TDiametrK[1,25]:=180 ;   TDiametrK[2,25]:=140 ;
   TDiametrK[0,26]:=0.614 ; TDiametrK[1,26]:=200 ;   TDiametrK[2,26]:=160 ;
   TDiametrK[0,27]:=0.616 ; TDiametrK[1,27]:=200 ;   TDiametrK[2,27]:=160 ;
   TDiametrK[0,28]:=0.702 ; TDiametrK[1,28]:=200 ;   TDiametrK[2,28]:=160 ;
   TDiametrK[0,29]:=0.704 ; TDiametrK[1,29]:=200 ;   TDiametrK[2,29]:=160 ;
   TDiametrK[0,30]:=0.706 ; TDiametrK[1,30]:=200 ;   TDiametrK[2,30]:=160 ;
   TDiametrK[0,31]:=0.802 ; TDiametrK[1,31]:=200 ;   TDiametrK[2,31]:=160 ;
   TDiametrK[0,32]:=0.804 ; TDiametrK[1,32]:=200 ;   TDiametrK[2,32]:=160 ;
   TDiametrK[0,33]:=0.900 ; TDiametrK[1,33]:=200 ;  TDiametrK[2,33]:=160 ;
   TDiametrK[0,34]:=1.0 ;   TDiametrK[1,34]:=200 ; TDiametrK[2,34]:=160 ;
   TDiametrK[0,35]:=1.1 ;   TDiametrK[1,35]:=200 ; TDiametrK[2,35]:=160 ;
   TDiametrK[0,36]:=1.192 ; TDiametrK[1,36]:=200 ; TDiametrK[2,36]:=160 ;
   TDiametrK[0,37]:=1.392 ; TDiametrK[1,37]:=200 ; TDiametrK[2,37]:=160 ;

   //завершення ініціалізації
      for a:=0 to 37 do
      Begin
         if ourdiametr = Tdiametrk[0,a] then
          ii:=a;
      end;{for}
  if pos('Компенсатор сальниковий (0.3)',sGrid.Cells[3,i])>0 then
   Begin
     if Tdiametrk[2,ii]=0 then
     HowManyKompensators:=0
     else
         Begin
           HMK:=len_sector/Tdiametrk[2,ii];
           if frac(HMK) >=0 then
            Begin
              HMK1:=trunc(HMK)+1-1;
              HowManyKompensators:=HMK1;
            end{if}
           else HowManyKompensators:=HMK;
         end;{else}
   end;{if}
  if( pos('Компенсатор П-подібний з гладкими відводами (1.7)',sGrid.Cells[3,i])>0 )or
    ( pos('Компенсатор П-подібний з круто зігнутими відводами (2.4)',sGrid.Cells[3,i])>0) or
    ( pos('Компенсатор П-подібний з зварними відводами (2.8)',sGrid.Cells[3,i])>0) then
   Begin
      HMK:=len_sector/Tdiametrk[2,ii];
           if frac(HMK) >=0 then
            Begin
              HMK1:=trunc(HMK)+1-1;
              HowManyKompensators:=HMK1;
            end{if}
           else HowManyKompensators:=HMK;
   end;{if}
end;{HowManyKompensators}

//Обрахунок еквівалентної довжини,розрахункової довжини
Procedure EkRoz_len(CM,TD_03,len_sector:real; var EkLen,RozLen:real);
Begin
 EkLen:=TD_03*CM;
 RozLen:=len_sector+EkLen;
end;{EkRoz_len}

//Питома втрата тиску при ГАММА
function PLP2(DH,IPIP0:real):real;
Begin
// showmessage(floattostr(dh)+'=='+floattostr(IPIP0));
 PLP2:=DH/IPIP0;
end;

//Обрахунок втрати тиску
Function loosP(RozLen,PLP:real):real;
Begin
  LoosP:=RozLen*PLP;
end;{LoosP}

//Оцінка точності
Function Ocurency(OLP,LSP:real):real;//Boolean;
var
   Ocurok:real;
Begin
  Ocurok:=((OLP-LSP)/OLP)*100;
  ocurency:=ocurok;
end;{Ocurency}

//Зведення точності
Function CastingOcurency(InputData:TstringGrid; i:integer;
                         SP,ST,LSP,IP0,DH,Speed,RozLen,OKUR:real;
                         ProportionalFile:TFileName;
                         var Orient_P,Orient_T,IP,IPIP0,PLP,RealSpeed,PLP_2,LSP2,OKUR2:real):boolean;
Begin
     LSP2:=LSP;
     OKUR2:=OKUR;
     While abs(OKUR2) > 0.01 do
      Begin
      LSP:=LSP2;
    //Орієнтовний тиск і температура на кінці ділянки
     Orient_PT_endMagistral(InputData,i,SP,LSP,ST,Orient_P,Orient_T);
    //інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари proportion)
    //за новими значеннями тиску і температури
     IP:=Interpolated_Proportion(Orient_P,Orient_T,ProportionalFile);
    //Середнє арифметичне значення між двома (Гамма)
     IPIP0:=(IP+IP0)/2;
    //Обчислення питомої втрат тиску
     PLP:=Pitoma_loos_P(InputData,i,LSP,IPIP0);
     //
     RealSpeed:=Speed/IPIP0;
      //Питома втрата тиску при ГАММА
     PLP_2:=PLP2(DH,IPIP0);
     //Обрахунок втрати тиску
     LSP2:=loosP(RozLen,PLP_2);
      //Оцінка точності
     OKUR2:=Ocurency(LSP,LSP2);
          //-----------------------------------------------------------------------
      AddAlgoritm('Початок алгоритму зведення оцінки точності ','OK',clRed);
      AddAlgoritm('Інтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion) IP0 = ',FloatTostr(IP0),clBlack);
      AddAlgoritm('Обчислення орієнтовних втрат тиску LSP =',FloatTostr(LSP),clBlack);
      AddAlgoritm('Орієнтовний тиск Orient_P =',FloatTostr(Orient_P),clBlack);
      AddAlgoritm('Орієнтовна температура на кінці ділянки Orient_T =',FloatTostr(Orient_T),clBlack);
      AddAlgoritm('Iнтерполювання (ГАММА) в таблиці питомої ваги перегрітої пари (proportion) за новими значеннями тиску і температури IP = ',FloatTostr(IP),clBlack);
      AddAlgoritm('Середнє арифметичне значення між двома (Гамма) IPIP0 = ',FloatTostr(IPIP0),clBlack);
      AddAlgoritm('Обчислення питомої втрат тиску PLP = ',FloatTostr(PLP),clBlack);
      AddAlgoritm('RealSpeed = ',FloatTostr(RealSpeed),clBlack);
      AddAlgoritm('Питома втрата тиску при ГАММА PLP_2 = ',FloatTostr(PLP_2),clBlack);
      AddAlgoritm('Обрахунок втрати тиску LSP2 = ',FloatTostr(LSP2),clBlack);
      AddAlgoritm('Оцінка точності OKUR2 = ',FloatTostr(OKUR2),clBlack);
      AddAlgoritm('Зведення оцінки точності пройшло успішно ','OK',clblue);
      AddAlgoritm('Звершення алгоритму зведення оцінки точності ','OK',clRed);
      end;
end;
//Питомі втрати тепла трубопроводів
Function Dq(Diametr:real;Type_prok:string;TOS_prok:real):real;
var DqT:array[0..9,0..37]of real;
i,stovp,radok:integer;
Begin
//ініціалізація масиву питомих втрат тепла трубопроводів
{    Діаметри         ------------------------Надземне прокладання--------------    -----------------------В непрохідних каналах------------    --------------В прохідних каналах----------------------}
   DqT[0,0]:=0.040 ;    DqT[1,0]:=0.55 ;    DqT[2,0]:=0.53 ;    DqT[3,0]:=0.53 ;    DqT[4,0]:=0.53 ;    DqT[5,0]:=0.53 ;    DqT[6,0]:=0.52 ;    DqT[7,0]:=0.59 ;    DqT[8,0]:=0.58 ;    DqT[9,0]:=0.56 ;
   DqT[0,1]:=0.050 ;    DqT[1,1]:=0.60 ;    DqT[2,1]:=0.59 ;    DqT[3,1]:=0.59 ;    DqT[4,1]:=0.58 ;    DqT[5,1]:=0.57 ;    DqT[6,1]:=0.56 ;    DqT[7,1]:=0.64 ;    DqT[8,1]:=0.63 ;    DqT[9,1]:=0.59 ;
   DqT[0,2]:=0.069 ;    DqT[1,2]:=0.66 ;    DqT[2,2]:=0.66 ;    DqT[3,2]:=0.65 ;    DqT[4,2]:=0.64 ;    DqT[5,2]:=0.64 ;    DqT[6,2]:=0.63 ;    DqT[7,2]:=0.71 ;    DqT[8,2]:=0.69 ;    DqT[9,2]:=0.66 ;
   DqT[0,3]:=0.810 ;    DqT[1,3]:=0.72 ;    DqT[2,3]:=0.71 ;    DqT[3,3]:=0.63 ;    DqT[4,3]:=0.70 ;    DqT[5,3]:=0.67 ;    DqT[6,3]:=0.66 ;    DqT[7,3]:=0.74 ;    DqT[8,3]:=0.72 ;    DqT[9,3]:=0.70 ;
   DqT[0,4]:=0.100 ;    DqT[1,4]:=0.79 ;    DqT[2,4]:=0.77 ;    DqT[3,4]:=0.76 ;    DqT[4,4]:=0.76 ;    DqT[5,4]:=0.74 ;    DqT[6,4]:=0.72 ;    DqT[7,4]:=0.81 ;    DqT[8,4]:=0.78 ;    DqT[9,4]:=0.76 ;
   DqT[0,5]:=0.125 ;    DqT[1,5]:=0.86 ;    DqT[2,5]:=0.84 ;    DqT[3,5]:=0.83 ;    DqT[4,5]:=0.83 ;    DqT[5,5]:=0.80 ;    DqT[6,5]:=0.79 ;    DqT[7,5]:=0.92 ;    DqT[8,5]:=0.87 ;    DqT[9,5]:=0.83 ;
   DqT[0,6]:=0.143 ;    DqT[1,6]:=0.93 ;    DqT[2,6]:=0.91 ;    DqT[3,6]:=0.89 ;    DqT[4,6]:=0.89 ;    DqT[5,6]:=0.87 ;    DqT[6,6]:=0.86 ;    DqT[7,6]:=1.02 ;    DqT[8,6]:=0.96 ;    DqT[9,6]:=0.89 ;
   DqT[0,7]:=0.150 ;    DqT[1,7]:=0.93 ;    DqT[2,7]:=0.91 ;    DqT[3,7]:=0.89 ;    DqT[4,7]:=0.89 ;    DqT[5,7]:=0.87 ;    DqT[6,7]:=0.86 ;    DqT[7,7]:=1.02 ;    DqT[8,7]:=0.96 ;    DqT[9,7]:=0.89 ;
   DqT[0,8]:=0.182 ;    DqT[1,8]:=0.93 ;    DqT[2,8]:=0.91 ;    DqT[3,8]:=0.89 ;    DqT[4,8]:=0.89 ;    DqT[5,8]:=0.87 ;    DqT[6,8]:=0.86 ;    DqT[7,8]:=1.02 ;    DqT[8,8]:=0.96 ;    DqT[9,8]:=0.89 ;
   DqT[0,9]:=0.184 ;    DqT[1,9]:=0.93 ;    DqT[2,9]:=0.91 ;    DqT[3,9]:=0.89 ;    DqT[4,9]:=0.89 ;    DqT[5,9]:=0.87 ;    DqT[6,9]:=0.86 ;    DqT[7,9]:=1.02 ;    DqT[8,9]:=0.96 ;    DqT[9,9]:=0.89 ;
   DqT[0,10]:=0.205 ;   DqT[1,10]:=1.09 ;   DqT[2,10]:=1.08 ;   DqT[3,10]:=1.06 ;   DqT[4,10]:=1.05 ;   DqT[5,10]:=1.04 ;   DqT[6,10]:=1.01 ;   DqT[7,10]:=1.20 ;   DqT[8,10]:=1.14 ;   DqT[9,10]:=1.07 ;
   DqT[0,11]:=0.207 ;   DqT[1,11]:=1.09 ;   DqT[2,11]:=1.08 ;   DqT[3,11]:=1.06 ;   DqT[4,11]:=1.05 ;   DqT[5,11]:=1.04 ;   DqT[6,11]:=1.01 ;   DqT[7,11]:=1.20 ;   DqT[8,11]:=1.14 ;   DqT[9,11]:=1.07 ;
   DqT[0,12]:=0.258 ;   DqT[1,12]:=1.24 ;   DqT[2,12]:=1.22 ;   DqT[3,12]:=1.17 ;   DqT[4,12]:=1.20 ;   DqT[5,12]:=1.17 ;   DqT[6,12]:=1.09 ;   DqT[7,12]:=1.32 ;   DqT[8,12]:=1.27 ;   DqT[9,12]:=1.19 ;
   DqT[0,13]:=0.260 ;   DqT[1,13]:=1.24 ;   DqT[2,13]:=1.22 ;   DqT[3,13]:=1.17 ;   DqT[4,13]:=1.20 ;   DqT[5,13]:=1.17 ;   DqT[6,13]:=1.09 ;   DqT[7,13]:=1.32 ;   DqT[8,13]:=1.27 ;   DqT[9,13]:=1.19 ;
   DqT[0,14]:=0.307 ;   DqT[1,14]:=1.24 ;   DqT[2,14]:=1.22 ;   DqT[3,14]:=1.17 ;   DqT[4,14]:=1.20 ;   DqT[5,14]:=1.17 ;   DqT[6,14]:=1.09 ;   DqT[7,14]:=1.32 ;   DqT[8,14]:=1.27 ;   DqT[9,14]:=1.19 ;
   DqT[0,15]:=0.309 ;   DqT[1,15]:=1.24 ;   DqT[2,15]:=1.22 ;   DqT[3,15]:=1.17 ;   DqT[4,15]:=1.20 ;   DqT[5,15]:=1.17 ;   DqT[6,15]:=1.09 ;   DqT[7,15]:=1.32 ;   DqT[8,15]:=1.27 ;   DqT[9,15]:=1.19 ;
   DqT[0,16]:=0.357 ;   DqT[1,16]:=1.54 ;   DqT[2,16]:=1.48 ;   DqT[3,16]:=1.42 ;   DqT[4,16]:=1.49 ;   DqT[5,16]:=1.42 ;   DqT[6,16]:=1.37 ;   DqT[7,16]:=1.59 ;   DqT[8,16]:=1.51 ;   DqT[9,16]:=1.41 ;
   DqT[0,17]:=0.359 ;   DqT[1,17]:=1.54 ;   DqT[2,17]:=1.48 ;   DqT[3,17]:=1.42 ;   DqT[4,17]:=1.49 ;   DqT[5,17]:=1.42 ;   DqT[6,17]:=1.37 ;   DqT[7,17]:=1.59 ;   DqT[8,17]:=1.51 ;   DqT[9,17]:=1.41 ;
   DqT[0,18]:=0.404 ;   DqT[1,18]:=1.54 ;   DqT[2,18]:=1.48 ;   DqT[3,18]:=1.42 ;   DqT[4,18]:=1.49 ;   DqT[5,18]:=1.42 ;   DqT[6,18]:=1.37 ;   DqT[7,18]:=1.59 ;   DqT[8,18]:=1.51 ;   DqT[9,18]:=1.41 ;
   DqT[0,19]:=0.406 ;   DqT[1,19]:=1.54 ;   DqT[2,19]:=1.48 ;   DqT[3,19]:=1.42 ;   DqT[4,19]:=1.49 ;   DqT[5,19]:=1.42 ;   DqT[6,19]:=1.37 ;   DqT[7,19]:=1.59 ;   DqT[8,19]:=1.51 ;   DqT[9,19]:=1.41 ;
   DqT[0,20]:=0.412 ;   DqT[1,20]:=1.56 ;   DqT[2,20]:=1.51 ;   DqT[3,20]:=1.42 ;   DqT[4,20]:=1.50 ;   DqT[5,20]:=1.42 ;   DqT[6,20]:=1.36 ;   DqT[7,20]:=1.59 ;   DqT[8,20]:=1.55 ;   DqT[9,20]:=1.39 ;
   DqT[0,21]:=0.414 ;   DqT[1,20]:=1.56 ;   DqT[2,20]:=1.51 ;   DqT[3,21]:=1.42 ;   DqT[4,21]:=1.50 ;   DqT[5,22]:=1.42 ;   DqT[6,23]:=1.36 ;   DqT[7,21]:=1.59 ;   DqT[8,21]:=1.55 ;   DqT[9,21]:=1.39 ;
   DqT[0,22]:=0.464 ;   DqT[1,22]:=1.67 ;   DqT[2,22]:=1.59 ;   DqT[3,22]:=-1.0 ;   DqT[4,22]:=1.62 ;   DqT[5,22]:=1.52 ;   DqT[6,22]:=1.45 ;   DqT[7,22]:=1.71 ;   DqT[8,22]:=1.62 ;   DqT[9,22]:=-1.0 ;
   DqT[0,23]:=0.466 ;   DqT[1,23]:=1.67 ;   DqT[2,23]:=1.59 ;   DqT[3,23]:=-1.0 ;   DqT[4,23]:=1.62 ;   DqT[5,23]:=1.52 ;   DqT[6,23]:=1.45 ;   DqT[7,23]:=1.71 ;   DqT[8,23]:=1.62 ;   DqT[9,23]:=-1.0 ;
   DqT[0,24]:=0.515 ;   DqT[1,24]:=1.76 ;   DqT[2,24]:=1.70 ;   DqT[3,24]:=-1.0 ;   DqT[4,24]:=1.68 ;   DqT[5,24]:=1.64 ;   DqT[6,24]:=1.55 ;   DqT[7,24]:=1.84 ;   DqT[8,24]:=1.72 ;   DqT[9,24]:=-1.0 ;
   DqT[0,25]:=0.517 ;   DqT[1,25]:=1.76 ;   DqT[2,25]:=1.70 ;   DqT[3,25]:=-1.0 ;   DqT[4,25]:=1.68 ;   DqT[5,25]:=1.64 ;   DqT[6,25]:=1.55 ;   DqT[7,25]:=1.84 ;   DqT[8,25]:=1.72 ;   DqT[9,25]:=-1.0 ;
   DqT[0,26]:=0.614 ;   DqT[1,26]:=1.96 ;   DqT[2,26]:=1.87 ;   DqT[3,26]:=-1.0 ;   DqT[4,26]:=1.88 ;   DqT[5,26]:=1.80 ;   DqT[6,26]:=1.71 ;   DqT[7,26]:=2.12 ;   DqT[8,26]:=1.98 ;   DqT[9,26]:=-1.0 ;
   DqT[0,27]:=0.616 ;   DqT[1,27]:=1.96 ;   DqT[2,27]:=1.87 ;   DqT[3,27]:=-1.0 ;   DqT[4,27]:=1.88 ;   DqT[5,27]:=1.80 ;   DqT[6,27]:=1.71 ;   DqT[7,27]:=2.12 ;   DqT[8,27]:=1.98 ;   DqT[9,27]:=-1.0 ;
   DqT[0,28]:=0.702 ;   DqT[1,28]:=2.13 ;   DqT[2,28]:=2.04 ;   DqT[3,28]:=-1.0 ;   DqT[4,28]:=2.04 ;   DqT[5,28]:=1.95 ;   DqT[6,28]:=1.86 ;   DqT[7,28]:=2.35 ;   DqT[8,28]:=2.16 ;   DqT[9,28]:=-1.0 ;
   DqT[0,29]:=0.704 ;   DqT[1,29]:=2.13 ;   DqT[2,29]:=2.04 ;   DqT[3,29]:=-1.0 ;   DqT[4,29]:=2.04 ;   DqT[5,29]:=1.95 ;   DqT[6,29]:=1.86 ;   DqT[7,29]:=2.35 ;   DqT[8,29]:=2.16 ;   DqT[9,29]:=-1.0 ;
   DqT[0,30]:=0.706 ;   DqT[1,30]:=2.13 ;   DqT[2,30]:=2.04 ;   DqT[3,30]:=-1.0 ;   DqT[4,30]:=2.04 ;   DqT[5,30]:=1.95 ;   DqT[6,30]:=1.86 ;   DqT[7,30]:=2.35 ;   DqT[8,30]:=2.16 ;   DqT[9,30]:=-1.0 ;
   DqT[0,31]:=0.802 ;   DqT[1,31]:=2.36 ;   DqT[2,31]:=2.26 ;   DqT[3,31]:=-1.0 ;   DqT[4,31]:=2.27 ;   DqT[5,31]:=2.17 ;   DqT[6,31]:=2.07 ;   DqT[7,31]:=2.63 ;   DqT[8,31]:=2.42 ;   DqT[9,31]:=-1.0 ;
   DqT[0,32]:=0.804 ;   DqT[1,32]:=2.36 ;   DqT[2,32]:=2.26 ;   DqT[3,32]:=-1.0 ;   DqT[4,32]:=2.27 ;   DqT[5,32]:=2.17 ;   DqT[6,32]:=2.07 ;   DqT[7,32]:=2.63 ;   DqT[8,32]:=2.42 ;   DqT[9,32]:=-1.0 ;
   DqT[0,33]:=0.900 ;   DqT[1,33]:=2.65 ;   DqT[2,33]:=2.49 ;   DqT[3,33]:=-1.0 ;   DqT[4,33]:=2.54 ;   DqT[5,33]:=2.39 ;   DqT[6,33]:=2.27 ;   DqT[7,33]:=2.88 ;   DqT[8,33]:=2.64 ;   DqT[9,33]:=-1.0 ;
   DqT[0,34]:=1.000 ;   DqT[1,34]:=2.92 ;   DqT[2,34]:=2.76 ;   DqT[3,34]:=-1.0 ;   DqT[4,34]:=2.79 ;   DqT[5,34]:=2.65 ;   DqT[6,34]:=2.49 ;   DqT[7,34]:=3.09 ;   DqT[8,34]:=2.86 ;   DqT[9,34]:=-1.0 ;
   DqT[0,35]:=1.100 ;   DqT[1,35]:=2.92 ;   DqT[2,35]:=2.76 ;   DqT[3,35]:=-1.0 ;   DqT[4,35]:=2.79 ;   DqT[5,35]:=2.65 ;   DqT[6,35]:=2.49 ;   DqT[7,35]:=3.09 ;   DqT[8,35]:=2.86 ;   DqT[9,35]:=-1.0 ;
   DqT[0,36]:=1.192 ;   DqT[1,36]:=2.92 ;   DqT[2,36]:=2.76 ;   DqT[3,36]:=-1.0 ;   DqT[4,36]:=2.79 ;   DqT[5,36]:=2.65 ;   DqT[6,36]:=2.49 ;   DqT[7,36]:=3.09 ;   DqT[8,36]:=2.86 ;   DqT[9,36]:=-1.0 ;
   DqT[0,37]:=1.392 ;   DqT[1,37]:=2.92 ;   DqT[2,37]:=2.76 ;   DqT[3,37]:=-1.0 ;   DqT[4,37]:=2.79 ;   DqT[5,37]:=2.65 ;   DqT[6,37]:=2.49 ;   DqT[7,37]:=3.09 ;   DqT[8,37]:=2.86 ;   DqT[9,37]:=-1.0 ;
//Кінець ініціалізації масиву питомих втрат тепла трубопроводів
{    Діаметри           ----------Надземне прокладання----------------------------  -----------В непрохідних каналах-------------------------   -------------В прохідних каналах-------------------------}
If (Type_prok ='Надземне = ') and (TOS_prok<=199) then stovp:=1;
If (Type_prok ='Надземне = ') and (TOS_prok>=200) and (TOS_prok<=299) then stovp:=2;
If (Type_prok ='Надземне = ') and (TOS_prok>=300) and (TOS_prok<=450) then stovp:=3;
If (Type_prok ='В не прохідних каналах = ') and (TOS_prok<=199) then stovp:=4;
If (Type_prok ='В не прохідних каналах = ') and (TOS_prok>=200) and (TOS_prok<=299) then stovp:=5;
If (Type_prok ='В не прохідних каналах = ') and (TOS_prok>=300) and (TOS_prok<=450) then stovp:=6;
If (Type_prok ='В прохідних каналах = ') and (TOS_prok<=199) then stovp:=7;
If (Type_prok ='В прохідних каналах = ') and (TOS_prok>=200) and (TOS_prok<=299) then stovp:=8;
If (Type_prok ='В прохідних каналах = ') and (TOS_prok>=300) and (TOS_prok<=450) then stovp:=9;
for i:=0 to 37 do
 Begin
  if DqT[0,i] = Diametr then radok:=i;
 end;{if}
 Dq:=DqT[stovp,radok];
end;{Dq}

//Визначення середньо температури на ділянці
Function TMID(Start_T,Orient_t:real):real;
Begin
 TMID:=(Start_t+Orient_T)/2;
end;{TMID}

//Втрати тепла на ділянці
Function LoosTeplo(tmid1,TOSP,DqReal,Roz_len:real):real;
Begin
 LoosTeplo:=(TMID1-TOSP)*DqReal*Roz_len;
end;{LoosTeplo}

//Перепад температури на ділянці
Function Dt(LTeplo,LP,IP0CP:real):real;
Begin
 Dt:=(3.6*LTeplo)/(LP*IP0CP);
end;{Dt}

//Реальний тиск на кінці ділянки
Function Real_PP(Start_P,LSP2:real):real;
Begin
  Real_PP:=Start_P-LSP2;
end;{Real_PP}

//Реальна температура на кінці ділянки
Function Real_TT(Start_T,Dt1:real):real;
Begin
 Real_TT:=Start_T-Dt1;
end;{Real_TT}

//Збільшення діаметру при умові коли LSP>OLP
Function YakasLaga (InputData:TStringGrid;i:integer;
                    Diam1,Diam,Len_Sector,IPIP0,OLP,SP,ST:real;
                    Real_IP0,LP:real;
                    Proportion:TFileName;
                    var DiamNew,DH,TD_03,HMK,CM,EkLen,RozLen,PLP_2,LSP,Speed,RealSpeed:real;
                    var NumD:integer;
                    var TD_02:string):real;
var
    TDiametr:array[0..2,0..37]of string;
    Lambda,nabl1:real;
    j,jj,cod:integer;
Begin
  //ініціалізація масиву діаметрів
   TDiametr[0,0]:='0.04' ;   TDiametr[1,0]:='45x2.5' ;   TDiametr[2,0]:='1.37' ;
   TDiametr[0,1]:='0.05' ;   TDiametr[1,1]:='57x3.5' ;   TDiametr[2,1]:='1.85' ;
   TDiametr[0,2]:='0.069' ;  TDiametr[1,2]:='76x3.5' ;   TDiametr[2,2]:='2.75' ;
   TDiametr[0,3]:='0.081' ;   TDiametr[1,3]:='89x3.5' ;   TDiametr[2,3]:='3.3' ;
   TDiametr[0,4]:='0.1' ;    TDiametr[1,4]:='108x4' ;    TDiametr[2,4]:='4.3' ;
   TDiametr[0,5]:='0.125' ;  TDiametr[1,5]:='133x4' ;    TDiametr[2,5]:='5.68' ;
   TDiametr[0,6]:='0.143' ;  TDiametr[1,6]:='152x4.5' ;  TDiametr[2,6]:='6.2' ;
   TDiametr[0,7]:='0.150' ;  TDiametr[1,7]:='159x4.5' ;  TDiametr[2,7]:='7.1' ;
   TDiametr[0,8]:='0.182' ;  TDiametr[1,8]:='194x6' ;    TDiametr[2,8]:='9.2' ;
   TDiametr[0,9]:='0.184' ;  TDiametr[1,9]:='194x5' ;    TDiametr[2,9]:='9.2' ;
   TDiametr[0,10]:='0.205' ; TDiametr[1,10]:='219x7' ;   TDiametr[2,10]:='10.7' ;
   TDiametr[0,11]:='0.207' ; TDiametr[1,11]:='219x6' ;   TDiametr[2,11]:='10.7' ;
   TDiametr[0,12]:='0.258' ; TDiametr[1,12]:='273x8' ;   TDiametr[2,12]:='14.1' ;
   TDiametr[0,13]:='0.260' ; TDiametr[1,13]:='273x7' ;   TDiametr[2,13]:='14.1' ;
   TDiametr[0,14]:='0.307' ; TDiametr[1,14]:='325x9' ;   TDiametr[2,14]:='17.6' ;
   TDiametr[0,15]:='0.309' ; TDiametr[1,15]:='325x8' ;   TDiametr[2,15]:='17.6' ;
   TDiametr[0,16]:='0.357' ; TDiametr[1,16]:='377x10' ;  TDiametr[2,16]:='21.2' ;
   TDiametr[0,17]:='0.359' ; TDiametr[1,17]:='377x9' ;   TDiametr[2,17]:='21.2' ;
   TDiametr[0,18]:='0.404' ; TDiametr[1,18]:='426x11' ;  TDiametr[2,18]:='24.9' ;
   TDiametr[0,19]:='0.406' ; TDiametr[1,19]:='426x10' ;  TDiametr[2,19]:='24.9' ;
   TDiametr[0,20]:='0.412' ; TDiametr[1,20]:='426x7' ;   TDiametr[2,20]:='25.4' ;
   TDiametr[0,21]:='0.414' ; TDiametr[1,21]:='426x6' ;   TDiametr[2,21]:='25.4' ;
   TDiametr[0,22]:='0.464' ; TDiametr[1,22]:='478x7' ;   TDiametr[2,22]:='29.4' ;
   TDiametr[0,23]:='0.466' ; TDiametr[1,23]:='478x6' ;   TDiametr[2,23]:='29.4' ;
   TDiametr[0,24]:='0.515' ; TDiametr[1,24]:='529x7' ;   TDiametr[2,24]:='33.3' ;
   TDiametr[0,25]:='0.517' ; TDiametr[1,25]:='529x6' ;   TDiametr[2,25]:='33.3' ;
   TDiametr[0,26]:='0.614' ; TDiametr[1,26]:='630x8' ;   TDiametr[2,26]:='41.4' ;
   TDiametr[0,27]:='0.616' ; TDiametr[1,27]:='630x7' ;   TDiametr[2,27]:='41.4' ;
   TDiametr[0,28]:='0.702' ; TDiametr[1,28]:='720x9' ;   TDiametr[2,28]:='48.9' ;
   TDiametr[0,29]:='0.704' ; TDiametr[1,29]:='720x8' ;   TDiametr[2,29]:='48.9' ;
   TDiametr[0,30]:='0.706' ; TDiametr[1,30]:='720x7' ;   TDiametr[2,30]:='48.9' ;
   TDiametr[0,31]:='0.802' ; TDiametr[1,31]:='820x9' ;   TDiametr[2,31]:='57.8' ;
   TDiametr[0,32]:='0.804' ; TDiametr[1,32]:='820x8' ;   TDiametr[2,32]:='57.8' ;
   TDiametr[0,33]:='0.900' ; TDiametr[1,33]:='920x11' ;  TDiametr[2,33]:='66.8' ;
   TDiametr[0,34]:='1.0' ;   TDiametr[1,34]:='1020x12' ; TDiametr[2,34]:='76.1' ;
   TDiametr[0,35]:='1.1' ;   TDiametr[1,35]:='1120x12' ; TDiametr[2,35]:='85.7' ;
   TDiametr[0,36]:='1.192' ; TDiametr[1,36]:='1220x14' ; TDiametr[2,36]:='95.2' ;
   TDiametr[0,37]:='1.392' ; TDiametr[1,37]:='1420x14' ; TDiametr[2,37]:='115.6' ;
   //кінець ініціалізації масиву
    for j:=0 to 37 do
    Begin
     val(TDiametr[0,j],nabl1,cod);
     if nabl1 = diam1 then
      jj:=j;
    end;{for}
     val(TDiametr[0,jj+1],Diam1,cod);
     NumD:=jj+1;
       Speed:=0.354*(LP/sqr(Diam1));
       RealSpeed:=Speed/IPIP0;
       Lambda:=1/sqr(1.14+2*log10(Diam1/0.0002));
       dh:=(0.00638*Lambda*(sqr(LP)/(sqr(Diam1)*sqr(Diam1)*Diam1)))*10;
       val(TDiametr[2,jj+1],TD_03,cod);
       TD_02:=TDiametr[1,jj+1];
    //Обрахунок кількості крмпенсаторів відповідно до обраного
     HMK:=HowManyKompensators(InputData,i,Diam1,len_sector);
     //визначення суми добутків видів місцевого опору на їх кількість
     Checked_Multiplication(InputData,HMK);
      val(sList.Strings[i-1],CM,cod);
      If diam1<diam then
        Begin
        //diam:=diam1;
        CM:=CM+0.5;
        //InputData.cells[3,i]:=InputData.cells[3,i]+', Звуження (0.5)';
        //InputData.cells[4,i]:=InputData.cells[4,i]+' ,1'
        end;{if}
      DiamNew:=diam1;
     //Обрахунок еквівалентної довжини,розрахункової довжини
     EkRoz_len(CM,TD_03,len_sector,EkLen,RozLen);
     //Питома втрата тиску при ГАММА
     PLP_2:=PLP2(DH,IPIP0);
     //Обрахунок втрати тиску
     LSP:=loosP(RozLen,PLP_2);
           //-----------------------------------------------------------------------
     AddAlgoritm('Початок алгоритму збільшення діаметру при умові коли LSP>OLP ','OK',clRed);
     AddAlgoritm('Підбір діаметрів Diam1 = ',FloatTostr(Diam1),clBlack);
     AddAlgoritm('Speed = ',FloatTostr(speed),clBlack);
     AddAlgoritm('RealSpeed = ',FloatTostr(realspeed),clBlack);
     AddAlgoritm('DH = ',FloatTostr(dh),clBlack);
     AddAlgoritm('Обрахунок кількості крмпенсаторів відповідно до обраного HMK = ',FloatTostr(HMK),clBlack);
     AddAlgoritm('Визначення суми добутків видів місцевого опору на їх кількість СМ = ',FloatTostr(CM),clBlack);
     AddAlgoritm('Обрахунок еквівалентної довжини EkLen = ',FloatTostr(EkLen),clBlack);
     AddAlgoritm('Обрахунок розрахункової довжини RozLen = ',FloatTostr(RozLen),clBlack);
     AddAlgoritm('Питома втрата тиску при ГАММА PLP_2 = ',FloatTostr(PLP_2),clBlack);
     AddAlgoritm('Обрахунок втрати тиску LSP = ',FloatTostr(LSP),clBlack);
     AddAlgoritm('Збільшення діаметру при умові LSP>OLP пройшло успішно  ','OK',clBlue);
     AddAlgoritm('Завершення алгоритму збільшення діаметру при умові коли LSP>OLP  = ','OK',clRed);
end;{YakasLaga}
end.{UNIT_Calcalation}


{незабути при виході програми знищити
 sLIST:TStrinLisT;}
