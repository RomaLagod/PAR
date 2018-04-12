{ $Header: /Delphi/Components/THyperGrid/HGPROP.PAS 7     1/13/97 9:27a Ppissan $}
//
// This unit implements the property editor class for ThgColumns
//
unit HgProp;

interface

uses DsgnIntf;

type

  THGColumnsPropertyEditor = class( TPropertyEditor )
    function GetAttributes : TPropertyAttributes; override;
    procedure Edit; override;
    function GetValue : string; override;
  end;

  THyperGridEditor = class( TComponentEditor )
  public
    procedure Edit; override;
  end;

  ThgVersionEditor = class( TpropertyEditor )
    function GetAttributes : TPropertyAttributes; override;
    function GetValue : string; override;
  end;

  ThgAuthorEditor = class( TpropertyEditor )
    procedure Edit; override;
    function GetAttributes : TPropertyAttributes; override;
    function GetValue : string; override;
  end;

implementation

uses HgGrid , Classes , SysUtils , Forms , Controls , HgDialog , HgGlobal , HgAbout; 

//------------------------------------------------------------------------------

procedure THyperGridEditor.Edit;
var
  EditorDialog  : TfrmHGColumnsEditor;
begin
  if Component is THyperGrid then
    begin
      EditorDialog := TfrmHGColumnsEditor.CreateColumnsEditor( Application , Self );
      if EditorDialog.ShowModal = mrOk then
        begin
          Designer.Modified;
          THyperGrid( Component ).Refresh;
        end;
    end;
end;

//------------------------------------------------------------------------------

function THGColumnsPropertyEditor.GetAttributes : TPropertyAttributes;
begin
  Result := [ paDialog , paReadonly ];
end;

procedure THGColumnsPropertyEditor.Edit;
var
  Component     : TComponent;
  EditorDialog  : TfrmHGColumnsEditor;
begin
  Component := GetComponent( 0 ) as TComponent;
  if Component is THyperGrid then
    begin
      EditorDialog := TfrmHGColumnsEditor.CreateColumnsEditor( Application , Self );
      if GetPropType^.Name = 'ThgHeadings' then
        EditorDialog.EditingHeadings := True;
      if EditorDialog.ShowModal = mrOk then
        begin
          Designer.Modified;
          THyperGrid( Component ).Refresh;
        end;
    end;
end;

function THGColumnsPropertyEditor.GetValue : string;
begin
  FmtStr( Result , '(%s)' , [ GetPropType^.Name ] );
end;

//------------------------------------------------------------------------------

function THGVersionEditor.GetAttributes : TPropertyAttributes;
begin
  Result := [ paReadonly ];
end;

function THGVersionEditor.GetValue : string;
begin
  Result := HyperGridVersionString;
end;

//------------------------------------------------------------------------------

function THGAuthorEditor.GetAttributes : TPropertyAttributes;
begin
  Result := [ paReadonly , paDialog ];
end;

function THGAuthorEditor.GetValue : string;
begin
  Result := 'Pablo Pissanetzky';
end;

procedure THGAuthorEditor.Edit;
var
  frm : TfrmHgAbout;
  Component     : TComponent;
begin
  Component := GetComponent( 0 ) as TComponent;
  if Component is THyperGrid then
    begin
      frm := TfrmHgAbout.Create( Application );
      frm.lblVersion.Caption := 'Version ' + THyperGrid( Component ).Version;
      frm.ShowModal;
    end;
end;

//------------------------------------------------------------------------------

end.
