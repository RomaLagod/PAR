unit unCustomPreview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FR_Ctrls, FR_View, ExtCtrls;

type
  TfrmCustomPreview = class(TForm)
    Panel1: TPanel;
    frPreview1: TfrPreview;
    frSpeedButton1: TfrSpeedButton;
    frSpeedButton2: TfrSpeedButton;
    frSpeedButton3: TfrSpeedButton;
    frSpeedButton4: TfrSpeedButton;
    frSpeedButton5: TfrSpeedButton;
    frSpeedButton6: TfrSpeedButton;
    frSpeedButton7: TfrSpeedButton;
    frSpeedButton8: TfrSpeedButton;
    frSpeedButton9: TfrSpeedButton;
    frSpeedButton10: TfrSpeedButton;
    frSpeedButton11: TfrSpeedButton;
    frSpeedButton12: TfrSpeedButton;
    procedure frSpeedButton4Click(Sender: TObject);
    procedure frSpeedButton5Click(Sender: TObject);
    procedure frSpeedButton6Click(Sender: TObject);
    procedure frSpeedButton7Click(Sender: TObject);
    procedure frSpeedButton8Click(Sender: TObject);
    procedure frSpeedButton9Click(Sender: TObject);
    procedure frSpeedButton10Click(Sender: TObject);
    procedure frSpeedButton1Click(Sender: TObject);
    procedure frSpeedButton2Click(Sender: TObject);
    procedure frSpeedButton3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure frSpeedButton11Click(Sender: TObject);
		procedure frSpeedButton12Click(Sender: TObject);
		procedure FormKeyDown(Sender: TObject; var Key: Word;
			Shift: TShiftState);
		constructor CreateByLanguage(AOwner:TComponent;LangId:Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCustomPreview: TfrmCustomPreview;

implementation

{$R *.DFM}

procedure TfrmCustomPreview.frSpeedButton4Click(Sender: TObject);
begin
  frPreview1.First;
end;

procedure TfrmCustomPreview.frSpeedButton5Click(Sender: TObject);
begin
  frPreview1.Prev;
end;

procedure TfrmCustomPreview.frSpeedButton6Click(Sender: TObject);
begin
  frPreview1.Next;
end;

procedure TfrmCustomPreview.frSpeedButton7Click(Sender: TObject);
begin
  frPreview1.Last;
end;

procedure TfrmCustomPreview.frSpeedButton8Click(Sender: TObject);
begin
	frPreview1.Find;
end;

procedure TfrmCustomPreview.frSpeedButton9Click(Sender: TObject);
begin
  frPreview1.SaveToFile;
end;

procedure TfrmCustomPreview.frSpeedButton10Click(Sender: TObject);
begin
  frPreview1.Print;
end;

procedure TfrmCustomPreview.frSpeedButton1Click(Sender: TObject);
begin
  frPreview1.OnePage;
end;

procedure TfrmCustomPreview.frSpeedButton2Click(Sender: TObject);
begin
  frPreview1.Zoom := 100;
end;

procedure TfrmCustomPreview.frSpeedButton3Click(Sender: TObject);
begin
	frPreview1.PageWidth;
end;

procedure TfrmCustomPreview.frSpeedButton12Click(Sender: TObject);
begin
	frPreview1.PageSetupDlg;
end;

procedure TfrmCustomPreview.FormActivate(Sender: TObject);
begin
	frSpeedButton2.Down := True;
	frSpeedButton2Click(nil);
end;

procedure TfrmCustomPreview.frSpeedButton11Click(Sender: TObject);
begin
	ModalResult := mrOk;
end;

procedure TfrmCustomPreview.FormKeyDown(Sender: TObject; var Key: Word;
	Shift: TShiftState);
begin
	frPreview1.Window.FormKeyDown(Sender, Key, Shift);
end;

constructor TfrmCustomPreview.CreateByLanguage(AOwner: TComponent;
  LangId: Integer);
begin
	inherited Create(AOwner);
	case LangId of
		1: begin				// Greek;
				Caption := 'Προεμφάνιση εκτύπωσης';
				frSpeedButton1.Hint := 'Εμφάνιση ολόκληρης';
				frSpeedButton2.Hint := 'Εμφάνιση στο 100%';
				frSpeedButton3.Hint := 'Μεγένθυση στο πλάτος της σελίδας';
				frSpeedButton4.Hint := 'Πρώτη Σελίδα';
				frSpeedButton5.Hint := 'Προηγούμενη Σελίδα';
				frSpeedButton6.Hint := 'Επόμενη Σελίδα';
				frSpeedButton7.Hint := 'Τελευταία Σελίδα';
				frSpeedButton8.Hint := 'Αναζήτηση στο report';
				frSpeedButton9.Hint := 'Αποθήκευση report';
				frSpeedButton10.Hint := 'Εκτύπωση report';
				frSpeedButton11.Hint := 'Εξοδος';
				frSpeedButton12.Hint := 'Ρυθμίσεις Εκτυπωτή';
			 end;
	else
		begin
			//nothing
		end
	end;
end;

end.
