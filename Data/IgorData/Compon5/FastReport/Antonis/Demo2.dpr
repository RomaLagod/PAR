program Demo2;

uses
  Forms,
  UniDemo2 in 'UniDemo2.pas' {Form1},
  unCustomPreview in 'unCustomPreview.pas' {frmCustomPreview};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
