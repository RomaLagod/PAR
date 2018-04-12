//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("HyperGrid.res");

#ifdef B4_COMPILE
  USEPACKAGE("vcl40.bpi");
  USEPACKAGE("VCLDB40.bpi");
  USEPACKAGE("bcbsmp40.bpi");
#else
  USEPACKAGE("vcl35.bpi");
  USEPACKAGE("dcldb35.bpi");
#endif

USEFORMNS("HgColors.pas", Hgcolors, hgColorSelectForm);
USEUNIT("HgReg.pas");
USERES("HgReg.dcr");
USEUNIT("HgGrid.pas");
USEUNIT("HgColumn.pas");
USEFORMNS("HgDialog.pas", Hgdialog, frmHGColumnsEditor);
USEUNIT("HgEdit.pas");
USEUNIT("HgGlobal.pas");
USEFORMNS("HgAbout.pas", Hgabout, frmHgAbout);
USEUNIT("HgHGrid.pas");
USEUNIT("HgProp.pas");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
    return 1;
}
//---------------------------------------------------------------------------
