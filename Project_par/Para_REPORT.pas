unit Para_REPORT;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuickRpt, QRCtrls, ExtCtrls, TeeProcs, TeEngine, Chart, DbChart,
  QRTEE, Series, QRExport;

type
  TReportPar = class(TForm)
    QuickRep1: TQuickRep;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    DetailBand1: TQRBand;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    SummaryBand1: TQRBand;
    QRBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    QRLabel14: TQRLabel;
    QRBand2: TQRBand;
    QRGroup1: TQRGroup;
    QRDBChart1: TQRDBChart;
    QRChart1: TQRChart;
    Series1: TLineSeries;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRLabel17: TQRLabel;
    QRLabel18: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    QRLabel22: TQRLabel;
    QRLabel23: TQRLabel;
    QRLabel24: TQRLabel;
    QRLabel25: TQRLabel;
    QRLabel26: TQRLabel;
    QRLabel27: TQRLabel;
    QRHTMLFilter1: TQRHTMLFilter;
    QRTextFilter1: TQRTextFilter;
    QRCSVFilter1: TQRCSVFilter;
    procedure QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportPar: TReportPar;

implementation

uses Base;

{$R *.dfm}

procedure TReportPar.QuickRep1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
QRLabel1.caption:=Para_Normal.sgShotOutputData.Cells[0,QuickRep1.RecordNumber+1];
QRLabel2.caption:=Para_Normal.sgShotOutputData.Cells[1,QuickRep1.RecordNumber+1];
QRLabel3.caption:=Para_Normal.sgShotOutputData.Cells[2,QuickRep1.RecordNumber+1];
QRLabel4.caption:=Para_Normal.sgShotOutputData.Cells[3,QuickRep1.RecordNumber+1];
QRLabel5.caption:=Para_Normal.sgShotOutputData.Cells[4,QuickRep1.RecordNumber+1];
QRLabel6.caption:=Para_Normal.sgShotOutputData.Cells[5,QuickRep1.RecordNumber+1];
QRLabel7.caption:=Para_Normal.sgShotOutputData.Cells[6,QuickRep1.RecordNumber+1];
QRLabel8.caption:=Para_Normal.sgShotOutputData.Cells[7,QuickRep1.RecordNumber+1];
QRLabel9.caption:=Para_Normal.sgShotOutputData.Cells[8,QuickRep1.RecordNumber+1];
QRLabel10.caption:=Para_Normal.sgShotOutputData.Cells[9,QuickRep1.RecordNumber+1];
QRLabel11.caption:=Para_Normal.sgShotOutputData.Cells[10,QuickRep1.RecordNumber+1];
QRLabel12.caption:=Para_Normal.sgShotOutputData.Cells[11,QuickRep1.RecordNumber+1];
QRLabel13.caption:=Para_Normal.sgShotOutputData.Cells[12,QuickRep1.RecordNumber+1];
//QRImage1.Picture:=Para_Normal.ChartPARA.Series[1]
MoreData:=QuickRep1.RecordNumber<Para_Normal.sgShotOutputData.RowCount;
end;

end.
