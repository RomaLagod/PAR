//
// This unit registers the THyperGrid component and the THGColumns property editor
//

unit HgReg;

interface

procedure Register;

implementation

uses Classes , HgGrid , HgColumn , HgProp , DsgnIntf , HgColors;

procedure Register;
begin
//  RegisterComponents( 'Marley' , [ ThgColorDialog ] );
  RegisterComponents( 'Samples' , [ THyperGrid ] );
  RegisterPropertyEditor( TypeInfo( thgHeadings ) , ThyperGrid , '' , THGColumnsPropertyEditor );
  RegisterComponentEditor( THyperGrid , THyperGridEditor );
  RegisterPropertyEditor( TypeInfo( string ) , ThyperGrid , 'Version' , THGVersionEditor );
  RegisterPropertyEditor( TypeInfo( string ) , ThyperGrid , 'Author' , THGAuthorEditor );
end;

end.
