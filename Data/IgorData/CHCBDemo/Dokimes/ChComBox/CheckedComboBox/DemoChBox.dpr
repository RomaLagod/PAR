program DemoChBox;

uses
  Forms,
  UnDemoChBox in 'UnDemoChBox.pas' {Form1},
  CheckComboSpec in 'CheckComboSpec.pas',
  CheckCombo in 'CheckCombo.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
